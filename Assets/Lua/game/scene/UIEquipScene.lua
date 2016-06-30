--[[
装备scene
author : Desmond
]]

require "game/scene/logic/equip/EquipManagement"
require "game/scene/logic/equip/EquipMainView"
require "game/scene/logic/equip/EquipUpgradeView"
require "game/scene/logic/equip/EquipMergeView"
require "game/scene/logic/equip/EquipExtract"
require "game/scene/logic/equip/EquipHandbookView"

UIEquipScene = class (BaseScene)

UIEquipScene.equipUI = nil --装备界面

UIEquipScene.EquipManagement = nil -- 数据管理
UIEquipScene.mainView = nil --装备主界面
UIEquipScene.upgradeView = nil --装备升级界面
UIEquipScene.mergeView = nil --装备融合界面
UIEquipScene.equipExtract = nil -- 装备抽取
UIEquipScene.handbookView = nil -- 图鉴界面
UIEquipScene.getItemsPanel = nil
UIEquipScene.sceneTarget = nil 
UIEquipScene.modelShow = nil -- 模型展

UIEquipScene.EquipTXT = nil -- icon名称表
UIEquipScene.UserInfo = nil -- 人物属性表
UIEquipScene.sceneParent = nil -- 父级场景
UIEquipScene.openViewClass = nil -- 打开该界面的类

-- 套装切换
UIEquipScene.SuitTable = nil
UIEquipScene.CurSuitid = nil
local SuitidToIndex = nil
local IndexToSuitid = nil
UIEquipScene.EquipUI_forward =nil
UIEquipScene.EquipUI_next =nil
UIEquipScene.EquipUI_Name =nil
local  RankNum = {    
    ["SS"] = 9,
    ["S"] = 8,
    ["A"] = 7,
    ["B"] = 6,
}
function UIEquipScene:Awake()
    --GamePrint("!!!!!!!!!!!!!!!!")
    self:init()
end

--初始化
function UIEquipScene:init()
    self.EquipTXT = TxtFactory:getTable(TxtFactory.EquipTXT)
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.uiRoot = find('UI Root')
    self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UICtrlEquipLua")
    self.EquipManagement = EquipManagement.new()
    self.EquipManagement.equipScene = self
    self.EquipManagement:awake()

    self.UserTxt = TxtFactory:getTable(TxtFactory.UserTXT)

    local sceneUI = find(ConfigParam.SceneOjbName)
    self.sceneParent = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.playerTopInfoPanel = self.sceneParent.playerTopInfoPanel
    self.modelShow = self.sceneParent.modelShow -- 模型展

    self.mainView = EquipMainView.new() --初始主界面
    self.mainView:init(self)

    local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local username = user[TxtFactory.USER_NAME] -- 获取名字
    local level =  user[TxtFactory.USER_LEVEL] -- 获取等级

--[[    local  nameLab = find('info/name/Label'):GetComponent('UILabel')
    nameLab.text = username -- 显示等级]]
    local levelLab = find('info/level'):GetComponent('UILabel')
    levelLab.text = "lv."..level -- 显示等级

    --初始化套装选择
    self.EquipUI_Name = find('info/name/Label'):GetComponent('UILabel')
    self:InitChooseEquip()
end

function function_name( ... )
    -- body
end
function UIEquipScene:SetActive(enable)
    self.mainView:SetActive(enable)
    self.sceneTarget:SetActive(enable)
    self.modelShow:SetActive(enable, self.modelShow.equip)
    if enable then
        local suit_id = TxtFactory:getTable(TxtFactory.MemDataCache):getPlayerSuit()
        local suitTable = TxtFactory:getTable(TxtFactory.SuitTXT)

        self.CurSuitid = suitTable:GetData(suit_id, TxtFactory.S_SUIT_TYPE)

        self.modelShow:ChooseEquip(self.CurSuitid)

        if SuitidToIndex ~= nil then
            self:UpdateChooseBtn(SuitidToIndex[self.CurSuitid])
        end
    end
end

-- 加载界面
function UIEquipScene:LoadUI(name)
    local path = "UI/"..name
    local obj = newobject(Util.LoadPrefab(path))
    obj.gameObject.transform.parent = self.uiRoot.gameObject.transform
    obj.gameObject.transform.localPosition = Vector3.zero
    obj.gameObject.transform.localScale = Vector3.one
    return obj
