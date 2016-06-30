--[[
author:Desmond
装备主界面
]]
EquipMainView = class()

EquipMainView.scene = nil --场景scene
EquipMainView.management = nil -- 数据model
EquipMainView.EquipInfoTab = nil -- 装备信息动态表

EquipMainView.equipPanel = nil  -- 装备界面
EquipMainView.equipPanel_material = nil -- 左下角三个格子 根
EquipMainView.equipListView = nil -- 装备列表面板
EquipMainView.equipPanel_itemsGrid = nil  -- 放格子list的根
EquipMainView.equipPanel_leftVolumeTab = nil -- 已装备的物品 保存

EquipMainView.equipPanel_equipUpgradePanel = nil -- 装备/升级 小界面
EquipMainView.equipPanel_unequipUpgradePanel = nil -- 卸载装备/升级 小界面

EquipMainView.equipPanel_volumeBuyPanel = nil -- 容器购买 

EquipMainView.equipPanel_equipUpgradePanelnameLabel = nil -- 装备/升级 小界面 名字
EquipMainView.equipPanel_equipUpgradePaneldesLabel = nil -- 装备/升级 小界面 数值
EquipMainView.equipPanel_unequipUpgradePanelnameLabel = nil -- 卸载装备/升级 小界面
EquipMainView.equipPanel_unequipUpgradePaneldesLabel = nil -- 卸载装备/升级 数值

EquipMainView.equipPanel_isSelectItem = nil -- 当前选中的按钮

EquipMainView.maxSlot = 3
EquipMainView.equipTable = nil -- icon名称表
EquipMainView.TopCoinDiamond = nil
EquipMainView.level = 1

--初始化界面
function EquipMainView:init(target)
    self.scene = target
    self.sceneTarget = target.sceneTarget
    self.equipTable = TxtFactory:getTable(TxtFactory.EquipTXT)
    self.equipPanel = self.scene:LoadUI("Equip/EquipUI")  -- 创建界面
    self.equipListView = self.equipPanel.transform:Find("UI/items")
    self.equipPanel_itemsGrid = self.equipListView:GetChild(0)
    self.equipPanel_material = find("EquipUI_material")

    self.management = self.scene.EquipManagement

    self.scene:SetUiAnChor()
    self.scene:boundButtonEvents(self.equipPanel)
end

function EquipMainView:SetActive(enable)
    self.equipPanel:SetActive(enable)
    if enable then
      self:EquipPanel_listUpdate()
    end
end

