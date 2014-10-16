window.echo = function(str, callback) {
    cordova.exec(callback, function(err) {
        callback('Nothing to echo.');
    }, "Echo", "echo", [str]);
};

window.initCast = function(callback) {
    cordova.exec(callback, function(err) {
                 callback('Error');
                 }, "Echo", "initCast", []);
}