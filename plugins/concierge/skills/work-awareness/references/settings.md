# Owner settings and exact-item disposition

Enable or disable only on the owner's explicit request. Reuse a current settings read; otherwise read once, then call `concierge_manage_work_awareness` with `enable` or `disable` and the settings revision. Use one stable `operationId` per intended mutation, preserving its identity on an identical uncertain retry. Disabling clears stored update content.

Mark `discussed` only after actually communicating the item; use `dismiss` only for the exact owner-dismissed item. Supply its `itemId` and item `revision`, not the settings revision. Injection, reading, ringing and hangup are not acknowledgement. A disposition never discharges another root's return obligation.

Use the supported mutation result as the receipt; no duplicate success read. On revision conflict, reread once. If the owner's instruction covers a fresh mutation, use the new settings/item revision and a fresh `operationId`; otherwise preserve the newer state and stop. A disabled/no-write result is not a successful enable, publish or disposition. Finish after an established result or a narrow unavailable/conflict report.
