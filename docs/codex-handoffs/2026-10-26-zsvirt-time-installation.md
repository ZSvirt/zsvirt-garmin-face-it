> 历史记录：以下保留迁出前的工作目录、分支、命令和验收事实。当前工程入口为本仓库README，现由`ZSvirt/zsvirt-garmin-face-it`独立维护。

# ZSvirt Time 真机安装交接 · 2026-10-26

## 仓库、分支与目标

repo：`/Users/zixiaobowen/myProjects/garmin-face-it`。本轮开始时实际分支为 `main`。用户要求将 ZSvirt 表盘安装到已连接的手表；已完成 Enduro 3 侧载及回读校验。

## 已完成与证据

- 使用 `garmin-dev` 技能和应用构建脚本编译 Enduro 3 真机目标，退出0，14,844字节。内容为时间、官方Logo、电量、今日步数。
- 通过 OpenMTP / Kalam 向 `Internal Storage/GARMIN/Apps/zsvirt-time-enduro3.prg` 新增一个文件。安装前6项，安装后7项；未删除或覆盖设备现有文件。
- 从手表下载到独立目录，与本次暂存的构建包逐字节相同。SHA-256：`6ba0f70a782caab9f4eb4d295162ee26121b7120c3766e7039d63b35ca0cf1d6`。
- 回读原件保留在 `watchfaces/zsvirt-time/bin/device-readback-enduro3-20261026/zsvirt-time-enduro3.prg`。结构化证据为应用 `docs/verification/enduro3-installation-20261026.json`；同目录三张 `enduro3-install-*.png` 为实际传输界面截图。
- 本次接管的浏览器句柄已释放，OpenMTP 正常退出；服务 `zsvirt-openmtp-install` 收到退出0回执。未提交或推送Git，未操作商店。

## 本轮调查与限制

读取应用README、manifest、build.py、专属开发约束和前序安装证据；未修改表盘源码。构建通过不代表腕上显示或续航通过。未重跑模拟器、时制测试或全仓库测试；此次没有渲染改动。

安装过程中共享源码和 `bin/zsvirt-time-enduro3.prg` 被并行工作更新：新PRG在08:46 UTC生成，为15,756字节、SHA-256 `d9f2937d55b019492b26652bc9d0559e9722ff9bb8791527cdc1bb1ef0eaed83`。将回读文件与这个新产物比较失败；与实际08:21构建并暂存的安装包比较完全一致。不要把当前bin文件或后续源码当作已经安装的版本。

连接处理走了弯路：原生坐标操作不稳定，直接调用Kalam诊断引擎出现 `SessionAlreadyOpened`，且Dispose后仍由本任务Python进程占用USB。重置该Python内核后占用释放；OpenMTP刷新成功。最终使用其原生Electron页面的CDP控制完成上传和回读。以后优先使用OpenMTP现有界面和明确的DOM控件，不重复尝试直接加载Kalam到主内核。CDP启动命令：`/Applications/OpenMTP.app/Contents/MacOS/OpenMTP --remote-debugging-port=19357`；按当前页面实际结构操作，Refresh按钮以 `aria-label` 定位，悬浮时包装元素title可能消失。

## 用户约束与下一步

用户对安装耗时非常不满；沟通直接报告是否已安装，不堆叠排查细节。保留并行任务改动、既有表盘和设备数据；密钥留在仓库外。

1. 用户拔掉USB后，长按左侧中键 → 表盘 → ZSvirt Time → 应用。
2. 收到反馈后记录真实显示、当天步数与电量；当前尚未观察物理屏幕。
3. 如果用户要求安装后续改动，以这份已安装包哈希为基线，核对最新候选再侧载；不要将共享bin变化自动计为安装成功。

## 恢复提示

> ZSvirt Time已侧载到Enduro 3，14,844字节，SHA-256 6ba0f70a782caab9f4eb4d295162ee26121b7120c3766e7039d63b35ca0cf1d6，设备回读与暂存安装包逐字节一致。OpenMTP已退出0。当前等待用户拔线并选择表盘后的真实显示反馈。并行工作已生成不同的15,756字节PRG，但本次未安装该新文件；准确版本依据watchfaces/zsvirt-time/docs/verification/enduro3-installation-20261026.json。不要重复安装或干预并行改动。
