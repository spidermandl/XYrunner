using System;
using System.Collections;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class SimpleFramework_Manager_ResourceManagerWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("initialize", initialize),
			new LuaMethod("releaseMemory", releaseMemory),
			new LuaMethod("getLoadingProgress", getLoadingProgress),
			new LuaMethod("StartLoadBundle", StartLoadBundle),
			new LuaMethod("AsyncLoadBundles", AsyncLoadBundles),
			new LuaMethod("AsyncLoadSingleBundle", AsyncLoadSingleBundle),
			new LuaMethod("CheckFile", CheckFile),
			new LuaMethod("New", _CreateSimpleFramework_Manager_ResourceManager),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("State", get_State, null),
			new LuaField("message", get_message, set_message),
			new LuaField("Progress", get_Progress, set_Progress),
			new LuaField("Aggreagate", get_Aggreagate, set_Aggreagate),
		};

		LuaScriptMgr.RegisterLib(L, "SimpleFramework.Manager.ResourceManager", typeof(SimpleFramework.Manager.ResourceManager), regs, fields, typeof(View));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSimpleFramework_Manager_ResourceManager(IntPtr L)
	{
		LuaDLL.luaL_error(L, "SimpleFramework.Manager.ResourceManager class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(SimpleFramework.Manager.ResourceManager);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_State(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name State");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index State on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.State);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_message(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name message");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index message on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.message);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Progress(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Progress");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Progress on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.Progress);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Aggreagate(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Aggreagate");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Aggreagate on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.Aggreagate);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_message(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name message");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index message on a nil value");
			}
		}

		obj.message = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Progress(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Progress");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Progress on a nil value");
			}
		}

		obj.Progress = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_Aggreagate(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Aggreagate");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Aggreagate on a nil value");
			}
		}

		obj.Aggreagate = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int initialize(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		Action arg0 = null;
		LuaTypes funcType2 = LuaDLL.lua_type(L, 2);

		if (funcType2 != LuaTypes.LUA_TFUNCTION)
		{
			 arg0 = (Action)LuaScriptMgr.GetNetObject(L, 2, typeof(Action));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.GetLuaFunction(L, 2);
			arg0 = () =>
			{
				func.Call();
			};
		}

		obj.initialize(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int releaseMemory(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		obj.releaseMemory();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int getLoadingProgress(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		float o = obj.getLoadingProgress();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int StartLoadBundle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		string[] objs0 = LuaScriptMgr.GetArrayString(L, 2);
		obj.StartLoadBundle(objs0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AsyncLoadBundles(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		string[] objs0 = LuaScriptMgr.GetArrayString(L, 2);
		IEnumerator o = obj.AsyncLoadBundles(objs0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AsyncLoadSingleBundle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		IEnumerator o = obj.AsyncLoadSingleBundle(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CheckFile(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.Manager.ResourceManager obj = (SimpleFramework.Manager.ResourceManager)LuaScriptMgr.GetUnityObjectSelf(L, 1, "SimpleFramework.Manager.ResourceManager");
		obj.CheckFile();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lua_Eq(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Object arg0 = LuaScriptMgr.GetLuaObject(L, 1) as Object;
		Object arg1 = LuaScriptMgr.GetLuaObject(L, 2) as Object;
		bool o = arg0 == arg1;
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

