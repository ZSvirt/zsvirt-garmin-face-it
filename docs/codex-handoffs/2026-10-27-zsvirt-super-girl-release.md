# ZSvirt 超分娘 1.1.0 发布交接 · 2026-10-27

## Repo、分支与目标

- Repo：`/Users/zixiaobowen/ZStack/zsvirt-garmin-face-it`。
- 分支：`feat/zsvirt-girl-device-release`。
- 已完成设备扩展、国际化、GitHub提交推送及Garmin Connect IQ提交；商店状态为`PENDING`，尚未公开上架。用户指定名字为 **ZSvirt 超分娘**，默认/中文应用名称及商店中英文标题均使用这个精确名称。
- 保留正式半身立绘、大号单行时间、月日、电量；不增加Logo、步数、星期或秒。技术目录、类名、UUID不因显示名称改变。

## 已完成与文件

- `faces/zsvirt-girl/`独立应用，UUID `29b9c146b06f45d985a3cc93b6dde7d5`；69产品、12分辨率、最低API1.4.0。各尺寸/调色板资源已生成；MIP和AMOLED使用独立编译期profile。
- 视图按真实字体宽高和屏幕圆弧排布；AMOLED低功耗显示灰色时间，按分钟奇偶换位。
- `shared/FaceTime.mc`为原时制模块直接迁移；默认构建仍为Time，入口统一为`scripts/build.py --face girl`。
- 默认与`resources-zhs`的`AppName`、矩阵名称、`store-listing.json`、README、AGENTS、开发约束及隐私说明均已采用新名。
- 资源处理与配置在`scripts/generate-resources.py`、`scripts/configure.py`；构建在`scripts/build.py`。最终资源、源码已由reviewer只读检查，未发现有证据的发布阻塞问题。
- 本阶段证据：`docs/verification/zsvirt-super-girl-1.1.0.json`、`docs/verification/zsvirt-super-girl-store-1.1.0.json`、`docs/release-zsvirt-girl-1.1.0.md`与`docs/zsvirt-super-girl-release.html`。旧1.0.0交接和HTML保留历史含义。

## 实际命令与结果

使用SDK9.2.0及命令级Java17环境：`JAVA_HOME=/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home`，PATH前置该Java的bin。

- `python3 scripts/generate-resources.py --face girl`成功。
- `python3 scripts/build.py --face girl --package 1.1.0`在最终改名后116/116区域目标成功，API1.3.1旧地区被SDK忽略。
- 最终IQ：`artifacts/zsvirt-girl/release-1.1.0/zsvirt-girl-1.1.0.iq`，2,033,286字节，SHA-256 `09c39103c276b15ee4882b799df892a740b6d0c6601d148ebd3b906b02825c63`。
- 改名前已送入商店预验证的原IQ及原报告移至`artifacts/zsvirt-girl/release-1.1.0/validated-before-rename/`，SHA `e2a96d2372121c7e244b2076a895041b27b760c18c805142ad54d53efd97b26d`，没有覆盖原件；旧名包未提交发布。
- `python3 scripts/build.py --face girl --device TARGET --release --run`已实际观察Enduro3、FR45、FR920XT、FR230、fēnix3、fēnix6S Pro、fēnix6 Pro、FR265S、FR165、FR265、FR965、fēnix9 Pro 51mm，覆盖全部12种分辨率。前7个MIP目标截图在名称更新前取得，渲染源码和位图未变；后5个AMOLED目标使用最终改名资源验证，另4个新目标运行退出码均为0。
- Enduro3的24h/12h、简体中文、10/31 11:59PM自然跨到11/01 12:00AM已观察。
- FR265S原始360×360 AOD两帧亮像素1303/1259，占圆屏1.280%/1.237%，重叠0；`fr265s-aod-even.png`与`fr265s-aod-odd.png`为官方Save Screen Capture原始导出。
- 最终FR265S休眠中从10/31 11:59PM自然切换为11/01 12:00AM，时间上下换位；唤醒恢复完整人物和11/01日期。5个AMOLED代表目标均已观察休眠/唤醒。原始窗口截图在`simulator/`，展示裁图在`store/`。
- Time的Enduro3与FR265发行模拟器定向构建通过。没有重跑单元测试或全仓库测试。
- 最终HTML在本会话Tern原生浏览器验收：1280px页面与同页390px验证iframe均无页面横向溢出，5张图片全部加载且保持1:1比例；窄栏表格在354px容器内独立横向滚动。深浅主题按钮往返切换成功，页面错误与控制台记录均为空；临时iframe已移除。最终回执已固定到本会话右侧，验收后释放浏览器接管并保留分栏。

