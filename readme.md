# Release Notes – v1.2.2

**Date:** 2026‑05‑27

## Overview
A new **AI‑driven threat analysis** capability has been added to the SIEM platform. High‑severity incidents are automatically enriched with contextual intelligence from the Groq LLM (model `llama-3.3-70b-versatile`) and displayed in an enhanced incident‑monitoring dashboard.

## Key Features
- **AI Incident Enrichment** – `src/llm_analyzer.py` calls the Groq API to generate a structured analysis (`threat_summary`, `what_happened`, `recommended_action`, `mitre_technique`, `risk_score`). Only `CRITICAL` and `HIGH` severity events trigger the LLM.
- **Graceful Error Handling** – API failures are caught, logged, and the pipeline continues without breaking the consumer.
- **Dashboard UI Update** – The React dashboard now includes a **“Groq AI Threat Analysis”** glass‑morphic card within the incident detail modal, showing the AI fields, a risk‑score meter, and MITRE ATT&CK mapping.
- **Docker Integration** – Groq SDK added to `requirements.txt`; `docker-compose.local.yml` passes `GROQ_API_KEY` into the consumer container; `Dockerfile.consumer` copies `llm_analyzer.py`.
- **Observability** – Logs (`[LLM] Successfully generated AI incident analysis` / `[LLM] Graceful fallback`) are emitted from the consumer for debugging.

## Impact
- Security analysts receive richer, actionable insight directly in the UI, reducing manual investigation time.
- Operational load stays low: AI calls only on critical/high alerts.
- System stability is maintained; a fallback ensures incidents are still stored if the LLM service is unavailable.

## Upgrade Steps
1. Pull the latest code (`git pull origin main`).
2. Re‑build Docker images to include the new Python dependency:
   ```powershell
   docker compose -f docker-compose.local.yml up -d --build --no-cache
   ```
3. Restart the dashboard container or clear the browser cache to load the updated UI bundle.
4. Verify `GROQ_API_KEY` is present in `.env` and propagated to the consumer service.

## Verification Checklist
- [ ] Consumer logs show `[LLM] Successfully generated AI incident analysis` for high‑severity events.
- [ ] Enriched incident documents contain the `ai_analysis` field in Elasticsearch.
- [ ] Dashboard Incident Detail Modal renders the AI analysis card with all fields displayed.
- [ ] No regression in existing alert processing (low/medium severity incidents remain unchanged).

---

*Acknowledgements*: Groq team for the LLM endpoint; front‑end designers for the glass‑morphic UI.
