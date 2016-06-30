--[[
author:hanli_xiong
功能:UI坐骑逻辑
]]
require "game/scene/logic/mount/MountManagement"
require "game/scene/logic/mount/MountAttributeView"
require "game/scene/logic/mount/MountSkillView"

UIMountScene = class(BaseScene)

-- 数据
UIMountScene.UserTxt = nil -- 玩家数据
UIMountScene.UserInfo = nil -- 玩家动态数据
UIMountScene.mountLevelTxt = nil -- 坐骑等级数据表
UIMountScene.mountTypeTxt = nil -- 坐骑种类表
UIMountScene.mountListCache = nil -- 玩家的坐骑列表数据
UIMountScene.mountIdList = nil -- 所有坐骑ID列表
UIMountScene.management = nil -- 通信媒介
UIMountScene.mountSkillTxt = nil -- 坐骑技能表

-- ui
UIMountScene.uiCtrl = nil
UIMountScene.uiRoot = nil
UIMountScene.sceneTarget = nil
UIMountScene.uiMountMain = nil -- 坐骑UI obj
-- UIMountScene.uiLevelUpMount = nil -- 升级坐骑UI obj

-- 坐骑主面板
UIMountScene.mountAttributePanel = nil -- 坐骑属性面板
UIMountScene.mountSkillPanel = nil -- 坐骑技能面板
UIMountScene.mountItemParent = nil
UIMountScene.mountItemPrefab = nil
UIMountScene.mountItemFlag = "mountItem"
UIMountScene.mountNameLabel = nil
UIMountScene.mountLevelLabel = nil
UIMountScene.mountInfoLabel = nil
UIMountScene.mountSkillName = nil
UIMountScene.upMountLvBtn = nil -- 升级按钮
UIMountScene.lvMaxBtn = nil -- 满级后
UIMountScene.equipTip = nil -- 上场提示
UIMountScene.coinIconName = "jinbi"
UIMountScene.diamondIconName = "zuanshi"

UIMountScene.coinLabel = nil -- 金币框
UIMountScene.diamondLabel = nil -- 钻石框

-- 升级界面
UIMountScene.upLvMaterial = nil -- 升级材料面板
UIMountScene.effect_levelup = nil -- 升级特效

UIMountScene.curMount = nil -- 当前选择的mountID
UIMountScene.lastMount = nil -- 上次选择的mountID
UIMountScene.mountState = nil -- 坐骑状态表 mountID = true/false 表示 出场／下场

UIMountScene.modelShow = nil -- 模型展
UIMountScene.sceneParent = nil -- 父级场景

function UIMountScene:Awake()
    self.uiRoot = find('UI Root')
    
	self.uiCtrl = UICtrlBase.new()
	self.uiCtrl:Awake()

    self.UserTxt = TxtFactory:getTable(TxtFactory.UserTXT)
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	self.mountLevelTxt = TxtFactory:getTable(TxtFactory.MountTXT)
	self.mountTypeTxt = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    self.mountListCache = TxtFactory:getMemDataCacheTable(TxtFactory.MountInfo)
    self.mountIdList = self.mountTypeTxt:GetMountIdList()
    self.mountSkillTxt = TxtFactory:getTable(TxtFactory.PetSkillMainTXT)
    
    self.management = MountManagement.new()
    self.management:Awake(self)
    self.mountState = {}
end

function UIMountScene:Start()
    self:InitUI()
end

function UIMountScene:Update()
    
end

function UIMountScene:SetActive(enable)
    self.uiMountMain:SetActive(enable)
    self.modelShow:SetActive(enable, self.modelShow.mount)
    self.effect_levelup.gameObject:SetActive(false)
end