## 发布回执与已解决问题

- 实现提交`31b3829758a5efcc9ab6b367926e44b4a0c506ec`已推送`feat/zsvirt-girl-device-release`，远端SHA回读一致；本交接、最终验收JSON及HTML随交付记录提交到同一分支。
- 商店链接：https://apps.garmin.com/apps/e6c45ce6-48a7-4178-80ab-01df609acf41 。版本1.1.0、内部版本1。创建HTTP200，随后状态从`PENDINGSCAN`转为`PENDING`，仅发布账号可见预览；页面提示审核可能需要最多3天，不保证具体获批时间。
- 持久化元数据`signatureCheckSuccessFul=true`，编辑页实际显示`Signature: Verified`。首次预验证页的失败提示没有延续到持久化结果；未修改或绕过任何校验标志。第一次预验证网络失败后重试一次成功；创建应用只提交一次。
- 116个设备类型与区域料号、两种语言的全部文本均已回读。Cartoon类别、免费、非Beta、无额外权限、无地区限制、禁用自动迁移；封面和2张MIP/AMOLED截图已保存。公开联系邮箱复用Time应用，不写入仓库证据。
- 锁屏阻塞经用户解锁解除，剩余验收已全部完成。旧的停滞SDK客户端退出码没有被计为运行通过。Python的AppKit对象曾返回旧进程缓存，原生Swift/窗口server查询用于恢复；不要复用本交接中的旧PID。
- 时间模拟中修改日期须先Stop再Start；Pause只会恢复旧时刻。关闭时间面板可能弹出`Stop Time Simulation?`，必须按实际对话框处理，不能把AX操作返回0当作画面已更新。
- 本任务模拟器最后通过正常退出结束，`zsvirt-girl-final-native`退出码0；`bg_12`也已结束。无需保留模拟器常驻。
- 本版本未安装到手表；已有88,700字节回读记录只证明旧名1.0.0侧载。腕上显示、续航与公开下载尚未验收。本次没有部署、合并main或发送群消息。

## 后续具体动作

1. 下一次继续时读取商店实时状态；获批前仅称已提交待审核，不以本交接推断已公开上架。
2. 获批后核对公开中英文页面、兼容设备与下载入口；保留本次原始IQ及哈希，不用重建包替换上传原件。
3. 需要更新Enduro3真机时先取得该次安装授权，区分侧载文件回读、腕上显示和续航验收。
4. 后续代码继续沿用`scripts/build.py --face girl`、当前UUID与外部原签名；只做与改动相关的定向构建/模拟器检查。

## 恢复提示

```text
继续 /Users/zixiaobowen/ZStack/zsvirt-garmin-face-it 的 feat/zsvirt-girl-device-release。ZSvirt 超分娘1.1.0已完成69产品适配、116区域导出、12种分辨率的实际模拟器验收和五种AMOLED尺寸的休眠/唤醒检查；FR265S跨午夜唤醒也已通过。最终IQ SHA09c39103c276b15ee4882b799df892a740b6d0c6601d148ebd3b906b02825c63，已上传商店e6c45ce6-48a7-4178-80ab-01df609acf41，持久化签名验证true；最后记录状态PENDING，未公开上架。先读docs/release-zsvirt-girl-1.1.0.md与两份verification JSON，后续重新读取商店状态。实现31b3829及验收资料已推送当前分支；不要重跑已通过且仍适用的检查。原始包不可覆盖，1.0.0真机安装证据不代表1.1.0。没有新的安装、部署、合并main或群通知授权。最终HTML为docs/zsvirt-super-girl-release.html，当前会话右侧展示；任务模拟器已正常退出。
```
