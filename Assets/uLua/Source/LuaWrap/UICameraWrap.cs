using System;
using UnityEngine;
using System.Collections.Generic;
using LuaInterface;
using Object = UnityEngine.Object;

public class UICameraWrap
{
	public static void Register(IntPtr L)
	{
		LuaMethod[] regs = new LuaMethod[]
		{
			new LuaMethod("IsPressed", IsPressed),
			new LuaMethod("CountInputSources", CountInputSources),
			new LuaMethod("Raycast", Raycast),
			new LuaMethod("IsHighlighted", IsHighlighted),
			new LuaMethod("FindCameraForLayer", FindCameraForLayer),
			new LuaMethod("Notify", Notify),
			new LuaMethod("GetMouse", GetMouse),
			new LuaMethod("GetTouch", GetTouch),
			new LuaMethod("RemoveTouch", RemoveTouch),
			new LuaMethod("ProcessMouse", ProcessMouse),
			new LuaMethod("ProcessTouches", ProcessTouches),
			new LuaMethod("ProcessOthers", ProcessOthers),
			new LuaMethod("ProcessTouch", ProcessTouch),
			new LuaMethod("ShowTooltip", ShowTooltip),
			new LuaMethod("New", _CreateUICamera),
			new LuaMethod("GetClassType", GetClassType),
			new LuaMethod("__eq", Lua_Eq),
		};

		LuaField[] fields = new LuaField[]
		{
			new LuaField("list", get_list, set_list),
			new LuaField("GetKeyDown", get_GetKeyDown, set_GetKeyDown),
			new LuaField("GetKeyUp", get_GetKeyUp, set_GetKeyUp),
			new LuaField("GetKey", get_GetKey, set_GetKey),
			new LuaField("GetAxis", get_GetAxis, set_GetAxis),
			new LuaField("onScreenResize", get_onScreenResize, set_onScreenResize),
			new LuaField("eventType", get_eventType, set_eventType),
			new LuaField("eventsGoToColliders", get_eventsGoToColliders, set_eventsGoToColliders),
			new LuaField("eventReceiverMask", get_eventReceiverMask, set_eventReceiverMask),
			new LuaField("debug", get_debug, set_debug),
			new LuaField("useMouse", get_useMouse, set_useMouse),
			new LuaField("useTouch", get_useTouch, set_useTouch),
			new LuaField("allowMultiTouch", get_allowMultiTouch, set_allowMultiTouch),
			new LuaField("useKeyboard", get_useKeyboard, set_useKeyboard),
			new LuaField("useController", get_useController, set_useController),
			new LuaField("stickyTooltip", get_stickyTooltip, set_stickyTooltip),
			new LuaField("tooltipDelay", get_tooltipDelay, set_tooltipDelay),
			new LuaField("longPressTooltip", get_longPressTooltip, set_longPressTooltip),
			new LuaField("mouseDragThreshold", get_mouseDragThreshold, set_mouseDragThreshold),
			new LuaField("mouseClickThreshold", get_mouseClickThreshold, set_mouseClickThreshold),
			new LuaField("touchDragThreshold", get_touchDragThreshold, set_touchDragThreshold),
			new LuaField("touchClickThreshold", get_touchClickThreshold, set_touchClickThreshold),
			new LuaField("rangeDistance", get_rangeDistance, set_rangeDistance),
			new LuaField("scrollAxisName", get_scrollAxisName, set_scrollAxisName),
			new LuaField("verticalAxisName", get_verticalAxisName, set_verticalAxisName),
			new LuaField("horizontalAxisName", get_horizontalAxisName, set_horizontalAxisName),
			new LuaField("commandClick", get_commandClick, set_commandClick),
			new LuaField("submitKey0", get_submitKey0, set_submitKey0),
			new LuaField("submitKey1", get_submitKey1, set_submitKey1),
			new LuaField("cancelKey0", get_cancelKey0, set_cancelKey0),
			new LuaField("cancelKey1", get_cancelKey1, set_cancelKey1),
			new LuaField("onCustomInput", get_onCustomInput, set_onCustomInput),
			new LuaField("showTooltips", get_showTooltips, set_showTooltips),
			new LuaField("lastTouchPosition", get_lastTouchPosition, set_lastTouchPosition),
			new LuaField("lastWorldPosition", get_lastWorldPosition, set_lastWorldPosition),
			new LuaField("lastHit", get_lastHit, set_lastHit),
			new LuaField("current", get_current, set_current),
			new LuaField("currentCamera", get_currentCamera, set_currentCamera),
			new LuaField("currentScheme", get_currentScheme, set_currentScheme),
			new LuaField("currentTouchID", get_currentTouchID, set_currentTouchID),
			new LuaField("currentKey", get_currentKey, set_currentKey),
			new LuaField("currentTouch", get_currentTouch, set_currentTouch),
			new LuaField("inputHasFocus", get_inputHasFocus, set_inputHasFocus),
			new LuaField("fallThrough", get_fallThrough, set_fallThrough),
			new LuaField("onClick", get_onClick, set_onClick),
			new LuaField("onDoubleClick", get_onDoubleClick, set_onDoubleClick),
			new LuaField("onHover", get_onHover, set_onHover),
			new LuaField("onPress", get_onPress, set_onPress),
			new LuaField("onSelect", get_onSelect, set_onSelect),
			new LuaField("onScroll", get_onScroll, set_onScroll),
			new LuaField("onDrag", get_onDrag, set_onDrag),
			new LuaField("onDragStart", get_onDragStart, set_onDragStart),
			new LuaField("onDragOver", get_onDragOver, set_onDragOver),
			new LuaField("onDragOut", get_onDragOut, set_onDragOut),
			new LuaField("onDragEnd", get_onDragEnd, set_onDragEnd),
			new LuaField("onDrop", get_onDrop, set_onDrop),
			new LuaField("onKey", get_onKey, set_onKey),
			new LuaField("onTooltip", get_onTooltip, set_onTooltip),
			new LuaField("onMouseMove", get_onMouseMove, set_onMouseMove),
			new LuaField("controller", get_controller, set_controller),
			new LuaField("activeTouches", get_activeTouches, set_activeTouches),
			new LuaField("isDragging", get_isDragging, set_isDragging),
			new LuaField("hoveredObject", get_hoveredObject, set_hoveredObject),
			new LuaField("GetInputTouchCount", get_GetInputTouchCount, set_GetInputTouchCount),
			new LuaField("GetInputTouch", get_GetInputTouch, set_GetInputTouch),
			new LuaField("currentRay", get_currentRay, null),
			new LuaField("cachedCamera", get_cachedCamera, null),
			new LuaField("isOverUI", get_isOverUI, null),
			new LuaField("selectedObject", get_selectedObject, set_selectedObject),
			new LuaField("dragCount", get_dragCount, null),
			new LuaField("mainCamera", get_mainCamera, null),
			new LuaField("eventHandler", get_eventHandler, null),
		};

		LuaScriptMgr.RegisterLib(L, "UICamera", typeof(UICamera), regs, fields, typeof(MonoBehaviour));
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateUICamera(IntPtr L)
	{
		LuaDLL.luaL_error(L, "UICamera class does not have a constructor function");
		return 0;
	}

	static Type classType = typeof(UICamera);

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetClassType(IntPtr L)
	{
		LuaScriptMgr.Push(L, classType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_list(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, UICamera.list);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetKeyDown(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.GetKeyDown);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetKeyUp(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.GetKeyUp);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetKey(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.GetKey);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetAxis(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.GetAxis);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onScreenResize(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onScreenResize);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_eventType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name eventType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index eventType on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.eventType);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_eventsGoToColliders(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name eventsGoToColliders");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index eventsGoToColliders on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.eventsGoToColliders);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_eventReceiverMask(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name eventReceiverMask");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index eventReceiverMask on a nil value");
			}
		}

