module.exports = function(config) {
  config.set({
    basePath: "",
    frameworks: ["jasmine"],
    files: [
      "lib/jquery/jquery.min.js",
      "lib/angularjs/angular.min.js",
      "lib/angularjs/angular-mocks.js",
      "bin/script.js",
      "spec/**/*.coffee"
    ],
    reporters: ["progress"],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ["PhantomJS"],
    captureTimeout: 60000,
    singleRun: false
  });
};