end

function UIEquipScene:Start()

end

function UIEquipScene:Update()
    -- self.equipExtract:Update() -- 只在播放动画时开启update
end

-- 装备熔炼按钮
function UIEquipScene:EquipPanel_mergeEquipBtn()
    self.mainView:SetActive(false)
    if not self.mergeView then
        self.mergeView = EquipMergeView.new() --初始融合界面
        self.mergeView:init(self)
    end
    self.mergeView:SetActive(true)
end

-- 抽取按钮
function UIEquipScene:EquipPanel_EquipExtractBtn()
    self.mainView:SetActive(false)
    if not self.equipExtract then
        self.equipExtract = EquipExtract.new() --抽装备界面
        self.equipExtract:init(self)
    end
    self.equipExtract:SetActive(true)
end

-- 装备图鉴按钮
function UIEquipScene:EquipPanel_handbookEquipBtn()
    self.mainView:SetActive(false)
    if not self.handbookView then
        self.handbookView = EquipHandbookView.new() -- 初始图鉴界面
        self.handbookView:init(self)
    end
    self.handbookView:SetActive(true)
end

-- 装备升级按钮
function UIEquipScene:EquipPanel_UpgradeView()
    self.mainView:SetActive(false)
    if not self.upgradeView then
        self.upgradeView = EquipUpgradeView.new() --初始升级界面
        self.upgradeView:init(self)
    end
    self.upgradeView:SetActive(true)
end

--[[
更新装备功能中的列表
code:协议号码
]]
function UIEquipScene:updateEquipList()
    --更新主界面列表
	self.mainView:EquipPanel_listUpdate()

end

UIEquipScene.initialVolume = nil -- 装备初始格子数量
-------------------------------------------------------------  创建界面 -------------------------------------
UIEquipScene.equipPanel = nil  -- 装备界面
UIEquipScene.dropEquipPanel = nil -- 抽取装备界面
UIEquipScene.upgradeEquipPanel = nil -- 升级装备界面
UIEquipScene.mergeEquipPanel = nil -- 合成装备界面
UIEquipScene.handbookEquipPanel = nil -- 装备图鉴界面

-- 创建单个动态按钮
function UIEquipScene:creatVolumeList(name,root,target)
    target = self.sceneTarget
    local bmObj = newobject(Util.LoadPrefab("UI/Equip/"..tostring(name)))
    bmObj.gameObject.transform.parent = root.gameObject.transform
    bmObj.gameObject.transform.localScale = Vector3(1,1,1)

	-- 添加按钮监听脚本
	local  bm = bmObj:AddComponent(UIButtonMessage.GetClassType())
	bm.target = target.gameObject
	bm.functionName = "OnClick"
    bm.trigger = 0
    local  bmp = bmObj:AddComponent(UIButtonMessage.GetClassType())
    bmp.target = target.gameObject
    bmp.functionName = "OnPress"
    bmp.trigger = 1
    -- 设置状态 赋空
    local state_zhuangbei = bmObj.gameObject.transform:FindChild("state_zhuangbei") 
    state_zhuangbei.gameObject:SetActive(false)
    local state_gou = bmObj.gameObject.transform:FindChild("state_gou")
    state_gou.gameObject:SetActive(false)
    local ico = bmObj.gameObject.transform:FindChild("icon")
    ico.gameObject:SetActive(false)
    local lock = bmObj.gameObject.transform:FindChild("lock")
    lock.gameObject:SetActive(false)

	return bmObj
end

