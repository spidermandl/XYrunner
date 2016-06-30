using System;
using LuaInterface;

public class DataCollectorWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Start", Start),
			new LuaMethod("Update", Update),
			new LuaMethod("OnDestroy", OnDestroy),
			new LuaMethod("SetAccount", SetAccount),
			new LuaMethod("SetAccountType", SetAccountType),
			new LuaMethod("SetAccountName", SetAccountName),
			new LuaMethod("SetLevel", SetLevel),
			new LuaMethod("SetGender", SetGender),
			new LuaMethod("SetGameServer", SetGameServer),
			new LuaMethod("OnChargeRequest", OnChargeRequest),
			new LuaMethod("OnChargeSuccess", OnChargeSuccess),
			new LuaMethod("OnRewrd", OnRewrd),
			new LuaMethod("OnPurchase", OnPurchase),
			new LuaMethod("OnUse", OnUse),
			new LuaMethod("OnBegin", OnBegin),
			new LuaMethod("OnCompleted", OnCompleted),
			new LuaMethod("OnFailed", OnFailed),
			new LuaMethod("New", _CreateDataCollector),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("Instance", get_Instance, null),
		};

		LuaScriptMgr.RegisterLib(L, "DataCollector", typeof(DataCollector), regs, fields, typeof(object));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDataCollector(IntPtr L)
	{
		int count = LuaDLL.lua_gettop(L);

		if (count == 0)
		{
			DataCollector obj = new DataCollector();
			LuaScriptMgr.PushObject(L, obj);
			return 1;
		}
		else
		{
			LuaDLL.luaL_error(L, "invalid arguments to method: DataCollector.New");
		}

		return 0;
	}

	static Type classType = typeof(DataCollector);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_Instance(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, DataCollector.Instance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Start(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DataCollector obj = (DataCollector)LuaScriptMgr.GetNetObjectSelf(L, 1, "DataCollector");
		obj.Start();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Update(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DataCollector obj = (DataCollector)LuaScriptMgr.GetNetObjectSelf(L, 1, "DataCollector");
		obj.Update();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnDestroy(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		DataCollector obj = (DataCollector)LuaScriptMgr.GetNetObjectSelf(L, 1, "DataCollector");
		obj.OnDestroy();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAccount(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		DataCollector.SetAccount(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAccountType(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		DataCollector.SetAccountType(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetAccountName(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		DataCollector.SetAccountName(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLevel(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		DataCollector.SetLevel(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetGender(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		DataCollector.SetGender(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetGameServer(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		DataCollector.SetGameServer(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnChargeRequest(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 4);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		double arg2 = (double)LuaScriptMgr.GetNumber(L, 3);
		string arg3 = LuaScriptMgr.GetLuaString(L, 4);
		DataCollector.OnChargeRequest(arg0,arg1,arg2,arg3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnChargeSuccess(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		DataCollector.OnChargeSuccess(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnRewrd(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		double arg0 = (double)LuaScriptMgr.GetNumber(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		DataCollector.OnRewrd(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnPurchase(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		double arg2 = (double)LuaScriptMgr.GetNumber(L, 3);
		DataCollector.OnPurchase(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnUse(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		int arg1 = (int)LuaScriptMgr.GetNumber(L, 2);
		DataCollector.OnUse(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnBegin(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		DataCollector.OnBegin(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnCompleted(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		DataCollector.OnCompleted(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int OnFailed(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		string arg0 = LuaScriptMgr.GetLuaString(L, 1);
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		DataCollector.OnFailed(arg0,arg1);
		return 0;
	}
}

