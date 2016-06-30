using System;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class UIAnchorWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateUIAnchor),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("uiCamera", get_uiCamera, set_uiCamera),
			new LuaField("container", get_container, set_container),
			new LuaField("side", get_side, set_side),
			new LuaField("runOnlyOnce", get_runOnlyOnce, set_runOnlyOnce),
			new LuaField("relativeOffset", get_relativeOffset, set_relativeOffset),
			new LuaField("pixelOffset", get_pixelOffset, set_pixelOffset),
		};

		LuaScriptMgr.RegisterLib(L, "UIAnchor", typeof(UIAnchor), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUIAnchor(IntPtr L)
	{
		LuaDLL.luaL_error(L, "UIAnchor class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(UIAnchor);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_uiCamera(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name uiCamera");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index uiCamera on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.uiCamera);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_container(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name container");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index container on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.container);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_side(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name side");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index side on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.side);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_runOnlyOnce(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name runOnlyOnce");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index runOnlyOnce on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.runOnlyOnce);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_relativeOffset(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name relativeOffset");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index relativeOffset on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.relativeOffset);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_pixelOffset(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name pixelOffset");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index pixelOffset on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.pixelOffset);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_uiCamera(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name uiCamera");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index uiCamera on a nil value");
			}
		}

		obj.uiCamera = (Camera)LuaScriptMgr.GetUnityObject(L, 3, typeof(Camera));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_container(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name container");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index container on a nil value");
			}
		}

		obj.container = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_side(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name side");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index side on a nil value");
			}
		}

		obj.side = (UIAnchor.Side)LuaScriptMgr.GetNetObject(L, 3, typeof(UIAnchor.Side));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_runOnlyOnce(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name runOnlyOnce");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index runOnlyOnce on a nil value");
			}
		}

		obj.runOnlyOnce = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_relativeOffset(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name relativeOffset");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index relativeOffset on a nil value");
			}
		}

		obj.relativeOffset = LuaScriptMgr.GetVector2(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_pixelOffset(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UIAnchor obj = (UIAnchor)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name pixelOffset");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index pixelOffset on a nil value");
			}
		}

		obj.pixelOffset = LuaScriptMgr.GetVector2(L, 3);
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

