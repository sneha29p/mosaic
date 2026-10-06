# TerraSentry 4.0 implementation summary

TerraSentry 4.0 upgrades the existing 3.4 codebase rather than replacing it.

## Modified existing files

- `.env.example` — live-provider tuning aligned to the bounded fast-evidence path.
- `README.md` — full 4.0 operation, Demo/Live/Presentation instructions.
- `VALIDATION.md` — acceptance/test report.
- `backend/Dockerfile` — includes the demo evidence directory.
- `backend/app/config.py` — Demo root and version 4.0.0.
- `backend/app/main.py` — deterministic Remal endpoints and live→cache→demo failure path.
- `docker-compose.yml` — repository-root build contexts so both services can access demo assets.
- `frontend/Dockerfile` — includes `demo/` in the Vite build.
- `frontend/package.json` — version 4.0.0.
- `frontend/src/App.tsx` — command-center home, Demo/Live switch, 2.5-second demo pipeline, Presentation Mode, 10-screen enhancements, Previous/Next navigation, risk tabs, impact table, response actions.
- `frontend/src/api.ts` — demo API accessor and safer one-read error parsing.
- `frontend/src/components/EvidenceDrawer.tsx` — demo/live provenance labels without false Sentinel claims.
- `frontend/src/components/MapWorkspace.tsx` — offline-capable demo MapLibre style, track/SAR/change/exposure/oil/priority/admin layers, popups, numbered zone markers.
- `frontend/src/components/SarCompare.tsx` — working split slider, real-EO image failure state, explicit demo labels.
- `frontend/src/styles.css` — geospatial command-center visual system, map-first dashboard, ocean/navy/cyan/earth accents, timeline, mode controls, responsive/presentation styles.
- `frontend/src/types.ts` — coherent demo data types.
- `run-backend.ps1` — install-once behavior and direct local launch.
- `run-frontend.ps1` — install-once behavior and direct local launch.

## Added files

- `SOURCES.md`
- `CHANGELOG_4.0.md`
- `validate_project.py`
- `setup-windows.ps1`
- `start-windows.ps1`
- `run-demo-assets.ps1`
- `frontend/vite.config.ts`
- `backend/tests/test_demo.py`
- `demo/remal/README.md`
- `demo/remal/manifest.json`
- `demo/remal/metadata.json`
- `demo/remal/analysis.json`
- `demo/remal/zones.geojson`
- `demo/remal/cyclone-track.geojson`
- `demo/remal/facilities.geojson`
- `demo/remal/roads.geojson`
- `demo/remal/fetch-demo-assets.ps1`

## Demo behavior

- Default mode: `DEMO MODE`.
- Main dashboard is populated immediately from the local Remal manifest.
- Start Analysis runs a deterministic 2.5-second five-stage animation.
- The same manifest drives all ten screens.
- Real EO display assets are cached locally with `fetch-demo-assets.ps1`.
- If imagery is not available, the UI says so; no synthetic SAR replacement is generated.

## Live behavior

The existing real Sentinel-1 pipeline remains available. It runs as a background job with real backend progress, timeouts, overlap gating and compatibility selection. On failure the order is:

1. same-AOI cached real investigation,
2. clearly labelled deterministic Remal demo evidence,
3. never synthetic SAR.
