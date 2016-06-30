--UIPetScene
--[[
ui萌宠逻辑
Huqiuxiang
]]

require "game/scene/logic/pet/PetMainView"
require "game/scene/logic/pet/PetMergeView"
require "game/scene/logic/pet/PetExtractView"
require "game/scene/logic/pet/PetManagement"
require "game/scene/logic/pet/PetHandbookView"

UIPetScene = class (BaseScene)
UIPetScene.petMainView = nil -- 萌宠主界面
UIPetScene.UserInfo = nil -- 人物信息表
UIPetScene.petMergeView = nil -- 萌宠融合界面
UIPetScene.petManagement = nil -- 萌宠数据管理
UIPetScene.petExtractView = nil -- 萌宠抽取界面
UIPetScene.petHandbookView = nil -- 萌宠图鉴界面
UIPetScene.uiRoot = nil 
UIPetScene.sceneTarget = nil 
UIPetScene.petIconInfoPanel = nil -- 萌宠信息界面
UIPetScene.petBigIconInfoPanel = nil 
UIPetScene.playerTopInfoPanel = nil -- 顶部资源界面
UIPetScene.petShowPanel = nil -- 获得萌宠展示面板
--UIPetScene.wordPrompt = nil -- 顶部提示文字
UIPetScene.coinTopPrice = nil 
UIPetScene.diamoinTopPrice = nil
UIPetScene.promptWordShowView = nil 

UIPetScene.modelShow = nil -- 模型秀
UIPetScene.sceneParent = nil -- 父级场景
UIEquipScene.openViewClass = nil -- 打开该界面的类

function UIPetScene:Awake()
	-- self.UserTxt = TxtFactory:getTable("UserTXT")
	-- self.MountTxt = TxtFactory:getTable("MountTXT")
    -- self.UIPetTab = {}
	-- self:creatPetlistPanel()
    self.uiRoot = find('UI Root')
    self.sceneTarget = self:AddUIButtonCtrlOnObjNil(self.uiRoot,"UICtrlPetLua")
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)

    --self:creatPetTopPanel()
    local sceneUI = find(ConfigParam.SceneOjbName)
    self.sceneParent = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
    self.playerTopInfoPanel = self.sceneParent.playerTopInfoPanel
    self.modelShow = self.sceneParent.modelShow -- 模型展

    self.petManagement = PetManagement.new() -- 萌宠管理器
    self.petManagement.scene = self
    self.petManagement:init()
    
    self.petMainView = PetMainView.new() --初始主界面
    self.petMainView:init(self)

    self:SetUiAnChor()

end

-- 创建顶部金币钻石ui
function UIPetScene:topShow()
    
end

function UIPetScene:SetActive(enable)
    self.petMainView:SetActive(enable)
    --self.sceneTarget:SetActive(enable)
    self.modelShow:SetActive(enable, self.modelShow.pet)
end

--启动事件--
function UIPetScene:Start()
end

function UIPetScene:Update()

end

function UIPetScene:FixedUpdate()
end

-- icon按钮OnClick处理
function UIPetScene:listBtnOnClick(obj)
    --local btn = obj.transform.parent.gameObject
    --if btn.gameObject.transform.parent.gameObject.name == "PetMainUI_itemsGrid" then -- 萌宠主界面列表按钮
        --self.petMainView:listBtnOnClick(btn)
--[[    elseif btn.gameObject.transform.parent.gameObject.name == "PetMypetUI_itemsGrid" then -- 我的宠物列表按钮
        if self.petMergeView ~= nil then
            self.petMergeView:myPetPanel_iconListOnClick(btn)
        else
            self.petMainView:OnClickMyPetPanel(btn)
        end]]
    --elseif btn.gameObject.transform.parent.gameObject.name == "PetHandbookUI_itemsGrid" then -- 图鉴列表按钮
        --self.petHandbookView:iconListOnClick(btn)
    --end

end