-- 创建装备按钮 赋值
function UIEquipScene:setIcon(obj,iconId)
    local ico = obj.gameObject.transform:FindChild("icon")
    local iconBack = obj.gameObject.transform:FindChild("Background")
    -- local icoBackground = obj.gameObject.transform:FindChild("icoBackground")
    -- local iconId = EquipInfoTab.bin_equips[u].tid
    local iconName = self.EquipTXT:GetData(iconId, "EQUIPMENT_ICON") 
    -- print("id:" .. iconId .. "&name:" .. tostring(iconName))
    local rank = self.EquipTXT:GetData(iconId,"RANK")
    ico:GetComponent("UISprite").spriteName = iconName--fjc

    if rank == "A" then
        iconBack:GetComponent("UISprite").spriteName = "lankuang"
    elseif rank == "B" then 
        iconBack:GetComponent("UISprite").spriteName = "lvkuang"
    elseif rank == "S" then
        iconBack:GetComponent("UISprite").spriteName = "zikuang"
    elseif rank == "SS" then
        iconBack:GetComponent("UISprite").spriteName = "huangkuang"
    else
        iconBack:GetComponent("UISprite").spriteName = "huikuang"
    end
    
    local level = self.EquipTXT:GetData(iconId, TxtFactory.S_EQUIP_LVL)
    local lvLabel = obj.transform:Find("level")
    if lvLabel then
        lvLabel:GetComponent("UILabel").text = "lv."..level
    end
    --GamePrint("eeee8888eeeeeeeee")
    ico.gameObject:SetActive(true)
    --GamePrint("22222222")
end

------------------------------------------------------------- 装备界面逻辑 -------------------------------------

--
function UIEquipScene:EquipPanel_equipBuyVolumeBack()
    self:updateEquipList()
    self.mainView:volumeBuyPanel_closeBtn()
end



-- 点击事件————————————————————————————————————————————————————————————————————————————
-- 按钮列表 处理分配 OnClick
function UIEquipScene:listBtnDistributeOnClick(btn)
    -- print(btn.transform.parent.gameObject.name)
    if btn.transform.parent.gameObject.name == "EquipHandBookUI_itemsGrid" then -- 装备图鉴界面的按钮list
        self.handbookView:HandBookEquipPanel_listBtnOnClick(btn)
    end
    if self:BtnIsEmpty(btn) then -- 没有则返回
        return
    end
    if btn.transform.parent.gameObject.name == "EquipeLevelUpUIgrid" then -- 装备升级的按钮list
        self.upgradeView:UpgradeEquipPanel_listBtnOnClick(btn)
    elseif btn.transform.parent.gameObject.name == "itemsGrid" then -- 装备界面的按钮list
        self.mainView:EquipPanel_listBtnOnClick(btn)
    elseif btn.transform.parent.gameObject.name == "EquipSmeltUIgrid" then -- 装备融合界面的按钮list
        self.mergeView:MergeEquipPanel_listBtnOnClick(btn)
    end
end
-- 按钮列表 处理分配 OnPress
function UIEquipScene:listBtnDistributeOnPress(btn)
    -- print(btn.transform.parent.gameObject.name)
    if btn.transform.parent.gameObject.name == "EquipeLevelUpUIgrid" then -- 装备升级的按钮list
         -- self:UpgradeEquipPanel_listBtnOnClick(btn.name)
    elseif btn.transform.parent.gameObject.name == "itemsGrid" then -- 装备界面的按钮list

    end
    self.equipPanel_isSelectItem = btn
end


-- 更新装备列表 公用(重要)
function UIEquipScene:listUpdate(itemGrid,iid)
    -- 再生成
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
        local  id = EquipInfoTab.bin_equips[u].id
        local name = tostring(id + 1)
        -- local obj = itemGrid.gameObject.transform:FindChild(name)
        local obj = itemGrid.transform:GetChild(u-1)
        obj.name = name
        -- 以后根据tid 遍历配置的信息 找相应的ico的图片
        self:setIcon(obj,EquipInfoTab.bin_equips[u].tid)

        if iid == id then
            local state_gouBtn = obj:FindChild("state_gou")
            state_gouBtn.gameObject:SetActive(true)
        end
    end
end

-- 文字显示 公用


-- 判断选中的按钮是不是为空
function UIEquipScene:BtnIsEmpty(btn)
    -- print("btn :"..btn.name)
    local EquipInfoTab = TxtFactory:getMemDataCacheTable(TxtFactory.EquipInfo)
    local isEmpty = true
    local Btnid = tonumber(btn.name) - 1
    for u , v in ipairs(EquipInfoTab.bin_equips) do
        if v.id == Btnid then
            isEmpty = false
        end
    end
    return isEmpty
end


-- 返回按钮
function UIEquipScene:BackBtn()
    -- self:ChangScene(SceneConfig.buildingScene)
    GamePrint(tostring(self.openViewClass))
    self.openViewClass:SetActive(true)
    self:SetActive(false)
end

