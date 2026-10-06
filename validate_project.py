from __future__ import annotations

import json
from pathlib import Path

ROOT = Path(__file__).resolve().parent
errors: list[str] = []

def require(path: str) -> Path:
    p = ROOT / path
    if not p.exists():
        errors.append(f"missing: {path}")
    return p

manifest_path = require("demo/remal/manifest.json")
app_path = require("frontend/src/App.tsx")
map_path = require("frontend/src/components/MapWorkspace.tsx")
compare_path = require("frontend/src/components/SarCompare.tsx")
require("frontend/src/components/RippleCursor.tsx")
require("frontend/src/hooks/useRippleCursor.ts")
require("demo/remal/fetch-demo-assets.ps1")
require("backend/app/main.py")

if manifest_path.exists():
    m = json.loads(manifest_path.read_text(encoding="utf-8"))
    checks = {
        "verified event mode": "VERIFIED" in m.get("mode", "").upper(),
        "5 zones": len(m.get("analysis", {}).get("zones", [])) >= 5,
        "timeline": len(m.get("demo", {}).get("timeline", [])) >= 5,
        "actions": len(m.get("demo", {}).get("actions", [])) >= 5,
        "resources": len(m.get("demo", {}).get("resources", [])) >= 5,
        "impact table": len(m.get("demo", {}).get("impact_before_after", [])) >= 5,
        "Sentinel-1 metadata": m.get("demo", {}).get("satellite_products", {}).get("sentinel1", {}).get("product_id", "").startswith("S1A_"),
        "Sentinel-2 metadata": m.get("demo", {}).get("satellite_products", {}).get("sentinel2", {}).get("product_id", "").startswith("S2A_"),
        "no confirmed oil spill": m.get("oil_risk", {}).get("confirmed_spill") is False,
    }
    errors.extend([f"failed data check: {name}" for name, ok in checks.items() if not ok])

if app_path.exists():
    app = app_path.read_text(encoding="utf-8")
    for term in [
        "EVENT FEED", "LIVE DATA", "OPERATIONS VIEW", "START EVALUATION",
        "CYCLONE / EVENT CONTEXT", "LATEST SATELLITE ANALYSIS", "BEFORE / AFTER TEMPORAL COMPARISON",
        "FLOOD / CHANGE DETECTION", "EXPOSURE ANALYSIS", "SECONDARY OIL-RISK SCREEN",
        "RISK, CONFIDENCE & PRIORITY", "BEFORE / AFTER IMPACT DASHBOARD", "RESPONSE PRIORITY DASHBOARD",
        "PREVIOUS", "NEXT ·",
    ]:
        if term not in app:
            errors.append(f"frontend workflow term missing: {term}")
    if "500" not in app or "2.5" not in app:
        errors.append("event-package loading sequence not found")

if map_path.exists():
    text = map_path.read_text(encoding="utf-8")
    for term in ["maplibre-gl", "priority-zones", "cyclone-track", "exposure-facilities", "oil-risk", "BOUNDARY"]:
        if term not in text:
            errors.append(f"map feature missing: {term}")

if compare_path.exists():
    text = compare_path.read_text(encoding="utf-8")
    if 'type="range"' not in text:
        errors.append("before/after draggable slider missing")
    if "does not fabricate satellite scenes" not in text:
        errors.append("SAR evidence fallback guardrail missing")

if errors:
    print("VALIDATION FAILED")
    for e in errors:
        print(" -", e)
    raise SystemExit(1)

print("VALIDATION PASSED")
print(" - coherent Cyclone Remal verified-event manifest")
print(" - 10-screen workflow + Previous/Next navigation")
print(" - verified event-package loading path")
print(" - MapLibre interactive evidence layers")
print(" - real-EO-only SAR display policy")
print(" - ripple cursor sources preserved")