-- 更新萌宠主界面的list
function UIPetScene:petMainView_ListUpdate()
    -- print("tujian")
    self.petMainView:panelUpdate()
    self.petMainView:updateLeftIcon()
end

function UIPetScene:OnUpgradeSucceed(boolLevelUP)
    self.petMainView:OnUpgradeSucceed(boolLevelUP)
end

function UIPetScene:UpStarCheck(tid)
    if not tid then
        return
    end
    local boolNeedUpStar = self.petManagement:isNeedUpStar(tid)
    local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
    local ctid = _txt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
    if boolNeedUpStar and tonumber(ctid) == 13001 then -- 如果是哈比
        print("刷邮件")
        self.sceneParent:GetMailList()
    end
end

-- 更新主界面 经验物品list
function UIPetScene:petMainView_expItemsListUpdate()
    self.petMainView:itemsListUpdate(true)
    self.petMainView:updateLeftIcon()
end

-- 主界面 图鉴按钮
function UIPetScene:petMainView_handbookBtn()
    if not self.petHandbookView then
        self.petHandbookView = PetHandbookView.new() -- 初始图鉴界面
        self.petHandbookView:init(self)
    end
    self.petHandbookView:SetActive(true)
    self.petMainView:SetActive(false)
end

-- 主界面 后退按钮
function UIPetScene:petMainView_backBtn()
    self.petMainView:backBtn()
    self.openViewClass:SetActive(true)
    self:SetActive(false)
end

-- 主界面 全部按钮
function UIPetScene:petMainView_allBtn(button)
    self.petMainView:allBtn(button)
end

-- 主界面 支援按钮
function UIPetScene:petMainView_aidBtn()
    self.petMainView:aidBtn()
end

-- 主界面 飞行按钮
function UIPetScene:petMainView_flightBtn()
    self.petMainView:flightBtn()
end

-- 主界面 上场按钮
function UIPetScene:petMainView_joinBtn()
    self.petMainView:joinBtn()
end

-- 主界面 上下场（返回）
function UIPetScene:petMainView_joinReponse()
    self.petMainView:joinReponse()
end

-- 替换宠物ui 事件方法
function UIPetScene:uiReplacePetEvent(fName, ...)
	self.petMainView:uiReplacePetEvent(fName, ...)
end

-- 显示替换上场萌宠界面
function UIPetScene:ChooseOnePetToReplace(petId)
    self.petMainView:ChooseOnePetToReplace(petId)
end

-- 主界面 送礼按钮
function UIPetScene:petMainView_giftBtn()
    --self.petMainView:giftBtn()
    self:petMainView_myGiftCloseBtn()
    self.petMainView:GoPetFunctionBtn()
    self.petMainView:SetGoMainBuild()
end

-- 主界面 我的礼物关闭按钮
function UIPetScene:petMainView_myGiftCloseBtn()
    self.petMainView:myGiftCloseBtn()
end

-- 购买界面 购买按钮
function UIPetScene:petMainView_buyBtn()
    self.petMainView:buyBtn()
end

-- 主界面 我的礼物 单个购买
function UIPetScene:petMainView_buyItems(btn)
    self.petMainView:creatBuyExpItem(btn)
end

-- 购买道具 面板关闭
function UIPetScene:buyItemPanelClose()
     self.petMainView:buyItemPanelClose()
end

-- 购买道具 加好
function UIPetScene:buyItemJia()
     self.petMainView:buyItemJia()
end

-- 购买道具 减号
function UIPetScene:buyItemJian()
     self.petMainView:buyItemJian()
end

-- 购买道具 最大
function UIPetScene:buyItemMax()
     self.petMainView:buyItemMax()
end

-- 主界面 抽取按钮
function UIPetScene:petMainView_extractBtn()
    if not self.petExtractView then
        self.petExtractView = PetExtractView.new() --初始抽取界面
        self.petExtractView:init(self)
    end
    self.petMainView:SetActive(false) -- 抽取功能
    self.petExtractView:SetActive(true) -- 抽取界面生成
