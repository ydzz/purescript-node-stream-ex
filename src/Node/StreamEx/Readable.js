var stream = require('stream')

exports.jsDestroy = function (obj) {
    return function(errString) {
      return function() {
         obj.destroy(new Error(errString));
      }
    }
}

exports.jsIsPaused = function (obj) {
   return function() {
     return obj.isPaused();
   }
}

exports.jsPause = function (obj) {
  return function() {
    return obj.pause();
  }
}

exports.jsPipe = function (obj) {
  return function (dest) {
    return function (isEnd) {
      return function() {
        return obj.pipe(dest,{end:isEnd})
      }
    }
  }
}

exports.jsRead = function (obj) {
  return function(number) {
    return function() {
      return obj.read(number);
    }
  }
}

exports.jsReadable = function (obj) {
  return function() {
    return obj.readable;
  }
}

exports.jsReadableHighWaterMark = function (obj) {
  return function() {
    return obj.readableHighWaterMark;
  }
}

exports.jsReadableLength = function (obj) {
  return function() {
    return obj.readableLength;
  }
}

exports.jsResume = function (obj) {
  return function() {
    return obj.resume();
  }
}

exports.jsSetEncoding = function (obj) {
  return function(encoding) {
    return function() {
      return obj.setEncoding(encoding);
    }
  }
}

exports.jsUnpipe = function (obj) {
  return function(dest) {
    return function() {
      return obj.unpipe(dest)
    }
  }
}

exports.jsUnshift = function (obj) {
  return function (chunk) {
    return function() {
      return obj.unshift(chunk)
    }
  }
}

exports.jsOnClose = function (obj) {
  return function(callback) {
    return function () {
      return obj.on("close",callback);
    }
  }
}

exports.jsOnData = function (obj) {
  return function (callback) {
    return function(){
      return obj.on("data",function(data) {
        return callback(data)()
      });
    }
  }
}

exports.jsOnEnd = function (obj) {
  return function(callback) {
    return function () {
      obj.on("end",callback);
    }
  }
}

exports.jsOnError = function (obj) {
  return function(callback) {
    return function(){
      obj.on("error",function(e){
        callback(e.toString())()
      });
    }
  }
}

exports.jsOnReadable = function (obj) {
  return function(callback) {
    return function () {
      obj.on("readable",callback);
    }
  }
}

exports.mkReadable = function (opts) {
　return function () {
    opts.read = function (n) {
      var self = this;
      opts._read(n)(function(data) {
        return function () { self.push(data);}
      })()
    }
    if(opts._destroy != null) {
      opts.destroy = function(err,callback) {
        opts._destroy(err)(callback)()
      }
    }
    var newReadable = new stream.Readable(opts);
    return newReadable;
  }
}