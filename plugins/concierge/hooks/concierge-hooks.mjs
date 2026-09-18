#!/usr/bin/env node
import { mkdir, readFile, writeFile } from "node:fs/promises";
import { join } from "node:path";

const MAX_MARKER_BYTES = 8_192;
const input = await readJson(process.stdin);
const event = input?.hook_event_name;

if (event === "SessionStart") {
  process.stdout.write(JSON.stringify({
    hookSpecificOutput: {
      hookEventName: event,
      additionalContext: "Concierge close-loop guard: native Codex thread/goal state remains authoritative; a phone hangup ends Voice only.",
    },
  }));
  process.exit(0);
}

if (event !== "Stop") {
  process.stdout.write("{}");
  process.exit(0);
}

const markerPath = markerFile();
const marker = await readMarker(markerPath);
if (input.stop_hook_active === true) {
  await writeMarker(markerPath, { ...marker, continuationUsed: true, pending: true });
  process.stdout.write("{}");
  process.exit(0);
}

const credibleUnfinished = marker.activeGoal === true || marker.planActive === true || marker.returnObligationPending === true;
if (credibleUnfinished && marker.continuationUsed !== true) {
  await writeMarker(markerPath, { ...marker, continuationUsed: true, pending: true });
  process.stdout.write(JSON.stringify({
    decision: "block",
    reason: "Concierge has credible unfinished native work or a pending owner return obligation; continue once, then allow the next stop.",
  }));
  process.exit(0);
}

process.stdout.write("{}");

async function readJson(stream) {
  let text = "";
  for await (const chunk of stream) text += chunk;
  try { return JSON.parse(text); } catch { return {}; }
}

function markerFile() {
  const root = process.env.PLUGIN_DATA || process.env.CLAUDE_PLUGIN_DATA;
  return root ? join(root, "close-loop.json") : undefined;
}

async function readMarker(path) {
  if (!path) return {};
  try {
    const text = await readFile(path, "utf8");
    if (Buffer.byteLength(text, "utf8") > MAX_MARKER_BYTES) return {};
    const value = JSON.parse(text);
    return value && typeof value === "object" ? value : {};
  } catch { return {}; }
}

async function writeMarker(path, marker) {
  if (!path) return;
  try {
    await mkdir(join(path, ".."), { recursive: true });
    const text = JSON.stringify({
      activeGoal: marker.activeGoal === true,
      planActive: marker.planActive === true,
      returnObligationPending: marker.returnObligationPending === true,
      continuationUsed: marker.continuationUsed === true,
      pending: marker.pending === true,
      ...(typeof marker.threadId === "string" ? { threadId: marker.threadId.slice(0, 256) } : {}),
    });
    if (Buffer.byteLength(text, "utf8") <= MAX_MARKER_BYTES) await writeFile(path, text, "utf8");
  } catch {
    // Hook failure must never turn a stop into an unbounded loop.
  }
}