end

-- 主界面 融合按钮
function UIPetScene:petMainView_mergeBtn()
    --[[if not self.petMergeView then
        self.petMergeView = PetMergeView.new() --初始融合界面
        self.petMergeView:init(self)
    end
    self.petMainView:SetActive(false) -- 融合按钮
    self.petMergeView:SetActive(true) -- 融合界面生成]]
    --self.petMainView:Showshengxin()
end



-- 融合界面 关闭按钮
function UIPetScene:petMergeView_closeBtn()
    self.petMergeView:SetActive(false)
    self.petMainView:SetActive(true)
end

-- 融合界面 左边萌宠按钮
function UIPetScene:petMergeView_leftPetBtn()
    self.petMergeView:leftPetBtn()
end

-- 融合界面 右边萌宠按钮
function UIPetScene:petMergeView_rightPetBtn()
    self.petMergeView:rightPetBtn()
end

-- 融合界面 金币按钮
function UIPetScene:petMergeView_coinMergeBtn()
    self.petMergeView:coinMergeBtn()
end

-- 融合界面 钻石按钮
function UIPetScene:petMergeView_diamondMergeBtn()
    self.petMergeView:diamondMergeBtn()
end

-- 融合界面 我的萌宠关闭按钮
function UIPetScene:petMergeView_myPetPanel_closeBtn()
    if self.petMergeView ~= nil then
        self.petMergeView:myPetPanel_closeBtn()
    end
end

-- 融合界面 物品按钮
function UIPetScene:petMergeView_itemBtn()
    self.petMergeView:itemBtn()
end

-- 融合界面 辅助道具面板关闭按钮
function UIPetScene:petMergeView_aidItemPanel_closeBtn()
    self.petMergeView:aidItemPanel_closeBtn()
end

-- 融合界面 融合完毕更改ui状态
function UIPetScene:petMergeView_mergeEnd(newPet)

    if self.petMergeView ~= nil then
        self.petMergeView:mergeEnd(newPet)
    elseif self.petMainView ~= nil then
        self.petMainView:mergeEnd(newPet)
    end
end
-- 融合界面 打开说明
function UIPetScene:petMergeView_explanBtn()
    self.petMergeView:explanBtn()
end
-- 融合界面 关闭说明
function UIPetScene:petMergeView_CloseExplanBtn()
    self.petMergeView:CloseExplanBtn()
end

-- 抽取界面 关闭按钮
function UIPetScene:petExtractView_closeBtn()
    --GamePrint("petExtractView_closeBtn 2222222222222")
    self.petExtractView:SetActive(false)
    self.petMainView:SetActive(true)
end

-- 抽取界面 金币抽取按钮
function UIPetScene:petExtractView_coinBtn()
    self.petExtractView:coinBtn()
end

-- 抽取界面 钻石抽取按钮
function UIPetScene:petExtractView_diamondBtn()
    self.petExtractView:diamondBtn()
end

-- 抽取界面 碎片抽取按钮
function UIPetScene:petExtractView_pieceBtn()
    self.petExtractView:pieceBtn()
end

-- 抽取界面 icon显示
function UIPetScene:petExtractView_iconShow(tid)
    self.petExtractView:iconShow(tid)
end

function UIPetScene:petExtractView_petShowPanel_closeBtn()
    self.petExtractView:petShowPanel_closeBtn()
end

-- 抽取界面 抽取返回播动画
function UIPetScene:petExtractView_creatPetExtractAnim(gold,diamond,equips,items,pets,lottery_id)

    if lottery_id == 7 then
        --十连抽
        self.petExtractView:creatPetExtractAnim_ten(gold,diamond,equips,items,pets)
    else
        --单抽
        self.petExtractView:creatPetExtractAnim(gold,diamond,equips,items,pets)
	end
    --[[
    if #tab <= 1 then -- 单抽
        self.petExtractView:creatPetExtractAnim(tab[1])
    elseif #tab > 1 then -- 十连抽
        self.petExtractView:creatPetExtractAnim_ten(tab)
    end
    ]]--
