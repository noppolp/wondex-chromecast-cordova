var chromecast = {};

chromecast.echo = function(str, callback) {
    cordova.exec(callback, function(err) {
        callback('Nothing to echo.');
    }, "Echo", "echo", [str]);
};

chromecast.initCast = function(callback, error) {
    cordova.exec(callback, error, "Echo", "initCast", []);
}

chromecast.getDevices = function(callback, error){
    cordova.exec(callback, error, "Echo", "getDevices", []);
}