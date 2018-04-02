# 生成 Git 日志
自动生成git commit记录用以统计个人项目周报，全组项目周报，版本差异记录等

![](https://img.shields.io/badge/npm-v1.0.2-orange.svg)

 [GitHub](https://github.com/GiantZero-x/proj-gen-git-log)

### 使用
 `npm install gen-git-log -g`

 Or

 `cd ~/Downloads && git clone git@github.com:GiantZero-x/gen-git-log.git && ./gen-git-log && chmod +x gen-log.sh`

 * 执行`./gen-log.sh -r <path-to-your-repository>`
 * 自动在`log`文件夹(若无会自动创建)下生成{user}.md文件

### 示例
#### 生成个人周报  ->  xxx.md
```bash
➜ gen-git-log (master) $ git-log

# [2018-03-06]
#  * chore: 发布xx ([02f64964](http://xxx.xxx.xxx/xxx/xxx/commit/02f64964de959931074a253ed0ba185d96704c3d))  - 26 hours ago

# [2018-03-07]
#  * fix: xxx ([14b475d5](http://xxx.xxx.xxx/xxx/xxx/commit/14b475d53655f14a1be3cb51fc24f372dfc4be79))  - 13 hours ago
#  * fix: 移除xxx ([92349b05](http://xxx.xxx.xxx/xxx/xxx/commit/92349b058b484829ae36d12e2f1d57251f2fa6a3))  - 8 hours ago
#  * fix: 医院xxx ([38c958f8](http://xxx.xxx.xxx/xxx/xxx/commit/38c958f891ef4c78b66b53caf455dabca11b227e))  - 8 hours ago
#  * chore: 发布xxx ([60cec8c0](http://xxx.xxx.xxx/xxx/xxx/commit/60cec8c03a160cc43063e16331e462401ea6390b))  - 4 hours ago
```
#### 生成个人周报覆盖已有文件
```bash
➜  gen-git-log (master) $ git-log -f
```

#### 生成团队周报  ->  20xx.xx.xx.md
```bash
➜  gen-git-log (master) $ git-log -a ''

# [2018-03-06]
#  * chore：xxx修改 ([82d1ae32](http://xxx.xxx.xxx/xxx/xxx/commit/82d1ae3224e4787660429d7ecad02b6d1b2f9387))  <xxx>
#  * chore: xxx细节修改 ([42dad557](http://xxx.xxx.xxx/xxx/xxx/commit/42dad557fd9a766c82ad4563c36d6f9ce520cd9f))  <xxx>

# [2018-03-07]
#  * fix: xxx ([14b475d5](http://xxx.xxx.xxx/xxx/xxx/commit/14b475d53655f14a1be3cb51fc24f372dfc4be79))  <oo>
#  * chore:  xxx判断 ([d62be405](http://xxx.xxx.xxx/xxx/xxx/commit/d62be40566a730c2b064cd7fa723fd6082954c30))  <xxx>
#  * fix: 修复xxx ([5e6da2d9](http://xxx.xxx.xxx/xxx/xxx/commit/5e6da2d91f07c8cdd63eb594c054b2b1dc28456d))  <xxx>
#  * chore: 添加注释 ([6b20d235](http://xxx.xxx.xxx/xxx/xxx/commit/6b20d2350d64d0c2483d758449ad7723536eb9a8))  <xxx>
#  * feat: 完成xxx ([575001fb](http://xxx.xxx.xxx/xxx/xxx/commit/575001fb0a904bd6b900da9afbd6da28fb8aea05))  <xxx>
```

#### 生成待发布版本信息 ->  vx.x.x.md
```bash
➜  gen-git-log (master) $ git-log -a '' -t master -o develop

# > 2018-03-07

# #### 新增
# * xxxx ([575001fb](http://xxx.xxx.xxx/xxx/xxx/commit/575001fb0a904bd6b900da9afbd6da28fb8aea05))  @xxx

# #### 修改
# * xxxx ([14b475d5](http://xxx.xxx.xxx/xxx/xxx/commit/14b475d53655f14a1be3cb51fc24f372dfc4be79))  @ooo
# * xxx ([92349b05](http://xxx.xxx.xxx/xxx/xxx/commit/92349b058b484829ae36d12e2f1d57251f2fa6a3))  @ooo
# * xxx ([36f52ea3](http://xxx.xxx.xxx/xxx/xxx/commit/36f52ea30446031387f449dd504c8cf5fd7dd7dd))  @ooo

# #### 样式
# * xxx ([075ad629](http://xxx.xxx.xxx/xxx/xxx/commit/075ad629ee70bbbd0441b7c8b7e526129b2472c3))  @ooo
# * xx ([38c958f8](http://xxx.xxx.xxx/xxx/xxx/commit/38c958f891ef4c78b66b53caf455dabca11b227e))  @ooo

# #### 重构
# * xx ([5e6da2d9](http://xxx.xxx.xxx/xxx/xxx/commit/5e6da2d91f07c8cdd63eb594c054b2b1dc28456d))  @ooo

# #### 其他
# *  xxxx ([25706352](http://xxx.xxx.xxx/xxx/xxx/commit/257063524332cea17351dfa5a1a2fac602a980da))  @ooo
# * xxx ([6b20d235](http://xxx.xxx.xxx/xxx/xxx/commit/6b20d2350d64d0c2483d758449ad7723536eb9a8))  @ooo

# #### 文档
# * xx.0.2 ([60cec8c0](http://xxx.xxx.xxx/xxx/xxx/commit/60cec8c03a160cc43063e16331e462401ea6390b))  @ooo
# * xxx ([c23cb128](http://xxx.xxx.xxx/xxx/xxx/commit/c23cb128627d6811688b34dc2b7ea87ce6b515cb))  @ooo
```

#### 生成在 version 目录下
```bash
➜  gen-git-log (master) $ git-log -d version
```

### 配置
* -a	贡献者；默认：`git` 全局配置 `name`；可传 '' 表示所有贡献者
* -s	起始时间；默认：上周一
* -e	终止时间；默认：当天
* -o	设置比对分支源分支名；默认当前分支
* -t	设置比对分支目标分支名；默认当前分支
* -r	本地项目路径；默认当前目录
* -v	设置比对版本；默认`package.json`中`version`字段值
* -f	设置是否强制覆盖已有文件；默认：不覆盖
* -d	设置输出目录；默认：`log`

### 高级
#### xx仓库 someone 2018年1月1日至2018年1月31日commit记录至./git-log/someone.md文件中，若已存在该文件直接覆盖
```bash
➜  gen-git-log (master) $ git-log -r <path-to-your-repository> -a someone -s 2018-01-01 -e 2018-01-31 -d git-log -f
```
### 注意
 * 生成版本差异建议先**修改`package.json`版本号**
 * 尽可能**保证功能分支commit message精简扼要**
 * 对比模式需要两个分支都在本地存在

### 其他
* 团队周报中贡献者姓名为贡献者`git` 全局配置 `name`
* 版本日志中`@`后紧随贡献者`git` 全局配置 `email`用户名(即不包含@xx.xx)
* 根据配置项可生成各种git记录，欢迎优化拓展
