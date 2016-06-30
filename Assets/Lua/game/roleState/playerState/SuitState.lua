--[[
author:Desmond
套装技能状态，共享状态
]]
SuitState = class (IState)
SuitState._name = "SuitState"

SuitState.suit_config_id = nil --套装id
SuitState.skill_id = nil --技能id
SuitState.suit_type_id = nil --套装种类id

function SuitState:Enter(role)
    role.stateMachine:removeSharedState(self)--退出这个状态
    --self.super.Enter(self,role)
	local config_id =TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
    self.suit_config_id = config_id
    local skillTxt = TxtFactory:getTable(TxtFactory.SuitSkillTXT)
    local suitTxt = TxtFactory:getTable(TxtFactory.SuitTXT)
    local id = suitTxt:GetData(config_id,TxtFactory.S_SUIT_TYPE)
    local skill_id = suitTxt:GetData(config_id,TxtFactory.S_SUIT_FIRST_SKILL)
    self.skill_id = skill_id
    self.suit_type_id = id
	if tonumber(id) == TxtFactory.S_SUIT_DEFAULT_SUIT then --默认套装

	elseif tonumber(id) == TxtFactory.S_SUIT_CHOPPER_SUIT then --乔巴变大
        --print ("------------TxtFactory.S_SUIT_CHOPPER_SUIT then --乔巴变大 ")
    	local atk_count = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_ATK_CD)--攻击次数
		local sustain_time = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_SUSTAINED_TIME) --持续时间

        --[[
    	local buff = AtkCDState.new()
    	buff.ATK_CAP = atk_count
    	buff.duringTime = tonumber(sustain_time) --技能持续时间
    	role.stateMachine:addSharedState(buff)
        ]]

	elseif tonumber(id) == TxtFactory.S_SUIT_TEEMO_SUIT then --提莫的隐形
    	local freezing_time = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_CD_TIME)--冷却时间

	elseif tonumber(id) == TxtFactory.S_SUIT_FORTUNE_CAT_SUIT then --招财猫的金币雨
		local kill_count = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_KILL_CD)--击杀多少怪物

	elseif tonumber(id) == TxtFactory.S_SUIT_LION_EAR_SUIT then --狮子耳的吼
		local jump_count = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_JUMP_CD)--击杀多少怪物

	elseif tonumber(id) == TxtFactory.S_SUIT_FORTUNE_COLOR_SUIT then --招财猫的金币雨

	end

	   --  if self.role.property.PetSuitName=="desmond" then
    --     buff = SprintState.new()
    --     buff.duringTime = RoleProperty.SprintStateTime
    --     self:changeState (buff)
    --     -- self:addSharedState (ChopperSuitState.new())
    --     -- self:addSharedState (TeemoSuitState.new())
    --     --self:addSharedState (CatSuitState.new())
    --     -- self:changeState (LionEarSuitState.new())
    -- elseif self.role.property.PetSuitName=="ChopperSuit" then
    --     self:addSharedState(ChopperSuitState.new())
    -- elseif self.role.property.PetSuitName=="TeemoSuit" then
    --     self:addSharedState (TeemoSuitState.new())
    -- elseif self.role.property.PetSuitName=="FortuneCatSuitState" then --招财猫
    --     self:addSharedState (FortuneCatSuitState.new())
    -- elseif self.role.property.PetSuitName=="CatSuitColor" then --变色招财猫
    --     self:addSharedState (CatSuitState.new())
    -- elseif self.role.property.PetSuitName=="LionEarSuit" then
    --     self:changeState (LionEarSuitState.new())
    -- end
end


function SuitState:Excute(role,dTime)
    --self.super.Excute(self,role,dTime)

end

--[[ role:角色 为lua对象 ]]
function SuitState:Exit(role)

end

--触发技能
function SuitState:activateState(role)
	local id = self.suit_type_id
	local skill_id = self.skill_id
	if tonumber(id) == TxtFactory.S_SUIT_DEFAULT_SUIT then --默认套装
	    local s = role.stateMachine:getSharedState("SkillCDState")
	    if s ~= nil then
	        return
	    end

	    local skillTxt = TxtFactory:getTable(TxtFactory.SuitSkillTXT)
        local freezing_time = tonumber(skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_CD_TIME))
    	       - tonumber(TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_SUIT_SKILL_CD)) --冷却时间
        local sustain_time = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_SUSTAINED_TIME) --持续时间
        local buff = SprintState.new()
        if sustain_time == nil or sustain_time =='' then
        	sustain_time = 3
        end
        buff.duringTime = tonumber(sustain_time) --技能持续时间
        role.stateMachine:changeState(buff)

		buff = SkillCDState.new()
		buff.TIME_CAP = tonumber(freezing_time) + tonumber(sustain_time)--技能冷冻时间
        role.stateMachine:addSharedState(buff)--加入cd时间

	elseif tonumber(id) == TxtFactory.S_SUIT_CHOPPER_SUIT then --乔巴变大
        --非时间相关

	elseif tonumber(id) == TxtFactory.S_SUIT_TEEMO_SUIT then --提莫的隐形
    	local freezing_time = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_CD_TIME)--冷却时间

	elseif tonumber(id) == TxtFactory.S_SUIT_FORTUNE_CAT_SUIT then --招财猫的金币雨
		local kill_count = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_KILL_CD)--击杀多少怪物

	elseif tonumber(id) == TxtFactory.S_SUIT_LION_EAR_SUIT then --狮子耳的吼
		local jump_count = skillTxt:GetData(skill_id,TxtFactory.S_SUIT_SKILL_JUMP_CD)--击杀多少怪物

	elseif tonumber(id) == TxtFactory.S_SUIT_FORTUNE_COLOR_SUIT then --招财猫的金币雨

	end
end




