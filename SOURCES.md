# TerraSentry demo evidence sources

The Cyclone Remal presentation package is intentionally explicit about what is source-derived versus demo/precomputed.

## Event context

- India Meteorological Department / RSMC New Delhi — Cyclone Remal reports and best-track context.
- Government of India Press Information Bureau — Remal landfall / wind context.

## Earth observation

- Copernicus Data Space Ecosystem — Sentinel-1 and Sentinel-2 mission/product source.
- Hossen et al. (2025), Dhaka University Journal of Earth and Environmental Sciences — published Remal study for Patuakhali and Barguna, including documented Sentinel product identifiers and the reported inundation extent.
- Sentinel Asia Cyclone Remal emergency observation page — public JAXA ALOS-2 before/after SAR display imagery and public Sentinel-1-derived flood product.

## Important interpretation boundary

- `demo/remal/manifest.json` contains the exact presentation values consumed by the frontend.
- The published inundation extent is source-derived.
- Population exposure, road/facility intersections, priority-zone geometries and some response metrics are transparent demo/precomputed values designed to remain internally consistent. They are not presented as official operational statistics.
- Oil risk is deliberately labelled potential/unverified; the demo does not claim a confirmed spill.

The public EO URLs are stored in `demo/remal/manifest.json` under `demo.source_urls` and are consumed by `demo/remal/fetch-demo-assets.ps1` for local caching.

## v5.4 verified event sources

### Hurricane Otis — Acapulco, Mexico
- NASA Earth Observatory: https://science.nasa.gov/earth/earth-observatory/acapulco-after-hurricane-otis-152028/
- Pre-event Landsat 8 OLI acquisition: 21 September 2023.
- Post-event Landsat 9 OLI-2 acquisition: 31 October 2023.
- NASA/NHC event context: Category 5 landfall near Acapulco on 25 October 2023 with sustained winds reported at 270 km/h.

### Mumbai extreme rainfall — 8 July 2024
- Reuters event report: https://www.reuters.com/world/india/monsoon-rains-flood-indias-financial-capital-mumbai-2024-07-08/
- IMD/BMC rainfall values as reported publicly: Santacruz 268 mm in 24 hours; several locations exceeded 300 mm in six hours.
- NASA Worldview Snapshots: https://wvs.earthdata.nasa.gov/
- The package does not assert a project-derived Sentinel-1 flood polygon for Mumbai.

### Gulfstream oil spill — Tobago, Trinidad and Tobago
- ESA Copernicus Sentinel-1 image: https://www.esa.int/ESA_Multimedia/Images/2024/02/Tobago_oil_spill
- Trinidad & Tobago Ministry of Energy / TEMA incident release: https://www.energy.gov.tt/tema-leading-and-managing-efforts-in-oil-spill-response/
- International Charter / INPE probable-oil-on-water Sentinel-1A map: https://data.inpe.br/charter/data/Call_0988_TrinidadAndTobago/Call988_Trinidad_S1A_20240226.pdf
- IOPC Funds incident reporting: estimated 4,652 metric tonnes of persistent fuel oil spilled.
- ESA reported that the 14 February 2024 22:18 UTC Sentinel-1 observation showed the spill extending more than 160 km westwards.

These event packages preserve their original acquisition/event dates. Historical evidence is presented as VERIFIED EVENT evidence, not as a current live acquisition.
