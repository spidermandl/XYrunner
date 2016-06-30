using System;
using System.Collections;
using LuaInterface;

public class ArrayWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("GetLength", GetLength),
			new LuaMethod("GetLongLength", GetLongLength),
			new LuaMethod("GetLowerBound", GetLowerBound),
			new LuaMethod("GetValue", GetValue),
			new LuaMethod("SetValue", SetValue),
			new LuaMethod("GetEnumerator", GetEnumerator),
			new LuaMethod("GetUpperBound", GetUpperBound),
			new LuaMethod("CreateInstance", CreateInstance),
			new LuaMethod("BinarySearch", BinarySearch),
			new LuaMethod("Clear", Clear),
			new LuaMethod("Clone", Clone),
			new LuaMethod("Copy", Copy),
			new LuaMethod("IndexOf", IndexOf),
			new LuaMethod("Initialize", Initialize),
			new LuaMethod("LastIndexOf", LastIndexOf),
			new LuaMethod("Reverse", Reverse),
			new LuaMethod("Sort", Sort),
			new LuaMethod("CopyTo", CopyTo),
			new LuaMethod("ConstrainedCopy", ConstrainedCopy),
			new LuaMethod("New", _CreateArray),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("Length", get_Length, null),
			new LuaField("LongLength", get_LongLength, null),
			new LuaField("Rank", get_Rank, null),
			new LuaField("IsSynchronized", get_IsSynchronized, null),
			new LuaField("SyncRoot", get_SyncRoot, null),
			new LuaField("IsFixedSize", get_IsFixedSize, null),
			new LuaField("IsReadOnly", get_IsReadOnly, null),
		};

		LuaScriptMgr.RegisterLib(L, "System.Array", typeof(Array), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateArray(IntPtr L)
	{
		LuaDLL.luaL_error(L, "Array class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(Array);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Length(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Array obj = (Array)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Length");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Length on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.Length);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_LongLength(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Array obj = (Array)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name LongLength");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index LongLength on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.LongLength);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Rank(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Array obj = (Array)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name Rank");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index Rank on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.Rank);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsSynchronized(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Array obj = (Array)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsSynchronized");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsSynchronized on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsSynchronized);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_SyncRoot(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Array obj = (Array)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name SyncRoot");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index SyncRoot on a nil value");
			}
		}

		LuaScriptMgr.PushVarObject(L, obj.SyncRoot);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsFixedSize(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Array obj = (Array)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsFixedSize");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsFixedSize on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsFixedSize);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_IsReadOnly(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		Array obj = (Array)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name IsReadOnly");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index IsReadOnly on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.IsReadOnly);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLength(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		int o = obj.GetLength(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLongLength(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		long o = obj.GetLongLength(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetLowerBound(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		int o = obj.GetLowerBound(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetValue(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			long arg0 = (long)LuaScriptMgr.GetNumber(L, 2);
			object o = obj.GetValue(arg0);
			LuaScriptMgr.PushVarObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(long), typeof(long)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			long arg0 = (long)LuaDLL.lua_tonumber(L, 2);
			long arg1 = (long)LuaDLL.lua_tonumber(L, 3);
			object o = obj.GetValue(arg0,arg1);
			LuaScriptMgr.PushVarObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(int), typeof(int)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			int arg0 = (int)LuaDLL.lua_tonumber(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			object o = obj.GetValue(arg0,arg1);
			LuaScriptMgr.PushVarObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(long), typeof(long), typeof(long)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			long arg0 = (long)LuaDLL.lua_tonumber(L, 2);
			long arg1 = (long)LuaDLL.lua_tonumber(L, 3);
			long arg2 = (long)LuaDLL.lua_tonumber(L, 4);
			object o = obj.GetValue(arg0,arg1,arg2);
			LuaScriptMgr.PushVarObject(L, o);
			return 1;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(int), typeof(int), typeof(int)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			int arg0 = (int)LuaDLL.lua_tonumber(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
			object o = obj.GetValue(arg0,arg1,arg2);
			LuaScriptMgr.PushVarObject(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckParamsType(L, typeof(long), 2, count - 1))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			long[] objs0 = LuaScriptMgr.GetArrayNumber<long>(L, 2);
			object o = obj.GetValue(objs0);
			LuaScriptMgr.PushVarObject(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckParamsType(L, typeof(int), 2, count - 1))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			int[] objs0 = LuaScriptMgr.GetArrayNumber<int>(L, 2);
			object o = obj.GetValue(objs0);
			LuaScriptMgr.PushVarObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.GetValue");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetValue(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			long arg1 = (long)LuaScriptMgr.GetNumber(L, 3);
			obj.SetValue(arg0,arg1);
			return 0;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(object), typeof(int), typeof(int)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
			obj.SetValue(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(object), typeof(long), typeof(long)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			long arg1 = (long)LuaDLL.lua_tonumber(L, 3);
			long arg2 = (long)LuaDLL.lua_tonumber(L, 4);
			obj.SetValue(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(object), typeof(int), typeof(int), typeof(int)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 3);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 4);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 5);
			obj.SetValue(arg0,arg1,arg2,arg3);
			return 0;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(object), typeof(long), typeof(long), typeof(long)))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			long arg1 = (long)LuaDLL.lua_tonumber(L, 3);
			long arg2 = (long)LuaDLL.lua_tonumber(L, 4);
			long arg3 = (long)LuaDLL.lua_tonumber(L, 5);
			obj.SetValue(arg0,arg1,arg2,arg3);
			return 0;
		}
		else if (LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(object)) && LuaScriptMgr.CheckParamsType(L, typeof(long), 3, count - 2))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			long[] objs1 = LuaScriptMgr.GetArrayNumber<long>(L, 3);
			obj.SetValue(arg0,objs1);
			return 0;
		}
		else if (LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(object)) && LuaScriptMgr.CheckParamsType(L, typeof(int), 3, count - 2))
		{
			Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
			object arg0 = LuaScriptMgr.GetVarObject(L, 2);
			int[] objs1 = LuaScriptMgr.GetArrayNumber<int>(L, 3);
			obj.SetValue(arg0,objs1);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.SetValue");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetEnumerator(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		IEnumerator o = obj.GetEnumerator();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetUpperBound(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 2);
		int o = obj.GetUpperBound(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CreateInstance(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			Type arg0 = LuaScriptMgr.GetTypeObject(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			Array o = Array.CreateInstance(arg0,arg1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Type), typeof(int[]), typeof(int[])))
		{
			Type arg0 = LuaScriptMgr.GetTypeObject(L, 1);
			int[] objs1 = LuaScriptMgr.GetArrayNumber<int>(L, 2);
			int[] objs2 = LuaScriptMgr.GetArrayNumber<int>(L, 3);
			Array o = Array.CreateInstance(arg0,objs1,objs2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Type), typeof(int), typeof(int)))
		{
			Type arg0 = LuaScriptMgr.GetTypeObject(L, 1);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 3);
			Array o = Array.CreateInstance(arg0,arg1,arg2);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Type arg0 = LuaScriptMgr.GetTypeObject(L, 1);
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			Array o = Array.CreateInstance(arg0,arg1,arg2,arg3);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckTypes(L, 1, typeof(Type)) && LuaScriptMgr.CheckParamsType(L, typeof(long), 2, count - 1))
		{
			Type arg0 = LuaScriptMgr.GetTypeObject(L, 1);
			long[] objs1 = LuaScriptMgr.GetArrayNumber<long>(L, 2);
			Array o = Array.CreateInstance(arg0,objs1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckTypes(L, 1, typeof(Type)) && LuaScriptMgr.CheckParamsType(L, typeof(int), 2, count - 1))
		{
			Type arg0 = LuaScriptMgr.GetTypeObject(L, 1);
			int[] objs1 = LuaScriptMgr.GetArrayNumber<int>(L, 2);
			Array o = Array.CreateInstance(arg0,objs1);
			LuaScriptMgr.PushObject(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.CreateInstance");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int BinarySearch(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int o = Array.BinarySearch(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			IComparer arg2 = (IComparer)LuaScriptMgr.GetNetObject(L, 3, typeof(IComparer));
			int o = Array.BinarySearch(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			object arg3 = LuaScriptMgr.GetVarObject(L, 4);
			int o = Array.BinarySearch(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 5)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			object arg3 = LuaScriptMgr.GetVarObject(L, 4);
			IComparer arg4 = (IComparer)LuaScriptMgr.GetNetObject(L, 5, typeof(IComparer));
			int o = Array.BinarySearch(arg0,arg1,arg2,arg3,arg4);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.BinarySearch");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clear(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
		Array.Clear(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clone(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		object o = obj.Clone();
		LuaScriptMgr.PushVarObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Copy(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			Array arg1 = (Array)LuaScriptMgr.GetNetObject(L, 2, typeof(Array));
			long arg2 = (long)LuaScriptMgr.GetNumber(L, 3);
			Array.Copy(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(long), typeof(Array), typeof(long), typeof(long)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			long arg1 = (long)LuaDLL.lua_tonumber(L, 2);
			Array arg2 = (Array)LuaScriptMgr.GetLuaObject(L, 3);
			long arg3 = (long)LuaDLL.lua_tonumber(L, 4);
			long arg4 = (long)LuaDLL.lua_tonumber(L, 5);
			Array.Copy(arg0,arg1,arg2,arg3,arg4);
			return 0;
		}
		else if (count == 5 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(int), typeof(Array), typeof(int), typeof(int)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
			Array arg2 = (Array)LuaScriptMgr.GetLuaObject(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			int arg4 = (int)LuaDLL.lua_tonumber(L, 5);
			Array.Copy(arg0,arg1,arg2,arg3,arg4);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.Copy");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IndexOf(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int o = Array.IndexOf(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int o = Array.IndexOf(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int o = Array.IndexOf(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.IndexOf");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Initialize(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		obj.Initialize();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LastIndexOf(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int o = Array.LastIndexOf(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int o = Array.LastIndexOf(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 4)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			object arg1 = LuaScriptMgr.GetVarObject(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			int o = Array.LastIndexOf(arg0,arg1,arg2,arg3);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.LastIndexOf");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Reverse(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			Array.Reverse(arg0);
			return 0;
		}
		else if (count == 3)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			Array.Reverse(arg0,arg1,arg2);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.Reverse");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Sort(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			Array.Sort(arg0);
			return 0;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(IComparer)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			IComparer arg1 = (IComparer)LuaScriptMgr.GetLuaObject(L, 2);
			Array.Sort(arg0,arg1);
			return 0;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(Array)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			Array arg1 = (Array)LuaScriptMgr.GetLuaObject(L, 2);
			Array.Sort(arg0,arg1);
			return 0;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(Array), typeof(IComparer)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			Array arg1 = (Array)LuaScriptMgr.GetLuaObject(L, 2);
			IComparer arg2 = (IComparer)LuaScriptMgr.GetLuaObject(L, 3);
			Array.Sort(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(int), typeof(int)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 3);
			Array.Sort(arg0,arg1,arg2);
			return 0;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(int), typeof(int), typeof(IComparer)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 3);
			IComparer arg3 = (IComparer)LuaScriptMgr.GetLuaObject(L, 4);
			Array.Sort(arg0,arg1,arg2,arg3);
			return 0;
		}
		else if (count == 4 && LuaScriptMgr.CheckTypes(L, 1, typeof(Array), typeof(Array), typeof(int), typeof(int)))
		{
			Array arg0 = (Array)LuaScriptMgr.GetLuaObject(L, 1);
			Array arg1 = (Array)LuaScriptMgr.GetLuaObject(L, 2);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 3);
			int arg3 = (int)LuaDLL.lua_tonumber(L, 4);
			Array.Sort(arg0,arg1,arg2,arg3);
			return 0;
		}
		else if (count == 5)
		{
			Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
			Array arg1 = (Array)LuaScriptMgr.GetNetObject(L, 2, typeof(Array));
			int arg2 = (int)LuaScriptMgr.GetNumber(L, 3);
			int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
			IComparer arg4 = (IComparer)LuaScriptMgr.GetNetObject(L, 5, typeof(IComparer));
			Array.Sort(arg0,arg1,arg2,arg3,arg4);
			return 0;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Array.Sort");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CopyTo(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Array obj = (Array)LuaScriptMgr.GetNetObjectSelf(L, 1, "Array");
		Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 2, typeof(Array));
		long arg1 = (long)LuaScriptMgr.GetNumber(L, 3);
		obj.CopyTo(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ConstrainedCopy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 5);
		Array arg0 = (Array)LuaScriptMgr.GetNetObject(L, 1, typeof(Array));
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		Array arg2 = (Array)LuaScriptMgr.GetNetObject(L, 3, typeof(Array));
		int arg3 = (int)LuaScriptMgr.GetNumber(L, 4);
		int arg4 = (int)LuaScriptMgr.GetNumber(L, 5);
		Array.ConstrainedCopy(arg0,arg1,arg2,arg3,arg4);
		return 0;
	}
}

