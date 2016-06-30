﻿using UnityEngine;
using System;
using System.IO;
using System.Text;
using System.Collections;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Reflection;
using LuaInterface;
using SimpleFramework.Manager;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace SimpleFramework {
    public class Util {
        private static List<string> luaPaths = new List<string>();

        public static int Int(object o) {
            return Convert.ToInt32(o);
        }

        public static float Float(object o) {
            return (float)Math.Round(Convert.ToSingle(o), 2);
        }

        public static long Long(object o) {
            return Convert.ToInt64(o);
        }

        public static int Random(int min, int max) {
            return UnityEngine.Random.Range(min, max);
        }

        public static float Random(float min, float max) {
            return UnityEngine.Random.Range(min, max);
        }

        public static string Uid(string uid) {
            int position = uid.LastIndexOf('_');
            return uid.Remove(0, position + 1);
        }

        public static long GetTime() {
            TimeSpan ts = new TimeSpan(DateTime.UtcNow.Ticks - new DateTime(1970, 1, 1, 0, 0, 0).Ticks);
            return (long)ts.TotalMilliseconds;
        }

        /// <summary>
        /// 搜索子物体组件-GameObject版
        /// </summary>
        public static T Get<T>(GameObject go, string subnode) where T : Component {
            if (go != null) {
                Transform sub = go.transform.FindChild(subnode);
                if (sub != null) return sub.GetComponent<T>();
            }
            return null;
        }

        /// <summary>
        /// 搜索子物体组件-Transform版
        /// </summary>
        public static T Get<T>(Transform go, string subnode) where T : Component {
            if (go != null) {
                Transform sub = go.FindChild(subnode);
                if (sub != null) return sub.GetComponent<T>();
            }
            return null;
        }

        /// <summary>
        /// 搜索子物体组件-Component版
        /// </summary>
        public static T Get<T>(Component go, string subnode) where T : Component {
            return go.transform.FindChild(subnode).GetComponent<T>();
        }

        /// <summary>
        /// 添加组件
        /// </summary>
        public static T Add<T>(GameObject go) where T : Component {
            if (go != null) {
                T[] ts = go.GetComponents<T>();
                for (int i = 0; i < ts.Length; i++) {
                    if (ts[i] != null) GameObject.Destroy(ts[i]);
                }
                return go.gameObject.AddComponent<T>();
            }
            return null;
        }

        /// <summary>
        /// 添加组件
        /// </summary>
        public static T Add<T>(Transform go) where T : Component {
            return Add<T>(go.gameObject);
        }

        /// <summary>
        /// 查找子对象
        /// </summary>
        public static GameObject Child(GameObject go, string subnode) {
            return Child(go.transform, subnode);
        }

        /// <summary>
        /// 查找子对象
        /// </summary>
        public static GameObject Child(Transform go, string subnode) {
            Transform tran = go.FindChild(subnode);
            if (tran == null) return null;
            return tran.gameObject;
        }

        /// <summary>
        /// 取平级对象
        /// </summary>
        public static GameObject Peer(GameObject go, string subnode) {
            return Peer(go.transform, subnode);
        }

        /// <summary>
        /// 取平级对象
        /// </summary>
        public static GameObject Peer(Transform go, string subnode) {
            Transform tran = go.parent.FindChild(subnode);
            if (tran == null) return null;
            return tran.gameObject;
        }

        /// <summary>
        /// 手机震动
        /// </summary>
        public static void Vibrate() {
            //int canVibrate = PlayerPrefs.GetInt(Const.AppPrefix + "Vibrate", 1);
            //if (canVibrate == 1) iPhoneUtils.Vibrate();
        }

        /// <summary>
        /// Base64编码
        /// </summary>
        public static string Encode(string message) {
            byte[] bytes = Encoding.GetEncoding("utf-8").GetBytes(message);
            return Convert.ToBase64String(bytes);
        }

        /// <summary>
        /// Base64解码
        /// </summary>
        public static string Decode(string message) {
            byte[] bytes = Convert.FromBase64String(message);
            return Encoding.GetEncoding("utf-8").GetString(bytes);
        }

        /// <summary>
        /// 判断数字
        /// </summary>
        public static bool IsNumeric(string str) {
            if (str == null || str.Length == 0) return false;
            for (int i = 0; i < str.Length; i++) {
                if (!Char.IsNumber(str[i])) { return false; }
            }
            return true;
        }

        /// <summary>
        /// HashToMD5Hex
        /// </summary>
        public static string HashToMD5Hex(string sourceStr) {
            byte[] Bytes = Encoding.UTF8.GetBytes(sourceStr);
            using (MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider()) {
                byte[] result = md5.ComputeHash(Bytes);
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < result.Length; i++)
                    builder.Append(result[i].ToString("x2"));
                return builder.ToString();
            }
        }

        /// <summary>
        /// 计算字符串的MD5值
        /// </summary>
        public static string md5(string source) {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            byte[] data = System.Text.Encoding.UTF8.GetBytes(source);
            byte[] md5Data = md5.ComputeHash(data, 0, data.Length);
            md5.Clear();

            string destString = "";
            for (int i = 0; i < md5Data.Length; i++) {
                destString += System.Convert.ToString(md5Data[i], 16).PadLeft(2, '0');
            }
            destString = destString.PadLeft(32, '0');
            return destString;
        }

        /// <summary>
        /// 计算文件的MD5值
        /// </summary>
        public static string md5file(string file) {
            try {
                FileStream fs = new FileStream(file, FileMode.Open);
                System.Security.Cryptography.MD5 md5 = new System.Security.Cryptography.MD5CryptoServiceProvider();
                byte[] retVal = md5.ComputeHash(fs);
                fs.Close();

                StringBuilder sb = new StringBuilder();
                for (int i = 0; i < retVal.Length; i++) {
                    sb.Append(retVal[i].ToString("x2"));
                }
                return sb.ToString();
            } catch (Exception ex) {
                throw new Exception("md5file() fail, error:" + ex.Message);
            }
        }

        /// <summary>
        /// 清除所有子节点
        /// </summary>
        public static void ClearChild(Transform go) {
            if (go == null) return;
            for (int i = go.childCount - 1; i >= 0; i--) {
                GameObject.Destroy(go.GetChild(i).gameObject);
            }
        }

        /// <summary>
        /// 生成一个Key名
        /// </summary>
        public static string GetKey(string key) {
            return AppConst.AppPrefix + AppConst.UserId + "_" + key;
        }

        /// <summary>
        /// 取得整型
        /// </summary>
        public static int GetInt(string key) {
            string name = GetKey(key);
            return PlayerPrefs.GetInt(name);
        }

        /// <summary>
        /// 有没有值
        /// </summary>
        public static bool HasKey(string key) {
            string name = GetKey(key);
            return PlayerPrefs.HasKey(name);
        }

        /// <summary>
        /// 保存整型
        /// </summary>
        public static void SetInt(string key, int value) {
            string name = GetKey(key);
            PlayerPrefs.DeleteKey(name);
            PlayerPrefs.SetInt(name, value);
        }

        /// <summary>
        /// 取得数据
        /// </summary>
        public static string GetString(string key) {
            string name = GetKey(key);
            return PlayerPrefs.GetString(name);
        }

        /// <summary>
        /// 保存数据
        /// </summary>
        public static void SetString(string key, string value) {
            string name = GetKey(key);
            PlayerPrefs.DeleteKey(name);
            PlayerPrefs.SetString(name, value);
        }

        /// <summary>
        /// 删除数据
        /// </summary>
        public static void RemoveData(string key) {
            string name = GetKey(key);
            PlayerPrefs.DeleteKey(name);
        }

        /// <summary>
        /// 清理内存
        /// </summary>
        public static void ClearMemory() {
            GC.Collect(); Resources.UnloadUnusedAssets();
            LuaScriptMgr mgr = AppFacade.Instance.GetManager<LuaScriptMgr>(ManagerName.Lua);
            if (mgr != null && mgr.lua != null) mgr.LuaGC();
        }

		//release memory
		public static void releaseMemory(){
			ResourceManager resourceMgr = AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
			resourceMgr.releaseMemory ();
		}

        /// <summary>
        /// 是否为数字
        /// </summary>
        public static bool IsNumber(string strNumber) {
            Regex regex = new Regex("[^0-9]");
            return !regex.IsMatch(strNumber);
        }

        /// <summary>
        /// 取得数据存放目录
        /// </summary>
        public static string DataPath {
            get {
                string game = AppConst.AppName.ToLower();
                if (Application.isMobilePlatform) {
                    return Application.persistentDataPath + "/" + game + "/";
                }
                if (Application.platform == RuntimePlatform.WindowsPlayer) {
                    return Application.streamingAssetsPath + "/";
                }
                if (AppConst.DebugMode) {
                    if (Application.isEditor) {
                        return Application.dataPath + "/StreamingAssets/";
                    }
                }
				return //Application.dataPath + "/StreamingAssets/lua/";
					Application.dataPath + "/Lua/"; //pc runtime evn
				//"/Users/osondesmond/Documents/macRunner/";//mac export package
            }
        }

		/// <summary>
		/// AssetBundle存放目录
		/// </summary>
		public static string AssetBundlePath {
			get {
				if (Application.isMobilePlatform) {
					return DataPath + AppConst.AssetBundleName + "/";
				}
				if (Application.platform == RuntimePlatform.WindowsPlayer) {
					return DataPath + AppConst.AssetBundleName + "/";
				}
				if (AppConst.DebugMode) {
					if (Application.isEditor) {
						return Application.dataPath + "/StreamingAssets/" + AppConst.AssetBundleName + "/";
					}
				}
				return Application.dataPath + "/StreamingAssets/" + AppConst.AssetBundleName + "/";
			}
		}

		/// <summary>
		/// AssetBundle存放目录
		/// </summary>
		public static string PlatformName {
			get {
				switch(Application.platform){
				case RuntimePlatform.Android:
					return "android";
				case RuntimePlatform.IPhonePlayer:
					return "ios";
				default:
					return "android";
				}
			}
		}

		/// <summary>
		/// 取得行文本
		/// </summary>
		public static string GetFileText(string path) {
			return File.ReadAllText(path);
		}
		
		/// <summary>
		/// 网络可用
		/// </summary>
		public static bool NetAvailable {
            get {
                return Application.internetReachability != NetworkReachability.NotReachable;
            }
        }

        /// <summary>
        /// 是否是无线
        /// </summary>
        public static bool IsWifi {
            get {
                return Application.internetReachability == NetworkReachability.ReachableViaLocalAreaNetwork;
            }
        }

        /// <summary>
        /// 应用程序内容路径
        /// </summary>
        public static string AppContentPath() {
            string path = string.Empty;
            switch (Application.platform) {
                case RuntimePlatform.Android:
                    path = "jar:file://" + Application.dataPath + "!/assets/";
                break;
                case RuntimePlatform.IPhonePlayer:
                    path = Application.dataPath + "/Raw/";
                break;
                default:
                    path = Application.dataPath + "/StreamingAssets/";
                break;
            }
            return path;
        }

        /// <summary>
        /// 添加lua单机事件
        /// </summary>
        public static void AddClick(GameObject go, System.Object luafuc) {
            UIEventListener.Get(go).onClick += delegate(GameObject o) {
                LuaInterface.LuaFunction func = (LuaInterface.LuaFunction)luafuc;
                func.Call();
            };
        }

        /// <summary>
        /// 是否是登录场景
        /// </summary>
        public static bool isLogin {
            get { return Application.loadedLevelName.CompareTo("login") == 0; }
        }

        /// <summary>
        /// 是否是城镇场景
        /// </summary>
        public static bool isMain {
            get { return Application.loadedLevelName.CompareTo("main") == 0; }
        }

        /// <summary>
        /// 判断是否是战斗场景
        /// </summary>
        public static bool isFight {
            get { return Application.loadedLevelName.CompareTo("fight") == 0; }
        }

        /// <summary>
        /// 取得Lua路径
        /// </summary>
        public static string LuaPath(string name) {
            string path = AppConst.DebugMode ? Application.dataPath + "/" : DataPath;
            string lowerName = name.ToLower();
            if (lowerName.EndsWith(".lua")) {
                int index = name.LastIndexOf('.');
                name = name.Substring(0, index);
            }
            name = name.Replace('.', '/');
            if (luaPaths.Count == 0) {
                AddLuaPath(path);
            }
            path = SearchLuaPath(name + ".lua");
			//Debug.Log (path);
            return path;
        }

        /// <summary>
        /// 获取Lua路径
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static string SearchLuaPath(string fileName) {
            string filePath = fileName;
            for (int i = 0; i < luaPaths.Count; i++) {
                filePath = luaPaths[i] + fileName;
                if (File.Exists(filePath)) {
                    return filePath;
                }
            }
            return filePath;
        }

        /// <summary>
        /// 添加的Lua路径
        /// </summary>
        /// <param name="path"></param>
        public static void AddLuaPath(string path) {
            if (!luaPaths.Contains(path)) {
                if (!path.EndsWith("/")) {
                    path += "/";
                }
                luaPaths.Add(path);
            }
        }

        /// <summary>
        /// 删除Lua路径
        /// </summary>
        /// <param name="path"></param>
        public static void RemoveLuaPath(string path) {
            luaPaths.Remove(path);
        }

        public static void Log(string str) {
            Debug.Log(str);
        }

        public static void LogWarning(string str) {
            Debug.LogWarning(str);
        }

        public static void LogError(string str) {
            Debug.LogError(str);
        }

        public static GameObject LoadAsset(AssetBundle bundle, string name) {
#if UNITY_5
        return bundle.LoadAsset(name, typeof(GameObject)) as GameObject;
#else
            return bundle.Load(name, typeof(GameObject)) as GameObject;
#endif
        }

        public static Component AddComponent(GameObject go, string assembly, string classname) {
            Assembly asmb = Assembly.Load(assembly);
            Type t = asmb.GetType(assembly + "." + classname);
            return go.AddComponent(t);
        }

        /// <summary>
        /// 载入Prefab
        /// </summary>
        /// <param name="name"></param>
        public static GameObject LoadPrefab(string name) {
			ResourceManager resourceMgr = AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
			return resourceMgr.LoadObject<GameObject> ("Prefabs/" + name);
            //return Resources.Load(name, typeof(GameObject)) as GameObject;
        }

        /// <summary>
        /// 执行Lua方法
        /// </summary>
        public static object[] CallMethod(string module, string func, params object[] args) {
            LuaScriptMgr luaMgr = AppFacade.Instance.GetManager<LuaScriptMgr>(ManagerName.Lua);
            if (luaMgr == null) return null;
            string funcName = module + "." + func;
            funcName = funcName.Replace("(Clone)", "");
			//Debug.Log (funcName);
            return luaMgr.CallLuaFunction(funcName, args);
        }

        /// <summary>
        /// 防止初学者不按步骤来操作
        /// </summary>
        /// <returns></returns>
        static int CheckRuntimeFile() {
            if (!Application.isEditor) return 0;
            string streamDir = Application.dataPath + "/StreamingAssets/";
            if (!Directory.Exists(streamDir)) {
                return -1;
            } else {
                string[] files = Directory.GetFiles(streamDir);
                if (files.Length == 0) return -1;

				if (!File.Exists(streamDir + "fileMd5.txt")) {
					return -1;
                }
            }
            string sourceDir = AppConst.LuaWrapPath;
            if (!Directory.Exists(sourceDir)) {
                return -2;
            } else {
                string[] files = Directory.GetFiles(sourceDir);
                if (files.Length == 0) return -2;
            }
            return 0;
        }

        /// <summary>
        /// 检查运行环境
        /// </summary>
        public static bool CheckEnvironment() {
#if UNITY_EDITOR
            int resultId = Util.CheckRuntimeFile();
            if (resultId == -1) {
                Debug.LogError("没有找到框架所需要的资源，单击Game菜单下Build xxx Resource生成！！");
                EditorApplication.isPlaying = false;
                return false;
            } else if (resultId == -2) {
                Debug.LogError("没有找到Wrap脚本缓存，单击Lua菜单下Gen Lua Wrap Files生成脚本！！");
                EditorApplication.isPlaying = false;
                return false;
            }
            if (Application.loadedLevelName == "Test" && !AppConst.DebugMode) {
                Debug.LogError("测试场景，必须打开调试模式，AppConst.DebugMode = true！！");
                EditorApplication.isPlaying = false;
                return false;
            }
#endif            
            return true;
        }

		/// <summary>
		/// 载入Prefab
		/// </summary>
		/// <param name="name"></param>
        public static UnityEngine.Object LoadPrefabByPath(string path, string name)
        {
			ResourceManager resourceMgr = AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
			return resourceMgr.LoadObject<UnityEngine.Object>(path + name);
		}

        /// <summary>
        /// 载入Prefab
        /// </summary>
        /// <param name="name"></param>
        public static AudioClip LoadAudioClipByPath(string path, string name)
        {
			MusicManager music = AppFacade.Instance.GetManager<MusicManager>(ManagerName.Music);
			return music.LoadAudioClip (path + name);
		}

		//play background sound
		public static void PlayBackGroundSound(string name){
			MusicManager music = AppFacade.Instance.GetManager<MusicManager>(ManagerName.Music);
			music.PlayBacksound (name, true);
		}

		//play effect sound
		public static void PlayEffectSound(AudioClip clip,Vector3 position,float volume){
			MusicManager music = AppFacade.Instance.GetManager<MusicManager>(ManagerName.Music);
			music.PlayEffect (clip,position,volume);
		}

		//set sound volume
		public static void SetSoundVolume(float volume){
			MusicManager music = AppFacade.Instance.GetManager<MusicManager>(ManagerName.Music);
			music.setVolume (volume);
		}
		/// <summary>
		/// 加载场景
		/// </summary>
		public static void PreLoad(string[] asnames)
		{
			if(AppConst.UseAssetBundle){
				ResourceManager resourceMgr = AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
				resourceMgr.StartLoadBundle(asnames);
			}
			else{

			}
		}

		//get loading progress
		public static float getLoadingProgress(){
			ResourceManager resourceMgr = AppFacade.Instance.GetManager<ResourceManager>(ManagerName.Resource);
			return AppConst.UseAssetBundle?resourceMgr.getLoadingProgress ():1;
		}
        /// <summary>
        /// 是不是苹果平台
        /// </summary>
        /// <returns></returns>
        public static bool isApplePlatform {
            get {
                return Application.platform == RuntimePlatform.IPhonePlayer ||
                       Application.platform == RuntimePlatform.OSXEditor ||
                       Application.platform == RuntimePlatform.OSXPlayer;            
            }
        }

		public static byte[] EncryptStringToBytes_Aes(string plainText)
		{
			return AESHelper.EncryptStringToBytes_Aes (plainText,Encoding.UTF8.GetBytes(AESHelper.Key),AESHelper.keyVector);
		}

		public static string DecryptStringFromBytes_Aes(byte[] cipherText)
		{
			return AESHelper.DecryptStringFromBytes_Aes (cipherText, Encoding.UTF8.GetBytes(AESHelper.Key), AESHelper.keyVector);
		}
		public static byte[] DecryptBytesFromBytes_Aes(byte[] cipherText)
		{
			return AESHelper.DecryptBytesFromBytes_Aes (cipherText, Encoding.UTF8.GetBytes(AESHelper.Key), AESHelper.keyVector);
		}
    }
}