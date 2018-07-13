#  用宏定义 
            
     #ifdef DEBUG
     #import "Test.h"
     #endif
     或
     #ifdef DEBUG
            测试代码
     #endif
        #
#  以拖曳的方式添加的动态库和静态库 
        在 Targets - Build Settings - Search Paths 中分别设置 Library Search Paths 和 Framework Search Paths
        下在Release模式下删除
#  CocoaPods引入的第三方测试库
        在podfile中直接配置configurations在debug下生效  
        Example: pod 'FLEX', '2.4.5', :configurations => ['Debug']  