end

-- 抽取界面确定按钮
function UIPetScene:petExtractView_rewardItemOkBtn()
    self.petExtractView:rewardItemOkBtn()
end

-- 抽取碎片返回 刷新碎片ui
function UIPetScene:petExtractView_updatePetPieceUI()
    self.petExtractView:updatePetPieceUI()
end

-- 图鉴界面 关闭按钮
function UIPetScene:petHandbookView_closeBtn()
    self.petHandbookView:SetActive(false)
    self.petMainView:SetActive(true)
end

-- 图鉴界面 关闭按钮
function UIPetScene:petHandbookView_zhaohuan(btn)
    self.petHandbookView:zhaohuan(btn)
end

-- 图鉴界面 更新
function UIPetScene:petHandbookView_listUpdate()
    self.petHandbookView:listUpdate()
end

-- 加载界面
function UIPetScene:LoadUI(name)
    local path = "UI/"..name
    local obj = newobject(Util.LoadPrefab(path))
    obj.gameObject.transform.parent = self.uiRoot.gameObject.transform
    obj.gameObject.transform.localPosition = Vector3.zero
    obj.gameObject.transform.localScale = Vector3.one
    return obj
end

-- 创建萌宠小icon
function UIPetScene:creatPetIcon(tid,grid,target)

    local icon = newobject(Util.LoadPrefab("UI/Pet/MypetIcon"))
    icon.gameObject.transform.parent = grid.gameObject.transform
    icon.gameObject.transform.localScale = Vector3(1,1,1)
    self:UpdataPetIcon(tid,icon,target)

    local infoBtn = icon.transform:FindChild("petIconInfoBtn").gameObject
    AddonClick(infoBtn,function (infoBtn)
        -- body
        self:creatIconInfoPanel(infoBtn)
    end)
    return icon
end

function UIPetScene:UpdataPetIcon(tid,icon,target)
    local petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
    local ctid = _txt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
    local starNum = _txt:GetData(tid, TxtFactory.S_MOUNT_STAR) -- 星级
    -- body
    -- 添加按钮监听脚本
    local  seletePetIcon = icon.gameObject.transform:FindChild("SeletePetIcon")
    local  bm = seletePetIcon.gameObject:AddComponent(UIButtonMessage.GetClassType())
    bm.target = self.sceneTarget -- target.gameObject
    bm.functionName = "OnClick"
    bm.trigger = 0
    
    local starGrid = icon.gameObject.transform:FindChild("starGrid")
    local starGridCo = starGrid.gameObject.transform:GetComponent("UIGrid")
    for i=0, starGrid.childCount-1 do
        starGrid:GetChild(i).gameObject:SetActive(i < starNum)
    end
    starGridCo:Reposition() -- 自动排列

    -- 品质更改外框
    local rankData = petTable:GetData(ctid,"RANK_ICON")
    local rankIcon = icon.gameObject.transform:FindChild("iconback"):GetComponent("UISprite")
    rankIcon.spriteName = rankData
    -- GetComponent<UISprite>().spriteName

    -- 名字更改
    local nameData = petTable:GetData(ctid,"NAME")
    local nameLabel = icon.gameObject.transform:FindChild("name").gameObject.transform:GetComponent("UILabel")
    nameLabel.text = nameData

