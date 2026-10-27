# ZSvirt 娘表盘交接 · 2026-10-27

## 仓库、分支与目标

- Repo：`/Users/zixiaobowen/ZStack/zsvirt-garmin-face-it`。
- 分支：`feat/zsvirt-girl-watchface`，本轮从干净的`main`创建；尚未提交或推送。
- 目标：新增以正式ZSvirt娘形象为主体的独立表盘，用户设备为Enduro 3。
- 最终要求：大幅半身立绘、人物视觉居中、单行时间、月日和电量；用户明确不要独立ZSvirt Logo、不要步数。人物按反馈右移约10px。

## 已完成

- 新应用`faces/zsvirt-girl/`，名称`ZSvirt Girl`，入口`ZsvirtGirlApp`，UUID `29b9c146b06f45d985a3cc93b6dde7d5`，仅Enduro 3，最低API3.0.0。
- 从站点仓库的`apps/zsvirt-studio/public/brand/super-girl/masters/portrait.png`导入正式原图；保留SHA与处理参数在应用`assets/SOURCES.json`。没有重画形象。
- 头像/上半身裁剪框`(176,0,826,650)`缩放为280×280；这相对初版半身图向右移动10.34px。近白背景归白，y154–184淡化为纯白以容纳时间。量化至Enduro 3的64色调色板。Launcher为40×40人像。
- 时间跟随系统12/24小时制，12h显示AM/PM；本地月日为`MM/DD`，日期检查在时、分或时制改变时进行。电量读取系统值。无步数依赖、联网、计时器、动画、后台服务或传感器权限。
- 构建、配置和资源生成统一增加`--face time|girl`，默认仍为Time；两应用分别生成配置、矩阵和产物。时制模块移到`shared/FaceTime.mc`，无兼容路径。
- 原Time UUID `cb51f19636e64ae1b979bfd8bf070e31`、69目标矩阵和签名身份保留。密钥未复制入仓库。
- 更新根README、AGENTS、开发约束和隐私说明。效果页为`docs/zsvirt-girl.html`，内嵌真实模拟器截图；验证记录为`docs/verification/zsvirt-girl-20261027.json`。
- 用户随后授权安装：已通过OpenMTP / Kalam将最终PRG新增至Enduro 3的`Internal Storage/GARMIN/Apps/zsvirt-girl-enduro3.prg`，安装前6项、安装后7项；未删除或覆盖设备已有文件。
- 从手表回读的88,700字节文件与暂存安装包逐字节一致，SHA-256为`7129a3a8acfaf2f2e79a72f0411ffef6ae65305fde9455b35ad31cf93508da47`。暂存和回读位于`bin/install-zsvirt-girl-20261027-182954/`及其`readback/`子目录。
- 安装证据为`docs/verification/zsvirt-girl-installation-20261027.json`及`girl-install-uploaded-20261027.png`、`girl-install-readback-20261027.png`。已释放浏览器接管并正常退出本轮独占启动的OpenMTP，服务退出0。等待用户拔线并选择表盘后的腕上反馈。

## 主要文件

- 新增：`faces/zsvirt-girl/source/ZsvirtGirlApp.mc`、`ZsvirtGirlView.mc`，其`assets/`、`resources/`、`docs/compatibility.json`及生成的`manifest.xml`、`monkey.jungle`。
- 移动：`source/FaceTime.mc` → `shared/FaceTime.mc`，模块逻辑未改变。
- 修改：`scripts/build.py`、`configure.py`、`generate-resources.py`及根生成配置。
- 文档：根`README.md`、`AGENTS.md`、`docs/garmin-dev-project.md`、`docs/privacy.md`、效果页、本交接、验证JSON。
- 原图SHA-256：`855ed8f397882d7adb82c0679e7f432a6eee25686f7d24a89b43b1f2996cc89d`。

## 实际验证

使用SDK9.2.0、Java17（命令级`JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home`，PATH前置该Java的bin）。以下最终版本命令均退出0：

```sh
python3 scripts/generate-resources.py --face girl
python3 scripts/build.py --face girl --device enduro3
python3 scripts/build.py --face girl --device enduro3 --release --run
python3 scripts/build.py --face girl --package 1.0.0
python3 scripts/build.py --face time --device enduro3
python3 scripts/build.py --face time --device fr265 --simulator --release
```

