--[[
  丘比 机械猫
  作者：huqiuxiang
]]
ChobePet = class (BasePet)
ChobePet.type = 'ChobePet'

ChobePet.roleName = "robot_cat"
ChobePet.throwThing = false 

function ChobePet:Awake()
    self.super.Awake(self)

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self

    self.role = LuaShell.getRole(LuaShell.DesmondID) 
    self:initParam()
end

function ChobePet:initParam()
    self.dropPoint = self.bundleParams[1]

    self.gameObject.transform.position = self.role.gameObject.transform.position
    self.gameObject.transform.rotation = UnityEngine.Quaternion.Euler(0,-90,0)
    self.gameObject.transform:Translate(0,1,0)  -- 偏移量

    -- if self.throwThing == true then  -- 扔东西状态
    --      self.stateMachine:changeState(ChobeThrowingThingsState.new())
    -- end

    if self.role.stateMachine:getState()._name == "DiveState" then
         self.stateMachine:changeState(PetEscortState.new())
         self.gameObject.transform:Translate(-0.3,1.3,0)  -- 偏移量
                  -- print("ChobeEscortState")
    elseif self.role.stateMachine:getState()._name == "DeadState" then
         self.stateMachine:changeState(ChobeRescueState.new())
         self.gameObject.transform:Translate(0,0,0)  -- 偏移量
                  -- print("ChobeRescueState")
    end
end


--启动事件--
function ChobePet:Start()
	-- self.stateMachine:changeState(ChobeThrowingThingsState.new())
end



function ChobePet:OnTriggerEnter( gameObj )
end


function ChobePet:itweenCallback()
    self.super.itweenCallback(self)
end

function ChobePet:init()
    self.super.init(self)
    self.gameObject.transform.localScale = UnityEngine.Vector3(1.5,1.5,1.5)--*self.role.property.Multiple
    self.gameObject.transform:Translate(-0.5,1.5,0,Space.World)--UnityEngine.Vector3(position.x -0.5,position.y+1.2,position.z)
    self.gameObject.transform.rotation = UnityEngine.Vector3(0,180,0)
end





