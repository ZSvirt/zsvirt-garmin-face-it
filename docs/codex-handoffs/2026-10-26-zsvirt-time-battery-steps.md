> 历史记录：以下保留迁出前的工作目录、分支、命令和验收事实。当前工程入口为本仓库README，现由`ZSvirt/zsvirt-garmin-face-it`独立维护。

# ZSvirt Time 电量与步数交接 · 2026-10-26

## repo、branch、当前目标

- repo：`/Users/zixiaobowen/myProjects/garmin-face-it`。
- 当前分支：`main`；电量与步数功能提交`4aa2a60`已推送GitHub，并由GitHub分支API回读确认。
- 当前目标：电量与步数功能及Enduro 3版本1.1.0上传已完成；用户追加要求按另一款表盘的35个官方目标扩展兼容性，需要继续实现和发布后续版本。
- 1.1.0已经Garmin接受，内部版本2，状态PENDING；编辑元数据确认签名true、版本1.1.0。详见应用`docs/release-1.1.0.md`及`docs/verification/store-submission-1.1.0.json`。前序1.0.0包与记录保留。

## 已完成

`ZsvirtTimeView`在每次系统刷新读取`System.getSystemStats().battery`和`ActivityMonitor.getInfo().steps`；值变化时更新字符串。左侧电池图标与整数百分比，右侧脚步图标与完整步数。有效0步显示0，null显示`--`且不沿用旧值；null分支尚未通过模拟器注入验证。

Logo与时间位置保留，AM/PM中心197px，数据中心225px。没有新权限、Timer、后台服务、设置项或联网。真机PRG与普通模拟器PRG构建成功，官方模拟器实际验证正常值、六位步数、0值、12/24小时制与hide/show刷新。

README、开发约束、隐私说明和HTML回执已更新。回执嵌入本次实际截图，显示15:47、82%、8642步；这些为模拟器输入，不是用户手表实时数据。

## 已调查或修改的文件

- 修改：`watchfaces/zsvirt-time/source/ZsvirtTimeView.mc`。
- 修改：应用`README.md`、`docs/garmin-dev-project.md`、`docs/privacy.md`、`docs/delivery.html`。
- 新增：应用`docs/verification/battery-steps.json`及本交接。
- 本地模拟器截图：应用`docs/verification/battery-steps-8642-window.png`、`battery-steps-full-six-digits-window.png`、`battery-steps-zero-window.png`、`battery-steps-final-window.png`、`battery-steps-final-screen.png`。PNG沿用仓库忽略规则；HTML内嵌最终裁图。
- 未修改：`FaceTime.mc`、`TimeTests.mc`、manifest、构建脚本、1.0.0原始发布包和旧表盘。

## 已运行命令与结果

- `python3 watchfaces/zsvirt-time/scripts/build.py --device enduro3`：退出0，BUILD SUCCESSFUL；PRG 14,844字节，SHA-256 `6ba0f70a782caab9f4eb4d295162ee26121b7120c3766e7039d63b35ca0cf1d6`。
- `python3 watchfaces/zsvirt-time/scripts/build.py --device enduro3 --run`：编译退出0，runner退出0；服务`zsvirt-battery-steps-run`正常退出。报告`bin/build-enduro3-sim.json`，PRG SHA-256 `be30af2c07d3f3278d6c019ee0af0b5472bfe20f987ae6bc1e6bafeb5ddd94d3`。
- 模拟器50%/8642步；100%/123456步与PM；0%/0步与PM；82%/8642步、24小时制。全部实际截图未见重叠、裁切或归零后的旧字残留，电池填充随数值正确变化。
- 恢复模拟器电量50%、0步、24小时制，随后正常关闭本任务独占的simulator PID 39046。没有停止共享浏览器服务。
- 未重跑未改动的时制测试或全仓库测试。前序3个时制用例PASS但SDK runner退出1的记录仍在原交接中，不把它计为本轮检查。
- 回执在Tern 1386px浅色与无窗口390px深色完成实际浏览器检查；截图加载、窄屏展开控件通过，无横向溢出，4个本地链接均存在，控制台与页面错误均为0。证据为应用`docs/verification/battery-steps-browser.json`。窄屏测试页已关闭；Tern回执停靠到本会话owner `2237677961422`右侧块`2237677961556`。

## 已知限制、风险与阻塞

没有1.1.0上传阻塞。没有真机安装、腕上显示、续航或null步数注入证据。1.1.0仅支持Enduro 3；多设备兼容尚待实现与独立验证。

模拟器活动数据网格不能只设置AXValue后点击Apply：必须提交编辑器。已验证可用方式：按真实窗口位置双击今日Steps单元格，定位其实际文本框，写值，再用发往simulator PID的Return提交后点击Apply。电量对话框写值后Tab提交再点OK。每次操作先用System Events将simulator设为frontmost，并等待窗口出现；跨调用焦点变化曾导致输入失败，不能把AXValue回读当作屏幕值已更新。最终结论以实际表盘截图为准。

## 用户偏好与限制

中文沟通，结构服务信息；HTML使用effective-html（`skill://html`），以实际表盘和简短证据为主。绑定当前Tern owner `2237677961422`在右侧展示，原回执块已不存在，因此本轮创建块`2237677961556`。不弹出外部浏览器。

保留其它表盘和用户已有未提交记录，不全量暂存、不重置、不删分支。密钥始终在仓库外。用户本轮明确授权推送GitHub和上传商店，并追加扩展其它佳明手表；继续完成兼容版及发布。真机安装仍需对应授权。

## 下一步

1. 切新的兼容性分支，按另一款表盘的35个官方target核对当前SDK设备包。
2. 实现多尺寸布局、旧API目标以及AMOLED休眠显示，保持Logo、时间、电量、步数与独立UUID。
3. 完成全部受影响目标构建和代表尺寸/显示技术的实际模拟器验收，再推送并上传后续版本，保留1.0.0与1.1.0原包。
4. 更新最终HTML与发布交接；没有真机安装授权，不执行侧载。

## 恢复提示

> 继续garmin-face-it的ZSvirt Time。main已推送电量/步数功能4aa2a60。1.1.0上传成功，内部2，PENDING，仅Enduro3；SDK验签true，发布模拟器退出0，证据见应用docs/release-1.1.0.md和docs/verification/store-submission-1.1.0.json。用户追加要求像另一表盘一样兼容其它佳明手表，继续按35官方target适配并推送上传兼容版，不能停在Enduro3版本。原有多尺寸矩阵在watchfaces/reference-face-configurable/docs/compatibility.json，包含11种分辨率、48KiB旧机和AMOLED。保留旧表盘改动与签名身份，无真机安装授权。
