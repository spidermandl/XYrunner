using System;
using LuaInterface;

public class DelegateFactoryWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("Action_GameObject", Action_GameObject),
			new LuaMethod("Action", Action),
			new LuaMethod("UnityEngine_Events_UnityAction", UnityEngine_Events_UnityAction),
			new LuaMethod("System_Reflection_MemberFilter", System_Reflection_MemberFilter),
			new LuaMethod("System_Reflection_TypeFilter", System_Reflection_TypeFilter),
			new LuaMethod("UIEventListener_VoidDelegate", UIEventListener_VoidDelegate),
			new LuaMethod("UIEventListener_BoolDelegate", UIEventListener_BoolDelegate),
			new LuaMethod("UIEventListener_FloatDelegate", UIEventListener_FloatDelegate),
			new LuaMethod("UIEventListener_VectorDelegate", UIEventListener_VectorDelegate),
			new LuaMethod("UIEventListener_ObjectDelegate", UIEventListener_ObjectDelegate),
			new LuaMethod("UIEventListener_KeyCodeDelegate", UIEventListener_KeyCodeDelegate),
			new LuaMethod("UIPanel_OnGeometryUpdated", UIPanel_OnGeometryUpdated),
			new LuaMethod("UIPanel_OnClippingMoved", UIPanel_OnClippingMoved),
			new LuaMethod("UIWidget_OnDimensionsChanged", UIWidget_OnDimensionsChanged),
			new LuaMethod("UIWidget_OnPostFillCallback", UIWidget_OnPostFillCallback),
			new LuaMethod("UIDrawCall_OnRenderCallback", UIDrawCall_OnRenderCallback),
			new LuaMethod("UIWidget_HitCheck", UIWidget_HitCheck),
			new LuaMethod("UIGrid_OnReposition", UIGrid_OnReposition),
			new LuaMethod("Comparison_Transform", Comparison_Transform),
			new LuaMethod("TestLuaDelegate_VoidDelegate", TestLuaDelegate_VoidDelegate),
			new LuaMethod("EventDelegate_Callback", EventDelegate_Callback),
			new LuaMethod("Camera_CameraCallback", Camera_CameraCallback),
			new LuaMethod("AudioClip_PCMReaderCallback", AudioClip_PCMReaderCallback),
			new LuaMethod("AudioClip_PCMSetPositionCallback", AudioClip_PCMSetPositionCallback),
			new LuaMethod("Application_LogCallback", Application_LogCallback),
			new LuaMethod("Application_AdvertisingIdentifierCallback", Application_AdvertisingIdentifierCallback),
			new LuaMethod("Display_DisplaysUpdatedDelegate", Display_DisplaysUpdatedDelegate),
			new LuaMethod("UICamera_GetKeyStateFunc", UICamera_GetKeyStateFunc),
			new LuaMethod("UICamera_GetAxisFunc", UICamera_GetAxisFunc),
			new LuaMethod("UICamera_OnScreenResize", UICamera_OnScreenResize),
			new LuaMethod("UICamera_OnCustomInput", UICamera_OnCustomInput),
			new LuaMethod("UICamera_VoidDelegate", UICamera_VoidDelegate),
			new LuaMethod("UICamera_BoolDelegate", UICamera_BoolDelegate),
			new LuaMethod("UICamera_FloatDelegate", UICamera_FloatDelegate),
			new LuaMethod("UICamera_VectorDelegate", UICamera_VectorDelegate),
			new LuaMethod("UICamera_ObjectDelegate", UICamera_ObjectDelegate),
			new LuaMethod("UICamera_KeyCodeDelegate", UICamera_KeyCodeDelegate),
			new LuaMethod("UICamera_MoveDelegate", UICamera_MoveDelegate),
			new LuaMethod("UICamera_GetTouchCountCallback", UICamera_GetTouchCountCallback),
			new LuaMethod("UICamera_GetTouchCallback", UICamera_GetTouchCallback),
			new LuaMethod("Localization_LoadFunction", Localization_LoadFunction),
			new LuaMethod("Localization_OnLocalizeNotification", Localization_OnLocalizeNotification),
			new LuaMethod("UIToggle_Validate", UIToggle_Validate),
			new LuaMethod("UIProgressBar_OnDragFinished", UIProgressBar_OnDragFinished),
			new LuaMethod("UIInput_OnValidate", UIInput_OnValidate),
			new LuaMethod("UIScrollView_OnDragNotification", UIScrollView_OnDragNotification),
			new LuaMethod("SpringPanel_OnFinished", SpringPanel_OnFinished),
			new LuaMethod("UICenterOnChild_OnCenterCallback", UICenterOnChild_OnCenterCallback),
			new LuaMethod("Clear", Clear),
			new LuaMethod("New", _CreateDelegateFactory),
			new LuaMethod("GetClassType", GetClassType),
		};

		LuaScriptMgr.RegisterLib(L, "DelegateFactory", regs);
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateDelegateFactory(IntPtr L)
	{
		LuaDLL.luaL_error(L, "DelegateFactory class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(DelegateFactory);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Action_GameObject(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Action_GameObject(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Action(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Action(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UnityEngine_Events_UnityAction(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UnityEngine_Events_UnityAction(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int System_Reflection_MemberFilter(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.System_Reflection_MemberFilter(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int System_Reflection_TypeFilter(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.System_Reflection_TypeFilter(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIEventListener_VoidDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIEventListener_VoidDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIEventListener_BoolDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIEventListener_BoolDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIEventListener_FloatDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIEventListener_FloatDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIEventListener_VectorDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIEventListener_VectorDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIEventListener_ObjectDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIEventListener_ObjectDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIEventListener_KeyCodeDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIEventListener_KeyCodeDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIPanel_OnGeometryUpdated(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIPanel_OnGeometryUpdated(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIPanel_OnClippingMoved(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIPanel_OnClippingMoved(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIWidget_OnDimensionsChanged(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIWidget_OnDimensionsChanged(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIWidget_OnPostFillCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIWidget_OnPostFillCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIDrawCall_OnRenderCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIDrawCall_OnRenderCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIWidget_HitCheck(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIWidget_HitCheck(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIGrid_OnReposition(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIGrid_OnReposition(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Comparison_Transform(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Comparison_Transform(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int TestLuaDelegate_VoidDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.TestLuaDelegate_VoidDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int EventDelegate_Callback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.EventDelegate_Callback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Camera_CameraCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Camera_CameraCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AudioClip_PCMReaderCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.AudioClip_PCMReaderCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int AudioClip_PCMSetPositionCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.AudioClip_PCMSetPositionCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Application_LogCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Application_LogCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Application_AdvertisingIdentifierCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Application_AdvertisingIdentifierCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Display_DisplaysUpdatedDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Display_DisplaysUpdatedDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_GetKeyStateFunc(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_GetKeyStateFunc(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_GetAxisFunc(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_GetAxisFunc(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_OnScreenResize(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_OnScreenResize(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_OnCustomInput(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_OnCustomInput(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_VoidDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_VoidDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_BoolDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_BoolDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_FloatDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_FloatDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_VectorDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_VectorDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_ObjectDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_ObjectDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_KeyCodeDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_KeyCodeDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_MoveDelegate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_MoveDelegate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_GetTouchCountCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_GetTouchCountCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICamera_GetTouchCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICamera_GetTouchCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Localization_LoadFunction(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Localization_LoadFunction(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Localization_OnLocalizeNotification(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.Localization_OnLocalizeNotification(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIToggle_Validate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIToggle_Validate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIProgressBar_OnDragFinished(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIProgressBar_OnDragFinished(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIInput_OnValidate(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIInput_OnValidate(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UIScrollView_OnDragNotification(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UIScrollView_OnDragNotification(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SpringPanel_OnFinished(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.SpringPanel_OnFinished(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int UICenterOnChild_OnCenterCallback(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		LuaFunction arg0 = LuaScriptMgr.GetLuaFunction(L, 1);
		Delegate o = DelegateFactory.UICenterOnChild_OnCenterCallback(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Clear(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		DelegateFactory.Clear();
		return 0;
	}
}