-- 卸载物品（返回）
function UIEquipScene:UnequipmentUpgradePanel_equipBtnFromSer()
    self.mainView:UnequipmentUpgradePanel_equipBtnFromSer()

end

-- 装备物品（返回）
function UIEquipScene:EquipmentUpgradePanel_equipBtnFromSer()
    self.mainView:EquipmentUpgradePanel_equipBtnFromSer()

end

-- 升级装备（返回）
function UIEquipScene:UpgradeEquipPanel_coinBtnFromSer()
    self.upgradeView:UpgradeEquipPanel_coinBtnFromSer()
end

function UIEquipScene:UpgradeEquipAddEffect()
    self.upgradeView:UpgradeEquipAddEffect()
end

-- 装备融合（返回）
function UIEquipScene:MergeEquipPanel_mergeBtnFormSer(tabData)
    local itemsObj = {} -- 存放生成的奖励物品obj 的tab
     -- 生成items obj物体
    for i = 1, #tabData do 
        local obj = self:creatVolumeList("icoBack",self.uiRoot,self.sceneTarget)
        obj.gameObject.transform.localPosition = Vector3.zero
        self:setIcon(obj,tabData[i].tid)
        itemsObj[i] = obj
    end

    self:rewardItemsShow(itemsObj,true) -- 创建奖励界面
    self.mergeView:MergeEquipPanel_mergeBtnFormSer()
end

-- 抽取装备（返回）
--[[function UIEquipScene:ExtractEquipPanel_InfoFromSer()
    self.equipExtract:extractEquipInfoFromSer()
end]]

-- 抽取动画确定按钮
function UIEquipScene:ExtractEquipPanel_rewardItemOkBtn()
    self.equipExtract:rewardItemOkBtn()
end

--  创建抽到的物品
function UIEquipScene:creatGetItemsPanel(itemsData,priceType)
    if not itemsData then
        return
    elseif #itemsData == 1 then -- 单抽
        self.equipExtract:creatPetExtractAnim(itemsData[1],priceType)
    elseif  #itemsData > 1 then -- 十抽
        self.equipExtract:creatPetExtractAnim_ten(itemsData,priceType)
    end

end

-- 关闭主界面
function UIEquipScene:closeMainPanel()
    self.mainView:closePanel()
end
-- 打开主界面
function UIEquipScene:showMainPanel()
    self.mainView:showPanel()
end

function UIEquipScene:CloseGetItemsPanel()
    self.getItemsPanel:SetActive(false)
end

-- 文字显示（小窗口）
function UIEquipScene:infoPanelWordShow(id,nameLabel,desciptLabel,iconBack,icon)
    iconName = self.EquipTXT:GetData(id,"EQUIPMENT_ICON")
    local level = self.EquipTXT:GetData(id,"RANK")
        local  iconBackName = nil
        if level == "A" then
          iconBackName= "lankuang"
        elseif level == "B" then 
          iconBackName = "lvkuang"
        elseif level == "S" then
          iconBackName = "zikuang"
        elseif level == "SS" then
          iconBackName= "huangkuang"
        else
          iconBackName = "huikuang"
        end

   SetSprite(iconBack.gameObject,iconBackName)
   SetSprite(icon.gameObject,iconName)

    local t = nil
    local name = self.EquipTXT:GetData(id,"NAME")
    --print ("--------------function EquipManagement:infoPanelWordShow "..tostring(id)..' '..tostring(name))
    for i = 10, self.EquipTXT:GetColumnLength() -1 do
        t =  self.EquipTXT:GetDataByColumnIndex(id,i)
        if t ~= "" then
            -- print("t"..tostring(t))
            break
        end
    end
    nameLabel.text = name
    desciptLabel.text = self.EquipTXT:GetData(id,"EQUIPMENTDESC")
   -- desciptLabel.text = t

end

-- 装备抽金币判断
function UIEquipScene:coinPriceCheck(price)
    -- print("判断金币是否够")
    local flag = nil
    local gold = tonumber(self.UserInfo[TxtFactory.USER_GOLD])  
    if price > gold then
        local word = "金币不够"
        self:promptWordShow(word)
        flag = false
        return flag
    else
        -- print("金币足够")
        flag = true
        return flag
    end
end

