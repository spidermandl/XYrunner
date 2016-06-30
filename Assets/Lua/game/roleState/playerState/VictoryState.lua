
--VictoryState
--[[
author:Huqiuxiang
角色失败状态
]]
VictoryState = class (BasePlayerState)
VictoryState._name = "VictoryState"
VictoryState.UIPanelObj = nil 
VictoryState.Time = 0 --动画时间
VictoryState.scene = nil --场景scene

function VictoryState:Enter(role)
	-- 播放胜利动画 
    self.super.Enter(self,role)
	role.property.moveDir=UnityEngine.Vector3(0,role.property.diveSpeed,0) --向量速度
end

function VictoryState:Excute(role,dTime)
--print(role.stateMachine.previousState._name)
local flag = self.super.isOnGround(self,role)
-- print("是否在地面"..tostring(flag))
--判断是否在空中 在空中调用落下方法
if flag == true then
	self:UIPanelShow()
else
	self:IsJump(role,dTime)
end


end

--碰到物体在空中
function VictoryState:IsJump(role,dTime)
	--判断是否在地面 
    local dHeight = (role.property.moveDir.y + role.property.jumpACC* dTime) * dTime--这一时刻y执行距离
	local flag,hitinfo = UnityEngine.Physics.Raycast (role.gameObject.transform.position, UnityEngine.Vector3.down, nil, dHeight)

    
    if flag ==true then --判断碰撞物是否为地面
    	flag = false
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if obj ~= nil then
        	if tostring(obj.type) == "RoadSurface" then
        		flag = true
        	end
        end
    end

	--下降过程:
	--一直下降直到撞击平面
	if flag == false then
		--print ("height: "..tostring(dHeight).."  volictor: "..tostring(role.property.moveDir.y).." timeGap: "..tostring(dTime))
		role.property.moveDir.y = role.property.moveDir.y + role.property.jumpACC* dTime
        role.gameObject.transform:Translate(role.property.moveDir.x*dTime,-dHeight,0, Space.World)
	-- 下降至地面:
	else
        self:UIPanelShow()
   end
end


--弹出面板
function VictoryState:UIPanelShow()
	self.animator:Play("Victory")
	self.Time = self.Time + 1
		-- 通知弹出胜利界面 
    --local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	if self.Time >= 180 then --动画结束
		--print("弹出胜利框") 生成结算萌宠
		if self.scene ==nil then
        	self.scene = find(ConfigParam.SceneOjbName)
        	local battleScene = LuaShell.getRole(self.scene.gameObject:GetInstanceID())
        	battleScene:sendStoryRunningRequest()
    	end
	end
end

