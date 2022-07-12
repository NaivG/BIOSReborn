# 项目原名：BIOS
SimpleMultiBatchSystemLoader

将在八月份上线

# NOTICE
新版，好耶
---

# 这是什么（What is this）

BatchSL是我个人编写的通用bat系统启动器，相较于bat系统自带的启动器，它有许多新的功能，例如：

BatchSL is a generic bat system launcher written by me personally. Compared with the launcher that comes with the bat system, it has many new features, such as:

    多系统引导，支持本地和网络启动，具体参照 boot.ini
    Multi-system boot, support local and network boot, refer to boot.ini for details
    稳定引导，在失败后能弹出错误码以分析
    Stable boot, able to pop up error codes for analysis after failure
    *NEW
    - 检测并修复设置
    - 简单易用的多语言支持
    - 自动获取UAC权限
    - 记忆强制运行的选择
    - 修正程序运行位置
    - 首次运行时可自动配置
      (已知BUG:第三方SleepX.exe在win11的旧版控制台中会闪退)
    - 实时DEBUG（正在完善）

# Q&A

Q：如何导入系统？

   How do I import the system?

A：在网上寻找现成的bat系统，下载并打包成zip格式压缩包，确保bat系统启动文件在压缩包根目录，在压缩包内新建 boot 文件夹，在 boot 文件夹内新建 BIOS 文件夹。新建一个文本文档，拷贝以下代码：

   Find a ready-made bat system on the Internet, download and pack it into a zip archive, make sure the bat system boot file is in the root directory of the archive, create a new boot folder inside the archive, and a new BIOS folder inside the boot folder. Create a new text document and copy the following code.

    @echo off & cd X:\ & call [bat系统启动文件的名称(Name of the system boot file)].bat或cmd

保存退出，名称改为 system.boot 。把 boot 文件放入在压缩包的 BIOS 文件夹内，退出，把压缩包后缀名改为.img。打开 boot.ini ，按如下帮助修改引导项并将压缩包复制进BIOS启动器根目录。

Save and exit, change the name to system.boot. Put the boot file in the BIOS folder of the zip archive, exit, and change the zip archive extension to .img. Open boot.ini, modify the boot entries as described below and copy the zip archive into the BIOS bootloader root directory.

    n -- 默认引导项(Default boot items)
    [数字(number like)123] -- 引导项名称(Name of boot item)
    type[数字(number like)123]a -- 引导项类型，img为本地img引导，network为网络img引导(Boot item type, "img" for local img boot, "network" for network img boot)
    img[数字(number like)123]b -- 本地引导img名称(不带后缀名)(Local boot img name (without suffix))
    address[数字(number like)123]b -- 网络引导img地址(类似www.xxx.com/xxx.img)(Network boot img address (similar to www.xxx.com/xxx.img))

Q：我使用过后电脑多出一个X盘是怎么回事？

   What's wrong with an extra X drive on my computer after I've used it?

A：这是正常引导创建的虚拟磁盘，再打开一下BIOS启动器就消失了。

   This is the virtual disk created by normal boot, open the BIOS again and it disappears.

Q：我的电脑不支持怎么办？

   What if my computer doesn't support it?

A：可以尝试强制运行，win7以上的系统如果边框错位的话右键cmd窗口，找到属性，里面会有个使用旧版控制台，把它勾上。

   You can try to force to run, win7 above the system if the border is misplaced right click cmd window, find properties, there will be a use of the old version of the console, check it.
