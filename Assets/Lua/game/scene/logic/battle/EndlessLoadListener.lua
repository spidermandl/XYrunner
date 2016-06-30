--[[
author:Desmond
loader 监听器
]]
EndlessLoadListener = class()
EndlessLoadListener.callback = nil --回调对象
--通知速度变化
function EndlessLoadListener:notifySpeedChange(speed)
	self.callback:changePlayerSpeed(speed)
	-- 提示加速
	if self.callback.uiCtrl ~= nil then
		self.callback.uiCtrl:OpenSpeedUp()
	end
	
end

--改变中景显示
--base 场景种类
--local x 坐标
function EndlessLoadListener:changeMiddleLandscape(base,pos_x)
	self.callback:changeMiddleLandscape(base,pos_x)
end

--改变远景显示
--base 场景种类
--local x 坐标
function EndlessLoadListener:changeFarLandscape(base,pos_x)
	self.callback:changeFarLandscape(base,pos_x)
end

--加入场景切换过渡动画
function EndlessLoadListener:addCurtain(pos_x)
	self.callback:addCurtain(pos_x)
end

--移除场景切换过渡动画
function EndlessLoadListener:removeCurtain()
	--self.callback:removeCurtain(pos_x)
end

--隐藏显示场景平行光
function EndlessLoadListener:setActiveLight(flg)
	self.callback:setActiveLight(flg)
end