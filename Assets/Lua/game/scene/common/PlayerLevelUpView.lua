
--[[
	ui提示类
	sunkai
]]
PlayerLevelUpView = class()
PlayerLevelUpView.panel = nil
PlayerLevelUpView.sceneTarget = nil
PlayerLevelUpView.scene = nil 

function PlayerLevelUpView:init(targetScene,OkDel,...)
	self.scene = targetScene
	self.sceneTarget = targetScene.sceneTarget
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/common/PlayerLevelUpView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3(0,0,-400)
    	self.panel.gameObject.transform.localScale = Vector3.one

    	local btn = getUIGameObject(self.panel,"OkBut")
		
    	self.scene:SetButtonTarget(btn,self.sceneTarget)
	end
	
	self.LvLab = getUIComponent(self.panel,"role/Label","UILabel")
	self.ScoreLab = getUIComponent(self.panel,"showdata/score/Label","UILabel")
	self.DiamondNumLab = getUIComponent(self.panel,"showdata/reward/Label","UILabel")
	self.GoldNumLab = getUIComponent(self.panel,"showdata/reward/Label 1","UILabel")
	self.RoleSprite= getUIComponent(self.panel,"role/Icon","UISprite")
	self.OkDel = OkDel 
	self.args = {...}
end




function PlayerLevelUpView:InitData(lv)
	self.LvLab.text = "LV."..lv
	local tableTXT = TxtFactory:getTable(TxtFactory.PlayerLevelUpTXT) 
	local Accounts_Score_Bonus = tonumber(tableTXT:GetData(lv,"Accounts_Score_Bonus"))*100
	self.ScoreLab.text =  "+"..Accounts_Score_Bonus.."%"
	local Diamond = tonumber(tableTXT:GetData(lv,"Accounts_LvUp_Diamond"))
	local Gold = tonumber(tableTXT:GetData(lv,"Accounts_LvUp_Gold"))
	self.DiamondNumLab.text = "+"..Diamond
	self.GoldNumLab.text = "+"..Gold
	
   local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    if user[TxtFactory.USER_SEX] == 0 then
       self.RoleSprite.spriteName = "gg"
    elseif user[TxtFactory.USER_SEX] == 1 then
         self.RoleSprite.spriteName = "mm"
    end
	
	-- 添加升级奖励到人物身上
	 user[TxtFactory.USER_GOLD] = user[TxtFactory.USER_GOLD] + Gold
	 user[TxtFactory.USER_DIAMOND] = user[TxtFactory.USER_DIAMOND] + Diamond
	
end

function PlayerLevelUpView:close()
	self.OkDel(self.scene,self.args)
	destroy(self.panel)
end