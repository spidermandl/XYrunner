--[[
	author:Desmond
	装备融合功能逻辑
]]

EquipMergeView = class ()

EquipMergeView.scene = nil --场景scene
EquipMergeView.management = nil -- 数据model

EquipMergeView.mergeEquipPanel = nil
EquipMergeView.MergeEquipPanel_itemsGrid = nil 
EquipMergeView.MergeEquipPanel_equipCountLabel = nil 
EquipMergeView.MergeEquipPanel_desriptPanel = nil 
EquipMergeView.MergeEquipPanel_leftVolumeTab = nil 
EquipMergeView.MergeEquipPanel_isSelectItem = nil -- 选中按钮
EquipMergeView.MergeEquipPanel_replacePanel = nil -- 替换界面

EquipMergeView.leftVolumeMax = 3 
--初始化
function EquipMergeView:init(targetScene)
    self.scene = targetScene
    self.mergeEquipPanel = self.scene:LoadUI("Equip/EquipSmeltUI")
    self.MergeEquipPanel_itemsGrid = find("EquipSmeltUIgrid")
    self.MergeEquipPanel_equipCountLabel = find("equipCountLabel")

    self.management = self.scene.EquipManagement
   
    self.MergeEquipPanel_material = find("EquipSmeltUI_material")

    self.MergeEquipPanel_leftVolumeTab = {}
    self:ResetLeftTab()
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    EquipInfoTab[TxtFactory.MERGE_EQUIPEDNFO] = self.MergeEquipPanel_leftVolumeTab

    self:MergeEquipPanel_listUpdate()
    self.scene:boundButtonEvents(self.mergeEquipPanel)

end

function EquipMergeView:SetActive(enable)
    self.mergeEquipPanel:SetActive(enable)
    if enable then
        self:MergeEquipPanel_listUpdate()
        self.scene:listUpdate(self.MergeEquipPanel_itemsGrid) -- 更新列表
    else
        self:ResetLeftTab()
    end
end

function EquipMergeView:ResetLeftTab()
    self.MergeEquipPanel_leftVolumeTab[1] = nil
    self.MergeEquipPanel_leftVolumeTab[2] = nil
    self.MergeEquipPanel_leftVolumeTab[3] = nil
end

