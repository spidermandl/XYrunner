--[[
author:Desmond
基类ui view
]]
BaseView = class()
BaseView.scene = nil --对应的scene
BaseView.name = nil --view名字
BaseView.gameObject = nil -- UI prefab对象
BaseView.uiPrefabName = nil --prefab name

--回退到上一个view
function BaseView:pop()
	local manager = TxtFactory:getTable(TxtFactory.UITransitionManager)
	local name = manager:pop()
    
    if name == nil then --切换view
    	local view = manager:top()
    	self.scene:changeView(view)
    else --切scene
    	self.scene:ChangeScene(name)
    end

end

--进入下一个view
function BaseView:push()
	local manager = TxtFactory:getTable(TxtFactory.UITransitionManager)
	manager:push(self.name)
	self.scene:changeView(self.name)
end

--显示
function BaseView:show()
	-- body
end

--隐藏
function BaseView:hide()
	-- body
end