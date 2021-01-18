# 网页模块

`webview`可以加载网页，因此可以使用`html`来构建 UI。此模块提供了`html`的加载和通信功能。

## 安装

```bash
# auto端需要安装core包和webview包
npm i "@auto.pro/core" "@auto.pro/webview" -S

# html端需要安装web包
npm i "@auto.pro/web" -S

```

如果 html 没有使用模块加载机制，可以直接复制出`@auto.pro/web`包里的`src/index.js`来直接使用。

## 使用示例

```html
<!-- assets/index.html -->

<!-- web.js为@auto.pro/web包的src/index.js，可直接从node_modules文件夹里找到 -->
<script src="web.js">
    <script>

        function fn () {
            alert('fn')
        }

        document.documentElement.onclick = function () {
            // 触发auto的test通信事件，传递参数为123，不使用第三个参数时，html会等待auto的结果
            const result = AutoWeb.auto('test', 123)

            // 触发auto的test通信事件，传递参数为123，并指定为异步响应，异步响应可以接收到多个参数
            AutoWeb.auto('test', 123, function (param1, param2, ...paramN) {
                // auto端执行done后，将会执行此函数
            })

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

webview.on("test").subscribe(([param, done]) => {
    // 返回值由done传递回去
    // done必须且仅能执行一次，如果不想给返回值可以直接done()
    // 当html部分的AutoWeb.auto使用第三个参数时，done将异步返回结果
    done("这是一个返回值")

    toastLog("auto收到了html的test事件，值是" + param)
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

    // 将一个函数设置成auto可调用的类型
    // 与上面的window.show等价，devicelly是为了便于在组件化前端框架中调用组件函数
    AutoWeb.devicelly("show", function (username, password) {})
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

@auto.pro/webview

-   run: function(path: string, option?: object)

    -   path: `string` html 地址
    -   option: `object` 自定义参数

        -   xmlString: `string` ui 布局
        -   webviewId: `string` ui 布局中 webview 的 id，设置自定义 ui 布局时必填
        -   webviewObject: 可以自主传入 webview 对象，此时将不会创建新布局
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
        监听 html 的`eventName`事件，返回一个可观察对象，用法见上方示例。

    -   runHtmlFunction: `function (fnName: string, ...value): Observable<any>`  
        执行`html`的`fnName`方法，详细用法见上方示例。

    -   runHtmlJS: `function(js: string): Observable`  
        执行一行`html`的`javascript`代码，用法见上方示例。

`runHtmlFunction`和`runHtmlJS`返回的都是`RxJS`的可观察对象，[这里是一些基本用法](/example/ob)。

@auto.pro/web

-   setMode: function (mode: string)  
    为了方便调试，可将模式设置成打印类型
    mode: 'prompt' | 'console.log'

-   auto: function(eventName: string, params?: any, callback?: Function)  
     html 向 auto 主动发出通信事件
    -   eventName: 要触发的 auto 通信事件
    -   params: 要传递的参数
    -   callback: auto 返回结果后的回调，使用此参数时整个通信将变为异步
-   devicelly: function(fnName: string, fn: function, self: any, once?: boolean)  
     设置一个可供 auto 执行的函数
    -   fnName: 绑定到 window 上的函数名
    -   fn: 要绑定的函数
    -   self: 可自定义 fn 的指针
    -   once: 此函数是否只能执行一次，默认为 false 可一直执行。
-   removeDevicelly: function(fnName: string)  
     移除绑定的函数
    -   fnName: 要移除的函数名
