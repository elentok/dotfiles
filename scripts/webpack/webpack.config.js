const path = require("path")
const webpack = require("webpack")
const autoprefixer = require("autoprefixer")
const ExtractTextPlugin = require("extract-text-webpack-plugin")
const HtmlWebpackPlugin = require("html-webpack-plugin")

const env = process.env.NODE_ENV || "development"

let jsFilename = "[name].js"
let cssFilename = "[name].css"

if (env === "production") {
  jsFilename = "[name]-[hash].js"
  cssFilename = "[name]-[contenthash].css"
}

const config = {
  entry: {
    app: path.resolve(__dirname, "src/index.js"),
  },

  output: {
    filename: jsFilename,
    publicPath: process.env.ASSETS_PATH,
    path: path.join(__dirname, "dist/assets"),
  },

  resolve: {
    extensions: [".js", ".pug", ".css", ".scss", ".yml", ".yaml"],
    modules: [
      path.join(__dirname, "src"),
      path.join(__dirname, "../node_modules")],
  },

  module: {
    rules: [
      // babel
      {
        test: /\.js$/,
        exclude: /node_modules\/underscore/,
        use: [{
          loader: "babel-loader",
          options: {
            presets: ["es2015"],
            plugins: ["transform-object-assign"],
          }
        }]
      },

      // fonts
      {
        test: /\.(eot|svg|ttf|woff(2)?)(\?v=\d+\.\d+\.\d+)?/,
        use: "file-loader?name=[name]-[hash].[ext]",
      },

      // images, pug and yaml
      { test: /\.(png|jpg)$/, use: "file-loader?name=[name]-[hash].[ext]", },
      { test: /\.pug$/, use: "pug-loader" },
      { test: /\.ya?ml$/, use: "yml-loader" },

      // css
      {
        test: /\.s?css$/,
        use: ExtractTextPlugin.extract({
          fallback: "style-loader",
          use: ["css-loader", "sass-loader", {
            loader: "postcss-loader",
            options: {
              plugins: [autoprefixer({ browsers: ["last 2 versions"] })],
            }
          }]
        }),
      },
    ]
  },

  plugins: [
    new ExtractTextPlugin({ filename: cssFilename }),
    new webpack.ProvidePlugin({
      "fetch":
        "imports-loader?this=>global!exports-loader?global.fetch!whatwg-fetch",
      "Promise":
        "imports-loader?this=>global!exports-loader?global.Promise!es6-promise",
    }),
    new HtmlWebpackPlugin({
      template: path.join(__dirname, "src/index.pug"),
      filename: "../index.html"
    }),
  ],
}

switch (env) {
case "development":
  Object.assign(config, {
    devtool: "sourcemap",
    devServer: {
      port: 8081,
    }
  })
  break

case "test":
  Object.assign(config, { devtool: "sourcemap" })
  break

case "production":
  config.plugins.push(new webpack.optimize.UglifyJsPlugin())
  break
}

module.exports = config
