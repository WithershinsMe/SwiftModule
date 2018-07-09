#  加载动态库

## 静态库 .a   链接时会被复制到可执行文件中  由目标文件组成 
## 动态库 .dll , .dylib, so  链接时不复制，程序运行后用dyld加载  没有main函数的可执行文件

## Framework是一种资源打包方式，包括代码，头文件和资源文件

## 编译： 源代码文件编译为目标文件
## 链接： 目标文件加上第三方库和系统库链接为可执行文件

### 静态库的资源最终都会打包到main bundle中
### 动态库的资源会被存放在Framework中

### @import  导入一个modul,不需要在project setting中手动添加framework,系统自动加载，效率高
### Tips:
### header search path一般指定非递归，递归的寻找头文件会影响效率


###
http://www.cocoachina.com/ios/20170427/19136.html
https://www.zybuluo.com/qidiandasheng/note/603907

