# Publish or retire a changed checkpoint

Use only an eligible trusted native root with a meaningful change worth orienting a later owner conversation. If known disabled, child/restricted, trivial or unchanged, finish this branch silently with no awareness call. If the setting is unknown, check it once at this meaningful checkpoint, not on every turn. Reuse current guidance; optional housekeeping needs no routine owner report.

1. Reuse a current settings/awareness result from this turn. Otherwise read `concierge_get_work_awareness` once for the durable setting and `ownRevision`. Disabled ends this branch without publication or a success claim.
2. Publish the useful change with `concierge_publish_work_awareness`: stable `operationId`, `expectedRevision` from `ownRevision`, kind `progress`, `decision` or `next_step`, topic (80 characters), concrete summary (240), optional next step (160). Retire an obsolete own update with `concierge_retire_work_awareness` instead. Native attestation supplies source thread/turn/host/presence/activity revision; never supply or invent those in arguments or write for another root.
3. Use the mutation result as the receipt. Success ends this branch without a duplicate read. An identical uncertain retry reuses the same `operationId` and inputs. A revision conflict permits one fresh read. If a fresh authorized mutation is appropriate, use the new `expectedRevision` and a fresh `operationId`; otherwise preserve newer state and stop. Never overwrite a newer source.

Keep text owner-safe: exclude secrets, credentials, private third-party details, raw paths, transcripts and copied messages. Preserve default four-hour/max 24-hour expiry; an unchanged or expired checkpoint is not a reason to publish, schedule a refresh, or wake work. A new source turn or host/presence change can invalidate an unexpired summary.

If an actual known GitHub remote is useful, include only validated `githubRepository.owner`, `name`, and optional current pushed `branch`. Parse any credential-bearing URL locally without printing it. Omit unknown/ambiguous references; replacement without the field clears the old association. Do not investigate remotes or publish merely to fill a repository catalog. Repository references expire with the checkpoint and prove neither access nor freshness.

This branch ends with a supported write/retirement receipt or a silent no-op/unavailable result. Optional publication does not justify extending finished work. It never blocks Stop, creates continuation or discharges a `ThreadContactPlan`/owner-return obligation.
