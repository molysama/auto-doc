# webpack 插件

此插件能让 webpack 添加 UI 模式，并可自动进行 AES 加密。

## 安装

```bash
npm i @auto.pro/webpack-plugin
```

## UI 模式

```javascript
// webpack.config.js

const AutoProWebpackPlugin = require('@auto.pro/webpack-plugin')

module.exports = {
    entry: {
        app: '../src/index.js'
    },
    plugins: [
        new AutoProWebpackPlugin({
            // 将entry的app设置成UI模式
            ui: ['app']
        }),
        ...
    ],
    ...
}
```

## AES 加密

插件还提供了 AES 加密功能，使用的加密参数是`AES/ECB/PKCS7padding`，解密时也应该用对应参数。

```javascript
// webpack.config.js

const AutoProWebpackPlugin = require('@auto.pro/webpack-plugin')

module.exports = {
    entry: {
        app: '../src/index.js'
    },
    plugins: [
        new AutoProWebpackPlugin({
            // 将entry的app设置成UI模式
            ui: ['app'],
            encode: {
                // AES的key
                key: 'SecretPassphrase'
            }
        }),
        ...
    ],
    ...
}

```

```javascript
// 在auto里解密AES文件并运行
const source = $crypto.decrypt(
    files.read("dist/app.js", "utf8"),
    new $crypto.Key("SecretPassphrase"), // 对应encode的key
    "AES/ECB/PKCS7padding",
    {
        input: "base64",
        output: "string",
    }
)
files.write("dist/main.js", source)
engines.execScriptFile("dist/main.js")
```
