var stream = require('stream')

exports.mkDuplex = function (opts) {
   return function() {
     var newDuplex = new stream.Duplex(opts);
     if(opts._read != null) {
       newDuplex._read = function (n) {
         var self = this;
         opts._read(n)(function(data) {
           return function () { self.push(data,'ascii');}
         })()
       }
     }
     if(opts._write != null) {
      newDuplex._write = function(data,enc,callback) {
        opts._write(data)(enc)(function(e){
          return function() {
            callback(e == null ? null : new Error(e))
          }
        })();
      }
     }
     return newDuplex;
   }
}