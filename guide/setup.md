## 安装 node 环境

由于都是 npm 包，需要安装 node 环境，下载地址

-   [nodejs 官网](https://nodejs.org/en/)
-   [阿里源下载](https://npm.taobao.org/mirrors/node/)

建议安装 12LTS 版本，太新的可能会出现 bug。下载 msi 包后一直下一步即可，不需要额外配置。
安装成功后可在终端输入`node -v`查看版本号，如果没输出可能是需要重启终端。

## 安装 nrm 加速工具（可选）

npm 官方在国外，直接安装多少有点慢，nrm 是个方便的镜像源工具

```bash
# 安装nrm工具包
npm i -g nrm

# 查看镜像源列表
nrm ls

# 将npm切换到淘宝源
nrm use taobao
```

安装成功后在终端输入`nrm`判断是否安装成功，没输出可能是需要重启终端

## 安装 cli 工具包

```bash
npm i -g "@auto.pro/cli"
```

安装成功后在终端输入`auto-cli -h`判断是否安装成功，没输出可能是需要重启终端。
`auto-cli`是一个命令行工具，能帮助你下载模板和查看其他资源

## 安装 git

git 是一个强大的版本管理工具，下载模板也需要使用到它，同时能方便地同步最新模板。

-   [下载地址](https://git-scm.com/)

## 安装 vscode 路径提示插件（可选）

1. 安装 vscode 插件 `Path Intellisense`，要安装 `1.4.2` 版本的，新版本有 bug
2. 选择 vscode 左上角的`文件` -> `首选项` -> `设置` -> 输入 `Path Intellisense` -> `在 setting.json 中编辑`
3. 添加一个配置项

```javascript
"path-intellisense.mappings": {
    "@": "${workspaceRoot}/src",
    "assets": "${workspaceRoot}/assets"
}
```

配置成功后，vscode 会将`@`符号识别为`src`目录

## 安装 Auto 的 vscode 插件

-   Pro 用户可在 vscode 里搜索安装 Auto 作者提供的`Auto.js-Pro-Ext`
-   非 Pro 用户可搜索安装`Auto.js-VSCodeExt-Fixed`，此版本对旧版插件进行了一些完善
