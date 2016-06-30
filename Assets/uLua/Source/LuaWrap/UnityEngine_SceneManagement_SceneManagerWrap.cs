using System;
using UnityEngine;
using LuaInterface;

public class UnityEngine_SceneManagement_SceneManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("GetActiveScene", GetActiveScene),
			new LuaMethod("SetActiveScene", SetActiveScene),
			new LuaMethod("GetSceneByPath", GetSceneByPath),
			new LuaMethod("GetSceneByName", GetSceneByName),
			new LuaMethod("GetSceneAt", GetSceneAt),
			new LuaMethod("LoadScene", LoadScene),
			new LuaMethod("LoadSceneAsync", LoadSceneAsync),
			new LuaMethod("CreateScene", CreateScene),
			new LuaMethod("UnloadScene", UnloadScene),
			new LuaMethod("MergeScenes", MergeScenes),
			new LuaMethod("MoveGameObjectToScene", MoveGameObjectToScene),
			new LuaMethod("New", _CreateUnityEngine_SceneManagement_SceneManager),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("sceneCount", get_sceneCount, null),
			new LuaField("sceneCountInBuildSettings", get_sceneCountInBuildSettings, null),
		};

		LuaScriptMgr.RegisterLib(L, "UnityEngine.SceneManagement.SceneManager", typeof(UnityEngine.SceneManagement.SceneManager), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUnityEngine_SceneManagement_SceneManager(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			UnityEngine.SceneManagement.SceneManager obj = new UnityEngine.SceneManagement.SceneManager();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UnityEngine.SceneManagement.SceneManager.New");
		}

		return 0;
	}

	static Type classType = typeof(UnityEngine.SceneManagement.SceneManager);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_sceneCount(IntPtr L)
	{
		LuaScriptMgr.Push(L, UnityEngine.SceneManagement.SceneManager.sceneCount);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_sceneCountInBuildSettings(IntPtr L)
	{
		LuaScriptMgr.Push(L, UnityEngine.SceneManagement.SceneManager.sceneCountInBuildSettings);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetActiveScene(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		UnityEngine.SceneManagement.Scene o = UnityEngine.SceneManagement.SceneManager.GetActiveScene();
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetActiveScene(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UnityEngine.SceneManagement.Scene arg0 = (UnityEngine.SceneManagement.Scene)LuaScriptMgr.GetNetObject(L, 1, typeof(UnityEngine.SceneManagement.Scene));
		bool o = UnityEngine.SceneManagement.SceneManager.SetActiveScene(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetSceneByPath(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		UnityEngine.SceneManagement.Scene o = UnityEngine.SceneManagement.SceneManager.GetSceneByPath(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetSceneByName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		UnityEngine.SceneManagement.Scene o = UnityEngine.SceneManagement.SceneManager.GetSceneByName(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetSceneAt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		UnityEngine.SceneManagement.Scene o = UnityEngine.SceneManagement.SceneManager.GetSceneAt(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadScene(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(int)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			UnityEngine.SceneManagement.SceneManager.LoadScene(arg0);
			return 0;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			UnityEngine.SceneManagement.SceneManager.LoadScene(arg0);
			return 0;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(UnityEngine.SceneManagement.LoadSceneMode)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			UnityEngine.SceneManagement.LoadSceneMode arg1 = (UnityEngine.SceneManagement.LoadSceneMode)LuaScriptMgr.GetLuaObject(L, 2);
			UnityEngine.SceneManagement.SceneManager.LoadScene(arg0,arg1);
			return 0;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(UnityEngine.SceneManagement.LoadSceneMode)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			UnityEngine.SceneManagement.LoadSceneMode arg1 = (UnityEngine.SceneManagement.LoadSceneMode)LuaScriptMgr.GetLuaObject(L, 2);
			UnityEngine.SceneManagement.SceneManager.LoadScene(arg0,arg1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UnityEngine.SceneManagement.SceneManager.LoadScene");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadSceneAsync(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(int)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			AsyncOperation o = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(arg0);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			AsyncOperation o = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(arg0);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(UnityEngine.SceneManagement.LoadSceneMode)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			UnityEngine.SceneManagement.LoadSceneMode arg1 = (UnityEngine.SceneManagement.LoadSceneMode)LuaScriptMgr.GetLuaObject(L, 2);
			AsyncOperation o = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(UnityEngine.SceneManagement.LoadSceneMode)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			UnityEngine.SceneManagement.LoadSceneMode arg1 = (UnityEngine.SceneManagement.LoadSceneMode)LuaScriptMgr.GetLuaObject(L, 2);
			AsyncOperation o = UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UnityEngine.SceneManagement.SceneManager.LoadSceneAsync");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreateScene(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		UnityEngine.SceneManagement.Scene o = UnityEngine.SceneManagement.SceneManager.CreateScene(arg0);
		LuaScriptMgr.PushValue(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnloadScene(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			bool o = UnityEngine.SceneManagement.SceneManager.UnloadScene(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 1 && LuaScriptMgr.CheckTypes(L, 1, typeof(int)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			bool o = UnityEngine.SceneManagement.SceneManager.UnloadScene(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: UnityEngine.SceneManagement.SceneManager.UnloadScene");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MergeScenes(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UnityEngine.SceneManagement.Scene arg0 = (UnityEngine.SceneManagement.Scene)LuaScriptMgr.GetNetObject(L, 1, typeof(UnityEngine.SceneManagement.Scene));
		UnityEngine.SceneManagement.Scene arg1 = (UnityEngine.SceneManagement.Scene)LuaScriptMgr.GetNetObject(L, 2, typeof(UnityEngine.SceneManagement.Scene));
		UnityEngine.SceneManagement.SceneManager.MergeScenes(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MoveGameObjectToScene(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 1, typeof(GameObject));
		UnityEngine.SceneManagement.Scene arg1 = (UnityEngine.SceneManagement.Scene)LuaScriptMgr.GetNetObject(L, 2, typeof(UnityEngine.SceneManagement.Scene));
		UnityEngine.SceneManagement.SceneManager.MoveGameObjectToScene(arg0,arg1);
		return 0;
	}
}

