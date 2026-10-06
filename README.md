# TerraSentry 4.0 — Disaster Intelligence Command Center

TerraSentry is a full-stack geospatial disaster-intelligence application that combines **multi-temporal Earth-observation evidence**, interactive MapLibre mapping, exposure analysis, confidence-aware response prioritization, and a deterministic hackathon presentation path.

The application keeps two modes deliberately separate:

- **DEMO MODE** — default for presentation. Loads one coherent Cyclone Remal investigation after a deterministic 2.5-second processing sequence. The analytics are precomputed and the display SAR comes from real public Earth-observation products, never synthetic noise or generated satellite imagery.
- **LIVE DATA** — attempts current external providers and real Sentinel-1 processing. If the provider path times out or fails, TerraSentry keeps the UI alive and visibly switches to the Remal demo evidence package.

## Ten-screen workflow

1. Interactive Home / Mission Control
2. Cyclone / Event Context
3. Latest Satellite Analysis
4. Before / After Comparison
5. Flood / Change Detection
6. Exposure Analysis
7. Secondary Oil-Risk Analysis
8. Risk, Confidence & Priority
9. Before / After Impact Dashboard
10. Response Priority Dashboard

The selected investigation persists across the workflow. Previous/Next navigation and the left mission-flow rail do not reload the application.

## Mission Control

The home screen is now a map-first command center with:

- active Cyclone Remal context,
- natural-hazard assessment bars,
- environmental-impact indicators,
- interactive MapLibre map,
- cyclone track and current event state,
- flood/change, roads, facilities, SAR footprint, oil-risk and priority-zone overlays,
- response decision-support actions,
- resource-coordination status,
- horizontal impact timeline that controls the displayed event state,
- visible LIVE DATA / DEMO MODE switch,
- Presentation Mode.

## Cyclone Remal presentation dataset

The single demo source of truth lives in:

```text
demo/remal/
├─ manifest.json
├─ metadata.json
├─ analysis.json
├─ zones.geojson
├─ cyclone-track.geojson
├─ facilities.geojson
├─ roads.geojson
├─ fetch-demo-assets.ps1
├─ before.jpg       # downloaded real EO asset
├─ after.jpg        # downloaded real EO asset
├─ change.jpg       # downloaded real Sentinel-1-derived flood product
└─ reference.jpg    # local reference copy of before.jpg
```

`manifest.json` drives every demo dashboard. Values are not scattered throughout React components.

The dataset includes published Sentinel-1 and Sentinel-2 acquisition metadata, a published Remal inundation extent, a transparent population-exposure proxy, demo GIS intersections, five response-priority zones, an unverified oil-risk context, recommended actions and a common event timeline.

### Real SAR assets

TerraSentry does **not** generate fake SAR imagery. The project includes a downloader that caches real public emergency-observation imagery from Sentinel Asia/JAXA and the Sentinel-1-derived public flood product into `demo/remal/`.

On Windows, run once while online:

```powershell
.\demo\remal\fetch-demo-assets.ps1
```

`setup-windows.ps1` attempts this automatically. Once cached, Presentation Mode can render the SAR evidence without external provider calls.

If a real image has not been cached and the remote source is unavailable, the UI shows an explicit evidence-unavailable message. It never substitutes a gradient/noise image and calls it SAR.

## Deterministic 2.5-second demo pipeline

Click **START ANALYSIS** or **ANALYZE CYCLONE REMAL** while DEMO MODE is active. TerraSentry shows this sequence at 500 ms intervals:

1. Connecting to Earth observation catalogue…
2. Querying Sentinel-1 observations…
3. Checking temporal coverage…
4. Validating SAR acquisition…
5. Preparing change-detection evidence…

After the 2.5-second sequence, the single precomputed Remal investigation is activated and the user can move through all ten screens immediately. No expensive ML/geospatial calculation is executed during the presentation path.

## Live mode

LIVE DATA keeps the original project architecture and real-provider path:

1. query current Sentinel-1 catalogue,
2. rank orbit/polarization-compatible temporal pairs,
3. test real-raster overlap,
4. read the selected real SAR pair,
5. compute temporal backscatter change,
6. build evidence/confidence,
7. calculate GIS exposure when requested,
8. derive response priority separately from evidence confidence.

The live investigation runs as a background job so the frontend receives genuine progress. It has bounded provider timeouts and an interactive safety limit. Failure does not blank the dashboard: TerraSentry visibly reports **LIVE PROVIDER UNAVAILABLE · SWITCHED TO DEMO EVIDENCE**.

## Important analytical guardrails

TerraSentry intentionally avoids common judging traps:

- no single-image classifier presented as temporal disaster intelligence,
- no fake “instantaneous satellite feed” language,
- no synthetic SAR fallback,
- no hidden data provenance,
- hazard signal, confidence and response priority remain separate,
- `LIMITED` / `NOT_ASSESSABLE` are valid outcomes,
- a dark SAR candidate is not called a confirmed oil spill,
- population exposure is not called a casualty count,
- one pass is not called peak/max flood extent.

## Interactive maps

The project retains MapLibre. Demo maps can function without external tile services because the key analytical layers are local GeoJSON. When appropriate, the map supports:

- zoom and pan,
- SAR before / after / reference image layer,
- change/flood polygon,
- administrative boundary,
- cyclone track,
- SAR footprint,
- road network,
- facility markers and popups,
- potential oil-risk area,
- ranked priority zones with numbered markers,
- AOI recentering.

## Ripple / radar interaction

The original `RippleCursor.tsx` and `useRippleCursor.ts` remain in place. The implementation uses a single canvas plus `requestAnimationFrame`, GPU-friendly visual layers, bounded ripple count, pointer-event throttling and `prefers-reduced-motion` support.

## Presentation Mode

Click **PRESENTATION MODE** in the top header.

Presentation Mode:

- forces DEMO MODE,
- preloads the Remal investigation if available,
- hides less-useful setup/judge-debug sections,
- enlarges the main command-center map,
- avoids fragile live-provider calls,
- keeps the deterministic evidence package active,
- retains the clearly visible demo/evidence status.

## Windows — easiest setup

From the extracted `terrasentry` folder:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\setup-windows.ps1
```

Then start both backend and frontend:

```powershell
.\start-windows.ps1
```

Open:

- Frontend: `http://localhost:5173`
- API docs: `http://localhost:8000/docs`
- Health: `http://localhost:8000/api/health`

## Windows — manual setup

Backend:

```powershell
cd backend
python -m venv .venv
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Frontend in a second terminal:

```powershell
cd frontend
Set-Content .env "VITE_API_BASE=http://127.0.0.1:8000"
npm install
npm run dev
```

## Docker

```powershell
docker compose up --build
```

Then open `http://localhost:8080`.

The Docker build includes the demo folder in both the backend and frontend build contexts.

## Main API endpoints

```text
GET  /api/health
GET  /api/providers
GET  /api/events
GET  /api/weather
GET  /api/satellite/catalog
GET  /api/demo/remal
GET  /api/demo/remal/status
GET  /api/demo/remal/assets/{before|after|reference|change}
POST /api/investigations/jobs
GET  /api/investigations/jobs/{job_id}
POST /api/investigations
GET  /api/investigations/recent
GET  /api/investigations/{id}
POST /api/investigations/{id}/impact
POST /api/investigations/{id}/oil-risk
POST /api/investigations/{id}/review
GET  /api/investigations/{id}/brief
```

## Test / validation

Backend:

```powershell
cd backend
$env:PYTHONPATH="."
pytest -q
```

The repository tests cover temporal SAR pairing/change logic plus the coherent Remal demo package, real EO metadata routes, response-zone dataset and oil-risk guardrail.

Frontend:

```powershell
cd frontend
npm run typecheck
npm run build
```

See `VALIDATION.md` for the acceptance checklist and evidence/asset notes.