--[[    -- 信息按钮
    local infoBtn = icon.gameObject.transform:FindChild("petIconInfoBtn")
    local infoBtnMes = infoBtn.gameObject.transform:GetComponent("UIButtonMessage")
    infoBtnMes.target = self.sceneTarget --target.gameObject]]

    -- 碎片
    local pieceNum = icon.gameObject.transform:FindChild("pieceNum")
    pieceNum.gameObject:SetActive(false)

    -- icon设置
    local iconPic = icon.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
    iconPic.spriteName = petTable:GetData(ctid,"PET_ICON")

    -- 宠物类型图片
    local typeTag = icon.gameObject.transform:Find("type"):GetComponent("UISprite") -- 类型/飞行支援
    typeTag.spriteName = ""--petTable:GetData(ctid,"TYPE_ICON")

    -- 宠物类型图片
    --local tTag = icon.gameObject.transform:Find("tag"):GetComponent("UISprite") -- 上阵标记
    --tTag.spriteName = ""--petTable:GetData(ctid,"TYPE_ICON")
end

-- 创建萌宠大icon
function UIPetScene:creatPetIconBig(tid,iconParent)
    local petTable = TxtFactory:getTable("MountTypeTXT")
    local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
    local ctid = _txt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
    local starNum = _txt:GetData(tid, TxtFactory.S_MOUNT_STAR) -- 星级
    local level = _txt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级

    -- 萌宠icon按钮
    local icon = newobject(Util.LoadPrefab("UI/Pet/petMainIcon"))
    icon.gameObject.transform.parent = iconParent.gameObject.transform
    icon.gameObject.transform.localScale = Vector3(1,1,1)
    icon.gameObject.transform.localPosition = Vector3(0,-10,0)
    
    local  seletePetIcon = icon.gameObject.transform:FindChild("SeletePetIcon")
    local  bm = seletePetIcon.gameObject:AddComponent(UIButtonMessage.GetClassType())
    bm.target = self.sceneTarget -- target.gameObject
    bm.functionName = "OnClick"
    bm.trigger = 0

    local ic = icon.gameObject.transform:FindChild("icon")
    ic.gameObject.transform.localScale = Vector3(1,1,1)
    local bg = icon.gameObject.transform:FindChild("background")
    bg.gameObject:SetActive(false)
    local jo = ic.gameObject.transform:FindChild("join")
    jo.gameObject:SetActive(false)

    local bigIcon = ic.gameObject.transform:FindChild("bigIcon"):GetComponent("UISprite")
    bigIcon.spriteName = petTable:GetData(ctid,"PET_ICON_LIST")

    -- 品质更改外框
    local rankData = petTable:GetData(ctid,"RANK_ICON_2")
    local rankIcon = ic.gameObject.transform:FindChild("pank"):GetComponent("UISprite")
    rankIcon.spriteName = rankData

    -- 品质更改外框
    local petType = petTable:GetData(ctid,"TYPE_ICON")
    local typeIcon = ic.gameObject.transform:FindChild("type"):GetComponent("UISprite")
    typeIcon.spriteName = petType

    local starGrid = ic.gameObject.transform:FindChild("starGrid")
    local starGridCo = starGrid.gameObject.transform:GetComponent("UIGrid")
    for i=0, starGrid.childCount-1 do
        starGrid:GetChild(i).gameObject:SetActive(i < starNum)
    end
    starGridCo:Reposition() -- 自动排列

    local lvLabel = ic.gameObject.transform:FindChild("lvLabel").gameObject.transform:GetComponent("UILabel")
    lvLabel.text = tostring(level)

    -- 名字更改
    local nameData = petTable:GetData(ctid,"NAME")
    local nameLabel = ic.gameObject.transform:FindChild("nameLabel").gameObject.transform:GetComponent("UILabel")
    nameLabel.text = nameData

    return icon
end

-- 萌宠信息icon界面
function UIPetScene:creatIconInfoPanel(btn)
    local id = tonumber(btn.gameObject.transform.parent.name)
    local  ddate = self.petManagement:idPetData(id)

    local tid = ddate ~= nil and ddate.tid or nil
    if tid == nil then -- 如果尚未拥有这个宠物
        local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
        tid = mountTxt:GetData(id, TxtFactory.S_MOUNT_INIT_ID) -- 初始ID
    end
    self.petIconInfoPanel = PetinfoView.new()
    self.petIconInfoPanel:creatIconInfoPanel(self.uiRoot,tid, self,ddate)

