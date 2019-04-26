var stream = require('stream')

exports.mkTransform = function (opts) {
  return function() {
    var newTrans = new stream.Transform(opts);
    newTrans._transform = function (data,enc,callback) {
      var tSelf = this;
      opts._transform(data)(enc)(function(pdata){
        return function(){
          tSelf.push(pdata)
        }
      })(function(e){
        return function() {
          callback(e == null ? null : new Error(e))
        }
      })()
    }
    if(opts._flush != null) {
      newTrans._flush = function (callback) {
        var tSelf = this;
         opts._flush(function(pdata) {
           return function() {
             tSelf.push(pdata)
           }
         })(function(e){
          return function() {
            callback(e == null ? null : new Error(e))
          }
        })()
      }
    }
    return newTrans;
  }
}