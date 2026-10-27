# ZSvirt Garmin 表盘开发入口

本仓库维护ZSvirt Time与ZSvirt 超分娘两款独立应用。仓库根为ZSvirt Time应用根；ZSvirt 超分娘位于`faces/zsvirt-girl/`。先读[README](README.md)和[开发约束](docs/garmin-dev-project.md)；当前交接位于`docs/codex-handoffs/`。不要使用原多表盘工作区的`watchfaces/zsvirt-time/`路径。

- 唯一构建入口为`python3 scripts/build.py`，`--face time`为默认值，`--face girl`选择ZSvirt 超分娘；配置与资源分别由`scripts/configure.py`、`scripts/generate-resources.py`生成，同样接受`--face`。不手改生成的manifest/jungle，不新增包装入口。
- 两个应用各自的`docs/compatibility.json`维护各自设备矩阵；ZSvirt Time保持UUID `cb51f19636e64ae1b979bfd8bf070e31`，ZSvirt 超分娘保持UUID `29b9c146b06f45d985a3cc93b6dde7d5`。沿用原签名身份；SDK、Java、设备包及密钥属于外部工具环境，密钥禁止复制、链接或提交进仓库。
- ZSvirt 超分娘 1.1.0当前支持69个官方产品目标、12种分辨率，最低API1.4.0；API1.3.1旧区域被SDK忽略。默认应用名、简体中文名及商店中英文名称统一为`ZSvirt 超分娘`。白底正式大幅半身立绘、大号单行时间、`MM/DD`和电量；不显示独立Logo、步数、星期或秒。共享时制代码只放在`shared/FaceTime.mc`，两款应用分别引用。
- ZSvirt 超分娘人物资源按实际尺寸和设备调色板生成：MIP使用8/14/64/66个不透明色条目或ARGB2222，AMOLED使用RGB565，不合并不同14色调色板；逐尺寸对应表见开发约束。MIP休眠保持完整画面，AMOLED休眠为黑底灰色时间与AM/PM，按分钟奇偶在上下区域换位。`python3 scripts/build.py --face girl --package 1.1.0`导出至`artifacts/zsvirt-girl/release-1.1.0/`。
- ZSvirt 超分娘 1.1.0已完成116/116个区域目标签名导出；尚未上传商店、尚未安装手表，不据此声称所有模拟器或真机通过。2026-10-27安装并回读一致的88,700字节PRG属于当时名为`ZSvirt Girl`的1.0.0，不包含当前`ZSvirt 超分娘`改名；保留该历史事实。1.1.0模拟器与后续商店状态统一记录于`docs/release-zsvirt-girl-1.1.0.md`。
- 源码、资源、运行、商店及真机验证分别取证。仅路径或文档变化运行必要的定向构建；渲染变化需实际模拟器验收，不默认跑全仓库测试。
- 历史发布记录保留原始路径、提交和结果，不把历史成功写成当前验证。发布原包在本地`artifacts/release-*/`保留，禁止用重建结果覆盖已上传原件。
- 保留无关未提交改动；长任务结束更新仓库交接。商店发布、真机安装及群通知按当前用户授权执行。
