--[[
	author:Desmond
	装备升级功能逻辑
]]
EquipUpgradeView = class()

EquipUpgradeView.scene = nil --场景scene
EquipUpgradeView.management = nil -- 数据model

EquipUpgradeView.upgradeEquipPanel = nil
EquipUpgradeView.UpgradeEquipPanel_itemsGrid = nil -- btnlist 根
EquipUpgradeView.UpgradeEquipPanel_isSelectItem = nil -- 选中的按钮
EquipUpgradeView.UpgradeEquipPanel_use_coin = 9800 --
EquipUpgradeView.UpgradeEquipPanel_use_diamond = 100 --
EquipUpgradeView.UpgradeEquipPanel_levelForPanelShow = 5
EquipUpgradeView.UpgradeEquipPanel_UpgradePanelShow = nil -- 5级升级小窗口
EquipUpgradeView.equipTable = nil 
EquipUpgradeView.coinBtn = nil -- 金币按钮
EquipUpgradeView.diamondBtn = nil -- 钻石按钮
EquipUpgradeView.probabilityTip = nil -- 升级成功概率
EquipUpgradeView.itemNameLabel = nil -- 装备名
EquipUpgradeView.itemLevelLabel = nil -- 装备等级
EquipUpgradeView.attNameLabel = nil -- 属性名
EquipUpgradeView.attValueLabel = nil -- 属性值

function  EquipUpgradeView:init(targetScene)
    self.scene = targetScene
    self.upgradeEquipPanel = self.scene:LoadUI("Equip/EquipeLevelUpUI")
    self.UpgradeEquipPanel_itemsGrid = find("EquipeLevelUpUIgrid")
    self.equipTable = TxtFactory:getTable("EquipTXT")
    self.management = self.scene.EquipManagement
    -- self:UpgradeEquipPanel_listUpdate() -- 更新list
    
    -- local btn = self.UpgradeEquipPanel_itemsGrid.gameObject.transform:GetChild(0)
    -- self:UpgradeEquipPanel_listBtnOnClick(btn.gameObject) -- 默认选中第一个
    local equipInfo_trans = self.upgradeEquipPanel.transform:Find("UI/title/equipInfo")
    self.effectParentObj = equipInfo_trans:Find("EffectParent")
    self.itemNameLabel = equipInfo_trans:Find("nameLabel"):GetComponent("UILabel")
    self.itemLevelLabel = equipInfo_trans:Find("levelLabel"):GetComponent("UILabel")
    self.attNameLabel = equipInfo_trans:Find("addition/name"):GetComponent("UILabel")
    self.attValueLabel = equipInfo_trans:Find("addition/value"):GetComponent("UILabel")

    self.coinBtn = self.upgradeEquipPanel.transform:FindChild("UI/title/EquipeLevelUpUI_Gold")
    self.diamondBtn = self.upgradeEquipPanel.transform:FindChild("UI/title/EquipeLevelUpUI_Diamond")
    self.levelMax = self.upgradeEquipPanel.transform:FindChild("UI/title/Max")
    self.probabilityTip = self.coinBtn:Find("tip"):GetComponent("UILabel")
    self.scene:boundButtonEvents(self.upgradeEquipPanel)
end

function EquipUpgradeView:SetActive(enable)
    if self.effectObj ~= nil then
        self.effectObj.gameObject:SetActive(false)
    end
    self.upgradeEquipPanel:SetActive(enable)
    if enable then
        self:UpgradeEquipPanel_listUpdate() -- 清空列表数据
        self.scene:listUpdate(self.UpgradeEquipPanel_itemsGrid) -- 更新列表
        local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo) -- 获取要升级的按钮
        local selectBtn = EquipInfoTab[TxtFactory.EQUIPMAIN_SELECTED] + 1
        local btn = self.UpgradeEquipPanel_itemsGrid.gameObject.transform:FindChild(tostring(selectBtn))
        self:UpgradeEquipPanel_listBtnOnClick(btn.gameObject) -- 选中要升级的按钮
        -- print("当前升级的装备为"..selectBtn)
    end
end

-- 单个按钮点击
function EquipUpgradeView:UpgradeEquipPanel_listBtnOnClick(btn)
    for i = 1,self.UpgradeEquipPanel_itemsGrid.gameObject.transform.childCount do
		local child = self.UpgradeEquipPanel_itemsGrid.gameObject.transform:GetChild(i-1)
		local state_gou = child.gameObject.transform:FindChild("state_gou")
		state_gou.gameObject:SetActive(false)
     end

    local state_gouBtn = btn.gameObject.transform:FindChild("state_gou")
    state_gouBtn.gameObject:SetActive(true)

    self.UpgradeEquipPanel_isSelectItem = tonumber(btn.gameObject.name) - 1
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    EquipInfoTab[TxtFactory.UPGRADE_SELECTED] = self.UpgradeEquipPanel_isSelectItem

    -- 更新UI 
    self:UpgradeEquipPanel_UIUpdate(self.UpgradeEquipPanel_isSelectItem)
