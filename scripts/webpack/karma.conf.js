process.env.NODE_ENV = 'test'
const webpackConfig = require('./webpack.config.js')

module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['jasmine'],
    files: ['test/index.js'],
    exclude: [],
    preprocessors: {
      'test/index.js': ['webpack']
    },
    webpack: webpackConfig,
    reporters: ['progress'],
    port: 9876,
    colors: true,
    logLevel: config.LOG_INFO, // LOG_DISABLE, LOG_ERROR, LOG_WARN, LOG_DEBUG
    autoWatch: true,
    browsers: ['PhantomJS'],
    singleRun: false,
    concurrency: Infinity
  })
}
