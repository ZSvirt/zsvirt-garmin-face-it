# ZSvirt Garmin 表盘开发约束

本说明约束仓库`ZSvirt/zsvirt-garmin-face-it`。根目录为ZSvirt Time；ZSvirt 超分娘位于`faces/zsvirt-girl/`。两款应用分别维护身份、矩阵、资源与产物，共用根`scripts/`入口和`shared/FaceTime.mc`。用户持有Enduro 3。两款表盘当前各自支持69个官方产品目标，覆盖Enduro、Forerunner与35个fēnix目标；不能用一款应用的导出或验收结果代替另一款。

## 身份与配置

- UUID `cb51f19636e64ae1b979bfd8bf070e31`，入口 `ZsvirtTimeApp`，名称 `ZSvirt Time`；更新继续沿用原签名，不复制密钥进仓库。
- `docs/compatibility.json` 是本应用69个目标的配置源，含12种分辨率、圆形/半圆/矩形、MIP/AMOLED、设备内存和区域API。最低API1.4.0不覆盖仍标为1.3.1的区域固件；fēnix3等旧机的地区版本需按商店列表核对。
- `scripts/configure.py` 生成 manifest/jungle；构建脚本生成根配置及目标快照，不手改生成文件，不依赖其它表盘。
- `profiles/mip` 与 `profiles/amoled` 提供编译期 `DeviceProfile.AMOLED`。无额外权限。

## ZSvirt 超分娘 行为与资源

- UUID `29b9c146b06f45d985a3cc93b6dde7d5`，入口`ZsvirtGirlApp`；当前默认应用名、简体中文名及商店中英文名称统一为`ZSvirt 超分娘`。矩阵在`faces/zsvirt-girl/docs/compatibility.json`，包含69个产品目标、12种分辨率，最低API1.4.0；API1.3.1旧区域由SDK忽略，不纳入发行包。双语商店文案在`faces/zsvirt-girl/docs/store-listing.json`，文案准备完成不等于已上传商店。
- 使用站点提供的正式半身立绘，原图和SHA在应用的`assets/SOURCES.json`。按屏高等比缩放，白底画布上水平居中，矩形屏不拉伸人物。人物在屏高的154/280至172/280之间淡化为白色，存储位图在184/280处截断，为时间和底栏留白；Enduro 3保留约10像素向右的视觉中心调整。Launcher使用官方设备包指定尺寸与实际调色板。独立Logo、步数和相关依赖已移除。
- 大号单行时间使用共享`FaceTime`规则，按设备实际字体宽高及屏幕边界排布，12小时制附AM/PM。本地月日来自`Gregorian.info(Time.now(), Time.FORMAT_SHORT)`，中英文均显示`MM/DD`，与电量组成底栏。时分/时制变化时才生成时间；完整画面绘制时处理待更新的时间布局并检查日期，电量变化时才更新百分比文字与图标填充。
- MIP休眠保持完整人物、时间、月日和电量。AMOLED休眠清为黑底，仅显示`0x555555`灰色时间与12小时制AM/PM，按分钟奇偶在上下不相交区域换位；唤醒恢复完整画面。AOD字体按边界与面积预算选择，实际亮像素比例仍需模拟器画面取证。不添加Timer、动画、后台服务、网络或传感器权限；不将模拟器结果等同于腕上体验、烧屏寿命或续航结论。
- 使用`python3 scripts/build.py --face girl --device enduro3`构建设备PRG，`python3 scripts/build.py --face girl --device enduro3 --release --run`运行发行模拟器目标，`python3 scripts/build.py --face girl --package 1.1.0`导出商店包。产物在`bin/zsvirt-girl/`，1.1.0导出在`artifacts/zsvirt-girl/release-1.1.0/`。`configure.py`和`generate-resources.py`也使用`--face girl`。

人物资源按以下实际屏幕尺寸和格式生成；调色板采用官方设备定义的不透明RGB条目，省略`TRANSPARENT`。资源路径包含尺寸和调色板身份，不把不同的14色调色板混用。ARGB2222的RGB通道等级为0、85、170、255；AMOLED按RGB565通道量化。

