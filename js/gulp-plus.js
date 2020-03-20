//
// Include files
//
var exec = require('child_process').execSync;
var fs = require('fs');
var SSH = require('ssh2-promise').Client;

module.exports = {
  //
  // function lines() reads a text file and returns an array of lines
  //
  lines: function (strFile) {
    var strText = fs.readFileSync(strFile, 'utf8');
    return strText.split('\n');
  },
  isIPaddr: function (ipaddress) {
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
  // function hosts() reads a text file and returns an array of hosts (if any)
  //
  hosts: function (strFile) {
    //
    //--- Assert hostfile exists and contains at least one IP address
    //
    var strLines = module.exports.lines(strFile);
    var strIPaddr = [];
    strLines.forEach(function (line) {
      if (module.exports.isIPaddr(line))
        strIPaddr.push(line.replace('\r', '').replace('\n', ''));
    });
    return strIPaddr;
  },
  //
  // function readJson() reads a json file and returns a JSON object
  //
  readJson: function (strFile) {
    return JSON.parse(fs.readFileSync(strFile));
  },
  //
  // replace all backslash to double backslash
  //
  strDoubleBackslash: function (str) {
    return str.split(String.fromCharCode(92)).join(String.fromCharCode(92, 92));
  },
  //
  // copies folder from host to remote
  //
  shScp: function (strConfig, strId, strIp, strHostDir, strRmteDir = '') {
    // strHostDir should not contain any slashes
    var strExec =
      'cd .. && scp -F ' +
      strConfig +
      ' -i ' +
      strId +
      ' -r ' +
      strHostDir +
      ' root@' +
      strIp +
      ':/root/' +
      strRmteDir;
    console.log(strExec);
    var strOutput = exec(strExec).toString();
    console.log(strOutput);
  },
  //
  // executes multiple SSH commands from an array of string in remote
  //
  sshExec: function (strCmd, jsnConn) {
    var ssh = new SSH(jsnConn);
    strCmd.forEach(function (cmd) {
      //use spawn if you want to stream an output
      ssh.exec(cmd).then((stdout) => {
        console.log(cmd + ': ' + stdout);
      })
    });
  }
};
