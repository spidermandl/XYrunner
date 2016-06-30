--[[
author:Desmond
新手战场引导
]]

BattleGuideView = class()

BattleGuideView.scene = nil --场景scene
BattleGuideView.name = "BattleGuideView" --类名

BattleGuideView.isGuideLevel = nil
BattleGuideView.MAINID  = nil
BattleGuideView.isFinish = nil
function BattleGuideView:Init(targetScene)
	self.scene = targetScene
	self.isGuideLevel = false
	self.MAINID  = nil
    self.isFinish = false
	if RoleProperty.isNaviceOpen == true then
		local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		local Curstep = user[TxtFactory.USER_GUIDE] -- 获取进度
		local GudieUISceneTXT = TxtFactory:getTable(TxtFactory.GudieUISceneTXT) 
		local LeveID = GudieUISceneTXT:GetData(Curstep,"LEVELID")
        if LeveID ~= nil and LeveID ~= "" and LeveID ~= "0" then
        	self.isGuideLevel = true
        	self.MAINID = GudieUISceneTXT:GetData(Curstep,"MAINID")
        end
    end

    if self.isGuideLevel == true then
    	
    	if  self.scene.jumpBtn == nil then
        	self.scene.jumpBtn = find("BtnJump")
    	end
    	if  self.scene.speedUpBtn == nil then
        	self.scene.speedUpBtn = find("BtnSpeedUp")
    	end
    	if  self.scene.attackBtn == nil then
        	self.scene.attackBtn = find("BtnAttack")
    	end
    	self.scene.jumpBtn:SetActive(false)
    	self.scene.speedUpBtn:SetActive(false)
    	self.scene.attackBtn:SetActive(false)
    end
end

function BattleGuideView:GuideIsFinish()
	-- body
	-- 引导结束更新进度
    if self.isFinish == true then
        GameWarnPrint(" 引导结束更新进度 引导结束更新进度")
        return
    end
    self.isFinish = true
	local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	local Curstep = user[TxtFactory.USER_GUIDE] -- 获取进度
	user[TxtFactory.USER_GUIDE] = Curstep + 1
    GameWarnPrint(" 引导结束更新进度 ="..tostring(user[TxtFactory.USER_GUIDE]).."||MAINID ="..tostring(MAINID))
	if  self.MAINID ~= nil and self.MAINID ~= "" and self.MAINID ~= "0" then
        local MAINID = tonumber(self.MAINID)
        -- 服务器数据 模块
        local management = GuideManagement.new()
        management:init(self)
        management:setValue(TxtFactory.AccountInfo,TxtFactory.ACCOUNT_GUIDE,MAINID)
        management:sendGuideProgress(MAINID) -- 保存进度
    end
end