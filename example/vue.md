# 以 Vue 作为界面

1. 新建一份默认模板项目

```bash

# 通过auto-cli命令创建项目
auto-cli create auto-vue-example

# 选择默认模板

# 使用vscode打开auto-vue-example文件夹

# 安装依赖
npm i

# 安装webview需要的模块
npm i "@auto.pro/webview" -S

```

2. 在`assets`文件夹里新建一个 index.html 文件，从 Vant 中复制一个示例内容：

```html
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Document</title>
        <!-- 引入样式文件 -->
        <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/vant@2.11/lib/index.css"
        />

        <!-- 引入 Vue 和 Vant 的 JS 文件 -->
        <script src="https://cdn.jsdelivr.net/npm/vue@2.6/dist/vue.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/vant@2.11/lib/vant.min.js"></script>
    </head>

    <body>
        <div id="app"></div>

        <script>
            // 在 #app 标签下渲染一个按钮组件
            new Vue({
                el: "#app",
                template: `<van-button @click="clickBtn" >按钮</van-button>`,
                mounted() {
                    window.fn = function () {
                        return "fn is running..."
                    }
                },
                methods: {
                    clickBtn() {
                        const result = prompt(
                            "btn",
                            JSON.stringify("hello,world")
                        )
                        alert(result)
                    },
                },
            })
        </script>
    </body>
</html>
```

3. 通过 webview 加载 html 文件

```javascript
// src/index.js

// 导入core包
import core from "@auto.pro/core"
// 导入webview模块的run函数
import { run } from "@auto.pro/webview"

core()

const HTML_PATH = "file://" + files.path("dist/index.html")

const wv = run(HTML_PATH)

wv.on("btn").subscribe(([param, done]) => {
    // done必须要执行一次，用作事件响应
    // 这里done直接返回一个字符串
    done(`成功接受到btn事件，传值为${param}`)
})
```

4. 编译文件

```bash
npm start
```

5. 以项目的方式运行、打包文件

## 以 vue-cli 的方式构建 UI 页面

使用 vue-cli 创建 UI 项目时，通过 http 来加载则无需任何修改。  
如果要通过 file 来加载本地 html，则要做相关配置：

```javascript
// vue.config.js

module.exports = {
    publicPath: "./",
    runtimeCompiler: true,
}
```
