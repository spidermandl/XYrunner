using System;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;

public class LocalizationWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Load", Load),
			new LuaMethod("Set", Set),
			new LuaMethod("LoadCSV", LoadCSV),
			new LuaMethod("Get", Get),
			new LuaMethod("Format", Format),
			new LuaMethod("Exists", Exists),
			new LuaMethod("New", _CreateLocalization),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("loadFunction", get_loadFunction, set_loadFunction),
			new LuaField("onLocalize", get_onLocalize, set_onLocalize),
			new LuaField("localizationHasBeenSet", get_localizationHasBeenSet, set_localizationHasBeenSet),
			new LuaField("dictionary", get_dictionary, set_dictionary),
			new LuaField("knownLanguages", get_knownLanguages, null),
			new LuaField("language", get_language, set_language),
		};

		LuaScriptMgr.RegisterLib(L, "Localization", typeof(Localization), regs, fields, null);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateLocalization(IntPtr L)
	{
		LuaDLL.luaL_error(L, "Localization class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(Localization);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loadFunction(IntPtr L)
	{
		LuaScriptMgr.Push(L, Localization.loadFunction);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onLocalize(IntPtr L)
	{
		LuaScriptMgr.Push(L, Localization.onLocalize);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_localizationHasBeenSet(IntPtr L)
	{
		LuaScriptMgr.Push(L, Localization.localizationHasBeenSet);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_dictionary(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, Localization.dictionary);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_knownLanguages(IntPtr L)
	{
		LuaScriptMgr.PushArray(L, Localization.knownLanguages);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_language(IntPtr L)
	{
		LuaScriptMgr.Push(L, Localization.language);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_loadFunction(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			Localization.loadFunction = (Localization.LoadFunction)LuaScriptMgr.GetNetObject(L, 3, typeof(Localization.LoadFunction));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			Localization.loadFunction = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				object[] objs = func.PopValues(top);
				func.EndPCall(top);
				return (byte[])objs[0];
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onLocalize(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			Localization.onLocalize = (Localization.OnLocalizeNotification)LuaScriptMgr.GetNetObject(L, 3, typeof(Localization.OnLocalizeNotification));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			Localization.onLocalize = () =>
			{
				func.Call();
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_localizationHasBeenSet(IntPtr L)
	{
		Localization.localizationHasBeenSet = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_dictionary(IntPtr L)
	{
		Localization.dictionary = (Dictionary<string,string[]>)LuaScriptMgr.GetNetObject(L, 3, typeof(Dictionary<string,string[]>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_language(IntPtr L)
	{
		Localization.language = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Load(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		TextAsset arg0 = (TextAsset)LuaScriptMgr.GetUnityObject(L, 1, typeof(TextAsset));
		Localization.Load(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Set(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(string)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			string arg1 = LuaScriptMgr.GetString(L, 2);
			Localization.Set(arg0,arg1);
			return 0;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(Dictionary<string,string>)))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			Dictionary<string,string> arg1 = (Dictionary<string,string>)LuaScriptMgr.GetLuaObject(L, 2);
			Localization.Set(arg0,arg1);
			return 0;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(string), typeof(byte[])))
		{
			string arg0 = LuaScriptMgr.GetString(L, 1);
			byte[] objs1 = LuaScriptMgr.GetArrayNumber<byte>(L, 2);
			Localization.Set(arg0,objs1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Localization.Set");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LoadCSV(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(byte[]), typeof(bool)))
		{
			byte[] objs0 = LuaScriptMgr.GetArrayNumber<byte>(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			bool o = Localization.LoadCSV(objs0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(TextAsset), typeof(bool)))
		{
			TextAsset arg0 = (TextAsset)LuaScriptMgr.GetLuaObject(L, 1);
			bool arg1 = LuaDLL.lua_toboolean(L, 2);
			bool o = Localization.LoadCSV(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Localization.LoadCSV");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Get(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string o = Localization.Get(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Format(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		object[] objs1 = LuaScriptMgr.GetParamsObject(L, 2, count - 1);
		string o = Localization.Format(arg0,objs1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Exists(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		bool o = Localization.Exists(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

