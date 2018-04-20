
#!/bin/bash

# 自动生成 Git 日志脚本
# feature
# * 可生成(本人:默认/其他人/团队)(任意时间段/上周:默认)(任意项目/当前项目:默认)日志
# * 可控制是否覆盖已有文件
# * 可控制是否显示生成时间
# * 可指定分支比对和版本比对模式
# * 比对模式可(指定/读取package.json：默认)版本生成对应文件名
# * 分支比对模式可指定比对分支(当前:默认)
# * 版本比对模式可指定比对版本(源版本/HEAD:默认、目标版本/最新版本:默认)

# commit 类型 键
TYPE_MAP=(feat fix refactor style docs chore)
# commit 类型 值
TYPE_TITLE_MAP=(新增 修改 重构 样式 文档 其他)
# 作者
AUTHOR=$(git config user.name)
# 当前日期+时间
NOW=$(date "+%F %H:%M")
# 起始日期
SINCE="last.Monday"
# 终止日期
UNTIL=$(date +%F)
# 是否覆盖文件
FOUCE=0
# 首行是否为生成日期
PRINT_TIME=0
# 输出目录
OUTPUT_DIR="log"

# function，去除字符串两头空格
trim() {
  trimmed=$1
  trimmed=${trimmed%% }
  trimmed=${trimmed## }
  trimmed=${trimmed## }

  echo $trimmed
}
# function，是否强制生成文件
shouldFouceResolve() {
  # 输出文件已存在 & 不强制生成 则提示并退出
  if [ -e $OUTPUT -a $FOUCE -eq 0 ]
  then
    echo "${OUTPUT} already exists! \n
      Please update package.json or remove log file or add '-f' follow the command!\n
    "
    exit 1
  fi
}
# function，首行是否输出生成日期
printTimeIfNeed(){
  if [ $PRINT_TIME -eq 1 ]
  then
    echo "> Generated on ${NOW} By [Gen-Git-Log](https://www.npmjs.com/package/gen-git-log)\n"

    case $MODE in
      branch)
      TITLE="${TARGET}...${SOURCE}"
      ;;
      tag)
      TITLE="${TARGET}...v$(getVersion)"
      ;;
    esac

    # 匹配模式
    if [ ! -z $TITLE ]
    then
      TITLE="## [${TITLE}](http://${REMOTE}/compare/${TITLE})"
      echo $TITLE
    fi
  fi
}
# function，获取版本
getVersion() {
  # 判断是否自定义版本
  if [ -z $VERSION ]
  then
    # 未传入版本
    if [ -z $REPO ]
    then
      # 没有传repo则package文件为当前目录所有
      PKG_PATH="./package.json"
    else
      PKG_PATH="${REPO}/package.json"
    fi

    # 自定义version为空时抓取版本
    while read line
    do
      # 抓取定义version行文本
      if [[ ${line} = *"version"* ]]
      then
        # 移除双引号
        VERSION=${line//\"/ }
        # 移除键名
        VERSION=${VERSION##*"version :"}
        # 获取版本
        VERSION=${VERSION%%" ,"}
        break
      fi
    done < $PKG_PATH
  fi
  trim $VERSION
}
# function，生成输出文件路径
generateOutPutPath() {
  # 输出文件路径，默认“v版本.md”
  echo "${OUTPUT_DIR}/v$(getVersion).md"
}
# 生成指定SOURCE TARGET tag差异记录
genSingleTagLog() {
    SOU=$1
    TAR=$2

    if [ ! "$3"x = "0"x ]
    then
      if [ $SOU = HEAD ]
      then
        # 如果是与最新HEAD对比则将HEAD设为version
        TIT="## [v$(getVersion)](http://${REMOTE}/compare/${TAR}...v$(getVersion))"
      else
        TIT="## [${SOU}](http://${REMOTE}/compare/${TAR}...${SOU})"
      fi

      echo "${TIT} ($(git -C "${REPO}" log -1 --format=%ad --date=short $SOU))"
    fi

    # 直接使用分支比对查找所有匹配 log
    GIT_PAGER=$(git -C "${REPO}" log --no-merges --reverse --format="${LOG_FORMAT}" "$SOU...$TAR")

    if [ ! -z "$GIT_PAGER" ]
    then
      # 字符串分隔符
      IFS="*"
      # 分割字符串为数组
      singleTagArr=($GIT_PAGER)
      # 还原分割符，否则会导致if判断失效
      IFS=""
      # 循环处理数组
      for s in ${singleTagArr[@]}
      do
        # 去除字符串两头空格
        s=$(trim $s)
        # 判断字符串非空
        if [ ! -z $s ]
        then
          # 替换全角冒号
          s=${s/：/:}
          # 循环commit 类型
          for type in ${TYPE_MAP[@]}
          do
            # 组织正则
            reg="${type}:"
            # 判断commit类型
            if [[ ${s} = *"${reg}"* ]]
            then
              # 裁剪字符串
              s=${s##*${reg}}
              s=${s%@*}
              # 移除空格
              s=$(trim $s)
              # 动态数组变量赋值
              eval COMMIT_${type}='(${COMMIT_'${type}'[*]} $s)'
              break
            fi
          done
        fi
      done

      # 处理数据
      typeIndex=0
      for type in ${TYPE_MAP[@]}
      do
        # 拷贝数组
        eval type='(${COMMIT_'${type}'[*]})'

        # 判断数组是否含有元素
        if [ ${#type[*]} != 0 ]
        then
          echo "#### ${TYPE_TITLE_MAP[$typeIndex]}"

          for i in ${type[@]}
          do
            echo "* ${i}"
          done
          echo
        fi
        let typeIndex++
      done
    fi
}

# 传参覆盖默认值
while getopts "m:a:s:u:S:T:r:v:ftd:h" arg
do
  case $arg in
    m)
      # 模式
      MODE=$OPTARG
    ;;
    a)
      # 作者
      AUTHOR=$OPTARG
    ;;
    s)
      # 起始日期
      SINCE=$OPTARG
    ;;
    u)
      # 终止日期
      UNTIL=$OPTARG
    ;;
    S)
      # 源分支/标签
      SOURCE=$OPTARG
    ;;
    T)
      # 目标分支/标签
      TARGET=$OPTARG
    ;;
    r)
      # Git 仓库本地路径
      REPO=$OPTARG
    ;;
    v)
      # 自定义版本
      VERSION=$OPTARG
    ;;
    f)
      # 强制覆盖文件
      FOUCE=1
    ;;
    t)
      # 首行输出生成日期
      PRINT_TIME=1
    ;;
    d)
      # 输出目录路径
      OUTPUT_DIR=$OPTARG
    ;;
    h)
      echo "
  Usage:\n
    git-log [options]\n

  Options:\n
    -m  生成模式  默认：无(周报)，可选：branch(分支比对)、tag(标签比对)、changelog(汇总日志)
    -a  想要过滤的作者  默认：$(git config user.name)
    -s  起始日期  默认：上周一，格式：2018-01-01
    -u  终止日期  默认：当天，格式：2018-01-01
    -S  源分支/标签 默认：无，比对模式：当前分支/最近标签
    -T  目标分支/标签 默认：无，比对模式：当前分支/当前HEAD
    -r  Git 仓库本地路径  默认：当前目录
    -v  版本号  默认：无，比对模式：仓库路径下 package.json 中 VERSION 字段值
    -f  覆盖文件  默认：否，不需要传值
    -t  log 首行为生成日期  默认：否，不需要传值
    -d  log 输出目录 默认：仓库路径下 log 文件夹
      "
      exit 1
    ;;
    ?)
      echo "unknown argument"
      exit 1
    ;;
  esac
