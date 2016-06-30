--[[
    author:huqiuxiang
    尼莫 NemoPet
    拉人，救起玩家时会为玩家套上一个水盾，持续一段时间，有水盾时玩家无敌。多段跳+1，玩家只能同时拥有1种盾效果
]]
NemoPet = class (BasePet)
NemoPet.type = 'NemoPet'

NemoPet.roleName = "nemo"

function NemoPet:Awake()
    self.super.Awake(self)

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self

    self.role = LuaShell.getRole(LuaShell.DesmondID) 
    
    self:initParam()
end

function NemoPet:initParam()
    self.dropPoint = self.bundleParams[1]

    self.gameObject.transform.position = self.role.gameObject.transform.position
    self.gameObject.transform.rotation = UnityEngine.Quaternion.Euler(0,-90,0)
    self.gameObject.transform:Translate(0,2,0)  -- 偏移量

    if self.role.stateMachine:getState()._name == "DiveState" then
        self.stateMachine:changeState(PetEscortState.new())
    elseif self.role.stateMachine:getState()._name == "DeadState" then
        -- print("if self.role.stateMachine:getState()._name == DropState")
        self.stateMachine:changeState(NemoRescueState.new())
    end
end

--启动事件--
function NemoPet:Start()
	-- self.super.Start(self)
end


function NemoPet:OnTriggerEnter( gameObj )
end


function NemoPet:creatObj()
  
end

function NemoPet:init()
    self.super.init(self)
    self.gameObject.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)--*self.role.property.Multiple
    self.gameObject.transform:Translate(-0.5,1.5,0,Space.World)--UnityEngine.Vector3(position.x -0.5,position.y+1.2,position.z)
    self.gameObject.transform.rotation = UnityEngine.Vector3(0,180,0)
end