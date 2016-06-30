--[[
author:huqiuxiang
无尽开头界面
]]
RankView = class()

RankView.scene = nil --场景scene
RankView.management = nil -- 数据model

RankView.panel = nil  -- 开头界面面板
RankView.itemsGrid = nil 
RankView.items = nil 
RankView.jqqdWord = nil 
RankView.effect = nil 
RankView.charIconTxt = nil 
RankView.challenge = nil
RankView.challangeInfo = nil --挑战信息

-- 初始化界面
function RankView:init()
	self.panel = self.scene:LoadUI("Endless/EndlessRankUI")
	self.panel.gameObject.transform.localPosition = Vector3.zero
	self.items = find("EndlessRankUI_items")
	self.itemsGrid = find("EndlessRankUI_itemsGrid")
	self.jqqdWord = find("EndlessRankUI_JQQDLabel")
	self.challenge = self.panel.transform:Find("UI/Challange")
	self.charIconTxt = TxtFactory:getTable(TxtFactory.CharIconTXT)
	self.jqqdWord.gameObject:SetActive(false)
	self.management = self.scene.endlessManagement

	self:bottonTargetFind()
	self.scene.CurretView = "RankView"
	self:jingdianBtn()
	self.scene:boundButtonEvents(self.panel)


 	-- 夺宝奇兵,等级开启
	-- if self.scene.FunctionOpen == nil then
	-- 	 self.scene.FunctionOpen = FunctionOpenView.new()
 --     	self.scene.FunctionOpen:Init(self.scene,true)
	-- end
	-- local bbtn = self.panel.transform:FindChild("UI/btn")
	-- self.scene.FunctionOpen:UpdataOtherBtn("套装",bbtn:FindChild("ChapterUI_role"))
	-- self.scene.FunctionOpen:UpdataOtherBtn("萌宠",bbtn:FindChild("ChapterUI_pet"))
	-- self.scene.FunctionOpen:UpdataOtherBtn("装备",bbtn:FindChild("ChapterUI_equip"))
	-- self.scene.FunctionOpen:UpdataOtherBtn("坐骑",bbtn:FindChild("ChapterUI_mount"))
	self:Refresh()
	local btn = find("EndlessRankUI_BtnReturn")
    local fun = function()
    	if   self.scene.CurretView == "RankView" then
            self.scene:ClearChallangeInfo()
            self.scene:SetActive(false)
            self.scene.sceneParent:SetActive(true)
            self.scene.rankView.effect:SetActive(false)
        elseif self.scene.CurretView == "itemsView" then
            self.scene.itemsView:destroy()
            self.scene.rankView:init()
        end
    end
    AddonClick(btn,fun)
end

-- 按钮target 赋值
function RankView:bottonTargetFind()
	local ui = self.panel.gameObject.transform:FindChild("UI")
	local nextBtn = ui.gameObject.transform:FindChild("EndlessRankUI_next")
	self.effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_button"))
	self.effect.gameObject.transform.parent = nextBtn.gameObject.transform
	self.effect.gameObject.transform.localPosition = Vector3.zero
	self.effect.gameObject.transform.localScale = Vector3.one
	SetEffectOrderInLayer(self.effect,2)


	local tiantiBtn = ui.gameObject.transform:FindChild("EndlessRankUI_tianti")
	local yuanzhengBtn = ui.gameObject.transform:FindChild("EndlessRankUI_yuanzheng")
	local jingdian = ui.gameObject.transform:FindChild("EndlessRankUI_jingdian")

end

-- list更新
function RankView:listUpdate(tabData)
	destroy(self.itemsGrid)
	self.itemsGrid = GameObject.New()

    local  ms = self.itemsGrid:AddComponent(UIGrid.GetClassType())
	-- ms.cellWidth = 150
	ms.cellHeight = 100
	ms.maxPerLine = 1
    self.itemsGrid.name =  "EndlessRankUI_itemsGrid"
    self.itemsGrid.gameObject.transform.parent = self.items.gameObject.transform
    self.itemsGrid.gameObject.transform.localPosition = Vector3(-222,145,0)
    self.itemsGrid.gameObject.transform.localScale = Vector3(1,1,1)

    for i = 1, #tabData do 
    	local icon = self:creatRankIcon(tabData[i].rank,tabData[i].score,tabData[i].username,tabData[i].icon)
    end

    local grid = self.itemsGrid.gameObject.transform:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列

end

