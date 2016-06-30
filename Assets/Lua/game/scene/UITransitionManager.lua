--[[
author:Desmond
界面堆栈管理
]]
UITransitionManager = class()
UITransitionManager.tag = "UITransitionManager"

UITransitionManager.uiStack = nil -- scene 和 ui的押栈
UITransitionManager.rootStack = nil --scene的押栈

--初始化
function UITransitionManager:Init()
	self.uiStack = {}
	self.rootStack = {}
end

--[[
切换UI
name ui prefab名 或 切换scene的名字
isScene 是否切换scene
]]
function UITransitionManager:push(name,isScene)
	if isScene == true then
		table.insert(self.rootStack,name)
		--切换 scene
	else
		--切换 ui
	end

	table.insert(self.uiStack,name)
end

--[[
回退ui
返回下一个 scene (如果需要切换scene)
          nil (如果是推出当前view)
]]
function UITransitionManager:pop()
	if self.rootStack[#self.uiStack] == self.uiStack[#self.uiStack-1] then --判断是不是scene里最后一个押栈ui
        table.remove(self.uiStack, #self.uiStack) --pop ui
        table.remove(self.uiStack, #self.uiStack) --pop scene
        table.remove(self.rootStack,#self.rootStack) --pop scene

        return self.rootStack[#self.rootStack]
	else
		table.remove(self.uiStack,#self.uiStack)
	end

end

--[[
获取当前view
返回 栈顶
]]
function UITransitionManager:top()
	return self.uiStack[#self.uiStack]
end