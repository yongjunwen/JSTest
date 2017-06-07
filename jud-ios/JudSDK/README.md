# JudSDK使用指南

## 概述

JudSDK 是一套简单易用的跨平台开发方案，能以 web 的开发体验构建高性能、可扩展的 native 应用。为了做到这些，JudSDK 与 Vue 合作，使用 Vue 作为上层框架，并遵循 W3C 标准实现了统一的 JSEngine 和 DOM API，这样一来，你甚至可以使用其他框架驱动 JudSDK，打造三端一致的 native 应用。

## 操作步骤
1. 使用 JudSDK_MTL Target进行Build
2. 在编译完成后，会自动打开Product文件夹，直接使用里面的JudSDK.framework 即可。
3. 目前支持的架构为：arm64、armv7、i386、x86_64
4. 引入JudSDK.framework到工程后，还需要添加以下库依赖:  

> AVKit.framework  
> JavaScriptcORE.framework  
> AVFoundation.framework  
> MediaPlayer.framework  
> CoreMedia.framework  
> ImageIO.framework  
> GLKit.framework  
> libstdc++.tbd  

5. 然后#import <JudSDK/JudSDK.h> 即可使用JudSDK所有的功能


## 更多支持

请联系 程剑锋(chengjianfeng，673302055@163.com)
