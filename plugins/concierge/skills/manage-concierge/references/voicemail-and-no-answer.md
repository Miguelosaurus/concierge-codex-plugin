# Call outcomes: voicemail, no-answer, decline, failure, and uncertainty

Load after an outbound/live attempt is unanswered, declined/rejected, provider/transport-failed, connected-but-incomplete, uncertain, or reaches voicemail.

Keep **transport outcome** separate from **task outcome**:

- **Dial/provider accepted:** the attempt was accepted for processing. This is not proof that the destination rang, answered, established a conversation, or completed the task.
- **Unanswered / no-answer:** no answered conversation was established according to authoritative call state. Do not rewrite this as provider failure or as a deliberate human decline unless authoritative state actually says so.
- **Declined / rejected:** authoritative call state says the attempt was declined or rejected. Report that exact outcome without inventing whether a person, device, carrier, screening layer, or policy caused it. Do not relabel it as generic infrastructure failure.
- **Provider / transport failure:** the call could not be established or maintained because authoritative transport/provider state says it failed. Do not report that the recipient declined or simply did not answer.
- **Connected / answered:** a live media/conversation path was established. Connection alone does not mean the delegated objective succeeded.
- **Task completed:** report completion only after the actual requested semantic outcome or material commitment is confirmed—for example, the reservation is actually booked, the information was obtained, or the requested decision was actually communicated.
- **Hangup / disconnect:** the call ended. The surviving work outcome may still be completed, partial, blocked, pending, or uncertain.
- **Uncertain:** available evidence is insufficient, ambiguous, or was lost after the attempt may already have progressed. Do not collapse uncertainty into failed, unanswered, declined, connected, or completed. Reconcile authoritative state before deciding what happened.

Voicemail is a call outcome, not an asynchronous voice note. Leave at most one concise, decision-ready message when useful and authorized: who is calling, the blocker, the decision/request, and a real deadline if needed. Leaving a voicemail does not complete the original delegated task unless delivery of that message was itself the requested objective.

Do not include private project, Calendar, memory, transcript, credential, or payment details in voicemail.

Retry semantics follow outcome certainty:

- after an **ambiguous/uncertain** effect, reconcile and reuse the same operation identity for the identical intended effect; never create a fresh ID merely because the response was lost;
- after a **known terminal** no-answer/decline/failure outcome, never automatically redial. A later deliberate retry is a new authorized side effect with a new operation ID and must pass fresh current authority, policy, commercial, occupancy, and capability checks.

If voicemail is unavailable, the task remains incomplete, or too much context is needed, keep the obligation in native work and use the scoped defer/recheck/owner-return semantics. Normal SMS/MMS and carrier voice-note fallback are not beta channels.
