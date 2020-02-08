//
// Include files
//
var fs = require('fs');
var gulp = require('gulp');
var tap = require('gulp-tap');

module.exports = {
  //
  // function lines() reads a text file and returns an array of lines
  //
  lines: function(strFile) {
    var strText = fs.readFileSync(strFile, 'utf8');
    return strText.split('\n');
  },
  isIPaddr: function(ipaddress) {
    if (
      /^(([1-9]?\d|1\d\d|2[0-5][0-5]|2[0-4]\d)\.){3}([1-9]?\d|1\d\d|2[0-5][0-5]|2[0-4]\d)$/gm.test(
        ipaddress
      )
    ) {
      return true;
    }
    return false;
  },
  //
  // function json() reads a json file and returns a JSON object
  //
  readJson: function(strFile) {
    return JSON.parse(fs.readFileSync(strFile));
  }
};
