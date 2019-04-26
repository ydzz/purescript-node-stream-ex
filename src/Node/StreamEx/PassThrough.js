var stream = require('stream')

exports.mkPassThrough = function () {
    return new stream.PassThrough();
}