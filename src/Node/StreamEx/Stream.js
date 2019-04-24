//var concatStream = require('concat-stream')
exports.jscork = function (obj) {
    return function () {
      obj.cork();
    }
}

exports.jsdestroy = function (obj) {
    return function(errString) {
      return function() {
         obj.destroy(new Error(errString));
      }
    }
}

exports.jsend = function (obj) {
  return function(chunk) { 
      return function (encoding) {
         return function (callback) {
             obj.end(chunk,encoding,callback);
         }
      }
  }
}

exports.jssetDefaultEncoding = function (obj) {
  return function(encoding) {
    return function() {
    　　obj.setDefaultEncoding(encoding);
    } 
  }
}

exports.jsuncork = function (obj) {
  return function () {
      obj.uncork();
  }
}

exports.jswritable = function(obj) {
  return function () {
     return obj.writable;
  }
}