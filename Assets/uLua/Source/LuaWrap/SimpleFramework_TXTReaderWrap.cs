using System;
using LuaInterface;

public class SimpleFramework_TXTReaderWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("ReadTxt", ReadTxt),
			new LuaMethod("Readbytes", Readbytes),
			new LuaMethod("ReadArray", ReadArray),
			new LuaMethod("WriteTxt", WriteTxt),
			new LuaMethod("New", _CreateSimpleFramework_TXTReader),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
		};

		LuaScriptMgr.RegisterLib(L, "SimpleFramework.TXTReader", typeof(SimpleFramework.TXTReader), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSimpleFramework_TXTReader(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			SimpleFramework.TXTReader obj = new SimpleFramework.TXTReader();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.TXTReader.New");
		}

		return 0;
	}

	static Type classType = typeof(SimpleFramework.TXTReader);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadTxt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string[][] o = SimpleFramework.TXTReader.ReadTxt(arg0);
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Readbytes(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		byte[] objs0 = LuaScriptMgr.GetArrayNumber<byte>(L, 1);
		string[][] o = SimpleFramework.TXTReader.Readbytes(objs0);
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadArray(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string[] objs0 = LuaScriptMgr.GetArrayString(L, 1);
		string[][] o = SimpleFramework.TXTReader.ReadArray(objs0);
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteTxt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		SimpleFramework.TXTReader.WriteTxt(arg0,arg1);
		return 0;
	}
}