-- 更新装备列表
function EquipMainView:EquipPanel_listUpdate()
    self.EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    if not self.EquipInfoTab or next(self.EquipInfoTab) == nil then
      self.management:sendEquipInfo()-- 获取角色信息
      return
    end
    
    destroy(self.equipPanel_itemsGrid.gameObject)
    self.equipPanel_itemsGrid = newobject(Util.LoadPrefab("UI/Equip/itemsGrid"))
    self.equipPanel_itemsGrid.name =  "itemsGrid"
    self.equipPanel_itemsGrid.transform.parent = self.equipListView
    self.equipPanel_itemsGrid.transform.localPosition = Vector3(0,80,0)
    self.equipPanel_itemsGrid.transform.localScale = Vector3(1,1,1)

    -- 左边格子状态清空
    for o = 1 ,self.equipPanel_material.transform.childCount do
		  local child = self.equipPanel_material.transform:GetChild(o-1)
		  local childIcon = child.gameObject.transform:FindChild("icon")
		  childIcon.gameObject:SetActive(false)
      local iconBack = child.gameObject.transform:FindChild("Background")
      iconBack:GetComponent("UISprite").spriteName = "huikuang"
    end

    -- 刷新已有装备
    self.scene:listUpdate(self.equipPanel_itemsGrid)
    -- 服务器消息 给装备赋值
    for u = 1 , #self.EquipInfoTab.bin_equips do
        -- 判断已经装备的 作处理
        if self.EquipInfoTab.bin_equips[u].slot ~= 0 then
            local obj = self.equipPanel_itemsGrid.transform:GetChild(u-1)
            local state_zhuangbei = obj.gameObject.transform:FindChild("state_zhuangbei") 
            state_zhuangbei.gameObject:SetActive(true)
        end
    end
    -- 添加加格子按钮
    if self.EquipInfoTab.unlocknum < self.EquipInfoTab.maxnum then
        local addVolumeBtn = self.scene:creatVolumeList("EquipUIt_addVolume",self.equipPanel_itemsGrid,self.equipPanel)
        addVolumeBtn.gameObject.name = "EquipUIt_addVolume"
    end
    
    local grid = self.equipPanel_itemsGrid:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列
    self.equipListView:GetComponent("UIScrollView"):ResetPosition()


    -- 给左下装备赋值
    -- 解锁
    for y = 1, self.EquipInfoTab.unlockslot do     --解锁的格子数
      local childy = self.equipPanel_material.gameObject.transform:GetChild(y-1)
      local childyLock = childy.gameObject.transform:FindChild("lock")
      childyLock.gameObject:SetActive(false)
    end
 
    local equipedEquipIds = self:GetEquipedEquipInfo()  -- 已穿戴的装备

    -- 更新左下角icon
    for t = 1, #equipedEquipIds do
        local childt = self.equipPanel_material.transform:GetChild(t-1)
        self.scene:setIcon(childt,equipedEquipIds[t].tid)
        --GamePrint("eeeeeeeeeeeee")
    end

    --刷新未解锁的格子
    local JieSuoTiaoJianTXT = TxtFactory:getTable(TxtFactory.JieSuoTiaoJianTXT)
    for yy = 2, 3 do     --解锁的格子数
      local childy = self.equipPanel_material.gameObject.transform:GetChild(yy-1)
      local r1,r2 = self.scene.sceneParent.FunctionOpen:UpdataFunctionOpen(JieSuoTiaoJianTXT.EquipID[yy])
      local childyLock = childy.gameObject.transform:FindChild("lock")
      if r1 == true then
        GamePrintTable("已经解锁！！！")
        childyLock.gameObject:SetActive(false)
        self.EquipInfoTab.unlockslot = self.EquipInfoTab.unlockslot + 1
      else
        childyLock.gameObject:SetActive(true)
        self:SetGeziBtn(childy.gameObject,r2)
      end
    end

end
function EquipMainView:SetGeziBtn(btn,errtxt)
    AddonClick(btn,function( ... )
        self.scene:promptWordShow(errtxt)
    end)
end

