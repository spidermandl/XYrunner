using System;
using UnityEngine;
using LuaInterface;

public class MathfWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Sin", Sin),
			new LuaMethod("Cos", Cos),
			new LuaMethod("Tan", Tan),
			new LuaMethod("Asin", Asin),
			new LuaMethod("Acos", Acos),
			new LuaMethod("Atan", Atan),
			new LuaMethod("Atan2", Atan2),
			new LuaMethod("Sqrt", Sqrt),
			new LuaMethod("Abs", Abs),
			new LuaMethod("Min", Min),
			new LuaMethod("Max", Max),
			new LuaMethod("Pow", Pow),
			new LuaMethod("Exp", Exp),
			new LuaMethod("Log", Log),
			new LuaMethod("Log10", Log10),
			new LuaMethod("Ceil", Ceil),
			new LuaMethod("Floor", Floor),
			new LuaMethod("Round", Round),
			new LuaMethod("CeilToInt", CeilToInt),
			new LuaMethod("FloorToInt", FloorToInt),
			new LuaMethod("RoundToInt", RoundToInt),
			new LuaMethod("Sign", Sign),
			new LuaMethod("Clamp", Clamp),
			new LuaMethod("Clamp01", Clamp01),
			new LuaMethod("Lerp", Lerp),
			new LuaMethod("LerpUnclamped", LerpUnclamped),
			new LuaMethod("LerpAngle", LerpAngle),
			new LuaMethod("MoveTowards", MoveTowards),
			new LuaMethod("MoveTowardsAngle", MoveTowardsAngle),
			new LuaMethod("SmoothStep", SmoothStep),
			new LuaMethod("Gamma", Gamma),
			new LuaMethod("Approximately", Approximately),
			new LuaMethod("SmoothDamp", SmoothDamp),
			new LuaMethod("SmoothDampAngle", SmoothDampAngle),
			new LuaMethod("Repeat", Repeat),
			new LuaMethod("PingPong", PingPong),
			new LuaMethod("InverseLerp", InverseLerp),
			new LuaMethod("ClosestPowerOfTwo", ClosestPowerOfTwo),
			new LuaMethod("GammaToLinearSpace", GammaToLinearSpace),
			new LuaMethod("LinearToGammaSpace", LinearToGammaSpace),
			new LuaMethod("IsPowerOfTwo", IsPowerOfTwo),
			new LuaMethod("NextPowerOfTwo", NextPowerOfTwo),
			new LuaMethod("DeltaAngle", DeltaAngle),
			new LuaMethod("PerlinNoise", PerlinNoise),
			new LuaMethod("FloatToHalf", FloatToHalf),
			new LuaMethod("HalfToFloat", HalfToFloat),
			new LuaMethod("New", _CreateMathf),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("PI", get_PI, null),
			new LuaField("Infinity", get_Infinity, null),
			new LuaField("NegativeInfinity", get_NegativeInfinity, null),
			new LuaField("Deg2Rad", get_Deg2Rad, null),
			new LuaField("Rad2Deg", get_Rad2Deg, null),
			new LuaField("Epsilon", get_Epsilon, null),
		};

		LuaScriptMgr.RegisterLib(L, "UnityEngine.Mathf", typeof(Mathf), regs, fields, null);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateMathf(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		Mathf obj = new Mathf();
		LuaScriptMgr.PushValue(L, obj);
		return 1;
	}

	static Type classType = typeof(Mathf);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_PI(IntPtr L)
	{
		LuaScriptMgr.Push(L, Mathf.PI);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Infinity(IntPtr L)
	{
		LuaScriptMgr.Push(L, Mathf.Infinity);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_NegativeInfinity(IntPtr L)
	{
		LuaScriptMgr.Push(L, Mathf.NegativeInfinity);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Deg2Rad(IntPtr L)
	{
		LuaScriptMgr.Push(L, Mathf.Deg2Rad);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Rad2Deg(IntPtr L)
	{
		LuaScriptMgr.Push(L, Mathf.Rad2Deg);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Epsilon(IntPtr L)
	{
		LuaScriptMgr.Push(L, Mathf.Epsilon);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Sin(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Sin(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Cos(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Cos(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Tan(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Tan(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Asin(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Asin(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Acos(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Acos(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Atan(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Atan(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Atan2(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float o = Mathf.Atan2(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Sqrt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Sqrt(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Abs(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Abs(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Min(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
			int o = Mathf.Min(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(float), typeof(float)))
		{
			float arg0 = (float)LuaDLL.lua_tonumber(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float o = Mathf.Min(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckParamsType(L, typeof(int), 1, count))
		{
			int[] objs0 = LuaScriptMgr.GetArrayNumber<int>(L, 1);
			int o = Mathf.Min(objs0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckParamsType(L, typeof(float), 1, count))
		{
			float[] objs0 = LuaScriptMgr.GetArrayNumber<float>(L, 1);
			float o = Mathf.Min(objs0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Mathf.Min");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Max(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
			int o = Mathf.Max(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2 && LuaScriptMgr.CheckTypes(L, 1, typeof(float), typeof(float)))
		{
			float arg0 = (float)LuaDLL.lua_tonumber(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float o = Mathf.Max(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckParamsType(L, typeof(int), 1, count))
		{
			int[] objs0 = LuaScriptMgr.GetArrayNumber<int>(L, 1);
			int o = Mathf.Max(objs0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (LuaScriptMgr.CheckParamsType(L, typeof(float), 1, count))
		{
			float[] objs0 = LuaScriptMgr.GetArrayNumber<float>(L, 1);
			float o = Mathf.Max(objs0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Mathf.Max");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Pow(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float o = Mathf.Pow(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Exp(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Exp(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Log(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 1)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float o = Mathf.Log(arg0);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 2)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			float o = Mathf.Log(arg0,arg1);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Mathf.Log");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Log10(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Log10(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Ceil(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Ceil(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Floor(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Floor(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Round(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Round(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CeilToInt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		int o = Mathf.CeilToInt(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FloorToInt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		int o = Mathf.FloorToInt(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RoundToInt(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		int o = Mathf.RoundToInt(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Sign(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Sign(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clamp(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(int), typeof(int), typeof(int)))
		{
			int arg0 = (int)LuaDLL.lua_tonumber(L, 1);
			int arg1 = (int)LuaDLL.lua_tonumber(L, 2);
			int arg2 = (int)LuaDLL.lua_tonumber(L, 3);
			int o = Mathf.Clamp(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else if (count == 3 && LuaScriptMgr.CheckTypes(L, 1, typeof(float), typeof(float), typeof(float)))
		{
			float arg0 = (float)LuaDLL.lua_tonumber(L, 1);
			float arg1 = (float)LuaDLL.lua_tonumber(L, 2);
			float arg2 = (float)LuaDLL.lua_tonumber(L, 3);
			float o = Mathf.Clamp(arg0,arg1,arg2);
			LuaScriptMgr.Push(L, o);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Mathf.Clamp");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clamp01(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.Clamp01(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Lerp(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.Lerp(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LerpUnclamped(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.LerpUnclamped(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LerpAngle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.LerpAngle(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MoveTowards(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.MoveTowards(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int MoveTowardsAngle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.MoveTowardsAngle(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SmoothStep(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.SmoothStep(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Gamma(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.Gamma(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Approximately(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		bool o = Mathf.Approximately(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SmoothDamp(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNetObject(L, 3, typeof(float));
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			float o = Mathf.SmoothDamp(arg0,arg1,ref arg2,arg3);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.Push(L, arg2);
			return 2;
		}
		else if (count == 5)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNetObject(L, 3, typeof(float));
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
			float o = Mathf.SmoothDamp(arg0,arg1,ref arg2,arg3,arg4);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.Push(L, arg2);
			return 2;
		}
		else if (count == 6)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNetObject(L, 3, typeof(float));
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
			float arg5 = (float)LuaScriptMgr.GetNumber(L, 6);
			float o = Mathf.SmoothDamp(arg0,arg1,ref arg2,arg3,arg4,arg5);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.Push(L, arg2);
			return 2;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Mathf.SmoothDamp");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SmoothDampAngle(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 4)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNetObject(L, 3, typeof(float));
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			float o = Mathf.SmoothDampAngle(arg0,arg1,ref arg2,arg3);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.Push(L, arg2);
			return 2;
		}
		else if (count == 5)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNetObject(L, 3, typeof(float));
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
			float o = Mathf.SmoothDampAngle(arg0,arg1,ref arg2,arg3,arg4);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.Push(L, arg2);
			return 2;
		}
		else if (count == 6)
		{
			float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
			float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
			float arg2 = (float)LuaScriptMgr.GetNetObject(L, 3, typeof(float));
			float arg3 = (float)LuaScriptMgr.GetNumber(L, 4);
			float arg4 = (float)LuaScriptMgr.GetNumber(L, 5);
			float arg5 = (float)LuaScriptMgr.GetNumber(L, 6);
			float o = Mathf.SmoothDampAngle(arg0,arg1,ref arg2,arg3,arg4,arg5);
			LuaScriptMgr.Push(L, o);
			LuaScriptMgr.Push(L, arg2);
			return 2;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: Mathf.SmoothDampAngle");
		}

		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Repeat(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float o = Mathf.Repeat(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PingPong(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float o = Mathf.PingPong(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InverseLerp(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float arg2 = (float)LuaScriptMgr.GetNumber(L, 3);
		float o = Mathf.InverseLerp(arg0,arg1,arg2);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ClosestPowerOfTwo(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		int o = Mathf.ClosestPowerOfTwo(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GammaToLinearSpace(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.GammaToLinearSpace(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int LinearToGammaSpace(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.LinearToGammaSpace(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsPowerOfTwo(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		bool o = Mathf.IsPowerOfTwo(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int NextPowerOfTwo(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		int o = Mathf.NextPowerOfTwo(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int DeltaAngle(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float o = Mathf.DeltaAngle(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int PerlinNoise(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		float arg1 = (float)LuaScriptMgr.GetNumber(L, 2);
		float o = Mathf.PerlinNoise(arg0,arg1);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FloatToHalf(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		float arg0 = (float)LuaScriptMgr.GetNumber(L, 1);
		ushort o = Mathf.FloatToHalf(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int HalfToFloat(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		ushort arg0 = (ushort)LuaScriptMgr.GetNumber(L, 1);
		float o = Mathf.HalfToFloat(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}
}

