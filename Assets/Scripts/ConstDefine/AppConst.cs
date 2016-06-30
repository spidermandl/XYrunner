﻿using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;

namespace SimpleFramework {
    public class AppConst {
        public const bool DebugMode = false;                        //调试模式-用于内部测试

        /// <summary>
        /// 如果想删掉框架自带的例子，那这个例子模式必须要
        /// 关闭，否则会出现一些错误。
        /// </summary>
        public const bool ExampleMode = true;                       //例子模式 
		public static string luaRootPath = Application.isMobilePlatform?"lua/":"" ; //"" pc路径;//"lua/";真机路径 //lua 代码根路径

        /// <summary>
        /// 如果开启更新模式，前提必须启动框架自带服务器端。
        /// 否则就需要自己将StreamingAssets里面的所有内容
        /// 复制到自己的Webserver上面，并修改下面的WebUrl。
        /// </summary>
        public const bool UpdateMode = false;                       //更新模式-默认关闭 
        public const bool AutoWrapMode = true;                      //自动添加Wrap模式

        public const bool UsePbc = true;                           //PBC
        public const bool UseLpeg = true;                          //lpeg
        public const bool UsePbLua = true;                         //Protobuff-lua-gen
        public const bool UseCJson = true;                         //CJson
        public const bool UseSproto = true;                        //Sproto
        public const bool LuaEncode = false;                        //使用LUA编码

        public const int TimerInterval = 1;
        public const int GameFrameRate = 30;                       //游戏帧频

        public const string AppName = "SimpleFramework";           //应用程序名称
        public const string AppPrefix = AppName + "_";             //应用程序前缀
        public const string WebUrl = "http://localhost:6688/";      //测试更新地址

        public static string UserId = string.Empty;                 //用户ID
		public const bool UseAssetBundle = false;					//使用AssetBundle
		public const bool isPBencrypted = false;					//使用pb encrytion
		public const string AssetBundleName = "AssetBundles";
        public static int SocketPort = 0;                           //Socket服务器端口
        public static string SocketAddress = string.Empty;          //Socket服务器地址

        public static string LuaBasePath {
            get { return Application.dataPath + "/uLua/Source/"; }
        }

        public static string LuaWrapPath {
            get { return LuaBasePath + "LuaWrap/"; }
        }
    }
}