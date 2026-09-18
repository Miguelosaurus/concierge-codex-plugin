# Channel reciprocity

Load when choosing the response presentation for an inbound interaction.

- The current beta is Voice-first: live call→live native Voice. Normal SMS/MMS and carrier voice-note replies are out of beta, even when a physical DID supports them.
- A higher DeliveryPlan, explicit owner preference, capability limit, or no-answer policy may override the call decision, but cannot create a removed carrier channel.
- If Voice is unavailable or not warranted, use native work notification/defer/recheck or the explicit no-return disposition and say only what the recipient needs to know.
