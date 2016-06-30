--[[
author:hanli_xiong
渠道sdk回调 由Platform.cs调用
]]

require "game/platform/ActionBase"

ActionLogin = class(ActionBase)
ActionLogin.name = "ActionLogin"
ActionLogin.id = 1001

ActionPay = class(ActionBase)
ActionPay.name = "ActionPay"
ActionPay.id = 1002

PlatformAction = {
	ActionBase = ActionBase.new(),
	ActionLogin = ActionLogin.new(),
	ActionPay = ActionPay.new(),
}

-- 发起渠道请求
-- action = PlatformAction.ActionBase
-- actionInfo = 请求的内容
-- actionObj = 处理回调的对象
-- actionFun = 处理回调的函数
function PlatformAction.CallAction(action, actionInfo, actionObj, actionFun)
	if action == nil then
		warn("Action为空")
		return
	end
	action:Push(actionFun, actionObj)
	--Platform.CallAndroid(action.id, actionInfo)
	Platform.callNativeFunc(action.id, actionInfo)
	
end

-- 运行事件 ( Android -> C# -> Lua )
function PlatformAction.RunAction(aid, ret)
	if PlatformAction[aid] == nil then
		warn("找不到这个Action ID:" .. aid)
		return
	end
	PlatformAction[aid]:Run(ret)
end
