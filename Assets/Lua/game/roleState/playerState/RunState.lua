RunState = class(BasePlayerState)

RunState._name = "RunState"
RunState.preAnim = nil --跑前衔接动画

function RunState:Enter(role)
    self.super.Enter(self,role)

    role.character.transform.rotation = Quaternion.Euler(0,90,0)
    if role.moveSpeedVect<0 then --角色移动方向向右
        role.moveSpeedVect = -1 * role.moveSpeedVect
        local vec = role.gameObject.transform.localScale
        vec.x = 1
        role.gameObject.transform.localScale = vec
    end

    if self.preAnim ~= nil then --设置前端承接动画
        --self.animator:Play(self.preAnim)
        self.super.playAnimation(self,role,self.preAnim)
    else
        self.preAnim = nil
        --self.animator:Play("run")
        self.super.playAnimation(self,role,"run")
    end
    role.property.moveDir=UnityEngine.Vector3(role:getMoveSpeed(),0,0) --横向移动速度 1

    --print ("----------------function RunState:Enter(role) "..tostring(role.property.moveDir.x))

    local flag = self.super.isOnGround(self,role)
    if flag == false then --判断是不是在地面上
        --GamePrint("-----------------------function RunState:Enter(role) ")
        role.stateMachine:changeState(DropState.new())
        return
    else 
        --切换摄像头状态
        -- local camera = LuaShell.getBattleCamera()
        -- camera:changeState(CameraAutoFixState.new())
    end
end

function RunState:Excute(role,dTime)
    self.super.Excute(self,role,dTime)

    role.gameObject.transform:Translate(role.property.moveDir.x*dTime,0,0, Space.World)
    ---print ("------------------------------->>>> function RunState:Excute(role,dTime) 1 ")
    if self.preAnim ~= nil then
        --print ("------------------------------->>>> function RunState:Excute(role,dTime) 2 ")
        local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
        if animInfo.normalizedTime >= 1.0 and animInfo:IsName(self.preAnim) then --动画结束
            --print ("------------------------------->>>> function RunState:Excute(role,dTime) 3 ")
            --self.animator:Play("run")
            self.super.playAnimation(self,role,"run")
            self.preAnim = nil
        end

        --return
    end

    local flag,hitinfo = self.super.isOnGround(self,role)
    if flag == false then
        role.stateMachine:changeState(DropState.new())
        return
    end

end

function RunState:exit( role )
    --role.stateMachine:removeSharedState(self)
end