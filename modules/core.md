# 核心模块

模板是无代码依赖的，此核心模块是实践 auto 后设计的框架核心，非必须。

auto 应用有以下特点：

-   可以有多线程
-   在 UI 线程里不允许阻塞型代码，如`sleep`、`http`
-   不同线程共享变量很可能导致 bug
-   有些事件和函数要求运行在同一个线程下
-   申请权限后常常需要等待一段时间才生效
-   图片资源需要手动回收，不方便写图色脚本

基于这些特性设计了`@auto.pro`框架，核心思想为：

-   核心包`core`，用来处理权限的申请、脚本的初始化，并提供常用属性和方法给其他模块使用
-   core 设计了一个作业线程`effect$`，非 UI 线程的操作都可以在这个作业线程下进行，避免了开启多个线程。
-   以插件包的形式提供网页、悬浮窗等模块，便于快速开发

## 安装

```bash
npm i "@auto.pro/core" -S
```

## 使用

```javascript
// src/index.js

import core from "@auto.pro/core"

core()
```

上面代码不请求任何权限，只是简单的初始化。  
core 可以接受一些参数，示例如下

```javascript
// src/index.js

import core from "@auto.pro/core"

core({
    baseWidth: 1920,
    baseHeight: 1080,
    needCap: true,
    needService: true,
    needFloaty: true,
    needForeground: true,
    needStableMode: true,
})
```

-   baseWidth: `boolean`  
    编写脚本时的横向分辨率，默认为 1280

-   baseHeight: `boolean`  
    编写脚本时的纵向分辨率，默认为 720

-   needCap: `true`（等同于'自动'） | `false` | `'横屏'` | `'竖屏'` | `'自动'`  
    是否申请**异步截屏**权限，以及截屏的类型，默认为 `false`

-   needService: `boolean`  
    是否申请无障碍服务权限

-   needFloaty: `boolean`  
    是否需要悬浮窗权限

## 作业线程 effect$

`core` 提供了一个作业线程，初始化完毕后会推送一次事件。

```javascript
// src/index.js

import core, { effect$ } from "@auto.pro/core"

core()

// core初始化完毕后，subscribe内的函数才会开始执行
effect$.subscribe(() => {
    toastLog("初始化完毕")
})

// 可以多次订阅
effect$.subscribe(() => {
    toastLog("第二次订阅")
})

// effect$会传递两个参数，分别是作业线程本身，以及作业线程的事件对象
effect$.subscribe(([effectThread, effectEvent]) => {
    toastLog(effectThread)
})

// 这段代码是在effect$之外的，它不会等待core的权限
toastLog("hello,world")
```
