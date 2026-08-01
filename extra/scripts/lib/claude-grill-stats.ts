import { createReadStream } from "node:fs"
import { stat } from "node:fs/promises"
import { createInterface } from "node:readline"

import glob from "fast-glob"

export const workflows = ["grill-me", "batch-grill-me", "grill-with-docs", "wayfinder"] as const

export type Workflow = (typeof workflows)[number]

interface TranscriptContentBlock {
  type?: string
  id?: string
  name?: string
  tool_use_id?: string
  text?: string
  input?: {
    questions?: unknown[]
  }
}

export interface TranscriptRecord {
  type?: string
  uuid?: string
  parentUuid?: string | null
  timestamp?: string
  isSidechain?: boolean
  isMeta?: boolean
  attributionSkill?: string | null
  message?: {
    id?: string
    role?: string
    content?: string | TranscriptContentBlock[]
  }
}

export interface WorkflowStats {
  questions: number
  exactQuestions: number
  inferredQuestions: number
  completedBatches: number
  pendingBatches: number
  pendingQuestions: number
  completedBatchSizes: number[]
}

export interface BatchQuestionStats {
  min: number
  max: number
  average: number
}

export interface AnalysisStats {
  total: WorkflowStats
  workflows: Record<Workflow, WorkflowStats>
  batchQuestions: BatchQuestionStats
}

export interface ScanStats extends AnalysisStats {
  filesScanned: number
  warnings: string[]
}

interface TimeWindow {
  since: Date
  until: Date
}

interface TranscriptNode {
  parentUuid: string | null
  command: string | null
}

const durationUnits: Record<string, number> = {
  s: 1_000,
  m: 60_000,
  h: 3_600_000,
  d: 86_400_000,
  w: 604_800_000,
}

const workflowByCommand: Record<string, Workflow> = {
  grill: "grill-me",
  "grill-me": "grill-me",
  "batch-grill-me": "batch-grill-me",
  "grill-with-docs": "grill-with-docs",
  wayfinder: "wayfinder",
}

export function parseDuration(value: string): number {
  const match = /^(\d+)([smhdw])$/.exec(value)
  if (!match || Number(match[1]) <= 0) {
    throw new Error("Duration must be a positive integer followed by s, m, h, d, or w")
  }

  const amount = Number(match[1])
  const milliseconds = amount * durationUnits[match[2]]
  if (!Number.isSafeInteger(amount) || !Number.isSafeInteger(milliseconds)) {
    throw new Error("Duration is too large")
  }

  return milliseconds
}

export function analyzeTranscriptRecords(
  records: TranscriptRecord[],
  window: TimeWindow,
): AnalysisStats {
  const nodes = buildTranscriptNodes(records)
  const answeredToolIds = collectAnsweredToolIds(records)
  const stats = emptyAnalysisStats()
  const seenToolIds = new Set<string>()
  const textCandidates = new Map<string, { text: string; workflow: Workflow }>()

  for (const record of records) {
    if (!isCountableAssistantRecord(record, window)) {
      continue
    }

    const workflow = findWorkflow(record, nodes)
    if (!workflow) {
      continue
    }

    const content = record.message?.content
    const blocks = Array.isArray(content) ? content : []
    const askBlocks = blocks.filter(isAskUserQuestionBlock)

    if (askBlocks.length > 0) {
      for (const block of askBlocks) {
        if (!block.id || seenToolIds.has(block.id)) {
          continue
        }

        seenToolIds.add(block.id)
        const questionCount = block.input?.questions?.length ?? 0
        if (questionCount === 0) {
          continue
        }

        addExactQuestions(stats.workflows[workflow], questionCount, answeredToolIds.has(block.id))
      }
      continue
    }

    const text = extractAssistantText(content)
    if (!text) {
      continue
    }

    const key = record.message?.id ?? record.uuid
    if (!key) {
      continue
    }

    const previous = textCandidates.get(key)
    if (!previous || text.length > previous.text.length) {
      textCandidates.set(key, { text, workflow })
    }
  }

  for (const { text, workflow } of textCandidates.values()) {
    const questionCount = inferPlainTextQuestionCount(text)
    stats.workflows[workflow].inferredQuestions += questionCount
    stats.workflows[workflow].questions += questionCount
  }

  return finalizeStats(stats)
}