		LuaScriptMgr.PushValue(L, obj.eventReceiverMask);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_debug(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name debug");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index debug on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.debug);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useMouse(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useMouse");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useMouse on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.useMouse);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useTouch(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useTouch");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useTouch on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.useTouch);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_allowMultiTouch(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name allowMultiTouch");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index allowMultiTouch on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.allowMultiTouch);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useKeyboard(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useKeyboard");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useKeyboard on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.useKeyboard);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_useController(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useController");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useController on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.useController);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_stickyTooltip(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name stickyTooltip");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index stickyTooltip on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.stickyTooltip);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_tooltipDelay(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name tooltipDelay");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index tooltipDelay on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.tooltipDelay);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_longPressTooltip(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name longPressTooltip");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index longPressTooltip on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.longPressTooltip);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_mouseDragThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name mouseDragThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index mouseDragThreshold on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.mouseDragThreshold);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_mouseClickThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name mouseClickThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index mouseClickThreshold on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.mouseClickThreshold);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_touchDragThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name touchDragThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index touchDragThreshold on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.touchDragThreshold);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_touchClickThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name touchClickThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index touchClickThreshold on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.touchClickThreshold);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_rangeDistance(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name rangeDistance");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index rangeDistance on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.rangeDistance);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_scrollAxisName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name scrollAxisName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index scrollAxisName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.scrollAxisName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_verticalAxisName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name verticalAxisName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index verticalAxisName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.verticalAxisName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_horizontalAxisName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name horizontalAxisName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index horizontalAxisName on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.horizontalAxisName);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_commandClick(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name commandClick");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index commandClick on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.commandClick);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_submitKey0(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name submitKey0");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index submitKey0 on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.submitKey0);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_submitKey1(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name submitKey1");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index submitKey1 on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.submitKey1);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_cancelKey0(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name cancelKey0");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index cancelKey0 on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.cancelKey0);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_cancelKey1(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name cancelKey1");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index cancelKey1 on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.cancelKey1);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onCustomInput(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onCustomInput);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_showTooltips(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.showTooltips);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lastTouchPosition(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.lastTouchPosition);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lastWorldPosition(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.lastWorldPosition);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_lastHit(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.lastHit);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_current(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.current);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_currentCamera(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.currentCamera);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_currentScheme(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.currentScheme);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_currentTouchID(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.currentTouchID);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_currentKey(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.currentKey);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_currentTouch(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, UICamera.currentTouch);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_inputHasFocus(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.inputHasFocus);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_fallThrough(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.fallThrough);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onClick(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onClick);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDoubleClick(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onDoubleClick);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onHover(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onHover);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onPress(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onPress);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onSelect(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onSelect);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onScroll(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onScroll);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDrag(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onDrag);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragStart(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onDragStart);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragOver(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onDragOver);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragOut(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onDragOut);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDragEnd(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onDragEnd);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onDrop(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onDrop);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onKey(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onKey);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onTooltip(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onTooltip);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_onMouseMove(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.onMouseMove);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_controller(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, UICamera.controller);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_activeTouches(IntPtr L)
	{
		LuaScriptMgr.PushObject(L, UICamera.activeTouches);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isDragging(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.isDragging);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_hoveredObject(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.hoveredObject);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetInputTouchCount(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.GetInputTouchCount);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_GetInputTouch(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.GetInputTouch);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_currentRay(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.currentRay);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_cachedCamera(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name cachedCamera");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index cachedCamera on a nil value");
			}
		}

		LuaScriptMgr.Push(L, obj.cachedCamera);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isOverUI(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.isOverUI);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_selectedObject(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.selectedObject);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_dragCount(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.dragCount);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_mainCamera(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.mainCamera);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_eventHandler(IntPtr L)
	{
		LuaScriptMgr.Push(L, UICamera.eventHandler);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_list(IntPtr L)
	{
		UICamera.list = (BetterList<UICamera>)LuaScriptMgr.GetNetObject(L, 3, typeof(BetterList<UICamera>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetKeyDown(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.GetKeyDown = (UICamera.GetKeyStateFunc)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.GetKeyStateFunc));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.GetKeyDown = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				object[] objs = func.PopValues(top);
				func.EndPCall(top);
				return (bool)objs[0];
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetKeyUp(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.GetKeyUp = (UICamera.GetKeyStateFunc)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.GetKeyStateFunc));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.GetKeyUp = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				object[] objs = func.PopValues(top);
				func.EndPCall(top);
				return (bool)objs[0];
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetKey(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.GetKey = (UICamera.GetKeyStateFunc)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.GetKeyStateFunc));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.GetKey = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				object[] objs = func.PopValues(top);
				func.EndPCall(top);
				return (bool)objs[0];
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetAxis(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.GetAxis = (UICamera.GetAxisFunc)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.GetAxisFunc));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.GetAxis = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				object[] objs = func.PopValues(top);
				func.EndPCall(top);
				return (float)objs[0];
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onScreenResize(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onScreenResize = (UICamera.OnScreenResize)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.OnScreenResize));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onScreenResize = () =>
			{
				func.Call();
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_eventType(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name eventType");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index eventType on a nil value");
			}
		}

		obj.eventType = (UICamera.EventType)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.EventType));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_eventsGoToColliders(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name eventsGoToColliders");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index eventsGoToColliders on a nil value");
			}
		}

		obj.eventsGoToColliders = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_eventReceiverMask(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name eventReceiverMask");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index eventReceiverMask on a nil value");
			}
		}

		obj.eventReceiverMask = (LayerMask)LuaScriptMgr.GetNetObject(L, 3, typeof(LayerMask));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_debug(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name debug");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index debug on a nil value");
			}
		}

		obj.debug = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useMouse(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useMouse");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useMouse on a nil value");
			}
		}

		obj.useMouse = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useTouch(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useTouch");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useTouch on a nil value");
			}
		}

		obj.useTouch = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_allowMultiTouch(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name allowMultiTouch");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index allowMultiTouch on a nil value");
			}
		}

		obj.allowMultiTouch = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useKeyboard(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useKeyboard");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useKeyboard on a nil value");
			}
		}

		obj.useKeyboard = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_useController(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name useController");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index useController on a nil value");
			}
		}

		obj.useController = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_stickyTooltip(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name stickyTooltip");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index stickyTooltip on a nil value");
			}
		}

		obj.stickyTooltip = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_tooltipDelay(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name tooltipDelay");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index tooltipDelay on a nil value");
			}
		}

		obj.tooltipDelay = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_longPressTooltip(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name longPressTooltip");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index longPressTooltip on a nil value");
			}
		}

		obj.longPressTooltip = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_mouseDragThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name mouseDragThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index mouseDragThreshold on a nil value");
			}
		}

		obj.mouseDragThreshold = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_mouseClickThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name mouseClickThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index mouseClickThreshold on a nil value");
			}
		}

		obj.mouseClickThreshold = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_touchDragThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name touchDragThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index touchDragThreshold on a nil value");
			}
		}

		obj.touchDragThreshold = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_touchClickThreshold(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name touchClickThreshold");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index touchClickThreshold on a nil value");
			}
		}

		obj.touchClickThreshold = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_rangeDistance(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name rangeDistance");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index rangeDistance on a nil value");
			}
		}

		obj.rangeDistance = (float)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_scrollAxisName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name scrollAxisName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index scrollAxisName on a nil value");
			}
		}

		obj.scrollAxisName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_verticalAxisName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name verticalAxisName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index verticalAxisName on a nil value");
			}
		}

		obj.verticalAxisName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_horizontalAxisName(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name horizontalAxisName");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index horizontalAxisName on a nil value");
			}
		}

		obj.horizontalAxisName = LuaScriptMgr.GetString(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_commandClick(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name commandClick");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index commandClick on a nil value");
			}
		}

		obj.commandClick = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_submitKey0(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name submitKey0");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index submitKey0 on a nil value");
			}
		}

		obj.submitKey0 = (KeyCode)LuaScriptMgr.GetNetObject(L, 3, typeof(KeyCode));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_submitKey1(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name submitKey1");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index submitKey1 on a nil value");
			}
		}

		obj.submitKey1 = (KeyCode)LuaScriptMgr.GetNetObject(L, 3, typeof(KeyCode));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_cancelKey0(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name cancelKey0");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index cancelKey0 on a nil value");
			}
		}

		obj.cancelKey0 = (KeyCode)LuaScriptMgr.GetNetObject(L, 3, typeof(KeyCode));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_cancelKey1(IntPtr L)
	{
		object o = LuaScriptMgr.GetLuaObject(L, 1);
		UICamera obj = (UICamera)o;

		if (obj == null)
		{
			LuaTypes types = LuaDLL.lua_type(L, 1);

			if (types == LuaTypes.LUA_TTABLE)
			{
				LuaDLL.luaL_error(L, "unknown member name cancelKey1");
			}
			else
			{
				LuaDLL.luaL_error(L, "attempt to index cancelKey1 on a nil value");
			}
		}

		obj.cancelKey1 = (KeyCode)LuaScriptMgr.GetNetObject(L, 3, typeof(KeyCode));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onCustomInput(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onCustomInput = (UICamera.OnCustomInput)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.OnCustomInput));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onCustomInput = () =>
			{
				func.Call();
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_showTooltips(IntPtr L)
	{
		UICamera.showTooltips = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_lastTouchPosition(IntPtr L)
	{
		UICamera.lastTouchPosition = LuaScriptMgr.GetVector2(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_lastWorldPosition(IntPtr L)
	{
		UICamera.lastWorldPosition = LuaScriptMgr.GetVector3(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_lastHit(IntPtr L)
	{
		UICamera.lastHit = (RaycastHit)LuaScriptMgr.GetNetObject(L, 3, typeof(RaycastHit));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_current(IntPtr L)
	{
		UICamera.current = (UICamera)LuaScriptMgr.GetUnityObject(L, 3, typeof(UICamera));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_currentCamera(IntPtr L)
	{
		UICamera.currentCamera = (Camera)LuaScriptMgr.GetUnityObject(L, 3, typeof(Camera));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_currentScheme(IntPtr L)
	{
		UICamera.currentScheme = (UICamera.ControlScheme)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.ControlScheme));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_currentTouchID(IntPtr L)
	{
		UICamera.currentTouchID = (int)LuaScriptMgr.GetNumber(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_currentKey(IntPtr L)
	{
		UICamera.currentKey = (KeyCode)LuaScriptMgr.GetNetObject(L, 3, typeof(KeyCode));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_currentTouch(IntPtr L)
	{
		UICamera.currentTouch = (UICamera.MouseOrTouch)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.MouseOrTouch));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_inputHasFocus(IntPtr L)
	{
		UICamera.inputHasFocus = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_fallThrough(IntPtr L)
	{
		UICamera.fallThrough = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onClick(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onClick = (UICamera.VoidDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.VoidDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onClick = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDoubleClick(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onDoubleClick = (UICamera.VoidDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.VoidDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onDoubleClick = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onHover(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onHover = (UICamera.BoolDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.BoolDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onHover = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onPress(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onPress = (UICamera.BoolDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.BoolDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onPress = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onSelect(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onSelect = (UICamera.BoolDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.BoolDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onSelect = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onScroll(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onScroll = (UICamera.FloatDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.FloatDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onScroll = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDrag(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onDrag = (UICamera.VectorDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.VectorDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onDrag = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragStart(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onDragStart = (UICamera.VoidDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.VoidDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onDragStart = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragOver(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onDragOver = (UICamera.ObjectDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.ObjectDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onDragOver = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragOut(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onDragOut = (UICamera.ObjectDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.ObjectDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onDragOut = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDragEnd(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onDragEnd = (UICamera.VoidDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.VoidDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onDragEnd = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onDrop(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onDrop = (UICamera.ObjectDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.ObjectDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onDrop = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onKey(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onKey = (UICamera.KeyCodeDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.KeyCodeDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onKey = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onTooltip(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onTooltip = (UICamera.BoolDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.BoolDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onTooltip = (param0, param1) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				LuaScriptMgr.Push(L, param1);
				func.PCall(top, 2);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_onMouseMove(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.onMouseMove = (UICamera.MoveDelegate)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.MoveDelegate));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.onMouseMove = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				func.EndPCall(top);
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_controller(IntPtr L)
	{
		UICamera.controller = (UICamera.MouseOrTouch)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.MouseOrTouch));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_activeTouches(IntPtr L)
	{
		UICamera.activeTouches = (List<UICamera.MouseOrTouch>)LuaScriptMgr.GetNetObject(L, 3, typeof(List<UICamera.MouseOrTouch>));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isDragging(IntPtr L)
	{
		UICamera.isDragging = LuaScriptMgr.GetBoolean(L, 3);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_hoveredObject(IntPtr L)
	{
		UICamera.hoveredObject = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetInputTouchCount(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.GetInputTouchCount = (UICamera.GetTouchCountCallback)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.GetTouchCountCallback));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.GetInputTouchCount = () =>
			{
				object[] objs = func.Call();
				return (int)objs[0];
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_GetInputTouch(IntPtr L)
	{
		LuaTypes funcType = LuaDLL.lua_type(L, 3);

		if (funcType != LuaTypes.LUA_TFUNCTION)
		{
			UICamera.GetInputTouch = (UICamera.GetTouchCallback)LuaScriptMgr.GetNetObject(L, 3, typeof(UICamera.GetTouchCallback));
		}
		else
		{
			LuaFunction func = LuaScriptMgr.ToLuaFunction(L, 3);
			UICamera.GetInputTouch = (param0) =>
			{
				int top = func.BeginPCall();
				LuaScriptMgr.Push(L, param0);
				func.PCall(top, 1);
				object[] objs = func.PopValues(top);
				func.EndPCall(top);
				return (UICamera.Touch)objs[0];
			};
		}
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_selectedObject(IntPtr L)
	{
		UICamera.selectedObject = (GameObject)LuaScriptMgr.GetUnityObject(L, 3, typeof(GameObject));
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsPressed(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 1, typeof(GameObject));
		bool o = UICamera.IsPressed(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int CountInputSources(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 0);
		int o = UICamera.CountInputSources();
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Raycast(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		Vector3 arg0 = LuaScriptMgr.GetVector3(L, 1);
		bool o = UICamera.Raycast(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int IsHighlighted(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 1, typeof(GameObject));
		bool o = UICamera.IsHighlighted(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int FindCameraForLayer(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		UICamera o = UICamera.FindCameraForLayer(arg0);
		LuaScriptMgr.Push(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int Notify(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		GameObject arg0 = (GameObject)LuaScriptMgr.GetUnityObject(L, 1, typeof(GameObject));
		string arg1 = LuaScriptMgr.GetLuaString(L, 2);
		object arg2 = LuaScriptMgr.GetVarObject(L, 3);
		UICamera.Notify(arg0,arg1,arg2);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetMouse(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		UICamera.MouseOrTouch o = UICamera.GetMouse(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int GetTouch(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		UICamera.MouseOrTouch o = UICamera.GetTouch(arg0);
		LuaScriptMgr.PushObject(L, o);
		return 1;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int RemoveTouch(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		int arg0 = (int)LuaScriptMgr.GetNumber(L, 1);
		UICamera.RemoveTouch(arg0);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessMouse(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UICamera obj = (UICamera)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UICamera");
		obj.ProcessMouse();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessTouches(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UICamera obj = (UICamera)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UICamera");
		obj.ProcessTouches();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessOthers(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 1);
		UICamera obj = (UICamera)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UICamera");
		obj.ProcessOthers();
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ProcessTouch(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 3);
		UICamera obj = (UICamera)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UICamera");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		bool arg1 = LuaScriptMgr.GetBoolean(L, 3);
		obj.ProcessTouch(arg0,arg1);
		return 0;
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int ShowTooltip(IntPtr L)
	{
		LuaScriptMgr.CheckArgsCount(L, 2);
		UICamera obj = (UICamera)LuaScriptMgr.GetUnityObjectSelf(L, 1, "UICamera");
		bool arg0 = LuaScriptMgr.GetBoolean(L, 2);
		obj.ShowTooltip(arg0);
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

