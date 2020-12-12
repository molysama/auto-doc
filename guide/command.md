## 命令行说明

auto-cli 命令行工具提供了以下功能

-   `auto-cli create [projectName]`  
    创建一个名为`projectName`的项目，可选择默认模板或 html 模板。html 模板适用的 Pro 版本为 Auto.Pro <= 7.0.4-0 或 Auto.pro >= 8.0.3。

-   `auto-cli dex [filename]`  
    将一个 js 文件转换成 dex。  
    如果 JS 中存在中文，直接转换成 dex 会导致乱码，这时候可以先将 JS 文件编码设置成`UTF-8 with BOM`，具体操作为：

    1. 选择 vscode 编辑器右下方的`UTF-8`标签
    2. 选择`通过编码保存`
    3. 选择`UTF-8 with BOM`

-   `auto-cli doc`  
     查看相关文档资源地址。
