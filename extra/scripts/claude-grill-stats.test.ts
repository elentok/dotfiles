import assert from "node:assert/strict"
import { mkdir, mkdtemp, rm, writeFile } from "node:fs/promises"
import { tmpdir } from "node:os"
import { join } from "node:path"
import test from "node:test"

import {
  analyzeTranscriptRecords,
  parseDuration,
  scanClaudeSessions,
  type TranscriptRecord,
} from "./lib/claude-grill-stats.ts"

const since = new Date("2026-08-01T10:00:00.000Z")
const until = new Date("2026-08-01T12:00:00.000Z")

function commandRecord(uuid: string, parentUuid: string | null, command: string): TranscriptRecord {
  return {
    type: "user",
    uuid,
    parentUuid,
    timestamp: "2026-08-01T10:01:00.000Z",
    message: {
      role: "user",
      content:
        `<command-message>${command}</command-message>\n` +
        `<command-name>/${command}</command-name>`,
    },
  }
}

function askRecord(
  uuid: string,
  parentUuid: string,
  toolUseId: string,
  questionCount: number,
  timestamp = "2026-08-01T10:02:00.000Z",
): TranscriptRecord {
  return {
    type: "assistant",
    uuid,
    parentUuid,
    timestamp,
    attributionSkill: "grilling",
    message: {
      id: `message-${uuid}`,
      role: "assistant",
      content: [
        {
          type: "tool_use",
          id: toolUseId,
          name: "AskUserQuestion",
          input: {
            questions: Array.from({ length: questionCount }, (_, index) => ({
              question: `Question ${index + 1}?`,
            })),
          },
        },
      ],
    },
  }
}

function answerRecord(uuid: string, parentUuid: string, toolUseId: string): TranscriptRecord {
  return {
    type: "user",
    uuid,
    parentUuid,
    timestamp: "2026-08-01T10:03:00.000Z",
    message: {
      role: "user",
      content: [{ type: "tool_result", tool_use_id: toolUseId }],
    },
  }
}

test("parseDuration accepts the agreed integer units", () => {
  assert.equal(parseDuration("30s"), 30_000)
  assert.equal(parseDuration("15m"), 900_000)
  assert.equal(parseDuration("2h"), 7_200_000)
  assert.equal(parseDuration("1d"), 86_400_000)
  assert.equal(parseDuration("2w"), 1_209_600_000)
})

test("parseDuration rejects unsupported or unsafe values", () => {
  for (const value of ["", "0h", "00h", "1.5h", "1h30m", "1ms", "-2h", "tomorrow"]) {
    assert.throws(() => parseDuration(value), /duration/i)
  }
  assert.throws(() => parseDuration(`${Number.MAX_SAFE_INTEGER}w`), /duration/i)
})

test("analyzes exact questions, completed batches, and pending batches", () => {
  const records = [
    commandRecord("command", null, "batch-grill-me"),
    askRecord("ask-1", "command", "tool-1", 3),
    answerRecord("answer-1", "ask-1", "tool-1"),
    askRecord("ask-2", "answer-1", "tool-2", 2),
  ]

  const stats = analyzeTranscriptRecords(records, { since, until })

  assert.deepEqual(stats.workflows["batch-grill-me"], {
    questions: 5,
    exactQuestions: 5,
    inferredQuestions: 0,
    completedBatches: 1,
    pendingBatches: 1,
    pendingQuestions: 2,
    completedBatchSizes: [3],
  })
})

test("uses the nearest slash command as the workflow boundary", () => {
  const records = [
    commandRecord("grill", null, "wayfinder"),
    askRecord("included", "grill", "tool-included", 1),
    commandRecord("other", "included", "commit"),
    askRecord("excluded", "other", "tool-excluded", 4),
  ]

  const stats = analyzeTranscriptRecords(records, { since, until })

  assert.equal(stats.total.questions, 1)
  assert.equal(stats.workflows.wayfinder.questions, 1)
})

test("maps legacy grill and conservatively infers plain-text questions", () => {
  const records: TranscriptRecord[] = [
    commandRecord("command", null, "grill"),
    {
      type: "assistant",
      uuid: "numbered",
      parentUuid: "command",
      timestamp: "2026-08-01T10:02:00.000Z",
      message: {
        id: "numbered-message",
        role: "assistant",
        content: "**Question 1 — Scope?**\n\n## Q2: Format?",
      },
    },
    {
      type: "assistant",
      uuid: "terminal",
      parentUuid: "numbered",
      timestamp: "2026-08-01T10:03:00.000Z",
      message: {
        id: "terminal-message",
        role: "assistant",
        content: "Does that match what you intended?",
      },
    },
  ]

  const stats = analyzeTranscriptRecords(records, { since, until })

  assert.equal(stats.workflows["grill-me"].questions, 3)
  assert.equal(stats.workflows["grill-me"].inferredQuestions, 3)
})

test("filters by question timestamp, skips sidechains, and deduplicates tool ids", () => {
  const duplicate = askRecord("duplicate", "ask", "same-tool", 2)
  const sidechain = askRecord("sidechain", "duplicate", "sidechain-tool", 3)
  sidechain.isSidechain = true

  const records = [
    commandRecord("command", null, "grill-me"),
    askRecord("outside", "command", "outside-tool", 5, "2026-08-01T09:59:59.999Z"),
    askRecord("ask", "outside", "same-tool", 2),
    duplicate,
    sidechain,
  ]

  const stats = analyzeTranscriptRecords(records, { since, until })

  assert.equal(stats.total.questions, 2)
  assert.equal(stats.total.pendingBatches, 1)
})

test("calculates aggregate batch-size statistics", () => {
  const records = [
    commandRecord("command", null, "batch-grill-me"),
    askRecord("ask-1", "command", "tool-1", 1),
    answerRecord("answer-1", "ask-1", "tool-1"),
    askRecord("ask-2", "answer-1", "tool-2", 4),
    answerRecord("answer-2", "ask-2", "tool-2"),
  ]

  const stats = analyzeTranscriptRecords(records, { since, until })

  assert.deepEqual(stats.batchQuestions, { min: 1, max: 4, average: 2.5 })
})

test("scans main transcripts while warning on malformed lines and excluding subagents", async () => {
  const root = await mkdtemp(join(tmpdir(), "claude-grill-stats-"))
  const subagentRoot = join(root, "project", "subagents")
  await mkdir(subagentRoot, { recursive: true })

  try {
    const records = [
      commandRecord("command", null, "batch-grill-me"),
      askRecord("ask", "command", "tool", 2),
    ]
    await writeFile(
      join(root, "session.jsonl"),
      records.map((record) => JSON.stringify(record)).join("\n") + "\n{truncated",
    )
    await writeFile(
      join(subagentRoot, "agent.jsonl"),
      records.map((record) => JSON.stringify(record)).join("\n"),
    )

    const stats = await scanClaudeSessions(root, { since, until })

    assert.equal(stats.filesScanned, 1)
    assert.equal(stats.warnings.length, 1)
    assert.equal(stats.total.questions, 2)
  } finally {
    await rm(root, { recursive: true, force: true })
  }
})
