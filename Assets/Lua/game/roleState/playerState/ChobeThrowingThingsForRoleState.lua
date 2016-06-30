--[[
author:huqiuxiang
丘比抛洒物品 人调用 状态
]]

ChobeThrowingThingsForRoleState = class(BasePlayerState)
ChobeThrowingThingsForRoleState._name = "ChobeThrowingThingsForRoleState"
ChobeThrowingThingsForRoleState.startTime = nil
ChobeThrowingThingsForRoleState.effects = nil 
ChobeThrowingThingsForRoleState.duringTime = 3 -- 丘比产生间隔
ChobeThrowingThingsForRoleState.isCreatedObj = false 

function ChobeThrowingThingsForRoleState:Enter(role)
	self.startTime = UnityEngine.Time.time
	-- self.effects = newobject(Util.LoadPrefab("Effects/Common/ef_prop_tili")) --创建特效
    -- self.effects.gameObject.transform.position = role.gameObject.transform.position

end

function ChobeThrowingThingsForRoleState:Excute(role,dTime)
    if UnityEngine.Time.time - self.startTime > self.duringTime then  -- 时间间隔触发判断
        -- 到达时间触发效果
        if self.isCreatedObj == true then
        	return
        end
        self:creatPet(role)
		self.startTime = UnityEngine.Time.time 
	end
end

function ChobeThrowingThingsForRoleState:Exit(role)
    if self.effects ~= nil then
		GameObject.Destroy(self.effects)
	end
end

-- 创建丘比 改变状态
function ChobeThrowingThingsForRoleState:creatPet(role)
    -- self.petObj = newobject(Util.LoadPrefab("Pet/chobe")) 
    -- self.petObj.gameObject.transform.position = role.gameObject.transform.position
    local offset = UnityEngine.Vector3(-0.5,1.8,0)
    	-- self.follower.gameObject.transform.position = position + offset
    local petObj = createPetFollower(role,role.gameObject.transform.position + offset)
	-- self.petObj.gameObject.transform.position = position + offset
    
    -- 丘比扔东西状态
    local petLua = LuaShell.getRole(petObj.gameObject:GetInstanceID())
    petLua.stateMachine:changeState(ChobeThrowingThingsState.new())
    self.isCreatedObj = true
end