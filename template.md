## 模板说明

auto 本身是基于`Rhino`引擎来执行 JS 的，部分 es6 语法特性跑不起来。  
为了能用上新语法特性来写 Auto 程序，需要在运行前进行预编译，这也就是本项目的主要目的。  
如果你还不是很熟悉 es6 语法，可以看看[阮一峰的简易教程](http://es6.ruanyifeng.com/)。  
模板提供了预设配置来处理 JS，大多数情况下不需要修改这些模板配置，但有必要了解一下相关配置项。

以下是默认模板的配置文件：

### webpack.config.js

```javascript
const path = require("path")

// JS混淆插件
const JavascriptObfuscator = require("webpack-obfuscator")
// Auto兼容插件
const AutoProWebpackPlugin = require("@auto.pro/webpack-plugin")
// JS编译文件分析插件
const BundleAnalyzerPlugin = require("webpack-bundle-analyzer")
    .BundleAnalyzerPlugin
const { CleanWebpackPlugin } = require("clean-webpack-plugin")

const dictionary = []
for (let i = 1024; i < 2048; i++) {
    dictionary.push(i.toString(2).replace(/1/g, "ν").replace(/0/g, "v"))
}

// 将指定文件设成ui模式
const compilePlugin = new AutoProWebpackPlugin({
    ui: ["app"],
})

const config = {
    entry: {
        app: "./src/index.js",
    },
    output: {
        filename: "[name].js",
        path: path.resolve(__dirname, "dist"),
        libraryTarget: "var",
        // libraryTarget: "commonjs2"
    },
    target: "node",
    module: {
        rules: [
            {
                test: /\.ts$/,
                exclude: /node_modules/,
                use: ["ts-loader", "@auto.pro/webpack-loader"],
            },
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: ["babel-loader", "@auto.pro/webpack-loader"],
            },
            {
                test: /\.(png|svg|jpg|gif)$/,
                use: {
                    loader: "url-loader",
                },
            },
        ],
    },
    resolve: {
        extensions: [".js", ".ts", ".json"],
        alias: {
            "@": path.resolve(__dirname, "src"),
        },
    },
}

module.exports = (env, argv) => {
    // 开发环境
    if (argv.mode === "development") {
        config.plugins = [
            new CleanWebpackPlugin(),
            new BundleAnalyzerPlugin(),
            compilePlugin,
        ]
        config.devtool = "source-map"

        // 生产环境
    } else {
        config.plugins = [
            new CleanWebpackPlugin(),
            new JavascriptObfuscator({
                compact: true,
                identifierNamesGenerator: "dictionary",
                identifiersDictionary: dictionary,
                // 生成的代码环境，可选browser、browser-no-eval、node
                target: "browser-no-eval",
                // 混淆对象键名
                transformObjectKeys: false,
                // 将字符串明文转义为Unicode，会大大增加体积，还原也比较容易，建议只对小文件使用
                unicodeEscapeSequence: false,
            }),
            compilePlugin,
        ]
    }

    return config
}
```

## 配置项说明

### 入口和出口

entry 指定了入口和出口，键代表出口文件名，值代表入口路径。  
以本配置为例：

```javascript
const config = {
    entry: {
        app: "./src/index.js",
    },
}
```

-   `./src/index.js`就是入口路径，代表我们要使用`src`目录的`index.js`作为根文件
-   `app`就是出口，会在编译结束后生成一个`app.js`文件

### UI 模式

auto 对于 UI 模式需要在文件头部加上`"ui";`标识，在插件的`ui`数组里添加对应出口名即可自动处理

```javascript
const compilePlugin = new AutoProWebpackPlugin({
    ui: ["app"],
})
```

插件的详细情况请看[这里](/modules/webpack-plugin)

### 输出模式

webpack 提供了多种文件输出模式，你可以根据自己的情况进行配置。

-   `var`（大多数场景）  
    我们需要直接以项目方式运行，或直接以单个脚本方式运行，此时`output.libraryTarget`使用默认的`var`即可。

-   `commonjs2`（制作模块）  
    有时候我们想把功能抽离成模块，以便复用，让其他 JS 文件能 require 或 import 这个模块，比如

```javascript
// main.js
var m = require("打包出来的模块.js")
```

则需要将`output.libraryTarget`设置成`commonjs2`。
