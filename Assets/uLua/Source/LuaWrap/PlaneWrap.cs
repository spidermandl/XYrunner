﻿using System;
using UnityEngine;
using LuaInterface;

public class PlaneWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("SetNormalAndPosition", SetNormalAndPosition),
			new LuaMethod("Set3Points", Set3Points),
			new LuaMethod("GetDistanceToPoint", GetDistanceToPoint),
			new LuaMethod("GetSide", GetSide),
			new LuaMethod("SameSide", SameSide),
			new LuaMethod("Raycast", Raycast),
			new LuaMethod("New", _CreatePlane),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("normal", get_normal, set_normal),
			new LuaField("distance", get_distance, set_distance),
		};

		LuaScriptMgr.RegisterLib(L, "UnityEngine.Plane", typeof(Plane), regs, fields, null);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreatePlane(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(LuaTable), typeof(float)))
		{
			Vector3 arg0 = LuaScriptMgr.GetVector3(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			Plane obj = new Plane(arg0,arg1);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(LuaTable), typeof(LuaTable)))
		{
			Vector3 arg0 = LuaScriptMgr.GetVector3(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			Plane obj = new Plane(arg0,arg1);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 3)
		{
			Vector3 arg0 = LuaScriptMgr.GetVector3(L, 1);
			Vector3 arg1 = LuaScriptMgr.GetVector3(L, 2);
			Vector3 arg2 = LuaScriptMgr.GetVector3(L, 3);
			Plane obj = new Plane(arg0,arg1,arg2);
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else if (count == 0)
		{
			Plane obj = new Plane();
			LuaScriptMgr.PushValue(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Plane.New");
		}

		return 0;
	}

	static Type classType = typeof(Plane);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_normal(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name normal");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index normal on a nil value");
			}
		}

		Plane obj = (Plane)o;
		LuaScriptMgr.Push(L, obj.normal);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_distance(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name distance");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index distance on a nil value");
			}
		}

		Plane obj = (Plane)o;
		LuaScriptMgr.Push(L, obj.distance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_normal(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name normal");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index normal on a nil value");
			}
		}

		Plane obj = (Plane)o;
		obj.normal = LuaScriptMgr.GetVector3(L, 3);
		LuaScriptMgr.SetValueObject(L, 1, obj);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_distance(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);

		if (o == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name distance");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index distance on a nil value");
			}
		}

		Plane obj = (Plane)o;
		obj.distance = (float)LuaScriptMgr.GetNumber(L, 3);
		LuaScriptMgr.SetValueObject(L, 1, obj);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetNormalAndPosition(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Plane obj = (Plane)LuaScriptMgr.GetNetObjectSelf(L, 1, "Plane");
		Vector3 arg0 = LuaScriptMgr.GetVector3(L, 2);
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 3);
		obj.SetNormalAndPosition(arg0,arg1);
		LuaScriptMgr.SetValueObject(L, 1, obj);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Set3Points(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		Plane obj = (Plane)LuaScriptMgr.GetNetObjectSelf(L, 1, "Plane");
		Vector3 arg0 = LuaScriptMgr.GetVector3(L, 2);
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 3);
		Vector3 arg2 = LuaScriptMgr.GetVector3(L, 4);
		obj.Set3Points(arg0,arg1,arg2);
		LuaScriptMgr.SetValueObject(L, 1, obj);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetDistanceToPoint(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Plane obj = (Plane)LuaScriptMgr.GetNetObjectSelf(L, 1, "Plane");
		Vector3 arg0 = LuaScriptMgr.GetVector3(L, 2);
		float o = obj.GetDistanceToPoint(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetSide(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		Plane obj = (Plane)LuaScriptMgr.GetNetObjectSelf(L, 1, "Plane");
		Vector3 arg0 = LuaScriptMgr.GetVector3(L, 2);
		bool o = obj.GetSide(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SameSide(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Plane obj = (Plane)LuaScriptMgr.GetNetObjectSelf(L, 1, "Plane");
		Vector3 arg0 = LuaScriptMgr.GetVector3(L, 2);
		Vector3 arg1 = LuaScriptMgr.GetVector3(L, 3);
		bool o = obj.SameSide(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Raycast(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		Plane obj = (Plane)LuaScriptMgr.GetNetObjectSelf(L, 1, "Plane");
		Ray arg0 = LuaScriptMgr.GetRay(L, 2);
		float arg1;
		bool o = obj.Raycast(arg0,out arg1);
		LuaScriptMgr.Push(L, o);
		LuaScriptMgr.Push(L, arg1);
		return 2;
	}
}

