const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
  entry: './js/ex_effective_bootstrap.js',
  target: 'web',
  output: {
    filename: 'ex_effective_bootstrap.js',
    path: path.resolve(__dirname, '../priv/static'),
    library: 'ExEffectiveBootstrap',
    libraryTarget: 'umd',
    globalObject: 'this'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader'
        }
      },
      {
        test: /\.s?css$/,
        use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader']
      }
    ]
  },
  plugins: [
    new MiniCssExtractPlugin({ filename: 'ex_effective_bootstrap.css' }),
  ]
}
