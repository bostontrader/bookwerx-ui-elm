const path = require('path')

module.exports = {
  mode: 'development',
  entry: {app: ['./index.js']},

  output: {
    path: path.join(__dirname, '/dist'),
    filename: 'webpack.js'
  },

  module: {
    rules: [
      {
        test: /\.(css|scss|sass)$/,
        use: [
          'style-loader',
          'css-loader'
        ]
      },
      {
        test: /\.html$/,
        exclude: /node_modules/,
        loader: 'file-loader?name=[name].[ext]'
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: 'elm-webpack-loader?verbose=true&warn=true',
        options: {
          cwd: path.join(__dirname, '/elm')
        }
      }
    ]
  }
}
