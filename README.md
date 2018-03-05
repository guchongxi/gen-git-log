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
* -s	起始时间；默认：上周一
* -e	终止时间；默认：当天
* -o	设置比对分支源分支名；默认当前分支
* -r	本地项目路径；默认当前目录
* -t	设置比对分支目标分支名；默认当前分支
* -v	设置比对版本；默认package.json中version字段值
* -f	设置是否强制覆盖已有文件；默认：不覆盖
* -d	设置输出目录；默认：log

### Usage
 * 命令行进入项目根目录
 * 执行`./gen-log.sh`
 * 自动在`log`文件夹(若无会自动创建)下生成{user}.md文件

### Caution
 * 每个版本需**修改`package.json`版本号**
 * 尽可能**保证功能分支commit message简明扼要并且没有无意义commit**(建议提测前rebase，可参考[Git常规操作](https://note.youdao.com/share/?id=b423064d79fb2f975165d3fc5a79ae5d&type=note#/))
 * 提交MR将`develop`合入`master`**前**执行命令
 * 代码合并后新增tag，复制粘贴log文件内容即可

### Other
* 可直接执行`.sh`文件，报错提示无权限需要执行`chmod 755 ./gen-log.sh`
* 根据配置项可生成各种git记录，欢迎优化拓展
