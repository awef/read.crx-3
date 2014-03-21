module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: [
      "lib/jquery/jquery.min.js",
      "lib/angularjs/angular.min.js",
      "bin/script.js",
      "lib/angularjs/angular-mocks.js",
      "spec/**/*.coffee"
    ],
    preprocessors: {
      '**/*.coffee': ['coffee']
    },
    coffeePreprocessor: {
      options: {
        sourceMap: true
      }
    },
    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,
    browsers: ['Chrome', 'Firefox'],
    singleRun: false
  });
};
