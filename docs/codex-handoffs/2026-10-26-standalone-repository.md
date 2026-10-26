# ZSvirt Time 独立仓库交接 · 2026-10-26

## 仓库、分支与目标

- 新仓库：`/Users/zixiaobowen/ZStack/zsvirt-garmin-face-it`，GitHub为 https://github.com/ZSvirt/zsvirt-garmin-face-it 。
- 拆分工作分支：`chore/standalone-repository`；交付分支：`main`。
- 目标：将ZSvirt表盘从多表盘工作区完整迁出，保持应用身份、功能和发布证据；确认GitHub推送成功后，将仓库链接发送到用户指定的钉钉「ZSvirt开源社区建设群」。

## 已完成与证据

- 从原仓库提交`2371cbe2655bf3f2afa1a0ee92d4f2d49adeb1a2`的`watchfaces/zsvirt-time/`提取7个相关Git提交；提取后的历史末端为`f167f8dd87f84441d88c50d36d7d0dc6271e17fa`。工程根移至本仓库根，源码及构建脚本无需改写。
- 逐文件核验52个构建输入，与原工程一致。UUID继续为`cb51f19636e64ae1b979bfd8bf070e31`；原签名密钥位于仓库外，未复制、链接或提交。
- 原始1.0.0、1.1.0、1.2.0、1.3.0商店包及本地发布材料已复制到本仓库`artifacts/`，四个IQ包SHA-256均与原件一致；这些产物不提交Git。
- 更新README、开发约束、隐私支持链接、历史发布HTML页脚；加入根`.gitignore`、`AGENTS.md`，保留四份历史交接及Enduro 3安装回读记录。
- GitHub公开仓库已创建；代码推送与群通知结果待写入本交接。

详细记录：[迁移验证JSON](../verification/repository-split-20261026.json)。

## 实际执行的验证

在新仓库根依次运行：

```sh
python3 scripts/build.py --device enduro3
python3 scripts/build.py --device fenix6pro
python3 scripts/build.py --device fr265 --simulator --release
```

三个命令均退出0并输出`BUILD SUCCESSFUL`。Enduro 3为15,756字节，fēnix 6 Pro为15,052字节，FR265模拟器发行构建为18,908字节。结果、SDK路径及SHA-256保存在验证JSON。

本轮未改表盘渲染或业务逻辑，未重新运行模拟器、单元测试或全仓库测试；未重新导出商店包、提交商店、安装手表或测量续航。历史运行结果只代表当时版本。

## 限制与协作边界

- 原工作区当前使用`feat/multifunction-fenix6`分支，有另一任务的未提交改动。迁出修改只在原仓库的`.local/worktrees/zsvirt-split-20261026`、分支`chore/split-zsvirt-repository`进行，不改动原工作区的分支、索引或未提交文件。
- 旧工作分支可能仍看到原ZSvirt目录，这是旧分支的视图；后续维护入口统一为本仓库，不新增同步脚本或兼容路径。
- 历史交接保留迁出时的命令、路径、提交和事实；从本仓库继续工作时使用当前README。
- 用户要求中文交付、保留原始发布材料，不默认全量测试，不在未授权情况下发布商店、安装手表或发送额外群消息。

## 后续接续步骤

1. 从本仓库启动工作，先读README和`docs/garmin-dev-project.md`；核对当前分支及现有改动。
2. 根据新需求选择设备和验证范围，构建继续使用`python3 scripts/build.py`。
3. 渲染变化后运行实际模拟器验收；商店状态、真机显示和续航分别取证，不沿用旧结论。

## 恢复提示

```text
继续维护 /Users/zixiaobowen/ZStack/zsvirt-garmin-face-it 的ZSvirt Time。先读README、docs/garmin-dev-project.md和本交接，核对main及现有改动。该工程已从garmin-face-it提取，保留7个相关历史提交、原UUID/签名及四个版本的本地原始发布包。52个构建输入逐文件一致，新路径的Enduro 3、fenix6pro、fr265模拟器发行构建已通过。不要再使用旧watchfaces/zsvirt-time路径，也不要动原工作区正在进行的feat/multifunction-fenix6任务；新的商店发布、真机安装和群消息必须按新任务授权处理。
```
