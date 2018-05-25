var timestampOfDay = 1000 * 60 * 60 * 24;

/**
 * 格式化日期 (2016-02-14)
 * @param {Date} targetDate
 */
const getFullDate = (targetDate) => {
  var now = new Date();

  var fullYear = now.getFullYear();
  var month = now.getMonth() + 1; // getMonth 方法返回 0-11，代表1-12月
  var date = now.getDate();
  var D, y, m, d;
  if (targetDate) {
    D = new Date(targetDate);
    y = D.getFullYear();
    m = D.getMonth() + 1;
    d = D.getDate();
  } else {
    y = fullYear;
    m = month;
    d = date;
  }
  m = m > 9 ? m : '0' + m;
  d = d > 9 ? d : '0' + d;

  return y + '-' + m + '-' + d;
}

const getLastMonday = () => {
  const now = new Date();

  return getFullDate(now.getTime() - (now.getDay() - 1) * timestampOfDay)
};

const handleGitRes = (cb) => {
  return (error, ...args) => {
    if (error) {
      console.error('simpleGitError', error);
    } else {
      cb(...args);
    }
  }
}
module.exports = {
  getFullDate,
  getLastMonday,
  handleGitRes
}