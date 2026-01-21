const { merge } = require("webpack-merge");
const singleSpaDefaults = require("webpack-config-single-spa-react-ts");
const { DefinePlugin } = require("webpack");

module.exports = (webpackConfigEnv, argv) => {
  const defaultConfig = singleSpaDefaults({
    orgName: "project",
    projectName: "react",
    webpackConfigEnv,
    argv,
    outputSystemJS: true,
  });


  if (defaultConfig.mode === "production") {
    require("dotenv").config({ path: ".env.production" });
  } else {
    require("dotenv").config();
  }

  return merge(defaultConfig, {
    // modify the webpack config however you'd like to by adding to this object
    plugins: [
      new DefinePlugin({
        "process.env.API_URL": JSON.stringify(process.env.API_URL),
      })
    ]
  });
};
