# TerraSentry 4.0 validation report

## Validation performed in this build environment

### Backend

- `python -m py_compile backend/app/*.py` — **PASS**
- `PYTHONPATH=backend pytest -q backend/tests` — **PASS: 9 tests**
- FastAPI TestClient:
  - `GET /api/health` — **200**, version `4.0.0`
  - `GET /api/demo/remal` — **200**, id `demo-remal-2024`
  - `GET /api/demo/remal/status` — **200**

The tests cover:

- AOI bounding box generation,
- transparent priority-score renormalization,
- true event bracketing,
- SAR temporal-change behavior,
- compatible orbit/polarization pairing,
- low-overlap pair rejection / next-pair retry,
- coherent Remal demo manifest,
- real Sentinel-1/Sentinel-2 metadata presence,
- oil-risk guardrail (`confirmed_spill == false`),
- dashboard data availability.

### Frontend source

- TypeScript/TSX source syntax transpilation across all `frontend/src` files — **PASS, 0 syntax diagnostics**.
- TypeScript typecheck using local compatibility declarations for external React/MapLibre/Lucide packages — **PASS**.
- `python validate_project.py` — **PASS**:
  - 10-screen workflow strings present,
  - Previous/Next workflow navigation present,
  - deterministic 2.5-second Demo Mode path present,
  - MapLibre map implementation present,
  - before/after range slider present,
  - real-EO-only SAR fallback guardrail present,
  - RippleCursor sources preserved,
  - demo data contains five priority zones, actions, resources and impact table.

A complete `npm install && npm run build` could not be executed in this sandbox because outbound npm access is unavailable. The source was nevertheless syntax-transpiled and typechecked with local external-module compatibility declarations. On an internet-connected machine, run the exact commands below as the final package-manager build check.

```powershell
cd frontend
npm install
npm run typecheck
npm run build
```

## Real EO image note

The build environment cannot download arbitrary internet files into the generated ZIP. Therefore the repository ships the verified public-source URLs plus `demo/remal/fetch-demo-assets.ps1`.

Run that script once while online. It caches:

- `before.jpg` — real JAXA ALOS-2 SAR emergency observation,
- `after.jpg` — real JAXA ALOS-2 SAR emergency observation,
- `change.jpg` — public Sentinel-1-derived flood product,
- `reference.jpg` — local reference copy.

The UI never generates a synthetic replacement. If imagery is not cached and cannot be reached, it displays an explicit evidence-unavailable state.

## Presentation acceptance sequence

1. Start backend — supported.
2. Start frontend — supported.
3. Open Home — command-center dashboard has local demo data.
4. Map renders — MapLibre implementation retained.
5. Cyclone/event visible — local Remal track / AOI layers.
6. Start Analysis — wired.
7. Loading state — deterministic Demo Mode overlay.
8. 2.5 seconds — five 500 ms stages.
9. Real EO asset path activated — local cache / verified public source; never synthetic.
10. Event Context — navigable.
11. Satellite Analysis — navigable and populated.
12. Before/After — draggable slider implemented.
13. Change Detection — populated.
14. Exposure — precomputed demo data + map layers/popups.
15. Oil Risk — `Potential Oil-Risk Signal`, `REQUIRES VERIFICATION`, no confirmed spill.
16. Risk/Confidence/Priority — separate tabs/signals.
17. Impact Dashboard — before/after table driven by shared manifest.
18. Response Priority — five ranked zones and numbered map markers.
19. Previous/Next navigation — implemented globally.
20. Ripple cursor — existing canvas implementation preserved.
21. Map interaction — zoom/pan/toggles/popups retained.
22. Refresh reliability — demo manifest available from backend and Vite public demo folder.

## Known operational dependency

LIVE DATA remains dependent on public external providers. The production behavior is intentionally safe: timeout/provider failure switches to the clearly labelled deterministic demo package instead of blanking or fabricating a live result.
