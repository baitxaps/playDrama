目录结构：
1.  Main，这是程序的入口，包括 AppDelegate 和 Main.Storyboard。
2.  Section, 这里放各个相对独立的业务模块相关的代码，比如登陆模块、设置页面等。
3.  General，这里放一些通用的、可以在各个业务模块之间复用的代码。
比如一些 Category, Class 以及一些基本控件等。
4.  Helper，这里放得是一些辅助类，可以把一些Manager放在这里。
5.  Model，这是模型类。可以把用到的基本模型类放在这里，比如User 模型类，Setting 模型类等。
6.  Macro，这个目录主要放一些宏，并且再细分为 AppMacro, UtilMacro, VendorMacro等。
7.  Vendor，这个目录是用来放一些第三方库或者其他的支持库的，并且这里存放的是一些和工程依赖比较严重的库，
如果依赖不重，可以考虑使用 cocoapods 来管理。
8.  Lua，  这个目录比较特殊，由于我在工程中使用了 Lua 技术，所以把 Lua 文件单独放在这里管理。
9.  Resource， 这是资源目录，具体又包括 Image 和 Sound 两个细分目录，存放用到的图片和音频资源。

Podfile 管理
pod 'SDWebImage', '~> 3.7.1'
pod 'AFNetworking', '~> 2.4.1'
pod "Reachability"

//SDWebImage内部实现过程
http://www.cocoachina.com/ios/20141212/10622.html
