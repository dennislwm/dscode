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
var strRootConfig = '../config/';

console.log('Reading ssh.conf file..');
var jsnFile = plus.readJson(strRootConfig + 'ssh.conf');
var strId = jsnFile.sshpath + jsnFile.sshid;
var strConfig = jsnFile.sshpath + jsnFile.sshconfig;

//
// Step (1):  Create a droplet at digitalocean.com
// Step (2):  Login to console at digitalocean.com to change root password
// Step (3):  local $ssh
// Step (4):  Update hostfile.txt with droplet IP
// Step (5):  $npm run sshkeygen
//              - local: $ssh-keygen
//              - local: $wsl ssh-copy-id
// Step (6):  $npm run sshmkswap
//              - local: $cd ..
//              - local: $scp
//              - remote: $chmod 700 mkswap.sh
//              - remote: $bin/mkswap.sh
// Step (7): $npm run sshinstall
//              - local: $cd ..
//              - local: $scp
//              - remote: $snap install docker
//              - remote: $cd docker-couchdb
//              - remote: $docker-compose up -d
//              - local: $curl -s http://104.248.234.155:8080
//

//
// task keygen - generate ssh and copy key to ipaddr
//  for each ipaddr:
//    (1) generate ssh key
//    (2) copy key to ipaddr
//
gulp.task('sshkeygen', done => {
  //
  //--- Assert sshpath is defined in config/ssh.conf
  //
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
  strIPaddr = plus.hosts(strRootConfig + 'hostfile.txt');
  if (strIPaddr.length === 0) {
    console.log('Error: hostfile.txt IPaddr is undefined.');
    return done();
  }

  if (readline.keyInYNStrict('Upload Identity file?') === false)
    //
    //--- Assert upload Identity file to server
    //
    return done();

  var strIdFileWsl = jsnFile.sshpathwsl + strInput;
  strIPaddr.forEach(function (ip) {
    var strOutput = exec(
      'wsl ssh-copy-id -f -i ' + strIdFileWsl + ' root@' + ip
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

gulp.task('sshmkswap', done => {
  strIPaddr = plus.hosts(strRootConfig + 'hostfile.txt');
  if (strIPaddr.length === 0) {
    console.log('Error: hostfile.txt IPaddr is undefined.');
    return done();
  }
  strIPaddr.forEach(function (ip) {
    //
    // scp folder bin to cloud
    //
    plus.shScp(
      plus.strDoubleBackslash(strConfig),
      plus.strDoubleBackslash(strId),
      ip,
      'bin',
      ''
    );

    /*
    var strExec =
      'cd .. && scp -F ' +
      strConfig +
      ' -i ' +
      strId +
      ' -r bin root@' +
      ip +
      ':/root/';
    console.log(strExec);
    var strOutput = exec(strExec).toString();
    console.log(strOutput);
    */

    plus.sshExec(['chmod 700 bin/mkswap.sh', 'bin/mkswap.sh'], {
      host: ip,
      username: 'root',
      privateKey: fs.readFileSync(strId)
    });
  });
  done();
});

gulp.task('sshinstall', done => {
  strIPaddr = plus.hosts(strRootConfig + 'hostfile.txt');
  if (strIPaddr.length === 0) {
    console.log('Error: hostfile.txt IPaddr is undefined.');
    return done();
  }
  strIPaddr.forEach(function (ip) {
    plus.sshExec(['snap install docker', 'docker-compose -v'], {
      host: ip,
      username: 'root',
      privateKey: fs.readFileSync(strId)
    });
  });
  console.log('*** Remote system restart required ***');
  done();
});

gulp.task('sshdocker', done => {
  strIPaddr = plus.hosts(strRootConfig + 'hostfile.txt');
  if (strIPaddr.length === 0) {
    console.log('Error: hostfile.txt IPaddr is undefined.');
    return done();
  }
  strIPaddr.forEach(function (ip) {
    //
    // scp folder bin to cloud
    //
    plus.shScp(
      plus.strDoubleBackslash(strConfig),
      plus.strDoubleBackslash(strId),
      ip,
      'docker-commento',
      'docker-commento'
    );

    plus.sshExec(['cd docker-commento', 'docker-compose up -d'], {
      host: ip,
      username: 'root',
      privateKey: fs.readFileSync(strId)
    });
  });
  done();
});