done

# 获取远程仓库地址
REMOTE=$(git -C "${REPO}" remote -v)
REMOTE=${REMOTE#*git@}
REMOTE=${REMOTE%%.git*}
REMOTE=${REMOTE/://}

# 格式化 https://ruby-china.org/topics/939
# %H:   commit hash
# %h:   短commit hash
# %an:  提交人名字
# %ae:  提交人邮箱
# %cr:  提交日期, 相对格式(1 day ago)
# %d:   ref名称
# %s:   commit信息标题
# %cd:  提交日期 (--date= 制定的格式)
FORMAT_DEFAULT=" * %s ([%h](http://${REMOTE}/commit/%H)) "

# 判断是否指定仓库路径重写输出目录路径
if [ -z $REPO ]
then
  OUTPUT_DIR="./${OUTPUT_DIR}"
else
  OUTPUT_DIR="${REPO}/${OUTPUT_DIR}"
fi


# 指定目录路径不存在则创建
if [ ! -e $OUTPUT_DIR ]
then
  mkdir $OUTPUT_DIR
fi

# 判断提交人，设定输出路径
if [ -z $AUTHOR ]
then
  # 提交人为空
  LOG_FORMAT="$FORMAT_DEFAULT <%an>"

  # 输出文件路径，默认“当前日期.md”
  OUTPUT="${OUTPUT_DIR}/$(date +%F).md"
else
  # 有提交人
  LOG_FORMAT="$FORMAT_DEFAULT - %cr"

  # 输出文件路径，默认“提交人名.md”
  OUTPUT="${OUTPUT_DIR}/${AUTHOR}.md"
fi

case $MODE in
  branch)
    LOG_FORMAT="$FORMAT_DEFAULT @%ae"

    OUTPUT=$(generateOutPutPath)

    shouldFouceResolve

    # 默认分支为当前分支
    CURRENT_BRANCH=$(git -C "${REPO}" rev-parse --abbrev-ref HEAD)

    if [ -z $SOURCE ]
    then
      SOURCE=$CURRENT_BRANCH
    fi
    if [ -z $TARGET ]
    then
      TARGET=$CURRENT_BRANCH
    fi

    # 直接使用分支比对查找所有匹配 log
    GIT_PAGER=$(git -C "${REPO}" log "$SOURCE...$TARGET" --no-merges --reverse --format="${LOG_FORMAT}")

    (
      printTimeIfNeed

      if [ ! -z "$GIT_PAGER" ]
      then
        # 字符串分隔符
        IFS="*"
        # 分割字符串为数组
        arr=($GIT_PAGER)
        # 还原分割符，否则会导致if判断失效
        IFS=""
        # 循环处理数组
        for s in ${arr[@]}
        do
          # 去除字符串两头空格
          s=$(trim $s)
          # 判断字符串非空
          if [ ! -z $s ]
          then
            # 替换全角冒号
            s=${s/：/:}
            # 循环commit 类型
            for type in ${TYPE_MAP[@]}
            do
              # 组织正则
              reg="${type}:"
              # 判断commit类型
              if [[ ${s} = *"${reg}"* ]]
              then
                # 裁剪字符串
                s=${s##*${reg}}
                s=${s%@*}
                # 移除空格
                s=$(trim $s)
                # 动态数组变量赋值
                eval COMMIT_${type}='(${COMMIT_'${type}'[*]} $s)'
                break
              fi
            done
          fi
        done

        # 处理数据
        typeIndex=0
        for type in ${TYPE_MAP[@]}
        do
          # 拷贝数组
          eval type='(${COMMIT_'${type}'[*]})'

          # 判断数组是否含有元素
          if [ ${#type[*]} != 0 ]
          then
            echo "#### ${TYPE_TITLE_MAP[$typeIndex]}"

            for i in ${type[@]}
            do
              echo "* ${i}"
            done
            echo
          fi
          let typeIndex++
        done
      else
        echo "${SOURCE}...${TARGET} 分支无差异"
      fi
    ) > $OUTPUT
  ;;
  tag)
    LOG_FORMAT="$FORMAT_DEFAULT @%ae"

    OUTPUT=$(generateOutPutPath)

    shouldFouceResolve

    # 获取最新标签
    LASTEST_TAG=$(git -C "${REPO}" describe --tags `git -C "${REPO}" rev-list --tags --max-count=1`)

    if [ -z $SOURCE ]
    then
      SOURCE="HEAD"
    fi
    if [ -z $TARGET ]
    then
      TARGET=$LASTEST_TAG
    fi


    (
      printTimeIfNeed
      genSingleTagLog $SOURCE $TARGET 0
    ) > $OUTPUT
  ;;
  changelog)
    if [ -z $REPO ]
    then
      OUTPUT="./CHANGELOG.md"
    else
      OUTPUT="${REPO}/CHANGELOG.md"
    fi

    LOG_FORMAT="$FORMAT_DEFAULT @%ae"

    shouldFouceResolve

    # 标签列表
    TAG_LIST=$(git -C "${REPO}" tag)

    # 字符串分隔符
    IFS="v"
    # 分割字符串为数组
    arr=($TAG_LIST)
    # 还原分割符，否则会导致if判断失效
    IFS=""
    # 第一次提交commit, 取duan hash
    LAST_TAG=$(git -C "${REPO}" rev-list --reverse HEAD | head -1)
    LAST_TAG=${LAST_TAG:0:6}
    FIRST_TAG="HEAD"

    len=$[${#arr[@]}-1]

    (
      # 循环处理数组
      for ((i=$len;i>0;i--))
      do
        s=${arr[$i]}
        # 去除字符串两头空格
        s=v$(trim $s)
        # 判断字符串非空
        if [ ! -z $s ]
        then
          # 不知道为什么一定要缓存一下，否则$s值错乱
          TEMP=$s
          echo $(genSingleTagLog $FIRST_TAG $s)
          FIRST_TAG=$TEMP
        fi
      done

      genSingleTagLog $FIRST_TAG $LAST_TAG
    ) > $OUTPUT
  ;;
  *)
    shouldFouceResolve

    (
      printTimeIfNeed
      # 先根据起始及终止时间查找符合条件的log并且把日期格式化后输出
      # 之后遍历所有输出的日期，在根据日期查询当天内的log进行打印
      git -C "${REPO}" log --since="${SINCE}" --until="${UNTIL}" --format="%cd" --date=short | sort -u | while read DATE ; do
      GIT_PAGER=$(git -C "${REPO}" log --no-merges --reverse --format="${LOG_FORMAT}" --since="${DATE} 00:00:00" --until="${DATE} 23:59:59" --author="${AUTHOR}")
      if [ ! -z "$GIT_PAGER" ]
      then
        echo "[${DATE}]"
        echo "${GIT_PAGER}"
        echo
      fi
    done
    ) > $OUTPUT
  ;;
esac

echo "Log has been written to '${OUTPUT}'"