-- 装备抽钻石判断
function UIEquipScene:diamondPriceCheck(price)
    local flag = nil
    local diamond = tonumber(self.UserInfo[TxtFactory.USER_DIAMOND])    
    if tonumber(price) > diamond then
        local word = "钻石不够"
        self:promptWordShow(word)
        flag = false
        return flag
    else 
        flag = true
        return flag
    end
end

-- 切换套装
function UIEquipScene:InitChooseEquip()
    local suitTable = TxtFactory:getTable(TxtFactory.SuitTXT)
    local allSuits = suitTable:GetSuitTable(self.UserInfo[TxtFactory.USER_SEX])

    GamePrintTable("切换套装 切换套装 切换套装")
    GamePrintTable(allSuits)

    GamePrintTable("切换套装11 切换套装 切换套装11")
    local txt = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
    GamePrintTable(txt)
    if SuitidToIndex == nil or IndexToSuitid == nil then
        --local  num = 0
        SuitidToIndex = {}
        IndexToSuitid = {}
--[[        for k, v in pairs(allSuits) do
            --num = num +1
            table.insert(IndexToSuitid,k)
            --IndexToSuitid[num] = k
            --table.insert(SuitidToIndex, k, num)
            --SuitidToIndex[k] = num
        end]]
        for k, v in pairs(txt.cur_suits) do
            --num = num +1
            if v.suit_lvl > 0 then
                table.insert(IndexToSuitid,v.suit_id)
            end
        end

        table.sort(IndexToSuitid,function(a,b) 
            return a < b
        end)

        local  num = #IndexToSuitid
        for i = 1, num do
            table.insert(SuitidToIndex, IndexToSuitid[i], i)
        end
--[[        GameWarnPrint("SuitidToIndexSuitidToIndex =");
        GamePrintTable(SuitidToIndex)
        GameWarnPrint("IndexToSuitid IndexToSuitid =");
        GamePrintTable(IndexToSuitid)
        GameWarnPrint("套装 数量：".. num);]]
    end
    self.EquipUI_forward =  self.mainView.equipPanel.transform:FindChild("UI/title/info/EquipUI_forward").gameObject
    self.EquipUI_next =  self.mainView.equipPanel.transform:FindChild("UI/title/info/EquipUI_next").gameObject

    if self.CurSuitid ~= nil then
        self:UpdateChooseBtn(SuitidToIndex[self.CurSuitid])
    end
end
function UIEquipScene:DoChooseEquip(difference)
    -- body
    --GameWarnPrint("套装 套装".. difference.."||cur ="..self.CurSuitid)
    local curIndex = SuitidToIndex[self.CurSuitid]
    local newIndex = curIndex + difference
    --GameWarnPrint("newIndex =".. newIndex)
    if newIndex < 1 or newIndex > #IndexToSuitid then
        return
    end
   
    self.CurSuitid = IndexToSuitid[newIndex]
    --GameWarnPrint("CurSuitid =".. self.CurSuitid)
    self.modelShow:ChooseEquip(self.CurSuitid)
    self:UpdateChooseBtn(newIndex)

end

function UIEquipScene:UpdateChooseBtn(curIndex)
    local  suitTable = TxtFactory:getTable(TxtFactory.SuitTXT)
    local  suitName = suitTable:GetSuitName(self.CurSuitid)
    self.EquipUI_Name.text = suitName

    self.EquipUI_forward:SetActive(curIndex > 1)
    self.EquipUI_next:SetActive(curIndex < #IndexToSuitid)
end

function UIEquipScene:SetOpenViewClass(openViewClass)
    self.openViewClass = openViewClass
end

-- UIEquipScene.itemKeyLine
-- 点击事件————————————————————————————————————————————————————————————————————————————

-- UIEquipScene.dataTab = {
--   ADDHP ADDITEMR  SLOWHP  ELFSOCRE  ADDATKSC  ADDSC ADDEXP  ADDGOLD TWOJUMPSOCRE  MOREJUMPSOCRE SUBATKDMG SUBDROPDMG 
--    MISATKDMG ADDSUCKHP ADDSUCKTIME ADDGODTIME  LIGHT_PE  TASK_PE ENERGY  ENERGYJUMP  DIAMOND_PE  ADDJUMP MATERIAL  ATK CDDOWM 
--     SPEED NOTE  SPTINT  VOLPLANE  NEVER JUMPTIME  SKILLBUFF
-- }