--筛选出所有已穿戴的装备
function EquipMainView:GetEquipedEquipInfo()
  
    local equipedEquipIds = {}
    for  i=1,#self.EquipInfoTab.bin_equips do
       if self.EquipInfoTab.bin_equips[i].slot ~= 0 then
          equipedEquipIds[#equipedEquipIds + 1] = self.EquipInfoTab.bin_equips[i]
       end
    end
    return equipedEquipIds
end

-- 装备列表按钮 OnClick 弹出更换装备界面
function EquipMainView:EquipPanel_listBtnOnClick(btn)
  
  -- print("弹出更换装备界面 ： ") -- 有三种情况 出现  装备 卸载 更换
    local slot = btn.name
    
    self.EquipInfoTab[TxtFactory.EQUIPMAIN_SELECTED] = tonumber(btn.gameObject.name) - 1

    local equipVolume = self.management:getEquipedValue()
    -- 先判断替换
    if equipVolume == self.maxSlot then
         -- 创建替换界面
         -- print("创建替换界面")
         return
    end

    -- 再判断是否装备了
    for i , v in ipairs(self.EquipInfoTab.bin_equips) do
         -- print("判断是否装备了"..v.name.." "..btn.name)
         if v.slot ~= 0 then
             if v.id ==  btn.name -1 then
                 -- print("装备了")
                 self:creatEquipPanel_unequipmentUpgradePanel(btn)
                 return
             end
         end
    end

    -- 最后一种情况是未装备的
     self:creatEquipPanel_equipmentUpgradePanel(btn)
end



--增加装备格子 (发送)
function EquipMainView:EquipPanel_extendSlotPost() 
    -- self.management:sendExtendSlot()
    self:creatvolumeBuyPanel()
end

function EquipMainView:OnLeftBagItem(action)
    local nub = nil -- 目标装备位
    local str_arr = lua_string_split(action, " ")
    if #str_arr == 2 then
        nub = tonumber(str_arr[2])
    end

    local equipedEquipIds = self:GetEquipedEquipInfo()  -- 已穿戴的装备
    if not nub or #equipedEquipIds == 0 then
      return
    end

    local target_tid = nil
    for i=1, #equipedEquipIds do
      if nub == equipedEquipIds[i].slot then
        print(nub.."号装备位上装备了"..equipedEquipIds[i].tid.."装备")
        target_tid = equipedEquipIds[i].tid
        self.EquipInfoTab[TxtFactory.EQUIPMAIN_SELECTED] = equipedEquipIds[i].id
        break
      end
    end
    if target_tid then
      self.management:sendUnequip(nub)
    end
end

-- 装备/升级 小界面 装备按钮 (发送)
function EquipMainView:EquipmentUpgradePanel_equipBtn()
     self.management:sendEquipItem()
end

-- 装备/升级 小界面 装备按钮 (返回)
function EquipMainView:EquipmentUpgradePanel_equipBtnFromSer()
    self:EquipPanel_listUpdate()
    self.EquipmentUpgradePanel_equipBtnWait = false
    self.equipPanel_equipUpgradePanel:SetActive(false)
end

-- 装备/升级 小界面 升级按钮 
function EquipMainView:EquipmentUpgradePanel_upgradeEquipBtn()
     self.equipPanel_equipUpgradePanel:SetActive(false)
     self.scene:EquipPanel_UpgradeView()
     self:SetActive(false)
end

-- 装备/升级 小界面 关闭按钮 
function EquipMainView:EquipmentUpgradePanel_closeBtn()
    self.equipPanel_equipUpgradePanel:SetActive(false)
end


-- 卸载装备/升级 小界面 装备按钮 (发送)
function EquipMainView:UnequipmentUpgradePanel_equipBtn()
    self.management:sendUnequip()
end

-- 卸载装备/升级 小界面 装备按钮 (返回)
function EquipMainView:UnequipmentUpgradePanel_equipBtnFromSer()
    self:EquipPanel_listUpdate()
    self.UnequipmentUpgradePanel_equipBtnWait = false
    if self.equipPanel_unequipUpgradePanel then
      self.equipPanel_unequipUpgradePanel:SetActive(false)
    end
end

-- 卸载装备/升级 小界面 升级按钮 
function EquipMainView:UnequipmentUpgradePanel_upgradeEquipBtn()
     self.equipPanel_unequipUpgradePanel:SetActive(false)
     self.scene:EquipPanel_UpgradeView()
end

-- 卸载装备/升级 小界面 关闭按钮 
function EquipMainView:UnequipmentUpgradePanel_closeBtn()
    self.equipPanel_unequipUpgradePanel:SetActive(false)
end

-- 创建 装备/升级 小界面
function EquipMainView:creatEquipPanel_equipmentUpgradePanel(btn)
  if self.equipPanel_equipUpgradePanel == nil then
    self.equipPanel_equipUpgradePanel = self.scene:LoadUI("Equip/EquipePopupUI")  -- 创建界面
    self.equipPanel_equipUpgradePanelnameLabel = find("EquipePopupUI_nameLabel").gameObject.transform:GetComponent("UILabel") -- 装备/升级 小界面 名字
    self.equipPanel_equipUpgradePaneldesLabel = find("EquipePopupUI_nubLabel").gameObject.transform:GetComponent("UILabel") -- 装备/升级 小界面 数值
  else
    self.equipPanel_equipUpgradePanel:SetActive(true)
  end

  -- local t =  nil
  iconBack = self.equipPanel_equipUpgradePanel.transform:FindChild("UI/title/equipInfo/info/Background")   
  icon = self.equipPanel_equipUpgradePanel.transform:FindChild("UI/title/equipInfo/info/Background/icon")
  -- local iconBackName = GetSpriteName(btn.transform:FindChild("Background").gameObject)
  -- local iconName = GetSpriteName(btn.transform:FindChild("icon").gameObject)
  -- SetSprite(iconBack.gameObject,iconBackName)
  -- SetSprite(icon.gameObject,iconName)

  
  local tid = nil
  for i , v in ipairs(self.EquipInfoTab.bin_equips) do
      -- print("判断是否装备了"..v.name.." "..btn.name)
      if v.id ==  btn.name -1 then
          tid = v.tid
      end
         
  end
  
  self.scene:infoPanelWordShow(tid,self.equipPanel_equipUpgradePanelnameLabel,self.equipPanel_equipUpgradePaneldesLabel,iconBack,icon) 
end

-- 创建 卸载装备/升级 小界面
function EquipMainView:creatEquipPanel_unequipmentUpgradePanel(btn)
  if not self.equipPanel_unequipUpgradePanel then
      self.equipPanel_unequipUpgradePanel = self.scene:LoadUI("Equip/EquipePopdownUI")  -- 创建界面
  else
      self.equipPanel_unequipUpgradePanel:SetActive(true)
  end

  self.equipPanel_unequipUpgradePanelnameLabel = find("MaterialPopupUI_nameLabel").gameObject.transform:GetComponent("UILabel") -- 卸载装备/升级 小界面
  self.equipPanel_unequipUpgradePaneldesLabel = find("MaterialPopupUI_type").gameObject.transform:GetComponent("UILabel") -- 卸载装备/升级 数值

  iconBack = self.equipPanel_unequipUpgradePanel.transform:FindChild("UI/title/MaterialInfo/info/Background")   
  icon = self.equipPanel_unequipUpgradePanel.transform:FindChild("UI/title/MaterialInfo/info/Background/icon")

  
  local tid = nil
  for i , v in ipairs(self.EquipInfoTab.bin_equips) do
      -- print("判断是否装备了"..v.name.." "..btn.name)
      if v.id ==  btn.name -1 then
          tid = v.tid
      end
  end

  self.scene:infoPanelWordShow(tid,self.equipPanel_unequipUpgradePanelnameLabel,self.equipPanel_unequipUpgradePaneldesLabel,iconBack,icon) 

    -- self.equipPanel_unequipUpgradePanelnameLabel.text = "t"
    -- self.equipPanel_unequipUpgradePaneldesLabel.text = "tid"
end

-- 创建 购买扩建容器按钮
EquipMainView.erroyText = ""
function EquipMainView:creatvolumeBuyPanel()
    self.equipPanel_volumeBuyPanel = self.scene:LoadUI("Equip/EquipeBuyVolumeUI")  -- 创建界面
    self.erroyText = ""
    -- 购买价钱
    local gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
    local  nNum = gameConfigTXT:GetData(1003,"CONFIG2")
    local  sSprings = string.split(gameConfigTXT:GetData(1003,"CONFIG3"),";") 
    --GamePrintTable(sSprings)
    --GamePrintTable(self.EquipInfoTab)
    local  bBuyNum = self.EquipInfoTab.buy_num ~= nil and tonumber(self.EquipInfoTab.buy_num) or 0
    local Lable = self.equipPanel_volumeBuyPanel.transform:FindChild("UI/title/PrizeLab/Label")
    local Lable1 = self.equipPanel_volumeBuyPanel.transform:FindChild("UI/title/PrizeLab/Label1")
    if bBuyNum >= #sSprings then
        Lable:GetComponent("UILabel").text = "背包栏全部开放，无需购买"
        Lable1.gameObject:SetActive(false)
        self.erroyText = "装备格子已达上限"
    else
       local  pPrize = sSprings[bBuyNum+1];

       Lable:GetComponent("UILabel").text = string.format("扩展%s个格子需要花费",nNum)
       Lable1.gameObject:SetActive(true)
       Lable1:GetComponent("UILabel").text = tostring(pPrize)
       --string.format("需要花费[ff0000]%s[-]钻石开启 [ff0000]%s[-]装备格子", pPrize,nNum)
      --self.EquipInfoTab.buy_num = bBuyNum + 1
      local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
      if UserInfo[TxtFactory.USER_DIAMOND] < tonumber(pPrize) then
          self.erroyText = "钻石不足，请充值"
      end
    end
end

-- 购买容量按钮
function EquipMainView:volumeBuyPanel_buyBtn()
  if  self.erroyText ~= "" then
      self.scene:promptWordShow(self.erroyText)
      return
  end
  self.management:sendExtendSlot()
  --self.EquipInfoTab.buy_num = bBuyNum + 1
end

-- 关闭 购买扩建容器按钮
function EquipMainView:volumeBuyPanel_closeBtn()
    destroy(self.equipPanel_volumeBuyPanel)
end

-- 打开界面
function EquipMainView:showPanel()
  self.equipPanel.gameObject:SetActive(true)
  self:EquipPanel_listUpdate()
end