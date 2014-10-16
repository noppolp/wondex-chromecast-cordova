var chromecast = {};

chromecast.echo = function(str, callback) {
    cordova.exec(callback, function(err) {
        callback('Nothing to echo.');
    }, "Echo", "echo", [str]);
};

chromecast.initCast = function(receiverAppId, callback, error) {
    cordova.exec(callback, error, "Echo", "initCast", [receiverAppId]);
};

chromecast.getDevices = function(callback, error){
    cordova.exec(callback, error, "Echo", "getDevices", []);
};

chromecast.selectDevice = function(deviceId, callback, error){
    cordova.exec(callback, error, "Echo", "selectDevice", [deviceId]);
};