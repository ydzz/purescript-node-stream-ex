var stream = require('stream')

exports.newPassThrough = function () {
    return new stream.PassThrough();
}