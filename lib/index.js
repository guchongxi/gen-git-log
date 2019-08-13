const program = require('commander');
const pkg = require('../package.json');

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
