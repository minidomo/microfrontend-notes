const singleSpaAngularWebpack = require('single-spa-angular/lib/webpack').default;

module.exports = (config, options) => {
  const singleSpaWebpackConfig = singleSpaAngularWebpack(config, options);

  if (!Array.isArray(singleSpaWebpackConfig.externals)) {
    singleSpaWebpackConfig.externals = [];
  }
  singleSpaWebpackConfig.externals.push('single-spa');

  // Feel free to modify this webpack config however you'd like to
  return singleSpaWebpackConfig;
};