- 新表盘真机/模拟器发行PRG均88,700字节，SHA-256 `7129a3a8acfaf2f2e79a72f0411ffef6ae65305fde9455b35ad31cf93508da47`。
- IQ本地导出1/1目标成功，17,321字节，SHA-256 `271d527a44e87f6ba2753962930aa6ee89a71022c8a9bb884b332da7a09255fa`。原包位于`artifacts/zsvirt-girl/release-1.0.0/zsvirt-girl-1.0.0.iq`，未上传。
- 原Time定向构建：Enduro 3为15,756字节，FR265模拟器发行版18,908字节；没有重新运行原Time模拟器。
- 官方Enduro 3模拟器实际观察：24h的18:14、12h的06:16 PM、月日10/27、电量100%；人物与文字可见，独立Logo和步数已移除。
- 截图：`docs/verification/girl-final-window.png`、`girl-final-screen.png`、`girl-12h-window.png`。PNG遵循仓库现有忽略规则，效果页内嵌最终截图。`girl-final-screen.png`是560×560的Retina窗口裁图，不是原始设备像素导出。
- 本轮独占启动的模拟器已正常退出；最终runner退出0，见`bin/zsvirt-girl/build-enduro3-sim-release.json`。
- 没有新增/重跑单元测试，没有全仓库测试；共享时制逻辑没有改变。本轮验证集中于新表盘实际画面、两种时制和受影响的构建配置。

## 限制与未通过项

- 通过原生Save面板导出设备原始PNG未完成，改用真实窗口截图并明确标记；不宣称已导出原始设备像素。
- 原生电量控件尝试设为0未提交，实际画面仍为100%；不将此作为0%通过项。
- 切换Display Mode后模拟器窗口不再可访问/可见，进程仍运行；未得到有效高/低功耗切换证据。随后正常退出模拟器，runner退出0。没有据此断言应用崩溃。
- 跨日、跨月日期注入、腕上显示和续航未验收。真机侧载及回读校验已完成；未上传商店、部署、提交Git或推送。安装阶段没有改动源码、重新构建或重跑测试。
- `.local/verification-python/`是本轮隔离安装的PyObjC验收依赖，不是应用依赖；没有修改系统Python环境。
- HTML右侧展示与浏览器检查另记在`docs/verification/zsvirt-girl-browser-20261027.json`。

## 用户偏好与边界

中文交付；保留已有工作和原发布包。用户明确不接受初版的小Q版贴纸、碎片分栏排版；新表盘使用大幅半身立绘，不增加独立Logo或步数。最终需求是人物、时间、月日、电量。用户随后明确授权安装到已连接的手表，本轮已完成；商店发布、提交推送或群通知仍须对应授权。

## 下一步

1. 如用户继续调整视觉，只改ZSvirt Girl的素材生成和视图，再用Enduro 3官方模拟器验证最终画面。
2. 用户拔掉USB后，长按左侧中键 → 表盘 → ZSvirt Girl → 应用；收到反馈后记录腕上显示。已安装包以安装JSON中的SHA及独立回读文件为准，不把共享bin后续变化计作已安装。
3. 若需要正式发布，先完成真机验收和有效的跨日/低功耗切换检查，再准备新应用商店资料；不得复用Time的商店应用ID。
4. 用户授权提交或推送后，按新旧应用相关文件精确暂存；保留历史原包和无关改动。

## 恢复提示

```text
继续 /Users/zixiaobowen/ZStack/zsvirt-garmin-face-it，分支feat/zsvirt-girl-watchface。先读本交接、README与开发约束。新增ZSvirt Girl位于faces/zsvirt-girl，UUID 29b9c146b06f45d985a3cc93b6dde7d5，仅Enduro3。最终按用户要求采用居中大幅半身立绘、单行时间、月日和电量，没有独立Logo和步数。人物从裁剪框176,0,826,650生成，相对半身初版右移约10px。新PRG/IQ构建和实际模拟器24h/12h显示通过，旧Time的Enduro3与FR265定向构建通过，最终runner退出0。真实截图内嵌docs/zsvirt-girl.html。用户已授权安装，最终88,700字节PRG已侧载到Enduro3，回读逐字节一致，SHA为7129a3a8acfaf2f2e79a72f0411ffef6ae65305fde9455b35ad31cf93508da47；证据见docs/verification/zsvirt-girl-installation-20261027.json，暂存/回读位于bin/install-zsvirt-girl-20261027-182954/。OpenMTP正常退出0。等待拔线后选择ZSvirt Girl的腕上反馈，不重复安装。0%电量、跨日、休眠切换、腕上显示及续航未取得有效验收，不得声称通过。没有商店发布、Git提交或推送。后续构建用python3 scripts/build.py --face girl，默认--face time仍构建原应用。
```
