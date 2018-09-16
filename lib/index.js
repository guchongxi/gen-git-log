const program = require('commander');
const updateNotifier = require('update-notifier');
const pkg = require('../package.json');

// 版本更新提示
// 默认一天提醒一次
updateNotifier({ pkg })
  .notify({ defer: false });

program
  .version(pkg.version)
  .usage('<command> [options]');

program
  .command('create')
  .alias('c')
  .description('生成 log 文件')
  .option('-f, --force', '强制构建，不校验是否已生成日志文件')
  .option('--work-dir [dir]', '工作目录，默认为当前目录')
  .action((options) => {
    require('./git')(options);
  });

program.parse(process.argv);

if (!program.args.length) {
  program.help();
}
