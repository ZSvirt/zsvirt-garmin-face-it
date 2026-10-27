# ZSvirt Garmin 表盘

[GitHub 仓库](https://github.com/ZSvirt/zsvirt-garmin-face-it) · [开发约束](docs/garmin-dev-project.md) · [问题反馈](https://github.com/ZSvirt/zsvirt-garmin-face-it/issues)

本仓库维护两款可分别安装的Connect IQ表盘：根目录的 **ZSvirt Time** 和 `faces/zsvirt-girl/` 的 **ZSvirt 超分娘**。两款表盘使用独立UUID、资源、设备矩阵和产物，共用构建入口及 `shared/FaceTime.mc` 时制逻辑。ZSvirt Time从`garmin-face-it/watchfaces/zsvirt-time`提取，保留7个相关Git历史提交；原始发布记录中的旧路径和提交链接是当时的证据。

本次迁移、GitHub推送与群通知结果见[独立仓库回执](docs/repository-split.html)，接续开发见[仓库交接](docs/codex-handoffs/2026-10-26-standalone-repository.md)。

## ZSvirt Time

以本地时间与ZSvirt官方Logo为主视觉，显示电量和今日步数的Connect IQ表盘。1.3.0扩展至69个官方设备目标，覆盖Enduro、Forerunner及本机官方设备包中的全部35个fēnix目标；完整清单以[独立设备矩阵](docs/compatibility.json)为准。

- 黑底白字，正式横版 Logo 等比缩放；时间、Logo 和数据根据屏幕与实际字体尺寸排布。
- 遵循手表 12/24 小时制；12 小时制显示 AM/PM，午夜和正午均为 12 点。
- 电池图标和整数百分比、脚步图标和完整步数。有效 0 显示 `0`，系统未提供步数时显示 `--`。
- MIP 休眠保持完整画面；AMOLED 休眠只显示灰色时间与 AM/PM，每分钟交替上下位置，唤醒恢复完整画面。
- 不显示秒，不添加计时器、动画、后台服务、联网或传感器权限。电量来自 `System.getSystemStats().battery`，今日步数来自 `ActivityMonitor.getInfo().steps`。
- 应用名 `ZSvirt Time`，UUID `cb51f19636e64ae1b979bfd8bf070e31`，沿用原签名，与耐力仪表独立安装。

fēnix6系列包含`fenix6`、`fenix6pro`、`fenix6s`、`fenix6spro`和`fenix6xpro`，由官方目标覆盖6／6S／6X的标准版、Pro、Sapphire、Solar及对应区域变体。另包含官方fēnix3、5、7、8、9、Chronos和E目标。最低API为1.4.0；部分旧机地区固件仍为API1.3.1，未包含在发行包中，具体可用型号以商店兼容列表为准。

2026-10-26提交1.3.0时，Connect IQ内部版本为4、状态为PENDING；商店主记录确认116个区域型号，fēnix6系列对应20个区域型号全部包含，实际兼容页已显示6／6S／6X及Pro、Sapphire、Solar变体。[商店预览](https://apps-developer.garmin.com/zh-CN/apps/2702e86b-ba01-44ed-9d5a-9b29777945f4?tid=1)在审核通过前仅账户本人可见，详见[发布记录](docs/release-1.3.0.md)。历史原包及1.0.0–1.2.0记录保留。

## ZSvirt 超分娘表盘

采用ZSvirt站点资源中的正式半身立绘，白底、大幅人物与大号单行时间，下方显示本地月日（`MM/DD`）和电量。人物按屏高等比缩放并水平居中，Enduro 3的裁剪视觉中心向右调整约10像素；不显示独立Logo、步数、星期或秒钟。跟随系统12/24小时制，12小时制附AM/PM；MIP休眠保持完整画面，AMOLED休眠切换为黑底灰色时间与AM/PM，按分钟奇偶在上下区域换位，唤醒恢复人物画面。

1.1.0扩展至 **69个官方产品目标、12种分辨率，最低API1.4.0**，覆盖Enduro、Forerunner和fēnix系列的MIP/AMOLED设备。当前默认应用名、简体中文名及商店中英文名称统一为`ZSvirt 超分娘`，UUID保持`29b9c146b06f45d985a3cc93b6dde7d5`；两种语言均使用`MM/DD`。本应用独立维护[设备矩阵](faces/zsvirt-girl/docs/compatibility.json)和[双语商店文案](faces/zsvirt-girl/docs/store-listing.json)。产品目标不等于所有区域固件均可安装；API1.3.1的旧区域版本由SDK忽略，不进入发行包。

人物按设备真实调色板生成：MIP包含8、14、64、66个不透明色条目及ARGB2222，AMOLED使用RGB565；同为14色的不同调色板分别生成资源。12种分辨率及对应格式见[开发约束](docs/garmin-dev-project.md#zsvirt-超分娘-行为与资源)，正式原图、SHA-256和裁剪/调色过程见[素材来源](faces/zsvirt-girl/assets/SOURCES.json)。

```sh
python3 scripts/generate-resources.py --face girl
python3 scripts/build.py --face girl --device enduro3
python3 scripts/build.py --face girl --device enduro3 --release --run
python3 scripts/build.py --face girl --package 1.1.0
```

真机PRG在`bin/zsvirt-girl/zsvirt-girl-enduro3.prg`，1.1.0原始IQ包在`artifacts/zsvirt-girl/release-1.1.0/`。全目标签名导出116/116成功；12种分辨率的代表设备已通过实际模拟器画面检查，5个AMOLED目标已检查休眠/唤醒，FR265S另通过跨午夜唤醒。2026-10-27已提交[Garmin商店](https://apps.garmin.com/apps/e6c45ce6-48a7-4178-80ab-01df609acf41)，签名回读通过，版本1.1.0、内部版本1、状态`PENDING`；审核通过前仅发布账号可见。当前1.1.0尚未安装到手表。详见[发布记录](docs/release-zsvirt-girl-1.1.0.md)、[HTML回执](docs/zsvirt-super-girl-release.html)及[当前交接](docs/codex-handoffs/2026-10-27-zsvirt-super-girl-release.md)。

历史安装：2026-10-27已将当时名为`ZSvirt Girl`的1.0.0的88,700字节PRG侧载到Enduro 3，设备回读与当时暂存包逐字节一致，见[安装记录](docs/verification/zsvirt-girl-installation-20261027.json)。当前新名为`ZSvirt 超分娘`；该历史安装不包含本次改名及1.1.0的新改动，腕上显示与续航尚未验收。[1.0.0实际效果与验收](docs/zsvirt-girl.html) · [1.0.0交接](docs/codex-handoffs/2026-10-27-zsvirt-girl.md)。

## 构建与运行

使用Connect IQ SDK、Java 17、矩阵中的官方设备包及仓库外原签名密钥。构建需要Python 3.11+；重新生成图片需要Pillow。现有签名默认位于`~/.local/share/garmin-face-it/developer_key.der`，这是仓库外的签名身份，不依赖旧仓库目录；其它环境通过`--key /path/to/developer_key.der`提供原密钥。以下命令均从本仓库根目录执行：

```sh
# 构建 Enduro 3 真机 PRG（默认目标）
python3 scripts/build.py --device enduro3

# 构建本表盘全部69个目标
python3 scripts/build.py --all

# 官方模拟器已启动时，运行去除调试信息后的目标
python3 scripts/build.py --device fr265 --release --run

# 全目标签名商店包
python3 scripts/build.py --package 1.3.0

# 需要修改时制逻辑时运行边界测试
python3 scripts/build.py --device enduro3 --test --run

# 从正式源图重建尺寸、调色板及 launcher 资源
python3 scripts/generate-resources.py
```

构建前自动从所选表盘的`docs/compatibility.json`生成对应应用根目录的`manifest.xml`和`monkey.jungle`，并生成本次目标的构建快照；不要手改生成配置。`--face time`是默认值，`--face girl`选择新表盘；`scripts/configure.py`和`scripts/generate-resources.py`也接受该参数。工程不依赖原工作区。

支持`--sdk`、`CIQ_SDK_HOME`与`--key`；SDK不明确或签名密钥缺失时直接报错。真机产物为`bin/zsvirt-time-<device>.prg`；带`-sim`、`-sim-release`、`-tests`的文件仅供官方模拟器。日志、哈希和退出码保留在`bin/`；构建产物与密钥不提交Git。

`--run` 持续连接应用直到结束。切换机型前在模拟器使用 **File → Kill Device**，防止沿用上一款设备；只执行 Kill App 不足以切换目标。结束本轮验收后退出本次独占启动的模拟器。

`--package VERSION` 使用官方 `-e -r` 导出，产物及报告保留于 `artifacts/release-VERSION/`。版本格式为 `MAJOR.MINOR.PATCH`；不能与单设备、模拟器或测试选项混用。

## 资源与品牌

Logo 来自 [ZSvirt 官方下载页](https://zsvirt.io/download)。`assets/` 保留正式源图，[SOURCES.json](assets/SOURCES.json)记录来源和 SHA-256。生成器只裁透明边、等比缩放、合成黑底，并按设备调色板生成黑白或四级灰图像；不重画 Logo，不用普通字体替代字标。Launcher 按官方设备定义的独立尺寸生成。时间使用设备内置字体。

Logo 属于 ZSvirt 品牌资产；官网下载页未附单独 Logo 许可，不将其视为商标权转让。

## 验收边界

构建、模拟器显示、商店提交、真机安装与续航分别验收。既有画面及1.3.0发布结果见[发布回执](docs/delivery.html)。2026-10-26已将此前Enduro 3专用的时间＋Logo＋电量＋步数版侧载并回读校验，14,844字节安装包与设备回读逐字节一致，详见[安装记录](docs/verification/enduro3-installation-20261026.json)；安装期间并行产生的后续改动不属于这次已安装版本。尚未验收腕上显示或测量续航；AMOLED亮像素检查不能替代真机烧屏与功耗验证。

独立仓库迁移已逐文件核验52个构建输入，确认与迁出前一致；新路径下Enduro 3、fēnix 6 Pro真机目标及FR265去除调试信息的模拟器目标构建通过。ZSvirt Time的1.0.0–1.3.0原始商店包复制后哈希一致，保留在本地`artifacts/`。详见[迁移验证记录](docs/verification/repository-split-20261026.json)。该次迁移未重新运行模拟器、单元测试或全仓库测试，也未再次上传商店或安装手表。

[隐私说明](docs/privacy.md) · [问题反馈](https://github.com/ZSvirt/zsvirt-garmin-face-it/issues)
