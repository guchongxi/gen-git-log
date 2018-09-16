const simpleGitModule = require('simple-git');
const gitRemoteOriginUrl = require('git-remote-origin-url');
const gitRevSync = require('git-rev-sync');
const getRepoInfo = require('git-repo-info');
const fs = require('fs');
const { getFullDate, getLastMonday, handleGitRes } = require('./utils');

module.exports = async (options = {}) => {
  const {
    workDir = process.cwd(),
    force = false
  } = options;

  const git = simpleGitModule(workDir);
  // 获取项目远程地址
  let url = await gitRemoteOriginUrl(workDir);

  // url 是 git 开头则认为是 git协议，需要转为 https 协议
  if (url.startsWith('git')) {
    url = url
      .replace(':', '/')
      .replace('git@', 'https://');
  }

  /**
   * 获取最新 tag
   */
  const getLatestTag = () => {
    return new Promise((resolve, reject) => {
      git.tags((err, { latest } = {}) => {
        if (err) {
          reject(err);
        } else {
          resolve(latest);
        }
      });
    });
  };

  const getLogStr = () => {
    return new Promise(async (resolve, reject) => {
      git.raw(['log', '--no-merges', `--format=%% %s ([%h](${url}/commit/%H)) <%an>`, `HEAD...${await getLatestTag()}`], (err, data = '') => {
        if (err) {
          reject(err);
        } else {
          const output = data
            .split('%')
            .map(item => item.trim())
            .filter(item => !!item)
            .join('\n');

          resolve(output);
        }
      });
    });
  };

  const data = await getLogStr();

  // fs.writeFile(`./log/v${require('../package.json').version}.log`, data);

  // const repoInfo = getRepoInfo();

  // console.log('\nrepo信息', repoInfo);
  // console.log('\n远程地址', url);
  // console.log('\n最近短hash', gitRevSync.short(workDir));
  // console.log('\n最近长hash', gitRevSync.long(workDir));
  // console.log('\n当前branch', gitRevSync.branch(workDir));


};