# 生成 Git 日志
自动生成`git commit`记录用以统计个人项目周报，全组项目周报，版本、分支差异记录自动生成Tag等

### 功能
  * 生成(本人:默认/其他人/团队)(任意时间段/上周:默认)(任意项目/当前项目:默认)日志
  * 控制是否覆盖已有文件
  * 控制是否显示生成时间
  * 指定分支比对、版本比对、`CHANGELOG`、`publish`模式
  * 比对模式可(指定/读取`package.json`：默认)版本生成对应文件名
  * 分支比对模式可指定比对分支(当前:默认)
  * 版本比对模式可指定比对版本(源版本/HEAD:默认、目标版本/最新版本:默认)
  * `CHANGELOG`模式可检索全部标签并生成每个标签log
  * `publish`模式可基于当前分支代码生成版本log，并与上个`commit`合并，切到指定分支进行合并，生成并推送标签和代码至远程

### 配置项
  * `-m`： 生成模式  默认：无(周报)，可选：branch(分支比对)、tag(标签比对)、changelog(汇总日志)、publish(发布模式)、copy(将标签对比结果仅输出至剪切板**该特性暂仅支持 macOS**)
  * `-a`： 贡献者；默认：`git` 配置 `name`；可传 ''(所有贡献者)、任意成员`name`
  * `-s`： 起始日期  默认：上周一，格式：2018-01-01
  * `-u`： 终止日期  默认：当天，格式：2018-01-01
  * `-S`： 源分支/标签 默认：无，比对模式：当前分支/最近标签 例：develop
  * `-T`： 目标分支/标签 默认：无，比对模式：当前分支/当前HEAD 例：master
  * `-r`： Git 仓库本地路径  默认：当前目录
  * `-v`： 版本号  默认：无，比对模式：仓库路径下 package.json 中 VERSION 字段值
  * `-d`： log 输出目录 默认：仓库路径下 log 文件夹
  * `-f`： 覆盖文件  默认：否，不需要传值
  * `-t`： log 首行为生成日期  默认：否，不需要传值

### 使用
```
➜ demo-project git:(master): npm install gen-git-log
```
**示例为安装在全局后切到项目目录使用，因此不需要`-r`参数, 并且本地代码与线上保持同步**
#### 周报
```bash
➜ demo-project git:(master): git-log
```
 #### 标签比对
 ```bash
#  此时需保证当前分支有未打tag的commit即可，即在开发分支即将合入master时使用最佳
➜ demo-project git:(develop): git-log -t -m tag
 ```
#### 项目CHANGELOG
```bash
➜ demo-project git:(master): git-log -m changelog
```
#### 发布模式
发布模式会做以下几件事，因为`可能会在master上提交代码，请慎用`
* 根据版本号生成log文件，同标签对比模式
* 生成`commit` "`chore: Publish version x.x.x`"
* 添加所有文件到暂存区
* 确认目标分支(默认: `master`)
* 切到目标分支
* 合并代码(`merge`)到目标分支
* 生成tag
* 推送tag
* 推送代码
* 复制版本`log`到剪切板
* 完成
```bash
➜ demo-project git:(master): git-log -m publish
```

 #### 非 Node 环境
```bash
➜ ~ cd ~/Downloads && git clone git@github.com:guchongxi/gen-git-log.git && ./gen-git-log && chmod +x gen-log.sh
```

 * 执行`./gen-log.sh -r <path-to-your-repository>`
 * 自动在`log`文件夹(若无会自动创建)下生成{user}.md文件

### 示例
#### 生成个人周报  ->  xxx.md
```bash
➜ demo-project git:(master): git-log

# [2018-03-06]
#  * chore: 发布xx ([02f64964](http://xxx.xxx.xxx/xxx/xxx/commit/02f64964de959931074a253ed0ba185d96704c3d))  - 26 hours ago

# [2018-03-07]
#  * fix: xxx ([14b475d5](http://xxx.xxx.xxx/xxx/xxx/commit/14b475d53655f14a1be3cb51fc24f372dfc4be79))  - 13 hours ago
#  * chore: 发布xxx ([60cec8c0](http://xxx.xxx.xxx/xxx/xxx/commit/60cec8c03a160cc43063e16331e462401ea6390b))  - 4 hours ago
```

#### 生成团队周报  ->  20xx.xx.xx.md
```bash
➜ demo-project git:(master): git-log -a ''

# [2018-03-06]
#  * chore：xxx修改 ([82d1ae32](http://xxx.xxx.xxx/xxx/xxx/commit/82d1ae3224e4787660429d7ecad02b6d1b2f9387))  <xxx>
#  * chore: xxx细节修改 ([42dad557](http://xxx.xxx.xxx/xxx/xxx/commit/42dad557fd9a766c82ad4563c36d6f9ce520cd9f))  <xxx>

# [2018-03-07]
#  * fix: xxx ([14b475d5](http://xxx.xxx.xxx/xxx/xxx/commit/14b475d53655f14a1be3cb51fc24f372dfc4be79))  <oo>
```

#### 生成待发布版本信息 ->  vx.x.x.md
```bash
➜ demo-project git:(master): git-log -m branch -S develop
# 或
➜ demo-project git:(master): git-log -m tag

# #### 新增
# * xxxx ([575001fb](http://xxx.xxx.xxx/xxx/xxx/commit/575001fb0a904bd6b900da9afbd6da28fb8aea05))  @xxx

# #### 修改
# * xxx ([92349b05](http://xxx.xxx.xxx/xxx/xxx/commit/92349b058b484829ae36d12e2f1d57251f2fa6a3))  @ooo
# * xxx ([36f52ea3](http://xxx.xxx.xxx/xxx/xxx/commit/36f52ea30446031387f449dd504c8cf5fd7dd7dd))  @ooo

# #### 其他
# *  xxxx ([25706352](http://xxx.xxx.xxx/xxx/xxx/commit/257063524332cea17351dfa5a1a2fac602a980da))  @ooo
# * xxx ([6b20d235](http://xxx.xxx.xxx/xxx/xxx/commit/6b20d2350d64d0c2483d758449ad7723536eb9a8))  @ooo

# #### 文档
# * xx.0.2 ([60cec8c0](http://xxx.xxx.xxx/xxx/xxx/commit/60cec8c03a160cc43063e16331e462401ea6390b))  @ooo
# * xxx ([c23cb128](http://xxx.xxx.xxx/xxx/xxx/commit/c23cb128627d6811688b34dc2b7ea87ce6b515cb))  @ooo
```

#### 生成在 version 目录下
```bash
➜ demo-project git:(master): git-log -d version
```

### 高级
#### xx仓库 someone 2018年1月1日至2018年1月31日commit记录至./git-log/someone.md文件中，若已存在该文件直接覆盖
```bash
➜ demo-project git:(master): git-log -r <path-to-your-repository> -a someone -s 2018-01-01 -u 2018-01-31 -d git-log -f
```
### 注意
 * `commit`分类要求所有`commit message`符合规范，及以`feat fix refactor style docs chore build ci pref test`开头，后紧跟`: `，然后是正文；例：`feat: 新增git-log`
 * 生成版本差异建议先**修改`package.json`版本号**
 * 尽可能**保证功能分支commit message精简扼要**
 * 分支对比模式需要两个分支都在本地存在

### 其他
* 团队周报中贡献者姓名为贡献者`git` 配置 `name`
* 版本日志中`@`后紧随贡献者`git` 配置 `email`用户名(即不包含@xx.xx)
* 根据配置项可生成各种git记录，欢迎优化拓展
