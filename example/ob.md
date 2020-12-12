# 可观察对象

本项目在很多地方使用了`RxJS`，这里是一些基本用法。

## Promise 化

如果不想使用`RxJS`特性，可以直接使用`toPromise()`将其转换成`Promise`对象。

```javascript
// src/index.js

import core, { effect$ } from "@auto.pro/core"

core()

// rxjs用法
effcet$.subscribe(() => {
    toastLog("权限已到位")
})

// promise用法1
effcet$.toPromise().then(() => {
    toastLog("权限已到位")
})

// promise用法2
async function demo() {
    await effect$.toPromise()
    toastLog("权限已到位")
}
```

## Observable

`RxJS`属于流式编程，简单来说就是`subscribe`就行了！不简单来说的话，篇幅不够。

```javascript
import core from "@auto.pro/core"
import { run } from "@auto.pro/webview"
import { repeat } from "rxjs/operators"

core()

const wv = run("http://www.baidu.com")

setTimeout(() => {
    // 取一次title的值
    wv.runHtmlJS("document.title").subscribe((val) => {
        toastLog("title: " + val)
    })

    // 取title的值，并重复三次
    wv.runHtmlJS("document.title")
        .pipe(repeat(3))
        .subscribe((val) => {
            console.log(val)
        })
}, 2000)
```

## RxJS 参考资料

-   [RxJS 教程](https://rxjs-cn.github.io/learn-rxjs-operators/)
-   [RxJS 操作符文档](https://rxjs.dev/api)
-   [RxJS 可拖动交互的数据流图示](https://rxmarbles.com/#combineLatest)
