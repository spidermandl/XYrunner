--[[
  author:Desmond
  会吸住主角的墙
]]

HangingSurface = class (BaseSurface)

HangingSurface.type = "HangingSurface"
HangingSurface.dropHangingTime =0

HangingSurface.curPlayWallCount = nil -- 当前该墙壁弹跳的次数
HangingSurface.playWallCount = nil -- 弹墙次数
HangingSurface.isCanPlayWall = nil -- 是否可以弹墙
HangingSurface.stayTime = nil -- 停留时间
HangingSurface.acceleration = nil -- 向下落的加速度


function HangingSurface:Awake()
    self.super.Awake(self)
    self.gameObject.layer = UnityEngine.LayerMask.NameToLayer("Step")
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = false
    self.collider.center=UnityEngine.Vector3(0,0,0)

    self.rigidBody = self.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
    self.rigidBody.useGravity = false
    self.rigidBody.isKinematic = false
    self.rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

end

function HangingSurface:initParam()
    self.super.initParam(self)
    if self.bundleParams['isCanPlayWall'] == nil then
        self.isCanPlayWall = false
        self.curPlayWallCount = 0
        return
    end
    self.playWallCount = self.bundleParams['playWallCount']
    self.isCanPlayWall = self.bundleParams['isCanPlayWall']
    self.stayTime = self.bundleParams['stayTime']
    self.acceleration = self.bundleParams['acceleration']
    self.curPlayWallCount = 0
    
end


function HangingSurface:OnCollisionEnter( collision )
    local obj = LuaShell.getRole(collision.gameObject:GetInstanceID())
    if obj ~= nil then
        if tostring(obj.type) == "HangingColliderItem" then
            local player = LuaShell.getRole(LuaShell.DesmondID)
            if player.stateMachine:getState()._name == "DeadState" then --角色被救起状态
                return 
            end
            self.curPlayWallCount = self.curPlayWallCount + 1
            if self.isCanPlayWall == false then --不能爬墙
                GamePrint("--------------------function HangingSurface:OnCollisionEnter( collision ) ")
                player.stateMachine:addSharedState(HangingBlockState.new())
                return
            end

            if self.playWallCount == -1 or self.curPlayWallCount <= self.playWallCount then --能爬墙，且符合次数要求
                local state = WallClimbState.new()
                state:SetValue(self.stayTime,self.acceleration)
                player.stateMachine:changeState(state)
                return
            end
        end
    end
    
end


function HangingSurface:OnCollisionStay( collision )

end

function HangingSurface:OnCollisionExit( collision )
    local obj = LuaShell.getRole(collision.gameObject:GetInstanceID())
    if obj ~= nil then
        if tostring(obj.type) == "HangingColliderItem"then
            --GamePrint("--------------------function HangingSurface:OnCollisionExit( collision ) ")
        end
    end

    	
end
