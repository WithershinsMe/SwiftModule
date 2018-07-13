#  Framework静态库优化
## Generate Debug Symbols to NO   减少静态库30%的体积
## Optimization Level下的Release Fastest,Smallest[-Os]
## Dead Code Stripping为YES,去掉冗余代码即代码被定义但未被使用.
## Deployment Postprocessing 为YES, 打开Strip优化


##用@_exported import DependencyA导入当前module引用的module, @_exported表示仅需导入module一次，就可以用module的任何文件