-- 初始化所有UI
function UIMountScene:InitUI()
	self.uiMountMain = self.uiCtrl:LoadUIPrefab("UI/Mount/MountMainUI")
    self.sceneTarget = self.uiMountMain.transform:GetChild(0).gameObject
    -- "MountMainUI"
    local trans = self.uiMountMain.transform:Find("UI/attInfo")
    self.mountAttributePanel = MountAttributeView.new()
    self.mountAttributePanel:Init(self, trans)
    trans = self.uiMountMain.transform:Find("UI/skillInfo")
    self.mountSkillPanel = MountSkillView.new()
    self.mountSkillPanel:Init(self, trans)
    self.mountItemParent = self.uiMountMain.transform:Find("UI/items/itemsGrid")
    self.mountItemPrefab = self.uiMountMain.transform:Find("UI/mountItemPre").gameObject
    self.mountNameLabel = self.uiMountMain.transform:Find("UI/title/info/nameLabel")
    self.mountLevelLabel = self.uiMountMain.transform:Find("UI/title/info/lvLabel")
    self.mountInfoLabel = self.uiMountMain.transform:Find("UI/title/info/descripLabel")
    self.mountSkillName = self.uiMountMain.transform:Find("UI/title/info/skillLabel")
    self.upMountLvBtn = self.uiMountMain.transform:Find("UI/title/MountMainUI_upgradeBtn")
    self.lvMaxBtn = self.uiMountMain.transform:Find("UI/title/lvMax").gameObject
    self.equipTip = self.uiMountMain.transform:Find("UI/title/equipTip").gameObject
    self.effect_levelup=self.uiMountMain.transform:Find("UI/title/ef_ui_shengji"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
    SetEffectOrderInLayer(self.effect_levelup,100)
    local sceneUI = find(ConfigParam.SceneOjbName)
    self.sceneParent = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.playerTopInfoPanel = self.sceneParent.playerTopInfoPanel
    self.modelShow = self.sceneParent.modelShow -- 模型展
    
    self.RetrunDelegate = self.BackToBuildScene

    -- self:SetUiAnChor()
    self:CreateMountList()

end

-- 返回城建场景
function UIMountScene:BackToBuildScene()
    local curmountID = -1 -- 如果没有选择任何坐骑则为-1
    for k,v in pairs(self.mountState) do
        if v then
            curmountID = k
            break
        end
    end
    print("选择了坐骑:" .. curmountID)
    self.management:SetCurMount(curmountID)
    self.management:SendSelectMount()
    self.sceneParent:SetActive(true)
    self:SetActive(false)
    -- self:ChangScene(SceneConfig.buildingScene)
end

-- 选中一匹坐骑 tag:上场标记(tag=-1不上场)
function UIMountScene:ChooseMount(name, tag)
	local mountId = self:parseMountId(name)
    print("ChooseMount:mountId:" .. mountId)
    self.lastMount = self.curMount -- 保存上个坐骑
	self.curMount = mountId -- 记录当前坐骑
    
	local data = self.mountListCache[TxtFactory.BIN_MOUNT][self.curMount]
    if data ~= nil then -- 如果已经解锁
        -- 设置被点击的item状态
        -- self.management:SetCurMount(self.curMount)
        self.mountState[self.curMount] = not self.mountState[self.curMount]
        local item = self.mountItemParent:Find(self.mountItemFlag .. " " .. self.curMount)
        item:Find("chosen").gameObject:SetActive(self.mountState[self.curMount])
    else
        self.mountState[self.curMount] = false
    end
    if tag == -1 then
        self.mountState[self.curMount] = false
    end
    self.equipTip:SetActive(self.mountState[self.curMount])
    if self.lastMount ~= nil and self.lastMount ~= self.curMount then
        -- 设置上次点击的item状态
        self.mountState[self.lastMount] = false
        local item = self.mountItemParent:Find(self.mountItemFlag .. " " .. self.lastMount)
        item:Find("chosen").gameObject:SetActive(false)
    end
    -- 显示坐骑信息
    self.mountNameLabel:GetComponent('UILabel').text = self.mountTypeTxt:GetData(mountId, "NAME")
    self.mountInfoLabel:GetComponent('UILabel').text = self.mountTypeTxt:GetData(mountId, "PETDESC")
    local skillId = self.mountTypeTxt:GetData(mountId, "ACTIVE_SKILLS")
    self.mountSkillName:GetComponent('UILabel').text = self.mountSkillTxt:GetData(skillId, "NAME")
    self:UpdateMountInfo()

	-- 显示坐骑模型预览
    self.modelShow:ChooseMount(self.curMount)

end

-- 显示／隐藏 坐骑属性界面
function UIMountScene:ShowMountAttr(enable)
    local data = self.mountListCache[TxtFactory.BIN_MOUNT][self.curMount]
    local tid = self.mountLevelTxt:GetData(self.curMount,TxtFactory.S_MOUNT_MAX)
    if data ~= nil then -- 如果已经解锁
        tid = data.tid
    end
	self.mountAttributePanel:SetActive(enable, tid)
end

-- 显示／隐藏 坐骑技能界面
function UIMountScene:ShowMountSkill(enable)
    local data = self.mountListCache[TxtFactory.BIN_MOUNT][self.curMount]
    local tid = self.mountLevelTxt:GetData(self.curMount,TxtFactory.S_MOUNT_MAX)
    if data ~= nil then -- 如果已经解锁
        tid = data.tid
    end
	self.mountSkillPanel:SetActive(enable, tid)
end

-- 创建坐骑列表
function UIMountScene:CreateMountList()
    for k, v in pairs(self.mountIdList) do
        local go = newobject(self.mountItemPrefab)
        go.transform.parent = self.mountItemParent
        go:SetActive(true)
        go.name = self.mountItemFlag .. " " .. v
        go.transform.localScale = Vector3.one
        local data = self.mountListCache.bin_mount[v]
        if data ~= nil then -- 如果已经解锁
            local lv = self.mountLevelTxt:GetData(data.tid,TxtFactory.S_MOUNT_LVL)
            self:UnLockMount(v, lv)
        else
            go.transform:Find("level").gameObject:SetActive(false)
            go.transform:Find("icon"):GetChild(0).gameObject:SetActive(true)
            go.transform:Find("getTip").gameObject:SetActive(true)
        end
        go.transform:Find("icon"):GetComponent("UISprite").spriteName = self.mountTypeTxt:GetData(v, "PET_ICON")
        go.transform:Find("name"):GetComponent("UILabel").text = self.mountTypeTxt:GetData(v, "NAME")
        self.mountState[v] = false
        if self.curMount == nil then
            self.curMount = v
        end
    end
    local tid = TxtFactory:getTable(TxtFactory.MemDataCache):getCurMountID()
    print("createmount:tid:" .. tostring(tid))
    if tid then
        self:ChooseMount(tostring(self.mountLevelTxt:GetTypeID(tid)))
    else
        self:ChooseMount(self.curMount, -1)
        -- self:ChooseMount(self.curMount)
    end

    self.mountItemParent:GetComponent("UIGrid"):Reposition()
end

-- 解锁一匹坐骑
function UIMountScene:UnLockMount(mountId, level)
    local tf = self.mountItemParent:Find(self.mountItemFlag .. " " .. mountId)
    if tf == nil then
        warn("找不到这匹坐骑:" .. mountId)
    end
    print("解锁坐骑:" .. mountId)
    if level == nil then
        level = 1
    end
    tf:Find("level").gameObject:SetActive(true)
    tf:Find("level"):GetComponent("UILabel").text = "Lv." .. tostring(level)
    tf:Find("icon"):GetChild(0).gameObject:SetActive(false)
    tf:Find("getTip").gameObject:SetActive(false)
end

-- 创建升级材料列表
function UIMountScene:CreateMatList(mountId)
    for i = 1, self.upLvMaterial.childCount do
        local item = self.upLvMaterial:GetChild(i - 1)
        item.gameObject:SetActive(true)
        item:Find("matNum"):GetComponent("UILabel").text = "0/5"
    end
    self.upLvMaterial:GetComponent("UIGrid"):Reposition()
end

-- 升级条件判断
function UIMountScene:CanUpgrade()
    if self.curMount == nil then
        warn("curMount == nil")
        return false
    end
    if self.mountListCache.bin_mount[self.curMount] == nil then
        warn("坐骑尚未解锁:" .. self.curMount)
        return false
    end
    local coins, diamond = self:GetUpgradeNeed(self.curMount)
    local usercoins = tonumber(self.UserInfo[TxtFactory.USER_GOLD])
    local userdiamond = tonumber(self.UserInfo[TxtFactory.USER_DIAMOND])
    if usercoins < coins then
        self:promptWordShow("金币不足")
        return false
    elseif userdiamond < diamond then
        self:promptWordShow("钻石不足")
        return false
    end
    return true
end

-- 得到升级该坐骑所需要的金币和钻石
function UIMountScene:GetUpgradeNeed(mountId)
    local tid = self.mountLevelTxt:GetData(mountId,TxtFactory.S_MOUNT_INIT_ID)
    local data = self.mountListCache[TxtFactory.BIN_MOUNT][self.curMount]
    if data ~= nil then -- 如果已经解锁
        tid = data.tid
    end
    local coins = tonumber(self.mountLevelTxt:GetData(tid, "UPGOLD"))
    local diamond = tonumber(self.mountLevelTxt:GetData(tid, "UPDIAMOND"))
    if coins == nil then coins = 0 end
    if diamond == nil then diamond = 0 end

    return coins, diamond
end

-- 升级坐骑按钮
function UIMountScene:OnBtnUpLevel()
    if self:CanUpgrade() then
        self.management:SendUpgradeMount(self.curMount)
    end
end

-- 升级一匹坐骑
function UIMountScene:UpgradeMount(mountId)
    self.effect_levelup.gameObject:SetActive(true)
    self.effect_levelup:Play()
    local tf = self.mountItemParent:Find(self.mountItemFlag .. " " .. mountId)
    if tf == nil then
        warn("找不到这匹坐骑:" .. mountId)
    end
    local data = self.mountListCache[TxtFactory.BIN_MOUNT][mountId]
    local level = self.mountLevelTxt:GetData(data.tid,TxtFactory.S_MOUNT_LVL)
    tf:Find("level"):GetComponent("UILabel").text = "Lv." .. tostring(level)
    self:UpdateMountInfo()
end

-- 刷新升级按钮/坐骑信息/玩家金币钻石 更新升级坐骑所需金币或钻石
function UIMountScene:UpdateMountInfo()
    local data = self.mountListCache[TxtFactory.BIN_MOUNT][self.curMount]
    -- local tid = tonumber(self.curMount) * 10000
    local tid = self.mountLevelTxt:GetData(self.curMount,TxtFactory.S_MOUNT_INIT_ID)
    if data ~= nil then -- 如果已经解锁
        tid = data.tid
    end
    -- 升级按钮
    self.upMountLvBtn:GetComponent("UIButton").isEnabled = data ~= nil
    self.upMountLvBtn:Find("goldNum").gameObject:SetActive(data ~= nil)
    self.upMountLvBtn:Find("coinIcon").gameObject:SetActive(data ~= nil)
    self.upMountLvBtn:Find("lock").gameObject:SetActive(data == nil)

    local nextLevel = self.mountLevelTxt:GetNextLevel(tid)
    if nextLevel == tonumber(tid) then -- 如果已经满级了
        self.upMountLvBtn.gameObject:SetActive(false)
        self.lvMaxBtn:SetActive(true)
    else
        self.upMountLvBtn.gameObject:SetActive(true)
        self.lvMaxBtn:SetActive(false)
        local goldNum, diamondNum = self:GetUpgradeNeed(self.curMount)
        if goldNum == 0 then
            self.upMountLvBtn:Find("goldNum"):GetComponent("UILabel").text = tostring(diamondNum)
            self.upMountLvBtn:Find("coinIcon"):GetComponent("UISprite").spriteName = self.diamondIconName
        else
            self.upMountLvBtn:Find("goldNum"):GetComponent("UILabel").text = tostring(goldNum)
            self.upMountLvBtn:Find("coinIcon"):GetComponent("UISprite").spriteName = self.coinIconName
        end
    end
    -- 等级信息
    self.mountLevelLabel:GetComponent('UILabel').text = "Lv" .. self.mountLevelTxt:GetData(tid,TxtFactory.S_MOUNT_LVL)
    -- 钻石金币
    --self.coinLabel:GetComponent('UILabel').text = self.UserTxt:getValue('gold')
    --self.diamondLabel:GetComponent('UILabel').text = self.UserTxt:getValue('diamond')
   --  self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
--	 self.coinLabel:GetComponent('UILabel').text= tonumber(self.UserInfo[TxtFactory.USER_GOLD])
  --   self.diamondLabel:GetComponent('UILabel').text = tonumber(self.UserInfo[TxtFactory.USER_DIAMOND])
end

-- 解析坐骑ID(私有)
function UIMountScene:parseMountId(name)
    str = lua_string_split(name, " ")
    if #str > 1 then
        return str[2]
    else
        return name
    end
end

-- 顺序遍历迭代器
-- function pairsByKeys(t)
--     local a = {}
--     for n in pairs(t) do
--         a[#a+1] = n
--     end
--     table.sort(a)
--     local i = 0
--     return function()
--         i = i + 1
--         return a[i], t[a[i]]
--     end
-- end

