var gitRemoteOriginUrl = require('git-remote-origin-url');
var gitRevSync = require('git-rev-sync');
var getRepoInfo = require('git-repo-info');
var { getFullDate, getLastMonday, handleGitRes } = require('./utils');
const simpleGitModule = require('simple-git');

const defaultOptions = {
  cwd: process.cwd()
}
const commitHandler = (data) => {
  const { subject, author, commit } = data;

  console.log('\ncommit 信息', commit);
  console.log('\ncommit 标题', subject);
  console.log('\ncommit 作者', author);
}

module.exports = async (options = {}) => {
  options = {
    ...defaultOptions,
    ...options
  }
  const { cwd } = options;
  const git = simpleGitModule(cwd);
  const url = await gitRemoteOriginUrl(cwd);
  const repoInfo = getRepoInfo();

  console.log('\nrepo信息', repoInfo);
  console.log('\n远程地址', url);
  console.log('\n最近短hash', gitRevSync.short(cwd));
  console.log('\n最近长hash', gitRevSync.long(cwd));
  console.log('\n当前branch', gitRevSync.branch(cwd));
  commits.forEach(commitHandler);
  git.tags(handleGitRes(({ all, latest }) => console.log(latest, all)));
  git.raw(['log', '--no-merges', '--format=%% %s ([%h](${REMOTE}/commit/%H)) <%an>'], handleGitRes(data => {
    dataArr = data.split('%').map(item => item.trim()).filter(item => !!item);
    console.log(dataArr);
  }));
}