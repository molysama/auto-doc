# webpack 加载器

如果直接在 webpack 中使用 xml 布局，会被误认为是 jsx，导致报错。
解决的办法是使用``符号将 xml 包起来，如：

```javascript
// 未经过处理的xml代码，会报错
ui.layout(<frame h="{{height}}">...</frame>)
```

```javascript
// 使用``将xml包起来，并将{{}}转换成JS变量，不会报错
ui.layout(`
    <frame h="${height}">
        ...
    </frame>
`)
```

代码多的时候修改会比较麻烦，此模块能让你免于手动处理。

## 安装

```bash
npm i "@auto.pro/webpack-loader" -D
```

## 使用

```javascript
// webpack.config.js
module.exports = {
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
            ...
        ],
    },
    ...
}
```