| 屏幕尺寸 | 屏幕 | 人物资源调色板/格式 |
| --- | --- | --- |
| 205×148 | MIP | 14色 |
| 208×208 | MIP | 8色 |
| 215×180 | MIP | 14色 |
| 218×218 | MIP | 14色、64色、66色或ARGB2222，按设备选择 |
| 240×240 | MIP | 64色或ARGB2222，按设备选择 |
| 260×260 | MIP | 64色或ARGB2222，按设备选择 |
| 280×280 | MIP | 64色或ARGB2222，按设备选择 |
| 360×360 | AMOLED | RGB565 |
| 390×390 | AMOLED | RGB565 |
| 416×416 | AMOLED | RGB565 |
| 454×454 | AMOLED | RGB565 |
| 466×466 | AMOLED | RGB565 |

1.1.0全目标签名导出已完成，116/116个区域目标成功；该结果不证明所有模拟器、真机或商店通过。1.1.0已于2026-10-27提交商店，当时回读状态为`PENDING`，尚未安装到手表；具体模拟器证据见[1.1.0发布记录](release-zsvirt-girl-1.1.0.md)，当前商店状态须实时核对。2026-10-27侧载并回读一致的88,700字节Enduro 3 PRG属于当时名为`ZSvirt Girl`的1.0.0，不包含当前`ZSvirt 超分娘`改名；保留[当时的安装记录](verification/zsvirt-girl-installation-20261027.json)，不将它作为1.1.0安装证据，腕上显示与续航尚未验收。

## ZSvirt Time 行为与资源

- `FaceTime` 处理12/24小时制及AM/PM，直接使用设备时钟，不转换时区。时间字符串只在时、分或时制变化时生成。
- `onLayout` 加载位图、读取实际字体尺寸并排布内容；字体常量的像素高度因设备和语言而异，不以固定坐标推广其它机型。Logo按12种屏宽生成，Launcher按官方定义的6种尺寸生成。
- 位图使用 `WatchUi.loadResource` 返回值，不把API4.0后的具体位图类型用于API1.x目标。
- 唤醒与MIP休眠读取 `System.getSystemStats().battery` 和 `ActivityMonitor.getInfo().steps`；数值变化时生成字符串。0步显示0，null显示`--`，不沿用旧值。完整重绘避免重新显示时残影。
- AMOLED睡眠仅画灰色时间及AM/PM；根据分钟奇偶在上下不相交区域切换，唤醒恢复完整画面。按官方10%亮像素限制验证实际画面；该设计的跨区域切换是实现选择，官方也建议轻微移动静态元素。模拟器检查不证明真机功耗、烧屏寿命或续航。
- 不显示秒，不引入Timer、动画、联网、后台服务或直接传感器采样。
- 正式Logo源图与来源见 `assets/SOURCES.json`。生成器只裁透明边、等比缩放并转换为设备可用调色板；8色MIP使用纯黑白，不重画品牌图形。

## 调度与验证

从本仓库根使用`python3 scripts/build.py`。`--face time`为默认应用，`--face girl`选择ZSvirt 超分娘；默认设备`--device enduro3`。`--all`构建所选应用矩阵内的全部目标；`--simulator`、`--run`、`--test`使用官方对应模拟器目标。脚本按自身位置确定应用根，不依赖当前工作目录或原`garmin-face-it`仓库。

`--run` 要求官方模拟器已启动，并持续连接直到应用结束。切换目标前使用 **File → Kill Device**，确认窗口回到空设备；仅Kill App会保留上一设备。截图时核对实际窗口目标，结束本任务时退出本次独占启动的模拟器。保留原始日志及退出码，不能把超时记为成功。

`--package VERSION` 通过官方 `-e -r` 导出所选应用的全部目标，保留原包、SHA报告和日志；ZSvirt Time位于`artifacts/release-VERSION/`，ZSvirt 超分娘位于`artifacts/zsvirt-girl/release-VERSION/`。发布前使用 `--device TARGET --release --run` 验证去除调试信息的构建。

渲染修改后验证对应尺寸及MIP/AMOLED实际模拟器画面；多目标变更需全目标发行导出和代表目标实际运行。仅时制逻辑改变时重跑 `tests/TimeTests.mc`。不默认运行另一表盘或全仓库测试。SDK9.2.0既有测试摘要解析问题需按实际用例输出和原始退出码分别报告，不吞异常。

构建、模拟器、商店提交、真机安装、腕上显示、续航分别需要独立证据。商店发布及真机安装需要对应授权，不从历史权限推定新操作。
