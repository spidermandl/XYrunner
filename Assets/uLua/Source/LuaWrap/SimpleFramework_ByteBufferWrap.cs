﻿using System;
using LuaInterface;

public class SimpleFramework_ByteBufferWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Close", Close),
			new LuaMethod("WriteByte", WriteByte),
			new LuaMethod("WriteInt", WriteInt),
			new LuaMethod("WriteShort", WriteShort),
			new LuaMethod("WriteLong", WriteLong),
			new LuaMethod("WriteFloat", WriteFloat),
			new LuaMethod("WriteDouble", WriteDouble),
			new LuaMethod("WriteString", WriteString),
			new LuaMethod("WriteBytes", WriteBytes),
			new LuaMethod("WriteBuffer", WriteBuffer),
			new LuaMethod("ReadByte", ReadByte),
			new LuaMethod("ReadInt", ReadInt),
			new LuaMethod("ReadShort", ReadShort),
			new LuaMethod("ReadLong", ReadLong),
			new LuaMethod("ReadFloat", ReadFloat),
			new LuaMethod("ReadDouble", ReadDouble),
			new LuaMethod("ReadString", ReadString),
			new LuaMethod("ReadBytes", ReadBytes),
			new LuaMethod("ReadBuffer", ReadBuffer),
			new LuaMethod("ToBytes", ToBytes),
			new LuaMethod("Flush", Flush),
			new LuaMethod("New", _CreateSimpleFramework_ByteBuffer),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
		};

		LuaScriptMgr.RegisterLib(L, "SimpleFramework.ByteBuffer", typeof(SimpleFramework.ByteBuffer), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateSimpleFramework_ByteBuffer(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			SimpleFramework.ByteBuffer obj = new SimpleFramework.ByteBuffer();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else if (count == 1)
		{
			byte[] objs0 = LuaScriptMgr.GetArrayNumber<byte>(L, 1);
			SimpleFramework.ByteBuffer obj = new SimpleFramework.ByteBuffer(objs0);
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: SimpleFramework.ByteBuffer.New");
		}

		return 0;
	}

	static Type classType = typeof(SimpleFramework.ByteBuffer);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Close(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		obj.Close();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteByte(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		byte arg0 = (byte)LuaScriptMgr.GetNumber(L, 2);
		obj.WriteByte(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteInt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		obj.WriteInt(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteShort(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		ushort arg0 = (ushort)LuaScriptMgr.GetNumber(L, 2);
		obj.WriteShort(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteLong(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		long arg0 = (long)LuaScriptMgr.GetNumber(L, 2);
		obj.WriteLong(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteFloat(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 2);
		obj.WriteFloat(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteDouble(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 2);
		obj.WriteDouble(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		string arg0 = LuaScriptMgr.GetLuaString(L, 2);
		obj.WriteString(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteBytes(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		byte[] objs0 = LuaScriptMgr.GetArrayNumber<byte>(L, 2);
		obj.WriteBytes(objs0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int WriteBuffer(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		LuaStringBuffer arg0 = LuaScriptMgr.GetStringBuffer(L, 2);
		obj.WriteBuffer(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadByte(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		byte o = obj.ReadByte();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadInt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		int o = obj.ReadInt();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadShort(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		ushort o = obj.ReadShort();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadLong(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		long o = obj.ReadLong();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadFloat(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		float o = obj.ReadFloat();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadDouble(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		double o = obj.ReadDouble();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadString(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		string o = obj.ReadString();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadBytes(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		byte[] o = obj.ReadBytes();
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ReadBuffer(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		LuaStringBuffer o = obj.ReadBuffer();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ToBytes(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		byte[] o = obj.ToBytes();
		LuaScriptMgr.PushArray(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Flush(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		SimpleFramework.ByteBuffer obj = (SimpleFramework.ByteBuffer)LuaScriptMgr.GetNetObjectSelf(L, 1, "SimpleFramework.ByteBuffer");
		obj.Flush();
		return 0;
	}
}

