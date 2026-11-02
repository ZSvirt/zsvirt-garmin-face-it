# ZSvirt Garmin Watch Faces

**English** · [简体中文](README_zh.md)

[GitHub Repository](https://github.com/ZSvirt/zsvirt-garmin-face-it) · [Development Guide](docs/garmin-dev-project.md) · [Issue Tracker](https://github.com/ZSvirt/zsvirt-garmin-face-it/issues)

This repository maintains two independently installable Connect IQ watch faces: **ZSvirt Time** at the repository root and **ZSvirt 超分娘** in `faces/zsvirt-girl/`. Each has its own UUID, resources, device matrix, and build artifacts. They share the build entry point and the time-formatting logic in `shared/FaceTime.mc`. ZSvirt Time was extracted from `garmin-face-it/watchfaces/zsvirt-time`, preserving seven relevant Git commits. Old paths and commit links in the original release records remain evidence of those releases.

See the [repository split report](docs/repository-split.html) for the migration, GitHub push, and group notification results, and the [repository handoff](docs/codex-handoffs/2026-10-26-standalone-repository.md) for continuing development.

## ZSvirt Time

A Connect IQ watch face centered on local time and the official ZSvirt logo, with battery level and today's step count. Version 1.3.0 expands support to 69 official device targets, covering Enduro, Forerunner, and all 35 fēnix targets in the locally installed official device packages. The [dedicated device matrix](docs/compatibility.json) is the source of truth for the full list.

- White text on a black background, with the official horizontal logo scaled proportionally. Time, logo, and data are laid out using the screen dimensions and actual font metrics.
- Follows the watch's 12/24-hour setting. The 12-hour format includes AM/PM and displays both midnight and noon as 12.
- Shows a battery icon with an integer percentage and a footsteps icon with the full step count. A valid zero is displayed as `0`; unavailable step data is displayed as `--`.
- MIP displays retain the full screen in sleep mode. AMOLED displays show only gray time and AM/PM, alternating between upper and lower positions each minute. Waking restores the full screen.
- No seconds, timers, animations, background services, network access, or sensor permissions. Battery level comes from `System.getSystemStats().battery`; today's steps come from `ActivityMonitor.getInfo().steps`.
- App name: `ZSvirt Time`. UUID: `cb51f19636e64ae1b979bfd8bf070e31`. Uses the original signing identity and installs independently of the endurance dashboard watch face.

The fēnix 6 family includes `fenix6`, `fenix6pro`, `fenix6s`, `fenix6spro`, and `fenix6xpro`. These official targets cover the standard, Pro, Sapphire, and Solar editions of the 6/6S/6X, including their regional variants. Official fēnix 3, 5, 7, 8, 9, Chronos, and E targets are also included. The minimum API version is 1.4.0. Some regional firmware versions on older devices remain on API 1.3.1 and are excluded from the release package; consult the store's compatibility list for available models.

When version 1.3.0 was submitted on 2026-10-26, the Connect IQ internal version was 4 and its status was PENDING. The main store record confirmed 116 regional models, including all 20 regional models in the fēnix 6 family. The compatibility page displayed the 6/6S/6X and their Pro, Sapphire, and Solar variants. The [store preview](https://apps-developer.garmin.com/zh-CN/apps/2702e86b-ba01-44ed-9d5a-9b29777945f4?tid=1) is visible only to the publishing account until approval. See the [release record](docs/release-1.3.0.md). Original release packages and the records for versions 1.0.0–1.2.0 are retained.

## ZSvirt 超分娘 Watch Face

Uses the official half-body character artwork from the ZSvirt website, with a white background, a large character portrait, and large single-line time. The local month/day (`MM/DD`) and battery level appear below. The artwork is scaled proportionally to screen height and centered horizontally; on Enduro 3, the crop's visual center is shifted about 10 pixels to the right. There is no separate logo, step count, weekday, or seconds display. It follows the system's 12/24-hour setting, with AM/PM in 12-hour mode. MIP sleep mode retains the full screen. AMOLED sleep mode shows gray time and AM/PM on black, alternating between upper and lower areas on even and odd minutes. Waking restores the character screen.

Version 1.1.0 expands support to **69 official product targets and 12 resolutions, with a minimum API version of 1.4.0**, covering MIP and AMOLED devices in the Enduro, Forerunner, and fēnix families. The default app name, Simplified Chinese app name, and both English and Chinese store names are all `ZSvirt 超分娘`. The UUID remains `29b9c146b06f45d985a3cc93b6dde7d5`, and both languages use `MM/DD`. This app maintains its own [device matrix](faces/zsvirt-girl/docs/compatibility.json) and [bilingual store listing](faces/zsvirt-girl/docs/store-listing.json). A supported product target does not mean every regional firmware version can install the app: the SDK skips older regional versions on API 1.3.1, excluding them from the release package.

Character resources are generated for the actual device palettes. MIP resources use palettes with 8, 14, 64, or 66 opaque color entries, or ARGB2222; AMOLED resources use RGB565. Different 14-color palettes receive separate resources. See the [development guide](docs/garmin-dev-project.md#zsvirt-超分娘-行为与资源) for the 12 resolutions and their formats, and the [asset sources](faces/zsvirt-girl/assets/SOURCES.json) for the official original artwork, SHA-256, and cropping and color-conversion process.

```sh
python3 scripts/generate-resources.py --face girl
python3 scripts/build.py --face girl --device enduro3
python3 scripts/build.py --face girl --device enduro3 --release --run
python3 scripts/build.py --face girl --package 1.1.0
```

The device PRG is at `bin/zsvirt-girl/zsvirt-girl-enduro3.prg`; the original 1.1.0 IQ package is in `artifacts/zsvirt-girl/release-1.1.0/`. Signed export succeeded for all 116/116 regional targets. Representative devices for all 12 resolutions passed actual simulator visual checks; five AMOLED targets were checked for sleep and wake behavior, and FR265S also passed a wake check across midnight. The app was submitted to the [Garmin store](https://apps.garmin.com/apps/e6c45ce6-48a7-4178-80ab-01df609acf41) on 2026-10-27, with the signature verified after submission. The recorded version was 1.1.0, internal version 1, and status `PENDING`; the listing is visible only to the publishing account until approval. Version 1.1.0 has not been installed on a watch. See the [release record](docs/release-zsvirt-girl-1.1.0.md), [HTML report](docs/zsvirt-super-girl-release.html), and [current handoff](docs/codex-handoffs/2026-10-27-zsvirt-super-girl-release.md).

Historical installation: on 2026-10-27, the 88,700-byte PRG for version 1.0.0, then named `ZSvirt Girl`, was sideloaded onto Enduro 3. The file read back from the device matched the staged package byte for byte; see the [installation record](docs/verification/zsvirt-girl-installation-20261027.json). The current name is `ZSvirt 超分娘`. That historical installation does not include the rename or the changes in 1.1.0. On-wrist appearance and battery life have not been verified. [Version 1.0.0 visuals and verification](docs/zsvirt-girl.html) · [Version 1.0.0 handoff](docs/codex-handoffs/2026-10-27-zsvirt-girl.md).

## Build and Run

Use the Connect IQ SDK, Java 17, the official device packages listed in the matrix, and the original signing key stored outside this repository. Builds require Python 3.11+; regenerating images requires Pillow. The existing signing key defaults to `~/.local/share/garmin-face-it/developer_key.der`. This signing identity is external to the repository and does not depend on the old repository directory. In other environments, supply the original key with `--key /path/to/developer_key.der`. Run the following commands from this repository's root:

```sh
# Build an Enduro 3 device PRG (the default target)
python3 scripts/build.py --device enduro3

# Build all 69 targets for this watch face
python3 scripts/build.py --all

# Run a build without debug information, with the official simulator already open
python3 scripts/build.py --device fr265 --release --run

# Export a signed store package for all targets
python3 scripts/build.py --package 1.3.0

# Run boundary tests when changing the time-formatting logic
python3 scripts/build.py --device enduro3 --test --run

# Regenerate sizes, palettes, and launcher resources from the official source image
python3 scripts/generate-resources.py
```

Before building, the scripts generate `manifest.xml` and `monkey.jungle` in the selected app's root from its `docs/compatibility.json`, along with a build snapshot for the selected target. Do not edit generated configuration by hand. `--face time` is the default; `--face girl` selects the character watch face. `scripts/configure.py` and `scripts/generate-resources.py` also accept this option. The project does not depend on the original workspace.

The build supports `--sdk`, `CIQ_SDK_HOME`, and `--key`. It fails explicitly if the SDK cannot be identified or the signing key is missing. Device builds are written to `bin/zsvirt-time-<device>.prg`; files with `-sim`, `-sim-release`, or `-tests` are for the official simulator only. Logs, hashes, and exit codes are retained in `bin/`. Build artifacts and keys are not committed to Git.

`--run` keeps the connection open until the app exits. Before switching device models, use **File → Kill Device** in the simulator to avoid reusing the previous device. Kill App alone does not switch the target. After verification, close any simulator instance started exclusively for that session.

`--package VERSION` uses the official `-e -r` export options and retains artifacts and reports in `artifacts/release-VERSION/`. Versions must use the `MAJOR.MINOR.PATCH` format. This option cannot be combined with single-device, simulator, or test options.

## Assets and Branding

The logo comes from the [official ZSvirt download page](https://zsvirt.io/download). Official source images are retained in `assets/`; [SOURCES.json](assets/SOURCES.json) records their origins and SHA-256 hashes. The generator only trims transparent edges, scales proportionally, composites onto black, and produces black-and-white or four-level grayscale images for the device palette. It does not redraw the logo or replace the wordmark with a regular font. Launcher resources use the separate dimensions specified by the official device definitions. The time display uses built-in device fonts.

The logo is a ZSvirt brand asset. The official download page does not include a separate logo license; availability of the asset does not constitute a transfer of trademark rights.

## Verification Scope

Builds, simulator rendering, store submission, device installation, and battery life require separate verification. See the [release report](docs/delivery.html) for existing visuals and the 1.3.0 release results. On 2026-10-26, the earlier Enduro 3-only version with time, logo, battery, and steps was sideloaded and read back for verification. The 14,844-byte installation package matched the device readback byte for byte; see the [installation record](docs/verification/enduro3-installation-20261026.json). Changes made in parallel during installation are not part of that installed version. On-wrist appearance and battery life have not been verified. AMOLED lit-pixel checks do not replace hardware burn-in or power-consumption validation.

The repository split verified all 52 build inputs individually against their pre-migration versions. Builds passed from the new path for the Enduro 3 and fēnix 6 Pro device targets and the FR265 simulator target without debug information. The original ZSvirt Time store packages for versions 1.0.0–1.3.0 retained matching hashes after copying and remain in the local `artifacts/` directory. See the [migration verification record](docs/verification/repository-split-20261026.json). That migration did not rerun the simulator, unit tests, or the full repository test suite, and did not upload to the store or install on a watch again.

[Privacy Notice](docs/privacy.md) · [Issue Tracker](https://github.com/ZSvirt/zsvirt-garmin-face-it/issues)