end

-- 萌宠icon信息界面 关闭按钮
function UIPetScene:petIconInfoPanel_closeBtn()
    self.petIconInfoPanel:closeBtn()
end

-- 萌宠界面显示属性
function UIPetScene:iconInfoPanelDescript(tid,desKeyLabel,desText)
    local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
    local petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
    local ctid = mountTxt:GetData(tid,TxtFactory.S_MOUNT_TYPE)
    local statistics = petTable:GetData(ctid,"SEE")
    local statisticsd = string.gsub(statistics,'"',"")
    local statistic_array = lua_string_split(tostring(statisticsd),",")

    local value = ""
    local valueKey = ""
    for i =1, #statistic_array do
        local kkey = statistic_array[i]
        local vv = mountTxt:GetData(tid,kkey)
        local vvNum = tonumber(vv)
        if vvNum > 0 then
            if kkey == "ADDSC" then
                vv = string.format("%4.2f",vvNum*100).."%"
            end
            value = value..tostring(vv).."\n"
            valueKey = valueKey..tostring(mountTxt.AttributeNew[kkey])..":\n"
        end
    end
    desText.text = value
    desKeyLabel.text = valueKey
    --[[local value = ""
            local ttex = string.format("%4.2f", tonumber(mountTxt:GetData(tid, "ADDSC"))*100).."%"
            --local ADDATKSCText = mountTxt:GetData(tid, "ADDATKSC") ~= "0" and mountTxt:GetData(tid, "ADDATKSC") or ""
            --GamePrint("tid ="..tostring(tid))
            --for i =1, #statistic_array do
                 --GamePrint("value ="..statistic_array[i])
            value = value .. "\n" .. mountTxt:GetData(tid, "ADDHP")
            value = value .. "\n" .. ttex
            --value = value .. "\n" .. ADDATKSCText
            --value = value .. "\n" .. mountTxt:GetData(tid, "COLLECTIONS_SCORE")
        
            --end
            desText.text = value
            desKeyLabel.text = "\n" ..mountTxt.Attribute.ADDHP .. "\n" ..
            mountTxt.Attribute.ADDSC .. "\n" 
        
            local ADDATKSCText = mountTxt:GetData(tid, "ADDATKSC")
        
            if ADDATKSCText ~= "0" then
                desText.text = desText.text..ADDATKSCText.."\n"
                desKeyLabel.text = desKeyLabel.text..mountTxt.Attribute.ADDATKSC .. "\n"
            end]]
    --mountTxt.Attribute.GOLD_SCORE 
        
    -- return value
end


