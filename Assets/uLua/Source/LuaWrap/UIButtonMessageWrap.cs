using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class UIButtonMessageWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateUIButtonMessage),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("target", get_target, set_target),
			new LuaField("functionName", get_functionName, set_functionName),
			new LuaField("trigger", get_trigger, set_trigger),
			new LuaField("includeChildren", get_includeChildren, set_includeChildren),
		};

		LuaScriptMgr.RegisterLib(L, "UIButtonMessage", typeof(UIButtonMessage), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUIButtonMessage(IntPtr L)
	{
		LuaDLL.luaL_error(L, "UIButtonMessage class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(UIButtonMessage);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_target(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name target");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index target on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.target);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_functionName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name functionName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index functionName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.functionName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_trigger(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name trigger");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index trigger on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.trigger);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_includeChildren(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name includeChildren");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index includeChildren on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.includeChildren);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_target(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name target");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index target on a nil value");
			}
		}

		obj.target = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_functionName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name functionName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index functionName on a nil value");
			}
		}

		obj.functionName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_trigger(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name trigger");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index trigger on a nil value");
			}
		}

		obj.trigger = (UIButtonMessage.Trigger)LuaScriptMgr.GetNetObject(L, 3, typeof(UIButtonMessage.Trigger));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_includeChildren(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIButtonMessage obj = (UIButtonMessage)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name includeChildren");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index includeChildren on a nil value");
			}
		}

		obj.includeChildren = LuaScriptMgr.GetBoolean(L, 3);
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

