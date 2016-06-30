--[[
author:Desmond
战斗按钮
]]
BattleControl = class()
BattleControl.scene = nil

BattleControl.attack = nil
BattleControl.skill = nil
BattleControl.jump = nil

function BattleControl:Awake()
	local root = find("UIGame")
	self.attack = getChildByPath(root,"LeftDown/BtnAttack")
	self.skill = getChildByPath(root,"LeftDown/BtnSpeedUp")
	self.jump = getChildByPath(root,"RightDown/BtnJump")

	AddonClick(self.attack,function ()
		self:DoAction("attack")
	end)
    
	AddonClick(self.skill,function ()
		self:DoAction("sprint")
	end)

	AddonPress(self.jump,function (obj,isPress)
		--GamePrint(tostring(isPress))
		if isPress == true then
			self:DoAction("jump")
		end
	end)

end

function BattleControl:DoAction(action)
	if action == "attack" then
		self.scene:doPlayerAction(action)
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.run_attack)
	elseif action == "sprint" then
		if self.scene.BattleGuideView.isGuideLevel == false  then
			self.scene:doPlayerAction(action)
			TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.item_shield)
		end
	elseif action =="jump" then
		self.scene:doPlayerAction(action)
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.run_jump)
	end

	--self:PlayOtherEffectSound(SoundType.run_attack)
	TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)

end

