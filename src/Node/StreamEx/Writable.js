var stream = require('stream')

exports.jsCork = function (obj) {
    return function () {
      obj.cork();
    }
}

exports.jsDestroy = function (obj) {
    return function(errString) {
      return function() {
         obj.destroy(errString == null ? null : new Error(errString));
      }
    }
}

exports.jsEnd = function (obj) {
  return function(chunk) { 
      return function (encoding) {
         return function (callback) {
           　return function () {
               return obj.end(chunk,encoding,callback);
             }
         }
      }
  }
}

exports.jsSetDefaultEncoding = function (obj) {
  return function(encoding) {
    return function() {
    　　obj.setDefaultEncoding(encoding);
    } 
  }
}

exports.jsUncork = function (obj) {
  return function () {
      obj.uncork();
  }
}

exports.jsWritable = function(obj) {
  return function () {
     return obj.writable;
  }
}

exports.jsWritableHighWaterMark = function (obj) {
  return function () {
    return obj.writableHighWaterMark;
  }
}

exports.jsWritableLength = function (obj) {
  return function () {
    return obj.writableLength;
  }
}

exports.jsWrite = function (obj) {
  return function(chunk) { 
      return function (encoding) {
         return function (callback) {
           return function () {
            return obj.write(chunk,encoding,callback);
           }
         }
      }
  }
}

exports.jsOnClose = function (obj) {
  return function(callback) {
    return function() {
      return obj.on("close",callback);
    } 
  }
}

exports.jsOnDrain = function (obj) {
  return function(callback) {
    return function() {
      return obj.on("drain",callback);
    } 
  }
}

exports.jsOnError = function (obj) {
  return function(callback) {
    return function() {
      return obj.on("error", function(e) {
        callback(e.toString())()
      });
    }
  }
}

exports.jsOnFinish = function (obj) {
  return function(callback) {
    return function() {
      return obj.on("finish",callback);
    }
  }
}

exports.jsOnPipe = function (obj) {
  return function(callback) {
    return function() {
      return obj.on("pipe",function(r) {
        callback(r)()
      } );
    }
  }
}

exports.jsOnUnpipe = function (obj) {
  return function(callback) {
    return function() {
      return obj.on("unpipe",function(r) {
        callback(r)()
      });
    }
  }
}

exports.mkWritable = function (opts) {
   return function () {
     if(opts._destory != null) {
       opts.destroy = function (err,callback) {
         opts._destory(err)(callback)()
       }
     }
     if(opts._final != null) {
       opts.final = function (callback) {
        opts._final(function(e){
          return function(){
            callback(e == null ? null : new Error(e))
          }
        })()
       }
     }

     var newStream = new stream.Writable(opts);
     newStream._write = function (data,enc,callback) {
      opts._write(data)(enc)(function(e){
        return function() {
          callback(e == null ? null : new Error(e))
        }
      })();
     }
     
     return newStream;
   }
}
