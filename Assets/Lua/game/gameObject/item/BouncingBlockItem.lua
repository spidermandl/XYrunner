--[[
author:Desmond
截断弹簧路径动画
]]
BouncingBlockItem = class(BaseItem)
BouncingBlockItem.type = 'BouncingBlockItem'

function BouncingBlockItem:Awake()
	self.super.Awake(self)
end

--初始化
function BouncingBlockItem:initParam()
    do
        return
    end
    if self.collider ==nil then
        self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    end
    self.collider.isTrigger = true

    self.collider.center=UnityEngine.Vector3(0,0.5,0)
    local bound = self.gameObject.transform.localScale
    self.collider.size=UnityEngine.Vector3(bound.x,bound.y,bound.z)

    self.super.initParam(self)

end

function BouncingBlockItem:OnTriggerEnter( gameObj )
    
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end
    
    local state = self.role.stateMachine:getState()
    if state._name == "BouncingState" then
    	iTween.Pause(self.role.gameObject)
    	state.forceDisrupt = true --打开可以切换
        --self.role.gameObject.transform.position = Vector3(self.role.gameObject.transform.position.x,self.role.gameObject.transform.position.y,self.gameObject.transform.position.z)
    	local DropState = BouncingDropState.new()
        DropState.targetZ = self.gameObject.transform.position.z
        self.role.stateMachine:changeState(DropState) 
	end

	self:inactiveSelf()
end