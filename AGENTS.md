# ZSvirt Garmin 表盘开发入口

本仓库独立维护ZSvirt Time，仓库根即Connect IQ应用根。先读[README](README.md)和[开发约束](docs/garmin-dev-project.md)；当前交接位于`docs/codex-handoffs/`。不要使用原多表盘工作区的`watchfaces/zsvirt-time/`路径。

- 构建入口为`python3 scripts/build.py`；配置与资源分别由`scripts/configure.py`、`scripts/generate-resources.py`生成，不手改生成的manifest/jungle，不新增包装入口。
- `docs/compatibility.json`独立维护设备矩阵。更新保持UUID `cb51f19636e64ae1b979bfd8bf070e31`和原签名身份；SDK、Java、设备包及签名密钥属于外部工具环境，密钥禁止复制、链接或提交进仓库。
- 源码、资源、运行、商店及真机验证分别取证。仅路径或文档变化运行必要的定向构建；渲染变化需实际模拟器验收，不默认跑全仓库测试。
- 历史发布记录保留原始路径、提交和结果，不把历史成功写成当前验证。发布原包在本地`artifacts/release-*/`保留，禁止用重建结果覆盖已上传原件。
- 保留无关未提交改动；长任务结束更新仓库交接。商店发布、真机安装及群通知按当前用户授权执行。
