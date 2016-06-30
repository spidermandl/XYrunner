using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class UIButtonCtrlWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("OnDoubleClick", OnDoubleClick),
			new LuaMethod("OnClick", OnClick),
			new LuaMethod("OnPress", OnPress),
			new LuaMethod("OnRelease", OnRelease),
			new LuaMethod("New", _CreateUIButtonCtrl),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("attachID", get_attachID, set_attachID),
			new LuaField("luaName", get_luaName, set_luaName),
		};

		LuaScriptMgr.RegisterLib(L, "UIButtonCtrl", typeof(UIButtonCtrl), regs, fields, typeof(BundleLua));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUIButtonCtrl(IntPtr L)
	{
		LuaDLL.luaL_error(L, "UIButtonCtrl class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(UIButtonCtrl);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_attachID(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonCtrl obj = (UIButtonCtrl)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name attachID");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index attachID on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.attachID);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_luaName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonCtrl obj = (UIButtonCtrl)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name luaName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index luaName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.luaName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_attachID(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonCtrl obj = (UIButtonCtrl)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name attachID");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index attachID on a nil value");
			}
		}

		obj.attachID = (double)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_luaName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonCtrl obj = (UIButtonCtrl)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name luaName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index luaName on a nil value");
			}
		}

		obj.luaName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnDoubleClick(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UIButtonCtrl obj = (UIButtonCtrl)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIButtonCtrl");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		obj.OnDoubleClick(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnClick(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UIButtonCtrl obj = (UIButtonCtrl)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIButtonCtrl");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		obj.OnClick(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPress(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UIButtonCtrl obj = (UIButtonCtrl)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIButtonCtrl");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		obj.OnPress(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnRelease(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UIButtonCtrl obj = (UIButtonCtrl)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UIButtonCtrl");
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 2, typeof(GameObject));
		obj.OnRelease(arg0);
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

