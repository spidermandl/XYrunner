--[[
author:Huqiuxiang
装备图鉴界面
]]

EquipHandbookView = class()

EquipHandbookView.HandBookEquipPanel_itemsGrid = nil 

EquipHandbookView.scene = nil --场景scene
EquipHandbookView.management = nil -- 数据model

EquipHandbookView.HandBookEquipPanel_handbookTab = nil -- 全部图鉴
EquipHandbookView.HandBookEquipPanel_handbookGetTab = nil -- 已经拥有的
EquipHandbookView.HandBookEquipPanel_infoPanel = nil -- 小界面
EquipHandbookView.equipCount = nil -- 装备数量文本

-- 创建装备图鉴面板 
function EquipHandbookView:init(target)
    self.scene = target
    self.level = 2
    self.handbookEquipPanel = self.scene:LoadUI("Equip/EquipHandBookUI")
    self.HandBookEquipPanel_itemsGrid = find("EquipHandBookUI_itemsGrid")
    self.equipCount = self.handbookEquipPanel.transform:Find("UI/title/equipCount"):GetComponent("UILabel")
    self.management = self.scene.EquipManagement
    self:HandBookEquipPanel_listUpdate()
    self.scene:boundButtonEvents(self.handbookEquipPanel)
end

function EquipHandbookView:SetActive(enable)

    if enable == true and self.handbookEquipPanel.activeSelf ~= true then
        self:HandBookEquipPanel_listUpdate()
    end

    self.handbookEquipPanel:SetActive(enable)

end

--创建图鉴面板  小界面
function EquipHandbookView:creatHandBookEquipPanel_infoPanel(btn)

    self.HandBookEquipPanel_infoPanel = self.scene:LoadUI("Equip/HandBookPopupUI")
    local nameLabel = find("HandBookPopupUI_nameLabel").gameObject:GetComponent("UILabel") -- 装备/升级 小界面 名字
    local desLabel = find("HandBookPopupUI_des").gameObject:GetComponent("UILabel") -- 装备/升级 小界面 数值
    -- local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    -- local t =  nil

    iconBack = self.HandBookEquipPanel_infoPanel.transform:FindChild("UI/title/equipInfo/info/Background")   
    icon = self.HandBookEquipPanel_infoPanel.transform:FindChild("UI/title/equipInfo/info/Background/icon")
    -- local iconBackName = GetSpriteName(btn.transform:FindChild("Background").gameObject)
    -- local iconName = GetSpriteName(btn.transform:FindChild("icon").gameObject)
    -- SetSprite(iconBack.gameObject,iconBackName)
    -- SetSprite(icon.gameObject,iconName)
    -- local equipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    -- self.HandBookEquipPanel_handbookTab = equipInfoTab[TxtFactory.HANDBOOK_INFOTAB]


    local tid = self.HandBookEquipPanel_handbookTab[tonumber(btn.name)].id
    -- print("fjc-----creatHandBookEquipPanel_infoPanel---------------------"..tostring(tid))
    self.scene:infoPanelWordShow(tid,nameLabel,desLabel,iconBack,icon)  

end

-- 文字显示（小窗口）
function EquipManagement:infoPanelWordShow(id,nameLabel,desciptLabel)
    -- nameLabel.text = self.equipTable:GetData(id,"NAME")
    -- desciptLabel.text = self.equipTable:GetData(id,"NAME")
    local t = nil
    local name = self.equipTable:GetData(id,"NAME")
    --print ("--------------function EquipManagement:infoPanelWordShow "..tostring(id)..' '..tostring(name))
    for i = 10, self.equipTable:GetColumnLength() -1 do
        t =  self.equipTable:GetDataByColumnIndex(id,i)
        if t ~= "" then
            -- print("t"..tostring(t))
            break
        end
    end
    nameLabel.text = name
    desciptLabel.text = self.equipTable:GetData(id,"EQUIPMENTDESC")
end