export async function scanClaudeSessions(root: string, window: TimeWindow): Promise<ScanStats> {
  const rootStat = await stat(root)
  if (!rootStat.isDirectory()) {
    throw new Error(`Claude sessions root is not a directory: ${root}`)
  }

  const paths = await glob("**/*.jsonl", {
    absolute: true,
    cwd: root,
    ignore: ["**/subagents/**"],
    onlyFiles: true,
  })
  const combined = emptyAnalysisStats()
  const warnings: string[] = []
  let filesScanned = 0

  for (const path of paths) {
    try {
      const records = await readTranscript(path, warnings)
      mergeAnalysisStats(combined, analyzeTranscriptRecords(records, window))
      filesScanned += 1
    } catch (error) {
      warnings.push(`${path}: ${errorMessage(error)}`)
    }
  }

  const finalized = finalizeStats(combined)
  return { ...finalized, filesScanned, warnings }
}

function buildTranscriptNodes(records: TranscriptRecord[]): Map<string, TranscriptNode> {
  const nodes = new Map<string, TranscriptNode>()
  for (const record of records) {
    if (!record.uuid) {
      continue
    }

    nodes.set(record.uuid, {
      parentUuid: record.parentUuid ?? null,
      command: extractCommand(record),
    })
  }
  return nodes
}

function extractCommand(record: TranscriptRecord): string | null {
  if (
    record.isMeta === true ||
    record.message?.role !== "user" ||
    typeof record.message.content !== "string"
  ) {
    return null
  }

  const match = /<command-name>\/([^<\s]+)<\/command-name>/.exec(record.message.content)
  return match?.[1] ?? null
}

function findWorkflow(
  record: TranscriptRecord,
  nodes: Map<string, TranscriptNode>,
): Workflow | null {
  let uuid = record.parentUuid
  const visited = new Set<string>()

  while (uuid && !visited.has(uuid)) {
    visited.add(uuid)
    const node = nodes.get(uuid)
    if (!node) {
      return null
    }
    if (node.command) {
      return workflowByCommand[node.command] ?? null
    }
    uuid = node.parentUuid
  }

  return null
}

function collectAnsweredToolIds(records: TranscriptRecord[]): Set<string> {
  const ids = new Set<string>()
  for (const record of records) {
    if (record.isSidechain === true || !Array.isArray(record.message?.content)) {
      continue
    }
    for (const block of record.message.content) {
      if (block.type === "tool_result" && block.tool_use_id) {
        ids.add(block.tool_use_id)
      }
    }
  }
  return ids
}

function isCountableAssistantRecord(record: TranscriptRecord, window: TimeWindow): boolean {
  if (record.isSidechain === true || record.message?.role !== "assistant" || !record.timestamp) {
    return false
  }

  const timestamp = Date.parse(record.timestamp)
  return (
    Number.isFinite(timestamp) &&
    timestamp >= window.since.getTime() &&
    timestamp <= window.until.getTime()
  )
}

function isAskUserQuestionBlock(block: TranscriptContentBlock): boolean {
  return (
    block.type === "tool_use" &&
    block.name === "AskUserQuestion" &&
    Array.isArray(block.input?.questions)
  )
}

function extractAssistantText(content: string | TranscriptContentBlock[] | undefined): string {
  if (typeof content === "string") {
    return content.trim()
  }
  if (!Array.isArray(content)) {
    return ""
  }
  return content
    .filter((block) => block.type === "text" && typeof block.text === "string")
    .map((block) => block.text?.trim() ?? "")
    .filter(Boolean)
    .join("\n")
}

