--[[
author:hanli_xiong
渠道回调事件基类
]]

ActionBase = class()

ActionBase.name = "ActionBase"
ActionBase.id = 1000 -- 事件ID
ActionBase.action = nil -- action = fun(obj[处理事件的对象], result[渠道的返回信息])
ActionBase.actionObj = nil -- 处理事件的对象

-- 添加事件
function ActionBase:Push(fun, obj)
	if self.action or self.actionObj then
		print(self.name .. ":上个事件未处理")
	end
	self.action = fun
	self.actionObj = obj
	print(self.name .. ":添加事件")
end

-- 移除事件
function ActionBase:Pop()
	self.action = nil
	self.actionObj = nil
	print(self.name .. ":移除事件")
end

-- 运行事件
function ActionBase:Run(ret)
	if self.action and self.actionObj then
		self.action(self.actionObj, ret)
		print(self.name .. ":运行事件")
		self:Pop()
	else
		print(self.name .. ":事件或事件处理对象为空")
		print(self.name .. ":未能处理信息:" .. ret)
	end
end