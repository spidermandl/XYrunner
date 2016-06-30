using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using LuaInterface;
using System.Reflection;
using System.IO;
using Junfine.Debuger;

#if UNITY_EDITOR
using UnityEditor;
#endif

namespace SimpleFramework.Manager {
	public class GameManager : LuaBehaviour {
		private string message;

		private Action enterGameFunc;
		
		/// <summary>
		/// 初始化游戏管理器
		/// </summary>
		void Awake() {
			Init();
		}
		
		/// <summary>
		/// 初始化
		/// </summary>
		void Init() {
			DontDestroyOnLoad(gameObject);  //防止销毁自己

//			//<Desmond>
//			if (Application.platform == RuntimePlatform.IPhonePlayer || 
//			    Application.platform == RuntimePlatform.Android ||
//			    Application.platform == RuntimePlatform.WP8Player) {
//				//Debug.Log("------------------------------>>>>>>>>>>> GameManager 1");
//				CheckExtractResource(); //释放资源
//				ZipConstants.DefaultCodePage = 65001;
//			} else {
//				//Debug.Log("------------------------------>>>>>>>>>>> GameManager 2");
//				OnResourceInited();
//			}
//			Screen.sleepTimeout = SleepTimeout.NeverSleep;
//			Application.targetFrameRate = AppConst.GameFrameRate;

			StartCoroutine(checkRes());
		}


		//wait till rescource manager finishes checking
		IEnumerator checkRes() {
			while (ResManager.State != ResourceManager.ResState.FINISH) {
				yield return new WaitForSeconds(1f);
			}
			ResManager.initialize(OnResourceInited);
//			OnResourceInited ();
			Screen.sleepTimeout = SleepTimeout.NeverSleep;
			Application.targetFrameRate = AppConst.GameFrameRate;

			if (enterGameFunc != null)
				enterGameFunc ();
		}

		//set enter game callback logic
		public void setEnterGame(System.Action func) {
			enterGameFunc = func;
		}

		/// <summary>
		/// 资源初始化结束
		/// </summary>
		public void OnResourceInited() {
			LuaManager.Start();
			//LuaManager.DoString ("print('------------------------first line--------------------------')");
			LuaManager.DoFile("Logic/game");       //加载游戏
			LuaManager.DoFile("Logic/network");    //加载网络
			initialize = true;                     //初始化完 
			
			NetManager.OnInit();    //初始化网络
			CallMethod("OnInitOK");   //初始化完成
		}

		
		void Update() {
			if (LuaManager != null && initialize) {
				LuaManager.Update();
			}
		}
		
		void LateUpdate() {
			if (LuaManager != null && initialize) {
				LuaManager.LateUpate();
			}
		}
		
		void FixedUpdate() {
			if (LuaManager != null && initialize) {
				LuaManager.FixedUpdate();
			}
		}
		
		/// <summary>
		/// 析构函数
		/// </summary>
		void OnDestroy() {
			if (NetManager != null) {
				NetManager.Unload();
			}
			if (LuaManager != null) {
				LuaManager.Destroy();
			}
			Debug.Log("~GameManager was destroyed");
		}
	}
}