function inferPlainTextQuestionCount(text: string): number {
  const numberedHeadings = text.match(
    /(?:^|\n)\s*(?:#{1,6}\s*)?(?:\*{1,2})?(?:Question|Q)\s*\d+\b/gim,
  )
  if (numberedHeadings) {
    return numberedHeadings.length
  }

  const trimmed = text.trim().replace(/[\s*_`"')\]]+$/g, "")
  return trimmed.endsWith("?") ? 1 : 0
}

function addExactQuestions(stats: WorkflowStats, questionCount: number, answered: boolean): void {
  stats.questions += questionCount
  stats.exactQuestions += questionCount
  if (answered) {
    stats.completedBatches += 1
    stats.completedBatchSizes.push(questionCount)
  } else {
    stats.pendingBatches += 1
    stats.pendingQuestions += questionCount
  }
}

function emptyWorkflowStats(): WorkflowStats {
  return {
    questions: 0,
    exactQuestions: 0,
    inferredQuestions: 0,
    completedBatches: 0,
    pendingBatches: 0,
    pendingQuestions: 0,
    completedBatchSizes: [],
  }
}

function emptyAnalysisStats(): AnalysisStats {
  return {
    total: emptyWorkflowStats(),
    workflows: {
      "grill-me": emptyWorkflowStats(),
      "batch-grill-me": emptyWorkflowStats(),
      "grill-with-docs": emptyWorkflowStats(),
      wayfinder: emptyWorkflowStats(),
    },
    batchQuestions: { min: 0, max: 0, average: 0 },
  }
}

function mergeAnalysisStats(target: AnalysisStats, source: AnalysisStats): void {
  for (const workflow of workflows) {
    const targetWorkflow = target.workflows[workflow]
    const sourceWorkflow = source.workflows[workflow]
    targetWorkflow.questions += sourceWorkflow.questions
    targetWorkflow.exactQuestions += sourceWorkflow.exactQuestions
    targetWorkflow.inferredQuestions += sourceWorkflow.inferredQuestions
    targetWorkflow.completedBatches += sourceWorkflow.completedBatches
    targetWorkflow.pendingBatches += sourceWorkflow.pendingBatches
    targetWorkflow.pendingQuestions += sourceWorkflow.pendingQuestions
    targetWorkflow.completedBatchSizes.push(...sourceWorkflow.completedBatchSizes)
  }
}

function finalizeStats(stats: AnalysisStats): AnalysisStats {
  stats.total = emptyWorkflowStats()
  for (const workflow of workflows) {
    const workflowStats = stats.workflows[workflow]
    stats.total.questions += workflowStats.questions
    stats.total.exactQuestions += workflowStats.exactQuestions
    stats.total.inferredQuestions += workflowStats.inferredQuestions
    stats.total.completedBatches += workflowStats.completedBatches
    stats.total.pendingBatches += workflowStats.pendingBatches
    stats.total.pendingQuestions += workflowStats.pendingQuestions
    stats.total.completedBatchSizes.push(...workflowStats.completedBatchSizes)
  }

  stats.batchQuestions = calculateBatchQuestionStats(stats.total.completedBatchSizes)
  return stats
}

function calculateBatchQuestionStats(sizes: number[]): BatchQuestionStats {
  if (sizes.length === 0) {
    return { min: 0, max: 0, average: 0 }
  }

  const sum = sizes.reduce((total, size) => total + size, 0)
  return {
    min: Math.min(...sizes),
    max: Math.max(...sizes),
    average: sum / sizes.length,
  }
}

async function readTranscript(path: string, warnings: string[]): Promise<TranscriptRecord[]> {
  const input = createReadStream(path, { encoding: "utf8" })
  const lines = createInterface({ input, crlfDelay: Infinity })
  const records: TranscriptRecord[] = []
  let lineNumber = 0

  for await (const line of lines) {
    lineNumber += 1
    if (!line.trim()) {
      continue
    }
    try {
      const value: unknown = JSON.parse(line)
      if (value && typeof value === "object") {
        records.push(value as TranscriptRecord)
      } else {
        warnings.push(`${path}:${lineNumber}: JSON value is not an object`)
      }
    } catch (error) {
      warnings.push(`${path}:${lineNumber}: ${errorMessage(error)}`)
    }
  }

  return records
}

function errorMessage(error: unknown): string {
  return error instanceof Error ? error.message : String(error)
}
