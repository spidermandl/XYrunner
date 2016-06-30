--[[
author:Desmond
基础消息结构
]]
BaseMsg = class ()

BaseMsg.callback = nil --消息接受回调对象
BaseMsg.funName  = nil --消息接受回调函数名字
function BaseMsg:Excute(response)
	
end