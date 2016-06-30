--[[
author:Desmond
无尽跑酷结束结算状态
]]
EndlessRunningOutState = class (BasePlayerState)

EndlessRunningOutState._name = "EndlessRunningOutState"
EndlessRunningOutState.UIPanelObj = nil 
EndlessRunningOutState.Time = 0 --动画时间
EndlessRunningOutState.scene = nil --场景scene

function EndlessRunningOutState:Enter(role)
	-- 播放胜利动画 
    GetCurrentSceneUI().gameIsOver = true
	self.super.Enter(self,role)
	role.property.moveDir=UnityEngine.Vector3(0,role.property.diveSpeed,0) --向量速度
end

function EndlessRunningOutState:Excute(role,dTime)
	-- 通知弹出失败界面 
    --判断是否在地面 
    --GamePrint("EndlessRunningOutState:Excute")
    local dHeight = (role.property.moveDir.y + role.property.jumpACC* dTime) * dTime--这一时刻y执行距离
    local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
    local flag = self.super.isOnGround(self,role)
    if flag == true then
        if animInfo:IsName("fail") == false then
            self.super.playAnimation(self,role,"fail")
            return
        end
        if animInfo.normalizedTime >= 1.0 then --动画结束
            if role.stateMachine.sharedStates["DeathSprintState"] ~= nil then
                GamePrint("有死亡冲锋状态")
                role:playSkill("101010")
                return
            end
            local scene = find(ConfigParam.SceneOjbName)
            self.scene = LuaShell.getRole(scene.gameObject:GetInstanceID())
            if GetCurrentSceneUI().isSendMessage_Gameover == false then
                GamePrint("aaaaaaaaaaaaaa")
                self.scene:sendEndRunningRequest()--发送消息
            end
            
        end
    else
        role.property.moveDir.y = role.property.moveDir.y + role.property.jumpACC* dTime
        role.gameObject.transform:Translate(0,-dHeight,0, Space.World)
    end
end
function EndlessRunningOutState:Exit(role)
    GetCurrentSceneUI().gameIsOver = false
end




