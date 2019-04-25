const fs = require('fs');

exports.createWriteStream = function(path){
    return function() {
      return fs.createWriteStream(path,{encoding:'utf8'});
    }
}