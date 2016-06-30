-- StealthState
--[[
潜行状态
author:Huqiuxiang
]]
StealthState = class(BasePlayerState)
StealthState._name = "StealthState"

StealthState.startTime = nil
StealthState.duringTime = 3

StealthState.playBody=nil 					-----主角身体
StealthState.playHead=nil 					-----主角头

StealthState.shaderTouMing = nil 
StealthState.shaderNormal = nil 

function StealthState:Enter(role)
	self.startTime = UnityEngine.Time.time
    local playObj = role.character.gameObject.transform:FindChild("player_male@skin")
    self.shaderTouMing = UnityEngine.Shader.Find("Unlit/Depth")
    self.shaderNormal = UnityEngine.Shader.Find("Custom/Role")
	self.playBody = playObj.gameObject.transform:FindChild("player_male_Body"):GetComponent("SkinnedMeshRenderer")
	self.playHead = playObj.gameObject.transform:FindChild("player_male_Head"):GetComponent("SkinnedMeshRenderer")
    self.playHead.material.shader = self.shaderTouMing
	self.playBody.material.shader = self.shaderTouMing
    
    self.mountSkinTable = {}
    self:mountStealth(role)
end

function StealthState:Excute(role,dTime)
	if UnityEngine.Time.time - self.startTime >self.duringTime then
		role.stateMachine:removeSharedState(self)
		return
	end

end

function StealthState:Exit(role)
	 self.playHead.material.shader = self.shaderNormal
	 self.playBody.material.shader = self.shaderNormal

	for i = 1 , #self.mountSkinTable do
		  self.mountSkinTable[i].material.shader = self.shaderNormal
	end
end

StealthState.mountSkinTable = nil
-- 判断坐骑 坐骑隐身
function StealthState:mountStealth(role)
	if role.stateMachine.sharedStates["CNMMountState"] ~= nil then  -- Mount_Cnm@skin  Mount_Cnm
		local mount = role.stateMachine.sharedStates["CNMMountState"].mount
		local skin = mount.gameObject.transform:FindChild("Mount_Cnm@skin")
        local skinMesha = skin.gameObject.transform:FindChild("Mount_Cnm"):GetComponent("SkinnedMeshRenderer")
        print(skinMesha.gameObject.name)
        self.mountSkinTable[1] = skinMesha
	elseif role.stateMachine.sharedStates["UFOMountState"] ~= nil then
     
	end

	for i = 1 , #self.mountSkinTable do
		  self.mountSkinTable[i].material.shader = self.shaderTouMing
	end

end