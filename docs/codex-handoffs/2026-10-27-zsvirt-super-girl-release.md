# ZSvirt 超分娘 1.1.0 发布交接 · 2026-10-27

## Repo、分支与目标

- Repo：`/Users/zixiaobowen/ZStack/zsvirt-garmin-face-it`。
- 分支：`feat/zsvirt-girl-device-release`。
- 当前目标：设备扩展、国际化、提交并推送GitHub、发布Garmin Connect IQ。用户最新指定名字为 **ZSvirt 超分娘**，默认/中文应用名称及商店中英文标题均已按这个精确名称更新。
- 保留正式半身立绘、大号单行时间、月日、电量；不增加Logo、步数、星期或秒。技术目录、类名、UUID不因显示名称改变。

## 已完成与文件

- `faces/zsvirt-girl/`独立应用，UUID `29b9c146b06f45d985a3cc93b6dde7d5`；69产品、12分辨率、最低API1.4.0。各尺寸/调色板资源已生成；MIP和AMOLED使用独立编译期profile。
- 视图按真实字体宽高和屏幕圆弧排布；AMOLED低功耗显示灰色时间，按分钟奇偶换位。
- `shared/FaceTime.mc`为原时制模块直接迁移；默认构建仍为Time，入口统一为`scripts/build.py --face girl`。
- 默认与`resources-zhs`的`AppName`、矩阵名称、`store-listing.json`、README、AGENTS、开发约束及隐私说明均已采用新名。
- 资源处理与配置在`scripts/generate-resources.py`、`scripts/configure.py`；构建在`scripts/build.py`。最终资源、源码已由reviewer只读检查，未发现有证据的发布阻塞问题。
- 本阶段证据：`docs/verification/zsvirt-super-girl-1.1.0.json`、`docs/release-zsvirt-girl-1.1.0.md`。旧1.0.0交接和HTML保留历史含义。

## 实际命令与结果

使用SDK9.2.0及命令级Java17环境：`JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home`，PATH前置该Java的bin。

- `python3 scripts/generate-resources.py --face girl`成功。
- `python3 scripts/build.py --face girl --package 1.1.0`在最终改名后116/116区域目标成功，API1.3.1旧地区被SDK忽略。
- 最终IQ：`artifacts/zsvirt-girl/release-1.1.0/zsvirt-girl-1.1.0.iq`，2,033,286字节，SHA-256 `09c39103c276b15ee4882b799df892a740b6d0c6601d148ebd3b906b02825c63`。
- 改名前已送入商店预验证的原IQ及原报告移至`artifacts/zsvirt-girl/release-1.1.0/validated-before-rename/`，SHA `e2a96d2372121c7e244b2076a895041b27b760c18c805142ad54d53efd97b26d`，没有覆盖原件；旧名包未提交发布。
- `python3 scripts/build.py --face girl --device TARGET --release --run`已实际观察Enduro3、FR45、FR920XT、FR230、fēnix3、fēnix6S Pro、fēnix6 Pro、FR265S。截图在本次release的`simulator/`，取得后只改显示名资源，渲染源码和人物位图未变。
- Enduro3的24h/12h、简体中文、10/31 11:59PM自然跨到11/01 12:00AM已观察。
- FR265S原始360×360 AOD两帧亮像素1303/1259，占圆屏1.280%/1.237%，重叠0；`fr265s-aod-even.png`与`fr265s-aod-odd.png`为官方Save Screen Capture原始导出。
- Time的Enduro3与FR265发行模拟器定向构建通过。没有重跑单元测试或全仓库测试。

## 当前阻塞与运行状态

- macOS查询明确返回`CGSSessionScreenIsLocked=true`。`screencapture -l`报`could not create image from window`，区域截图也报`could not create image from rect`。需要用户解锁后继续，不绕过系统锁屏。
- 尚未取得390、416、454、466像素代表目标画面，以及AMOLED唤醒/跨午夜唤醒的有效证据。不把失败截图、空AX窗口、脚本超时计为通过。
- 一次改名后的FR265S客户端连接停滞。已确认并终止本任务的shell子进程43419；SDK仍返回0，明确不将该次退出码当作运行验收通过。
- Python内核的`NSWorkspace.runningApplications()`曾返回旧进程缓存。后续以实时CGWindowList的窗口owner PID或新进程的原生系统查询为准，不信旧AppKit对象；当前后续实例曾观察到PID43900，接续必须重新核对。
- 当前服务`zsvirt-girl-final-native`通过`open -W -a`启动。最初TCP1235就绪探测超时，不代表GUI不存在；不要据此再开重复实例。`bg_12`为重用已构建FR265S PRG的monkeydo；结束设备后等待真实回执，最终正常退出本任务独占启动的模拟器。
- 当前Tern原生浏览器标签`girl-ciq-publish`为本任务商店上传表单。原包已预验证，表单曾填入双语标题/文案、Cartoon类别、免费、不收集数据、不使用ANT+、无地域限制、不自动迁移设备；公开号邮箱从现有Time商店元数据复用，没有写入文档。
- 用户授权提交推送和商店发布仍有效；本阶段尚未收到商店提交回执。新的手表安装、部署或群通知未授权。

## 后续具体动作

1. 核对锁屏已解除，使用当前真实模拟器PID恢复剩余4种尺寸、睡眠到唤醒及必要跨午夜检查。已通过且源码未改的检查无需重跑。
2. 更新验证JSON和发布记录，保留实际失败与限制；不把1.0.0手表安装当作1.1.0验收。
3. 精确暂存本任务文件并提交、推送当前分支；回读远端SHA。禁止全量暂存、重置或强推。
4. 商店必须换成最终改名IQ（上述09c391…），按`store-listing.json`恢复双语表单；封面/截图在`artifacts/zsvirt-girl/release-1.1.0/store/`。
5. 正常提交后回读新商店AppID、版本、UUID、持久化签名校验、双语字段及兼容设备；PENDING只表示已提交待审核，不说已公开上架。
6. 生成本阶段最终HTML证据页，在当前TERN_PANE右侧展示并验收；补齐发布回执与Git推送记录，正常退出任务专用模拟器并释放浏览器接管。

## 恢复提示

```text
继续 /Users/zixiaobowen/ZStack/zsvirt-garmin-face-it 的 feat/zsvirt-girl-device-release。用户已授权设备扩展、国际化、提交推送和商店发布，最新名字必须是 ZSvirt 超分娘。先读本交接和 docs/release-zsvirt-girl-1.1.0.md。最终新名IQ已116/116区域导出成功，2,033,286字节，SHA09c39103c276b15ee4882b799df892a740b6d0c6601d148ebd3b906b02825c63。原名预验证包已保留在validated-before-rename目录，不能上传错包。已有8个代表目标画面及Enduro跨月、FR265S两帧AOD原始像素证据；剩余4种AMOLED尺寸和唤醒因macOS锁屏未完成。先检查系统锁屏是否解除；不要相信持久Python中旧NSWorkspace进程缓存，以窗口server实际owner PID为准。保留当前未提交文件和历史1.0.0记录，不重装手表、不群通知。商店浏览器标签girl-ciq-publish复用Tern登录；最终提交必须回读签名、AppID及审核状态。完成后写最终HTML并固定当前会话右侧。
```
