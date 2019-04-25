const fs = require('fs');

exports.createWriteStream = function(path){
    return function() {
      return fs.createWriteStream(path,{encoding:'utf8'});
    }
}

exports.createReadStream = function(path){
  return function() {
    return fs.createReadStream(path,{encoding:'utf8'});
  }
}

exports.jslog = function(a) {
  return function(){
    console.log(a);
  }
}