//
// Include files
//
var exec = require('child_process').execSync;
var fs = require('fs');
var gulp = require('gulp');
var plus = require('./gulp-plus.js');
var readline = require('readline-sync');

//
// Global variables
//
var strLocalRoot = '../config/'; // root of project
var strRemoteRoot = '/'; // remote folder

//
// task keygen - generate ssh and copy key to ipaddr
//  for each ipaddr:
//    (1) generate ssh key
//    (2) copy key to ipaddr
//
gulp.task('keygen', done => {
  //
  //--- Assert sshpath is defined in ssh/config.json
  //
  console.log('Reading config.json file..');
  strFile = strLocalRoot + 'config.json';
  var jsnFile = plus.readJson(strFile);
  if (jsnFile.sshpath === undefined) {
    console.log('Error: config sshpath is undefined');
    return done();
  }

  //
  //--- Assert create Identity file if doesn't exist
  //
  var strInput = readline.question(
    'Please enter file in which to save the key (e.g. id_rsa_xx):'
  );
  var strIdFile = jsnFile.sshpath + strInput;
  if (fs.existsSync(strIdFile)) {
    console.log('Error: The Identity file already exists.');
  } else {
    console.log('Creating Identity file..');
    var strOutput = exec('ssh-keygen -f ' + strIdFile).toString();
    console.log(strOutput);
    var strConfigFile = jsnFile.sshpath + 'config';
    fs.appendFileSync(strConfigFile, 'IdentityFile ' + strIdFile + '\n');
  }

  //
  //--- Assert hostfile exists and contains at least one IP address
  //
  console.log('Reading hostfile..');
  var strFile = strLocalRoot + 'hostfile.txt';
  var strLines = plus.lines(strFile);
  var strIPaddr = [];
  strLines.forEach(function(line) {
    if (plus.isIPaddr(line)) strIPaddr.push(line);
  });
  if (strIPaddr.length === 0) {
    console.log('Error: hostfile IPaddr is undefined.');
    return done();
  }

  if (readline.keyInYNStrict('Upload Identity file?') === false)
    //
    //--- Assert upload Identity file to server
    //
    return done();

  strIPaddr.forEach(function(ip) {
    var strOutput = exec(
      'ssh-copy-id -f -i ' + strIdFile + ' root@' + ip
    ).toString();
    console.log(strOutput);
  });
  done();
});

//
// task mkswap - login to ipaddr via ssh and execute mkswap bash script
//  for each ipaddr:
//    (1) login to ipaddr via ssh
//    (2) copy mkswap bash script to ipaddr
//    (3) run mkswap bash script
//
