
#!/bin/bash

# Generates git changelog
#
# optional parameters
# -a	to filter by author
# -s	to select start date
# -e	to select end date
# -o	to select origin branch
# -r	to specify the repository path
# -t	to select target branch
# -v	to set version number
# -f	to set fouce gen file
# -d	to set output dir

# 作者，默认git全局配置name
AUTHOR=$(git config user.name)
# 起始时间，默认上周一
SINCE="last.Monday"
# 终止时间，默认当天
UNTIL=$(date +%F)
# 格式化
LOG_FORMAT=" %Cgreen*%Creset %s"
# 输出目录
OUTPUT_DIR="log"
# commit比对，源分支，当前分支
ORIGIN="$(git rev-parse --abbrev-ref HEAD)"
# commit比对，目标分支，默认当前分支
TARGET=$ORIGIN
# commit 类型 键
TYPE_MAP=(feat fix refactor style docs chore)
# commit 类型 值
TYPE_TITLE_MAP=(新增 修改 重构 样式 文档 其他)
# 强制生成文件
FOUCE=0
# 是否打印时间
PRINT_TIME=1

# function，去除字符串两头空格
trim()
{
  trimmed=$1
  trimmed=${trimmed%% }
  trimmed=${trimmed## }
  
  echo $trimmed
}
shouldFouceResolve()
{
  # 检查文输出件存在 & 不强制生成 则退出
  if [ -e $OUTPUT -a $FOUCE -eq 0 ]
  then
    echo "${OUTPUT} already exists! \nPlease update package.json or remove log file or add '-f' follow the command!\n"
    exit 1
  fi
}

# 传参覆盖默认值
while getopts "a:s:e:o:d:r:t:v:f" arg
do
  case $arg in
    a)
      AUTHOR=$OPTARG
    ;;
    s)
      SINCE=$OPTARG
    ;;
    e)
      UNTIL=$OPTARG
    ;;
    o)
      ORIGIN=$OPTARG
    ;;
    r)
      REPO=$OPTARG
    ;;
    t)
      TARGET=$OPTARG
    ;;
    v)
      VERSION=$OPTARG
    ;;
    f)
      FOUCE=1
    ;;
    d)
      OUTPUT_DIR=$OPTARG
    ;;
    ?)
      echo "unknown argument"
      exit 1
    ;;
  esac
done

# 指定目录但不存在则创建
if [ ! -z $OUTPUT_DIR -a ! -e $OUTPUT_DIR ]
then
  mkdir $OUTPUT_DIR
fi

# 判断作者
if [ -z $AUTHOR ]
then
  # 作者为空
  LOG_FORMAT="$LOG_FORMAT %Cblue(%an)%Creset"
  
  # 输出文件路径，默认“当前日期.md”
  OUTPUT="${OUTPUT_DIR}/$(date +%F).md"
else
  # 输出文件路径，默认“作者名.md”
  OUTPUT="${OUTPUT_DIR}/${AUTHOR}.md"
fi

# 判断是否使用commit比对模式
if [ $ORIGIN != $TARGET ]
then
  # 抓取版本
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
      VERSION=$(trim $VERSION)
      break
    fi
  done < package.json
  
  # 输出文件路径，默认“v版本.md”
  OUTPUT="${OUTPUT_DIR}/v${VERSION}.md"
  
  shouldFouceResolve
  
  GIT_PAGER=$(git -C "${REPO}" log "$TARGET..$ORIGIN" --no-merges --reverse --format="${LOG_FORMAT}")
  (
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
              # 移除空格
              s=$(trim $s)
              # 动态数组变量赋值
              eval COMMIT_${type}='(${COMMIT_'${type}'[*]} $s)'
              break
            fi
          done
        fi
      done
      
      if [ $PRINT_TIME -eq 1 ]
      then
        echo "> ${UNTIL}\n"
      fi
      
      # 处理数据
      typeIndex=0
      for type in ${TYPE_MAP[@]}
      do
        # 拷贝数组
        eval type='(${COMMIT_'${type}'[*]})'
        
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
      echo "${DIFF}版本无差异"
    fi
  ) > $OUTPUT
else
  shouldFouceResolve
  
  (
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
fi
# | less -R

echo "Log has been written to '${OUTPUT}'"
