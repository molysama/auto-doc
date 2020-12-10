# 网页模块

`webview`可以加载网页，因此可以使用`html`来构建 UI。此模块提供了`html`的加载和通信功能。

## 安装

```bash
# 先安装依赖模块core
npm i "@auto.pro/core" -S

# 安装webview模块
npm i "@auto.pro/webview" -S

```

## 使用示例

`webview`模块通信的本质是拦截和修改`html`的`prompt`事件。

```html
<script>
    // assets/index.html

    function parse(param) {
        return JSON.stringify(param)
    }

    document.documentElement.onclick = function () {
        // prompt只能传递字符串，在传递任何参数前都要统一做parse处理
        var result = prompt("hello", parse("world"))
        console.log("get result: " + result)
    }
</script>
```

```javascript
// src/index.js

import core, { effect$ } from "@auto.pro/core"
import { run } from "@auto.pro/webview"

core()

// html文件地址，既可以用线上，也可以用本地
// const HTML_PATH = 'http://www.moly.host:30030/'
const HTML_PATH = "file://" + files.path("assets/index.html")

const webview = run(HTML_PATH)

// hello对应html里prompt的第一个值
webview.on("hello").subscribe(([param, done]) => {
    // html发送prompt事件后可以接受返回值，返回值由done传递回去
    // done必须执行一次，如果不想给返回值可以直接done()
    done("这是一个返回值")

    toastLog("auto收到了html的hello事件，值是" + param)
})
```

上面代码演示了`html`主动向`auto`发送事件，下面将由`auto`主动触发`html`。

```html
<script>
    // assets/index.html

    window.show = function (username, password) {
        console.log("user is: " + username)
        console.log("password is: " + password)
        return "success"
    }
</script>
```

```javascript
// src/index.js

import core, { effect$ } from "@auto.pro/core"
import { run } from "@auto.pro/webview"

core()

// html文件地址，既可以用线上，也可以用本地
// const HTML_PATH = 'http://www.moly.host:30030/'
const HTML_PATH = "file://" + files.path("assets/index.html")

const webview = run(HTML_PATH)

// 直接执行一段JS语句
webview.runHtmlJS("document.title").subscribe((value) => {
    toastLog(`html的标题是：${value}`)
})

// 执行html的show函数，并传递两个参数
webview.runHtmlFunction("show", "molysama", "123456").subscribe((value) => {
    toastLog(`执行show的结果是：${value}`)
})
```

## API

-   run: function(path: string, option?: object)

    -   path: `string` html 地址
    -   option: `object` 自定义参数

        -   xmlString: `string` ui 布局
        -   webviewId: `string` ui 布局中 webview 的 id，设置自定义 ui 布局时必填
        -   chromeClientOption: `object` 自定义 WebChromeClient 的事件，它的常用事件有

            -   onCreateWindow  
                打开新窗口时的回调

            -   onCloseWindow  
                关闭窗口时的回调

            -   onJsAlert  
                监听 alert

            -   onJsConfirm  
                监听 confirm

            -   onJsPrompt  
                监听 prompt(本模块通过这个事件来通信)

            -   onProgressChanged  
                网页的加载进度改变时的回调

        -   webviewClientOption: `object` 自定义 WebViewClient 的事件，它的常用事件有

            -   onPagestarted  
                网页开始加载时的回调

            -   onPageFinished  
                网页加载结束的回调

            -   shouldOverrideUrlLoading  
                拦截 url 跳转

            -   onReceivedError  
                错误回调

            -   onReceivedSslError  
                https 错误回调

        -   afterLayout: `Function` 有时要紧跟着布局做系统初始化，可以放在这个函数里

-   run 执行成功后得到一个对象，它的属性和方法如下

    -   webviewObject: `android.webkit.WebView`  
        安卓的`Webview`对象

    -   on: `function (eventName: string): Observable<[any, Function]>`  
        监听 html 的`eventName`事件，返回一个可观察对象，详细用法见上方示例。

    -   runHtmlFunction: `function (fnName: string, ...value): Observable<any>`  
        执行`html`的`fnName`方法，详细用法见上方示例。

    -   runHtmlJS: `function(js: string): Observable`  
        执行一行`html`的`javascript`代码，详细用法见上方示例。