-- 更新列表
function EquipHandbookView:HandBookEquipPanel_listUpdate()

    self.management:handBookData() -- 配置表数据处理

    local equipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
	self.HandBookEquipPanel_handbookTab = equipInfoTab[TxtFactory.HANDBOOK_INFOTAB]
	
    self.HandBookEquipPanel_handbookGetTab = {}
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)

    --GamePrintTable("HandBookEquipPanel_listUpdate")
    for i=1,#EquipInfoTab.bin_equips do
        --GamePrintTable(tostring(3333333))
        local tid = tonumber(EquipInfoTab.bin_equips[i].tid)
        self.HandBookEquipPanel_handbookGetTab[tid] = true
    end

    --GamePrintTable(EquipInfoTab)
    --GamePrintTable(self.HandBookEquipPanel_handbookGetTab)
    -- print("nub"..#self.HandBookEquipPanel_handbookTab)
    
    local maxnum = #self.HandBookEquipPanel_handbookTab
    local itemGrid = self.HandBookEquipPanel_itemsGrid
    local curNum = tonumber(itemGrid.transform.childCount)
    for i =1 , maxnum do
        local ico
        if i > curNum then
    	   ico = self.scene:creatVolumeList("icoBack",itemGrid,self.scene.mainView.equipPanel)
    	   ico.gameObject.name = i
        else
            ico = itemGrid.transform:GetChild(i -1 ) --itemGrid.transform:FindChild(tostring(i))
        end

        local icon = ico.gameObject.transform:FindChild("icon")
        icon.gameObject:SetActive(true)
        local iconBack = ico.gameObject.transform:FindChild("Background")
        -- local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
        iconId = self.HandBookEquipPanel_handbookTab[i].id
        local  EquipTXT = TxtFactory:getTable(TxtFactory.EquipTXT)
        local iconName = EquipTXT:GetData(iconId, "EQUIPMENT_ICON") 

        local iconSp = icon:GetComponent("UISprite")
        if iconName and iconSp then 
            iconSp.spriteName = iconName--fjc
        end

        local level = EquipTXT:GetData(iconId,"RANK")

        local iconBackSp = iconBack:GetComponent("UISprite")
        if level == "A" then
          iconBackSp.spriteName = "lankuang"
        elseif level == "B" then 
            iconBackSp.spriteName = "lvkuang"
        elseif level == "S" then
            iconBackSp.spriteName = "zikuang"
        elseif level == "SS" then
            iconBackSp.spriteName = "huangkuang"
        else
            iconBackSp.spriteName = "huikuang"
        end

        --[[-- 已经拥有的作处理
                        if self.HandBookEquipPanel_handbookTab[i].flag == true then
                            local gou = ico.gameObject.transform:FindChild("state_gou")
                            gou.gameObject:SetActive(true)
                        end]]

         -- 已经拥有的作处理
         --GamePrintTable("HandBookEquipPanel_listUpdate ="..tostring(iconId))
          local gou = ico.gameObject.transform:FindChild("state_gou")
        if self.HandBookEquipPanel_handbookGetTab[tonumber(iconId)] == true then
            iconSp.atlas = Util.PreLoadAtlas("UI/Picture/EquipIcon")
            iconBackSp.atlas = Util.PreLoadAtlas("UI/Picture/EquipIcon")
            gou.gameObject:SetActive(true)
        else
            iconSp.atlas = Util.PreLoadAtlas("UI/Picture/EquipIconGray")
            iconBackSp.atlas = Util.PreLoadAtlas("UI/Picture/EquipIconGray")
            gou.gameObject:SetActive(false)
        end

    end

    local grid = itemGrid.gameObject.transform:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列

    self.equipCount.text = "[824614]我的装备:[-][FF0000]"..#equipInfoTab.bin_equips.."个[-]"

end
--[[-- 再生成
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    for i = 1 , EquipInfoTab.unlocknum do 
          local ico = self:creatVolumeList("icoBack",itemGrid,self.sceneTarget)
          self:SetButtonTarget(ico,self.sceneTarget)
          ico.name = "equipitem "..i
    end

    local grid = itemGrid.gameObject.transform:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列


    --排序 
    table.sort(EquipInfoTab.bin_equips,function(a,b) 
      local sa = RankNum[self.EquipTXT:GetData(a.tid,"RANK")]*100+a.tid%1000
      local sb = RankNum[self.EquipTXT:GetData(b.tid,"RANK")]*100+b.tid%1000

        if sa == sb  then
            return tonumber(a.tid) > tonumber(b.tid)
        else
            return sa > sb
        end

    end) 
 
    -- 服务器消息 给装备赋值
    for u = 1 , #EquipInfoTab.bin_equips do
        if u > EquipInfoTab.unlocknum then -- 超出装备格子限制
            warn("已有装备数量大于装备格子数")
            break
        end
        local name = tostring(EquipInfoTab.bin_equips[u].id + 1)
        -- local obj = itemGrid.gameObject.transform:FindChild(name)
        local obj = itemGrid.transform:GetChild(u-1)
        obj.name = name
        -- 以后根据tid 遍历配置的信息 找相应的ico的图片
        self:setIcon(obj,EquipInfoTab.bin_equips[u].tid)
    end]]
--关闭所有窗口，包括装备图鉴窗口和装备信息窗口
function EquipHandbookView:DestroySelf()
    self:HandBookEquipPanel_closeBtn()
    self:HandBookEquipPanel_infoCloseBtn()
end

-- 关闭按钮
function EquipHandbookView:HandBookEquipPanel_closeBtn()
    self:SetActive(false)
    self.scene.mainView:SetActive(true)
    local modelShow = self.scene.modelShow
    modelShow:SetActive(true, modelShow.equip)
end

-- 单个按钮点击
function EquipHandbookView:HandBookEquipPanel_listBtnOnClick(btn)
    self:creatHandBookEquipPanel_infoPanel(btn)


end

-- 小界面关闭 
function EquipHandbookView:HandBookEquipPanel_infoCloseBtn()
    -- self.scene.modelShow:SetActive(true)
    destroy(self.HandBookEquipPanel_infoPanel)

end