-- 更新列表
function EquipMergeView:MergeEquipPanel_listUpdate()
    destroy(self.MergeEquipPanel_itemsGrid)
    self.MergeEquipPanel_itemsGrid = newobject(Util.LoadPrefab("UI/Equip/EquipSmeltUIgrid"))
    local items = find("EquipSmeltUIitems")
    self.MergeEquipPanel_itemsGrid.name =  "EquipSmeltUIgrid"
    self.MergeEquipPanel_itemsGrid.transform.parent = items.gameObject.transform
    self.MergeEquipPanel_itemsGrid.transform.localPosition = Vector3(0,80,0)
    self.MergeEquipPanel_itemsGrid.transform.localScale = Vector3(1,1,1)

    -- print("左侧3个栏 状态")
    -- 左侧3个栏 状态
    for i = 1, self.MergeEquipPanel_material.gameObject.transform.childCount do
	    local child = self.MergeEquipPanel_material.gameObject.transform:GetChild(i-1)
	    local icon = child.gameObject.transform:FindChild("icon")
	    -- print(child.name)
        local effect = child.gameObject.transform:FindChild("icon/ef_ui_rh_02"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
        SetEffectOrderInLayer(effect,4)
	    icon.gameObject:SetActive(false)
        local add = child.gameObject.transform:FindChild("add")
        add.gameObject:SetActive(true)
        effect = child.gameObject.transform:FindChild("add/ef_ui_rh_01"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
        SetEffectOrderInLayer(effect,3)
    end
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    -- 更新 UI 我的装备
    local countLabel = find("EquipSmeltUI_equipCountLabel").gameObject.transform:GetComponent("UILabel")
    countLabel.text = tostring(#EquipInfoTab.bin_equips).."个"
end

--关闭所有窗口，包括装备融合窗口和装备信息窗口
function EquipMergeView:DestroySelf()
    self:MergeEquipPanel_closeBtn()
    self:MergeEquipPanel_equipItemCloseBtn()
end

-- 关闭按钮
function  EquipMergeView:MergeEquipPanel_closeBtn()
    self:SetActive(false)
    self.scene.mainView:SetActive(true)
    local modelShow = self.scene.modelShow
    modelShow:SetActive(true, modelShow.equip)
end

-- 装备熔炼按钮(发送)
function EquipMergeView:MergeEquipPanel_mergeBtn()
    self.management:sendEquipMerge()
end

-- 装备熔炼按钮(返回)
function EquipMergeView:MergeEquipPanel_mergeBtnFormSer()
    self:ResetLeftTab()
    self:MergeEquipPanel_listUpdate()
    -- self.scene:updateEquipList()
    self.scene:listUpdate(self.MergeEquipPanel_itemsGrid) -- 更新列表
end

-- 说明按钮
function EquipMergeView:MergeEquipPanel_desriptBtn()
    if self.MergeEquipPanel_desriptPanel == nil then
        self.MergeEquipPanel_desriptPanel = SnatchExplainView.new()
        self.MergeEquipPanel_desriptPanel:init(self.scene)
        self.MergeEquipPanel_desriptPanel:InitData("1003001")
    end
    self.MergeEquipPanel_desriptPanel:ShowView()
end

-- 关闭说明按钮
function EquipMergeView:MergeEquipPanel_desriptCloseBtn()
    self.MergeEquipPanel_desriptPanel:HiddenView()
end

-- 根据ID获取item对象
function EquipMergeView:GetItemByID(item_id)
    local id = tonumber(item_id)
    if not id then
        warn("item_id error:"..tostring(item_id))
    end
    return self.MergeEquipPanel_itemsGrid.transform:Find(tostring(item_id))
end

-- 单个按钮点击
function EquipMergeView:MergeEquipPanel_listBtnOnClick(btn)
    for i = 1,self.MergeEquipPanel_itemsGrid.gameObject.transform.childCount do
       local child = self.MergeEquipPanel_itemsGrid.gameObject.transform:GetChild(i-1)
       local state_gou = child.gameObject.transform:FindChild("state_gou")
       state_gou.gameObject:SetActive(false)
    end

    local state_gouBtn = btn.gameObject.transform:FindChild("state_gou")
    state_gouBtn.gameObject:SetActive(true)

    self.MergeEquipPanel_isSelectItem = btn
    self:MergeEquipPanel_equipItemBtn()
end

-- 装备物品按钮
function EquipMergeView:MergeEquipPanel_equipItemBtn()
    local child = nil -- 左边融合格子
    local nub = nil -- 空位序号
    local id  = tonumber(self.MergeEquipPanel_isSelectItem.name)-1

    for i=1, #self.MergeEquipPanel_leftVolumeTab do
        if self.MergeEquipPanel_leftVolumeTab[i] == id then -- 如果这个装备已经装备到熔炼栏里
            return
        end
    end
    for i=1, 3 do
        if self.MergeEquipPanel_leftVolumeTab[i] == nil then -- 获得靠前的空位
            nub = i
            break
        end
    end
    if nub == nil then 
        self.scene:promptWordShow("融合装备已选满")
        return 
    end
    print(tostring(self.MergeEquipPanel_leftVolumeTab[1])..
        "/"..tostring(self.MergeEquipPanel_leftVolumeTab[2])..
        "/"..tostring(self.MergeEquipPanel_leftVolumeTab[3]))
    
    -- 左侧3个栏 状态
    print("nub="..tostring(nub))
    self.MergeEquipPanel_leftVolumeTab[nub] = id
    child = self.MergeEquipPanel_material.gameObject.transform:GetChild(nub-1)
    local icon = child.gameObject.transform:FindChild("icon")
    icon.gameObject:SetActive(true)
    local tid = self.management:idFindForTid(id)
    self.scene:setIcon(icon,tid)
    local add = child.gameObject.transform:FindChild("add")
    add.gameObject:SetActive(false)

    local state_zhuangbei = self.MergeEquipPanel_isSelectItem.gameObject.transform:FindChild("state_zhuangbei") 
    state_zhuangbei.gameObject:SetActive(true)
end

-- 卸下物品按钮
function EquipMergeView:MergeEquipPanel_unequipItemBtn(action)
    local nub = nil
    local str_arr = lua_string_split(action, " ")
    if #str_arr == 2 then
        nub = tonumber(str_arr[2])
    end
    if self.MergeEquipPanel_leftVolumeTab[nub] == nil then -- 如果该位置未装备任何item
        return
    end
    print(tostring(self.MergeEquipPanel_leftVolumeTab[1])..
        "/"..tostring(self.MergeEquipPanel_leftVolumeTab[2])..
        "/"..tostring(self.MergeEquipPanel_leftVolumeTab[3]))
    local item_id = self.MergeEquipPanel_leftVolumeTab[nub]
    self.MergeEquipPanel_leftVolumeTab[nub] = nil

    child = self.MergeEquipPanel_material.gameObject.transform:GetChild(nub-1)
    local icon = child.gameObject.transform:FindChild("icon")
    icon.gameObject:SetActive(false)
    local add = child.gameObject.transform:FindChild("add")
    add.gameObject:SetActive(true)

    local itemObj = self:GetItemByID(tonumber(item_id)+1)
    if itemObj then
        local state_zhuangbei = itemObj:FindChild("state_zhuangbei")
        state_zhuangbei.gameObject:SetActive(false)
    end
end
