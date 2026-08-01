#!/usr/bin/env node

import { homedir } from "node:os"
import { join } from "node:path"

import {
  parseDuration,
  scanClaudeSessions,
  workflows,
  type ScanStats,
  type WorkflowStats,
} from "./lib/claude-grill-stats.ts"

const usage = `Usage: claude-grill-stats.ts <duration> [--json]

Show questions asked during Claude Code grilling sessions in a rolling time window.

Arguments:
  duration  Positive integer followed by s, m, h, d, or w (for example: 2h, 1d)

Options:
  --json    Print machine-readable JSON
  --help    Show this help

A completed batch round is one AskUserQuestion submission that you answered. Claude may
split one logical frontier round into multiple submissions. Legacy plain-text questions are
conservatively inferred and reported separately from exact AskUserQuestion counts.`

async function main(): Promise<void> {
  const args = process.argv.slice(2)
  if (args.includes("--help")) {
    console.info(usage)
    return
  }

  const json = args.includes("--json")
  const positional = args.filter((argument) => argument !== "--json")
  if (positional.length !== 1 || positional[0].startsWith("--")) {
    throw new Error(usage)
  }

  const duration = positional[0]
  const durationMilliseconds = parseDuration(duration)
  const until = new Date()
  const since = new Date(until.getTime() - durationMilliseconds)
  const root = join(homedir(), ".claude", "projects")
  const stats = await scanClaudeSessions(root, { since, until })

  for (const warning of stats.warnings) {
    console.error(`Warning: ${warning}`)
  }

  if (json) {
    console.info(JSON.stringify(jsonReport(duration, since, until, stats), null, 2))
  } else {
    console.info(humanReport(duration, since, until, stats))
  }
}

function humanReport(duration: string, since: Date, until: Date, stats: ScanStats): string {
  const headers = [
    "Workflow",
    "Questions",
    "Exact",
    "Inferred",
    "Batches",
    "Pending",
    "Pending questions",
  ]
  const rows = workflows.map((workflow) => statsRow(workflow, stats.workflows[workflow]))
  rows.push(statsRow("Total", stats.total))

  return [
    `Claude grilling stats — last ${duration}`,
    `Window: ${since.toISOString()} → ${until.toISOString()}`,
    `Scanned: ${stats.filesScanned} transcripts`,
    "",
    renderTable(headers, rows),
    "",
    `Completed batch rounds: ${stats.total.completedBatches}`,
    `Pending batch submissions: ${stats.total.pendingBatches}`,
    `Questions per completed batch: min ${stats.batchQuestions.min}, ` +
      `max ${stats.batchQuestions.max}, avg ${stats.batchQuestions.average.toFixed(2)}`,
    `Warnings: ${stats.warnings.length}`,
  ].join("\n")
}

function statsRow(label: string, stats: WorkflowStats): string[] {
  return [
    label,
    String(stats.questions),
    String(stats.exactQuestions),
    String(stats.inferredQuestions),
    String(stats.completedBatches),
    String(stats.pendingBatches),
    String(stats.pendingQuestions),
  ]
}

function renderTable(headers: string[], rows: string[][]): string {
  const widths = headers.map((header, index) =>
    Math.max(header.length, ...rows.map((row) => row[index].length)),
  )
  const renderRow = (row: string[]): string =>
    row
      .map((cell, index) => cell.padEnd(widths[index]))
      .join("  ")
      .trimEnd()

  return [
    renderRow(headers),
    widths.map((width) => "-".repeat(width)).join("  "),
    ...rows.map(renderRow),
  ].join("\n")
}

function jsonReport(duration: string, since: Date, until: Date, stats: ScanStats): object {
  return {
    duration,
    window: {
      since: since.toISOString(),
      until: until.toISOString(),
    },
    filesScanned: stats.filesScanned,
    warningCount: stats.warnings.length,
    questions: {
      total: stats.total.questions,
      exact: stats.total.exactQuestions,
      inferred: stats.total.inferredQuestions,
    },
    workflows: Object.fromEntries(
      workflows.map((workflow) => [workflow, publicWorkflowStats(stats.workflows[workflow])]),
    ),
    batchRounds: {
      completed: stats.total.completedBatches,
      pending: stats.total.pendingBatches,
      pendingQuestions: stats.total.pendingQuestions,
      questionsPerCompletedBatch: stats.batchQuestions,
    },
  }
}

function publicWorkflowStats(stats: WorkflowStats): object {
  return {
    questions: stats.questions,
    exactQuestions: stats.exactQuestions,
    inferredQuestions: stats.inferredQuestions,
    completedBatches: stats.completedBatches,
    pendingBatches: stats.pendingBatches,
    pendingQuestions: stats.pendingQuestions,
  }
}

main().catch((error: unknown) => {
  console.error(error instanceof Error ? error.message : String(error))
  process.exitCode = 1
})
