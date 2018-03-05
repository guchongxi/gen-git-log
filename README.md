# Auto Generate Git Log
自动生成git commit记录用以统计个人项目周报，全组项目周报，版本差异记录等

### Example
```bash
# 生成个人周报  ->  xxx.md
$ ./gen-log.sh

# [2018-02-27]
#  * feat: sss
#  * feat: xxx
#  * chore: xxxsss

# [2018-02-28]
#  * fix: xxx
#  * chore：fff
#  * chore：ggg

# [2018-03-01]
#  * chore: xxx
#  * chore: xxx
#  * feat: xxx

# [2018-03-02]
#  * fix：sdfdsf

# [2018-03-05]
#  * feat: xxx
```

```bash
# 生成个人周报覆盖已有文件
$ ./gen-log.sh -f
```

```bash
# 生成团队周报  ->  20xx.xx.xx.md
$ ./gen-log.sh -a ''

# [2018-02-26]
#  * refactor: sdfa (dachui)
#  * fix: 1639 (顾重)
#  * feat: gggg (dachui)
#  * feat: aaaaa (dachui)

# [2018-02-27]
#  * chore: sdf (dachui)
#  * chore: 代码格式化 (dachui)
#  * chore: sdf (顾重)

# [2018-02-28]
#  * fix: 1111 (顾重)
#  * chore: 22222 (dachui)

# [2018-03-01]
#  * chore: vvvv (顾重)
#  * chore: ssss (顾重)
#  * feat: bbbb (顾重)
#  * fix: asdf (dachui)

# [2018-03-05]
#  * feat: 2222 (顾重)
```

```bash
# 生成待发布版本信息 ->  vx.x.x.md
$ ./gen-log.sh -a '' -t master -o develop -s 1970-01-01

# > 2018-03-05

# #### 新增
# * sdf (lizhen)
# * 234 (dachui)
# * hh (dachui)
# * bbb (dachui)

# #### 修改
# * 2222 (asdf)

# #### 重构
# * vvvv (dachui)

# #### 文档
# * aaaa (dachui)

# #### 其他
# * ssss&优化代码 (lizhen)
# * vvvv (dachui)
# * 123 (顾重)
```

```bash
# 生成目录为version
$ ./gen-log.sh -d version
```

### Options
* -a	贡献者；默认：git 全局配置 name；可传 '' 表示所有贡献者
* -s	起始时间；默认：上周一
* -e	终止时间；默认：当天
* -o	设置比对分支源分支名；默认当前分支
* -r	本地项目路径；默认当前目录
* -t	设置比对分支目标分支名；默认当前分支
* -v	设置比对版本；默认package.json中version字段值
* -f	设置是否强制覆盖已有文件；默认：不覆盖
* -d	设置输出目录；默认：log

### Usage
 * 打开终端，执行

 `cd ~/Downloads && git clone git@github.com:GiantZero-x/proj-gen-git-log.git && ./proj-gen-git-log && chmod +x gen-log.sh`

 * 执行`./gen-log.sh -r <path-to-your-repository>`
 * 自动在`log`文件夹(若无会自动创建)下生成{user}.md文件

### Advanced
```bash
# 输出 someone 2018年1月1日至2018年1月31日commit记录至./git-log/someone.md文件中，若已存在该文件直接覆盖
./gen-log.sh -r <path-to-your-repository> -a someone -s 2018-01-01 -e 2018-01-31 -d git-log -f
```
### Caution
 * 每个版本需**修改`package.json`版本号**
 * 尽可能**保证功能分支commit message简明扼要并且没有无意义commit
 * 对比模式需要两个分支都存在本地

### Other
* 根据配置项可生成各种git记录，欢迎优化拓展