-- 获得萌宠展示面板创建 通用
function UIPetScene:creatPetShowPanel(items)
    if self.petShowPanel ~= nil then
        destroy(self.petShowPanel)
    end
    self.petShowPanel = self:LoadUI("common/CommonRewardItemsGetUI")
    local infoRoot = self.petShowPanel.gameObject.transform:FindChild("UI/CommonRewardItemsGetUI_Grid")
    local effect = self.petShowPanel.gameObject.transform:FindChild("ef_ui_ronghe"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
    SetEffectOrderInLayer(effect,505)
    local closeBtn = self.petShowPanel.gameObject.transform:FindChild("UI/CommonRewardItemsGetUI_OKBtn")
    self:SetButtonTarget(closeBtn,self.sceneTarget)
    closeBtn.name = "PetExtractPetShowUI_close"
    -- 关闭
    AddonClick(closeBtn,function( ... )
        -- body
        self:petShowPanel_closeBtn()
    end)
    -- local tid = self.petManagement:idDataForTid(id)
    -- local icon = self:creatPetIconBig(tid,infoRoot)
    -- icon.gameObject.name = id
    -- local infoBtn = icon.gameObject.transform:FindChild("petIconInfoBtn")
    -- self.scene:SetButtonTarget(infoBtn,self.sceneTarget)

    -- icon.gameObject.transform.localScale = Vector3(1.4,1.4,1)
    -- icon.gameObject.transform.localPosition = Vector3(0,-40,0)
    if type(items) ~= "table" then
        local id = items
        self:petShowPanel_creatItems(id,infoRoot)
        return
    end

    for i = 1 , #items do
        local id = items[i].id
        self:petShowPanel_creatItems(id,infoRoot)
    end


end

function UIPetScene:petShowPanel_creatItems(id,infoRoot)
    local tid = self.petManagement:idDataForTid(id)
    local icon = self:creatPetIcon(tid,infoRoot,self.sceneTarget)
    icon.name = id
    local infoBtn = icon.transform:FindChild("petIconInfoBtn")
    infoBtn.gameObject:SetActive(false)
    local petbtn = icon.transform:FindChild("SeletePetIcon")
    petbtn.gameObject:SetActive(false)
    self:SetButtonTarget(icon,self.sceneTarget,self.sceneTarget)
end

-- 萌宠展示面板关闭
function UIPetScene:petShowPanel_closeBtn()
    destroy(self.petShowPanel)
end

-- 装备抽金币判断
function UIPetScene:coinPriceCheck(price)
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
function UIPetScene:diamondPriceCheck(price)
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


--[[-- 提示文字显示 lua 不支持重载函数
function UIPetScene:promptWordShow(word)
    self.promptWordShowView = PromptWordShowView.new()
    self.promptWordShowView:init(self,word)
    GamePrint("萌宠提示板 关闭按钮 萌宠提示板 关闭按钮")
    -- self.wordPrompt.text = word
    local btn = self.promptWordShowView.panel.transform:FindChild("CommonPromptUI_Background")
    -- 萌宠提示板 关闭按钮
    AddonClick(btn,function()
        -- body
        GamePrint("萌宠提示板 关闭按钮 萌宠提示板 关闭按钮")
        self:promptWordShowClose()
    end)
end]]

-- 关闭文字提示
function UIPetScene:promptWordShowClose()
    self.promptWordShowView:close()
end
UIPetScene.PromptFun = nil
-- 提示文字显示
function UIPetScene:promptWordShow(word, fun)
    self.super.promptWordShow(self,word)
    self.PromptFun = fun
    -- 萌宠提示板 关闭按钮
    local btn = self.promptWordShowView.panel.transform:FindChild("CommonPromptUI_Background")
    AddonClick(btn,function()
        -- body
        --GamePrint("萌宠提示板 关闭按钮 萌宠提示板 关闭按钮")
        self:promptWordShowClose()
    end)
end

-- 关闭文字提示
function UIPetScene:promptWordShowClose()
    self.super.promptWordShowClose(self)
    if self.PromptFun then
        self.PromptFun(self)
    end
    self.PromptFun = nil
end

function UIPetScene:SetOpenViewClass(openViewClass)
    self.openViewClass = openViewClass
end

--[[-- 萌宠界面显示属性
function UIPetScene:iconInfoPanelDescript(tid,desKeyLabel,desText)
    local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
    local petTable = TxtFactory:getTable("MountTypeTXT")
    local ctid = mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
    local per = mountTxt:GetData(tid, "ADDSC")
    local value = mountTxt:GetData(tid, "ADDHP") .. "\n" ..
        tonumber(per)*100 .. "%" .. "\n" ..
        mountTxt:GetData(tid, "ADDATKSC") .. "\n" ..
        mountTxt:GetData(tid, "COLLECTIONS_SCORE")
    desText.text = value

    desKeyLabel.text = mountTxt.Attribute.ADDHP .. "\n" ..
        mountTxt.Attribute.ADDSC .. "\n" ..
        mountTxt.Attribute.ADDATKSC .. "\n" ..
        mountTxt.Attribute.GOLD_SCORE
    -- return value
end]]