-- 设置单个icon
function RankView:creatRankIcon(rank,level,username,touxiangId)
	local icon = newobject(Util.LoadPrefab("UI/Endless/endlessListIcon"))
	icon.gameObject.transform.parent = self.itemsGrid.gameObject.transform
	icon.gameObject.transform.localScale = Vector3.one

	local err, ret = pcall(ZZBase64.decode, username)
    if err then
        username = ret
    end

	local name = icon.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
	name.text = username
	local lv = icon.gameObject.transform:FindChild("LV"):GetComponent("UILabel")
	local sprite = icon.gameObject.transform:Find("LV/background")
	sprite.gameObject:SetActive(false)
	lv.text = level
	local rewardData = nil 
	local rankNum = ""
	if rank == 1 then
		rewardData = "no1"
	elseif rank == 2 then
		rewardData = "no2"
	elseif rank == 3 then
		rewardData = "no3"
	else
		rewardData = "no4"
		rankNum = tostring(rank)
	end
	-- print("rewardData"..rewardData)
	local reward = icon.gameObject.transform:FindChild("reward"):GetComponent("UISprite")
	reward.spriteName = rewardData
	icon.gameObject.transform:FindChild("reward/Rank"):GetComponent("UILabel").text = rankNum
	--reward.transform:FindChild("Rank"):GetComponent("UILabel").text = rankNum

	local touxiang = icon.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
	local spriteName = self.charIconTxt:GetData(touxiangId, "ICON")
	if spriteName ~= nil then
		touxiang.spriteName = spriteName
	end

	-- 赠送体力
	local tiliBtn = find("tiliBtn")
	local tiliBtnMes = tiliBtn.gameObject.transform:GetComponent("UIButtonMessage")
	tiliBtnMes.target = self.scene.uiRoot
	tiliBtn.name = "RankView_tiliBtn"

	return icon
end
function RankView:Refresh()
	--对战信息 
	self.challenge.gameObject:SetActive(true)
	self.challangeInfo = find("challangeInfo"):GetComponent("UILabel")
	local friendName = " "
	local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE)
    if TxtFactory:getMemDataCacheTable(TxtFactory.ChallengeInfo) ~= nil and battleType == 2 then
    	GamePrint("TxtFactory:getMemDataCacheTable(TxtFactory.ChallengeInfo) ~= nil")
    	local friendInfo = TxtFactory:getValue(TxtFactory.ChallengeInfo,TxtFactory.CHALLENGE_FRIENDINFO)
    	if friendInfo ~= nil then
	    	friendName = GetFriendNameByNick(friendInfo.nickname)
	    end
	elseif TxtFactory:getMemDataCacheTable(TxtFactory.ReplyChallengeInfo) ~= nil and battleType == 2 then
		local friendNick = TxtFactory:getValue(TxtFactory.ReplyChallengeInfo,TxtFactory.REPLYCHALLENGE_FRIENDNAME)
		if friendNick ~= nil then
			friendName = GetFriendNameByNick(friendNick)
		end
	else
		self.challenge.gameObject:SetActive(false)
    end
 	self.challangeInfo.text = friendName
end
-- 体力按钮
function RankView:tiliBtn(Btn)
	-- print(Btn.gameObject.transform.parent.name)

end

-- next按钮
function RankView:nextBtn()
	destroy(self.panel)
end

-- 经典按钮 发送
function RankView:jingdianBtn()
	-- local tab = 2
	local rankType = 1
	local rankPage = 1
	-- self:listUpdate(tab)
	self.management:sendEndlessRankData(rankType,rankPage)
	self.jqqdWord.gameObject:SetActive(false)
end

-- 经典按钮 返回
function RankView:jingdianBtnBack()
	local endlessRankInfo = TxtFactory:getMemDataCacheTable(TxtFactory.EndlessRankInfo)
  	local rankTab = endlessRankInfo[TxtFactory.ENDLESSRANK_INFOTAB]
	-- self.management:sendEndlessRankData(1,1)
	self:listUpdate(rankTab)
end
-- 天梯按钮 发送
function RankView:tiantiBtn()
	local tab = {}
	self.jqqdWord.gameObject:SetActive(true)
	self:listUpdate(tab)
end


-- 远征按钮 发送
function RankView:yuanzhengBtn()
	local tab = {}
	self.jqqdWord.gameObject:SetActive(true)
	self:listUpdate(tab)
end



-- 赠送体力按钮


function RankView:SetActive(active)

	if self.panel ~= nil then
		self.panel:SetActive(active)
	end
	if active == true then
		self:Refresh()
	end
end