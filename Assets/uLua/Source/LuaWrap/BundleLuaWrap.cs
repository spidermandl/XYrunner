using System;
using System.Collections;
using UnityEngine;
using LuaInterface;
using Object = UnityEngine.Object;

public class BundleLuaWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("New", _CreateBundleLua),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("luaName", get_luaName, set_luaName),
			new LuaField("param", get_param, set_param),
			new LuaField("args", get_args, set_args),
			new LuaField("isUpdate", get_isUpdate, set_isUpdate),
		};

		LuaScriptMgr.RegisterLib(L, "BundleLua", typeof(BundleLua), regs, fields, typeof(SimpleFramework.LuaBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateBundleLua(IntPtr L)
	{
		LuaDLL.luaL_error(L, "BundleLua class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(BundleLua);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_luaName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

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
	static int get_param(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name param");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index param on a nil value");
			}
		}

		LuaScriptMgr.PushArray(L, obj.param);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_args(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name args");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index args on a nil value");
			}
		}

		LuaScriptMgr.PushObject(L, obj.args);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isUpdate(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isUpdate");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isUpdate on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.isUpdate);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_luaName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

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
	static int set_param(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name param");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index param on a nil value");
			}
		}

		obj.param = LuaScriptMgr.GetArrayString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_args(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name args");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index args on a nil value");
			}
		}

		obj.args = (ArrayList)LuaScriptMgr.GetNetObject(L, 3, typeof(ArrayList));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isUpdate(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		BundleLua obj = (BundleLua)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name isUpdate");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index isUpdate on a nil value");
			}
		}

		obj.isUpdate = LuaScriptMgr.GetBoolean(L, 3);
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