end

-- UI更新
function EquipUpgradeView:UpgradeEquipPanel_UIUpdate(id)
    local coinBtnLabel = self.coinBtn.gameObject.transform:FindChild("needValue"):GetComponent("UILabel")
    local diamondBtnLabel = self.diamondBtn.gameObject.transform:FindChild("needValue"):GetComponent("UILabel")
    local leftIcon = self.upgradeEquipPanel.gameObject.transform:FindChild("UI/title/equipInfo/Background")
    

    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local tid = self.management:idFindForTid(id)
    self.scene:setIcon(leftIcon,tid) -- 更新左侧icon
    -- 升级概率更新
    local probability = self.equipTable:GetData(tid, "UPRATE")
    if tonumber(probability) then
        self.probabilityTip.text = "金币升级概率:" .. tonumber(probability)*100 .. "%"
    end
    -- 更新装备名，装备等级
    self.itemNameLabel.text = self.equipTable:GetData(tid,"NAME")
    self.itemLevelLabel.text = "Lv." .. tostring(self.equipTable:GetData(tid, TxtFactory.S_EQUIP_LVL))

    local itemAtt = function(levelMax) -- 设置装备附加属性
        if levelMax then
            local dataName, curdata = self.management:getExtAttribute(tid)
            self.attNameLabel.text = tostring(self.equipTable:GetData(tid,"EQUIPMENTDESC"))
            self.attValueLabel.text = "[FF0000]"..tostring(curdata).."[-]"
        else
            local dataName, curdata = self.management:getExtAttribute(tid)
            self.attNameLabel.text = tostring(self.equipTable:GetData(tid,"EQUIPMENTDESC"))
            local dataName, nextdata = self.management:getExtAttribute(tonumber(tid)+1)
            self.attValueLabel.text = "[824614]"..tostring(curdata).."[-][FF0000]>"..tostring(nextdata).."[-]"
        end
    end
    -- 更新升级按钮
    local equipType = self.equipTable:GetData(tid,"TYPE")
    if equipType == "4" then
        self.coinBtn.gameObject:SetActive(false)
        self.diamondBtn.gameObject:SetActive(false)
        itemAtt(true)
        return
    end
    local nub = self.equipTable:GetData(tid, TxtFactory.S_EQUIP_MAX) -- 满级判断
    self.coinBtn.gameObject:SetActive(tonumber(tid) ~= tonumber(nub))
    self.diamondBtn.gameObject:SetActive(tonumber(tid) ~= tonumber(nub))
    self.levelMax.gameObject:SetActive(tonumber(tid) == tonumber(nub))
    if tonumber(tid) ~= tonumber(nub) then
        -- 升级花费
        local upgold = self.equipTable:GetData(tid,"UPGOLD")
        local updiamond = self.equipTable:GetData(tid,"UPDIAMOND")
        coinBtnLabel.text = upgold
        diamondBtnLabel.text = updiamond
        itemAtt(false)
    else
        itemAtt(true)
    end
end

--关闭所有窗口，包括装备升级窗口和装备信息窗口
function EquipUpgradeView:DestroySelf()
    self:UpgradeEquipPanel_closeBtn()
    self:UpgradeEquipPanel_upgradePanelShowCloseBtn()
end

-- 关闭按钮
function EquipUpgradeView:UpgradeEquipPanel_closeBtn()
    local modelShow = self.scene.modelShow
    modelShow:SetActive(true, modelShow.equip)
    self:SetActive(false)
    self.scene.mainView:SetActive(true)
end

-- 升级金币按钮（发送）
function EquipUpgradeView:UpgradeEquipPanel_coinBtn()
    local tid = self.management:idFindForTid(self.UpgradeEquipPanel_isSelectItem)

    local upgold = self.equipTable:GetData(tid,"UPGOLD")
    local diamond = 0
    local coin = tonumber(upgold)
    local flag = self.scene:coinPriceCheck(coin)
    local equipType = self:equipUpgradeCheck(tid)
    if flag == false or equipType == "4" then
        return
    end

    self:UpgradeEquipPanel_levelUpBtn(coin,diamond)
    local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
    memData:AddUserInfo(-coin,diamond)   -- 刷新金币钻石
    self.scene:UpdatePlayerInfo()
end

