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