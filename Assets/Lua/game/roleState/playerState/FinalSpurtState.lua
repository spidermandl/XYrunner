--FinalSpurtState.lua
--[[
author:赵名飞
角色大黄鸭冲过终点状态
]]
FinalSpurtState = class (BasePlayerState)
FinalSpurtState._name = "FinalSpurtState"
FinalSpurtState.UIPanelObj = nil 
FinalSpurtState.Time = 0 --动画时间
FinalSpurtState.scene = nil --场景scene

function FinalSpurtState:Enter(role)
    self.super.Enter(self,role)
	self.scene = find(ConfigParam.SceneOjbName)
	self.battleScene = LuaShell.getRole(self.scene.gameObject:GetInstanceID())
	--self.battleScene.mainCamera.stateMachine:changeState(CameraStayState.new())
	self:UIPanelShow()
end

function FinalSpurtState:Excute(role,dTime)
end

--弹出面板
function FinalSpurtState:UIPanelShow()
	if self.battleScene.BattleGuideView.isGuideLevel == true then
		self.battleScene:VictoryUIPanelShow(nil,nil)
	else
		self.battleScene:sendStoryRunningRequest()
	end
end

