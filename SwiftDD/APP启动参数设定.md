# 代码调试
## XCode中Argument/Options模块设置启动参数，这些设定只有从Xcode中启动时才会起作用
### 设置启动时的语言 AppleLanguages (zh-Hans)
###  测试双倍文字时，UI是否显示正确 -NSDoubleLocalizedStrings YES
###  本地化时，查看那些字符串没有被本地化 -NSShowNonLocalizedStrings YES
## XCode中Environment Variable模块设置环境变量，应用任何时候都能起作用
      DYLD_PRINT_STATISTICS
      DYLD_PRINT_STATISTICS_DETAILS
      NSZombieEnabled YES  对象释放后，内存仍然被占用，调用会引起Crash,通常用户检测EXC_BAD_Access
      MallocStackLogging   记录下来内存分配的调用栈
      MallocScribble 对于释放的内存，每个Byte填充成0x55，能够提高野指针的crash率
      MallocGuard   调试的时候会使用libgmalloc替换malloc，从而在当内存出现错误的时候，及时crash你的App
      DYLD_INSERT_LIBRARIES /usr/lib/libgmalloc.dylib  开启MallocGuard
      
      读取设置的环境变量
      NSDictionary * environments = [[NSProcessInfo processInfo] environment];
      BOOL logOn = [[environments objectForKey:@"Network_Log_Enabled"] isEqualToString:@"YES"];

      查看APP的启动时间
      DYLD_PRINT_STATISTICS和DYLD_PRINT_STATISTICS_DETAILS   
