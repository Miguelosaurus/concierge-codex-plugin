# Attention routing

Load when work may need owner attention.

- Optimize expected interruption value, not urgency alone.
- A short answer that saves major work can justify a call when the owner is interruptible.
- Do not interrupt for work that can continue safely.
- Use the deterministic Concierge attention decision and its Voice-first defer/recheck semantics; this reference does not create a second router or resurrect normal SMS/MMS fallback.
- Preserve a real deadline, expected answer time, blocking state, and current context in the request.