-- 升级钻石按钮（发送）
function EquipUpgradeView:UpgradeEquipPanel_daimondBtn()
    local tid = self.management:idFindForTid(self.UpgradeEquipPanel_isSelectItem)

    local updiamond = self.equipTable:GetData(tid,"UPDIAMOND")
    local coin = 0
    local diamond = tonumber(updiamond)
    local flag = self.scene:diamondPriceCheck(updiamond)
    local equipType = self:equipUpgradeCheck(tid)
    if flag == false or equipType == "4" then
        return
    end
    self:UpgradeEquipPanel_levelUpBtn(0,self.UpgradeEquipPanel_use_diamond)
    local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
    memData:AddUserInfo(coin,-diamond)   -- 刷新金币钻石
    self.scene:UpdatePlayerInfo()
end

-- 升级统一发送
function EquipUpgradeView:UpgradeEquipPanel_levelUpBtn(coin,diamond)
        -- 五级更新出现小窗口
    -- local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)

    -- for i=1,#EquipInfoTab.bin_equips do
    --     local id = EquipInfoTab.bin_equips[i].id
    --     local tid = EquipInfoTab.bin_equips[i].tid

    --     if tonumber(self.UpgradeEquipPanel_isSelectItem.name) - 1 == id then
    --         local ctid = string.sub(tostring(tid),6,-1)
    --         if tonumber(ctid) == self.UpgradeEquipPanel_levelForPanelShow then
    --             -- self:UpgradeEquipPanel_creatUpgradePanelShow()
    --             return
    --         end
    --     end

    -- end
    self.management:sendEquiplevelUp(coin,diamond)
end

-- 升级金币按钮（返回）
function EquipUpgradeView:UpgradeEquipPanel_coinBtnFromSer(info)
    self:UpgradeEquipPanel_listUpdate() -- 清空列表数据
    self.scene:listUpdate(self.UpgradeEquipPanel_itemsGrid,self.UpgradeEquipPanel_isSelectItem) -- 更新此界面列表
    -- self.scene:updateEquipList() --更新主界面列表
    self:UpgradeEquipPanel_UIUpdate(self.UpgradeEquipPanel_isSelectItem) -- 更新ui
end

-- 清空当前列表信息
function EquipUpgradeView:UpgradeEquipPanel_listUpdate()
    destroy(self.UpgradeEquipPanel_itemsGrid)
    self.UpgradeEquipPanel_itemsGrid = GameObject.New()
    local items = self.upgradeEquipPanel.gameObject.transform:FindChild("UI/items")
    self.UpgradeEquipPanel_itemsGrid.name =  "EquipeLevelUpUIgrid"
    self.UpgradeEquipPanel_itemsGrid.gameObject.transform.parent = items.gameObject.transform
    self.UpgradeEquipPanel_itemsGrid.gameObject.transform.localPosition = Vector3(-120,110,0)
    self.UpgradeEquipPanel_itemsGrid.gameObject.transform.localScale = Vector3(1,1,1)

    local  ms = self.UpgradeEquipPanel_itemsGrid:AddComponent(UIGrid.GetClassType())
    ms.cellWidth = 120
    ms.cellHeight = 120
    ms.maxPerLine = 3
end

--升级特效
function EquipUpgradeView:UpgradeEquipAddEffect()
    if self.effectObj == nil then
        self.effectObj = newobject(Util.LoadPrefab("Effects/UI/ef_ui_shengji"))
        SetEffectOrderInLayer( self.effectObj,10)
        SetGameObjectLayer(self.effectObj,self.effectParentObj)
     end
     TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.levelup)
     self.effectObj.gameObject:SetActive(false)

     self.effectObj.transform.parent = self.effectParentObj.transform
	 self.effectObj.transform.localPosition = Vector3.zero
	 self.effectObj.transform.localScale = Vector3.one
     self.effectObj.gameObject:SetActive(true)
end

-- 创建升级小窗口 
function EquipUpgradeView:UpgradeEquipPanel_creatUpgradePanelShow()
    self.UpgradeEquipPanel_UpgradePanelShow = self.scene:LoadUI("Equip/LevelUpPopupUI")

end

-- 升级小窗口 关闭按钮
function EquipUpgradeView:UpgradeEquipPanel_upgradePanelShowCloseBtn()
    destroy(self.UpgradeEquipPanel_UpgradePanelShow)
end

-- 升级小窗口 升级按钮
function EquipUpgradeView:UpgradeEquipPanel_upgradePanelShowUpgradeBtn()
    local coin = self.UpgradeEquipPanel_use_coin
    local diamond = 0
    self:UpgradeEquipPanel_levelUpBtn(coin,diamond)

    destroy(self.UpgradeEquipPanel_UpgradePanelShow)
end

-- 升级装备检查
function EquipUpgradeView:equipUpgradeCheck(tid)
    local equipType = self.equipTable:GetData(tid,"TYPE")
    if equipType == "4" then
        local word = "该装备不能升级"
        self.scene:promptWordShow(word)
    end
    return equipType
end