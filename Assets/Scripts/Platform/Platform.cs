using UnityEngine;
using System.Collections;
using System.IO;
using System.Collections.Generic;
using System.Net;
using System.Runtime.InteropServices;

namespace SimpleFramework {
	public class Platform : MonoBehaviour {
	/*
	说明:
		类型1 — lua发起CallAndroid(id, param)
			id表示要调用的接口id
			param表示发送内容
		类型2 — android发起CallLua(param)
			param表示发送内容
	*/
#if UNITY_EDITOR

#elif UNITY_ANDROID
		static AndroidJavaObject m_activity;
		static AndroidAgent m_instance;
#endif


		#region singleton
		private static Platform instance = null;
		public static Platform Instance{
			get{
				if(instance == null){
					instance = GameObject.FindObjectOfType<Platform>();
				}
				return instance;
			}
		}

		public string Channel{
			get{
				#if UNITY_EDITOR
				return "default";
				#elif UNITY_ANDROID
				AndroidJavaClass manager = new AndroidJavaClass("com.xy.sdkbridge.SDKManager");
				return manager.CallStatic<string>("getChannelName");
				#elif UNITY_IPHONE
				return "ky7659";
				#else
					return "default";
				#endif
			}
		}
		#endregion

		void Awake(){
			DontDestroyOnLoad(gameObject);

		#if UNITY_EDITOR

		#elif UNITY_ANDROID
			using (AndroidJavaClass cls_UnityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
			{
				m_activity = cls_UnityPlayer.GetStatic<AndroidJavaObject>("currentActivity");
			}
		#endif
		}

		void Start(){
			DataCollector.Instance.Start ();
		}

		void OnDestroy(){
			DataCollector.Instance.OnDestroy ();
		}
		//invoked by lua script and call for func in native platform
		public void callNativeFunc(int id, string param){
		#if UNITY_EDITOR
			//如果是编辑器则直接回调
			switch (id){
			case 1001:
				CallLoginBack(param);
				break;
			case 1002:
				CallPayBack(param);
				break;
			default:
				Debug.LogWarning("function id is not found:" + id);
				break;
			}
		#elif UNITY_ANDROID
			m_activity.Call("callSDKFunc",id,param);
        #elif UNITY_IPHONE
			callSDKFunc(id,param);
		#endif
		}

		//Java层接口列表
		public struct JavaInterface{
			public const string javaFunName = "UnityAction";
			public const string LOGIN = "CallLogin";
			public const string PAY = "CallPay";
		}

		//Lua层接口列表
		public struct LuaInterface{
			public const string luaObjName = "PlatformAction";
			public const string luaFunName = "RunAction";
			public const string LOGIN = "ActionLogin";
			public const string PAY = "ActionPay";
		}

#if UNITY_IPHONE
		[DllImport("__Internal")]
		private static extern void callSDKFunc(int id,string param);
#endif
		//Android调用
		public void CallLoginBack(string result){
			//调用Lua
			string[] pstr = {LuaInterface.LOGIN, result};
			Util.CallMethod(LuaInterface.luaObjName, LuaInterface.luaFunName, pstr);
		}

		//Android调用
		public void CallPayBack(string result){
			//调用Lua
			string[] pstr = {LuaInterface.PAY, result};
			Util.CallMethod(LuaInterface.luaObjName, LuaInterface.luaFunName, pstr);
		}
	}
}
