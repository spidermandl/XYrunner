--[[
author:Desmond
功能:UI套装逻辑
未解决问题：
     3d 套装模型
     套装icon图片设置
     解锁机制需要完善---套装购买另外配表
]]

require "game/scene/logic/suit/SuitManagement" 
require "game/scene/logic/suit/FloatModel"

UISuitScene = class (BaseScene)

--[[UI 控件]]
UISuitScene.uiRoot = nil --ui根节点
UISuitScene.UIPanel_Suit = nil --ui prefab
UISuitScene.ModelCtr = nil              ------3D模型控制
UISuitScene.suitManager = nil           ------套装管理类
UISuitScene.RightChild=nil 							-----------面板右侧的部分中的总子物体 可能用于界面动画
UISuitScene.SuitNameSprite=nil 						-----------套装名字Sprite
UISuitScene.LvParent=nil 								-----------等级父物体
UISuitScene.LabelLv=nil 								-----------等级label
UISuitScene.SuitAttributeTitleSprite=nil 				-----------套装属性主题sprite
UISuitScene.DescribeLabel=nil 						-----------套装描述label
UISuitScene.SuitAttributesParent=nil 					-----------套装属性的父物体
UISuitScene.SuitAttributesGrid=nil 					-----------套装属性的父物体上绑定的UIGrid
UISuitScene.ButtonBuy=nil 							-----------购买按钮
UISuitScene.ButtonBuy1=nil 							-----------直接购买按钮
UISuitScene.ButtonUpgrade=nil 						-----------升级按钮
UISuitScene.ButtonMax=nil 							-----------最高级别
UISuitScene.ConsumptionDescribe=nil 					-----------消耗描述
UISuitScene.ConsumptionDescribeCoin=nil				-----------消耗描述金币
UISuitScene.ConsumptionDescribeCrystal=nil				-----------消耗描述钻石
UISuitScene.ConsumptionDescribeLabel=nil  			-----------消耗描述Label
UISuitScene.ButtonLeft=nil 							-----------向左按钮
UISuitScene.ButtonRight=nil 							-----------向右按钮
UISuitScene.ScrollPanel=nil 							-----------滑动框
UISuitScene.ScrollPanelOffset=nil 					-----------显示区域的纠正（滑动框上的UIPanel脚本）
UISuitScene.SelectIconsParent=nil 					-----------滑动框中选项的父物体
UISuitScene.BtnSelect=nil 							-----------选择按钮
UISuitScene.SelectedBox=nil 							-----------选择光标框
UISuitScene.SelectedTick=nil 							-----------选择光标勾
UISuitScene.targetPositionX=nil						-----------目标位置的X轴，用于矫正滑动框
UISuitScene.unlockTip=nil 		 					-----------解锁提示
UISuitScene.ScrollBar=nil 		 					-----------滑动条


UISuitScene.Model3D=nil 								-----------3D模型
UISuitScene.sceneTarget = nil  ---

--[[逻辑成员变量]]
UISuitScene.effect_levelup=nil 				-----------升级特效
UISuitScene.nowSuitLv=0 			---------------当前选中套装的等级
UISuitScene.suitObjs = nil 		--------------- 套装按钮框
UISuitScene.selected_index = 1  --------------- 选中box位置
UISuitScene.scroll_left_index =1 -------------- 滚动box最左端位置
UISuitScene.boxUnitLenght = 0 --box单位长度
UISuitScene.boxClipOffset = UnityEngine.Vector2(120,80) --box clipping offset

UISuitScene.modelShow = nil -- 模型秀
UISuitScene.sceneParent = nil -- 父级场景
UISuitScene.openViewClass = nil -- 打开该界面的类

function UISuitScene:Awake()
	self.super:Awake()

	-- self.ModelCtr = FloatModel.new()

	self.suitManager = SuitManagement.new()
	self.suitManager.scene = self
	self.suitManager:Awake()
	self:init()
end


function UISuitScene:Start()
end

function UISuitScene:Update()
    -- self:CorrectBoxPosition()---矫正滑动框
   	-- self.ModelCtr:Rotating3DModel()-----3D旋转
end

function UISuitScene:FixedUpdate()
end

--初始化
function UISuitScene:init()
	-- self.uiRoot = newobject(Util.LoadPrefab("UI/battle/UI Root"))
	-- self.uiRoot.name = 'UI Root'
	self.uiRoot = find('UI Root')
	  -- self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UICtrlEndlessLua")
	  
    self.UIPanel_Suit = newobject(Util.LoadPrefab("UI/Suit/SuitUI"))
    self.UIPanel_Suit.gameObject.transform.parent = self.uiRoot.gameObject.transform
    self.UIPanel_Suit.gameObject.transform.localPosition = Vector3.zero
    self.UIPanel_Suit.gameObject.transform.localScale = Vector3.one

	self.sceneTarget = self.UIPanel_Suit
	-- self.Model3D=self.UIPanel_Suit.gameObject.transform:Find("Camera3D"):Find("Cube")
	-- self.ModelCtr.Model3D = self.Model3D

	local uiPanel = self.UIPanel_Suit.gameObject.transform:Find("Panel")
	local uiLeft = uiPanel:Find("Left")
	self.RightChild = uiPanel:Find("Right"):Find("RightChild")
	local uiInformationPanel = self.RightChild:Find("InformationPanel")
	self.SuitNameSprite=uiInformationPanel:Find("SuitName"):GetComponent("UILabel")
	self.LvParent=uiInformationPanel:Find("Lv")
	self.LabelLv=self.LvParent:Find("LabelLv"):GetComponent("UILabel")
	self.SuitAttributeTitleSprite=uiInformationPanel:Find("SuiteAttributeTitle")
	self.DescribeLabel=uiInformationPanel:Find("Describe"):Find("Label1"):GetComponent("UILabel")
	self.SuitAttributesParent=uiInformationPanel:Find("SuiteAttributes")
	self.SuitAttributesGrid=self.SuitAttributesParent:GetComponent("UIGrid")
	local rightButtons=self.RightChild:Find("Buttons")
	self.ButtonBuy=rightButtons:Find("BtnBuy")
	self.ButtonBuy1=rightButtons:Find("BtnBuy1")
	self.ButtonUpgrade=rightButtons:Find("BtnUpgrade")
	self.ButtonMax=rightButtons:Find("BtnMax")
	self.ConsumptionDescribe=rightButtons:Find("Describe")
	self.ConsumptionDescribeCoin=self.ConsumptionDescribe:Find("coin")
	self.ConsumptionDescribeCrystal=self.ConsumptionDescribe:Find("crystal")
	self.ConsumptionDescribeLabel=self.ConsumptionDescribe:Find("Label"):GetComponent("UILabel")

	self.effect_levelup=uiLeft:Find("ef_ui_shengji"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
	SetEffectOrderInLayer(self.effect_levelup,10)
	self.ButtonLeft=uiLeft:Find("BtnLeft")
	self.ButtonRight=uiLeft:Find("BtnRight")
	self.unlockTip=uiLeft:Find("UnLockTip")

	self.ScrollPanel = uiLeft:Find("ScrollPanel")
	self.ScrollPanelOffset=self.ScrollPanel:GetComponent("UIPanel")
	self.SelectIconsParent=self.ScrollPanel:Find("SelectIcons")
	self.BtnSelect=self.SelectIconsParent:Find("BtnSelect")
	self.SelectedBox=self.ScrollPanel:Find("SelectedBox")
	self.SelectedTick=self.ScrollPanel:Find("SelectedTick")
	self.ScrollBar = uiLeft:Find("Scroll Bar"):GetComponent("UIScrollBar")

	local txt = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
	self.selected_index = txt[TxtFactory.SUIT_SELECTED_INDEX]
	self.scroll_left_index = txt[TxtFactory.SUIT_LEFT_INDEX]

 	self:initSuitBox()  -- 设置滑动框

    local sceneUI = find(ConfigParam.SceneOjbName)
	self.sceneParent = LuaShell.getRole(sceneUI.gameObject:GetInstanceID())

	--error(self.sceneParent.test)
	self.playerTopInfoPanel = self.sceneParent.playerTopInfoPanel
	self.modelShow = self.sceneParent.modelShow -- 模型展
	
	self.SelectedBox.gameObject:SetActive(false)
 	self.SelectedTick.gameObject:SetActive(false)

    self:SetUiAnChor()
    self:updateSelection(self.selected_index) --设置选中box
	

    LuaShell.addUserData(self.SuitNameSprite)
    LuaShell.addUserData(self.LabelLv)
    LuaShell.addUserData(self.DescribeLabel)
    LuaShell.addUserData(self.SuitAttributesGrid)
    LuaShell.addUserData(self.ConsumptionDescribeLabel)
    LuaShell.addUserData(self.effect_levelup)
    LuaShell.addUserData(self.ScrollPanelOffset)
    LuaShell.addUserData(self.ScrollBar)

end


--初始套装框数据
function UISuitScene:initSuitBox()
	self.suitObjs={}         --套装选择按钮存储
	local suitData = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)[TxtFactory.CUR_SUITS]
	--print (" ---------------  function UISuitScene:initSuitBox()  "..tostring(#suitData))
	local txt = TxtFactory:getTable(TxtFactory.SuitTXT)
	for i=1,#suitData do  --动态添加滑动框子物体
		--创建box
		local s_id = suitData[i][TxtFactory.SUIT_CONFIG_ID]
		local isOpen = txt:GetData(s_id,TxtFactory.S_SUIT_OPEN_CLOSE)
		--GamePrint("s_id    :"..s_id.." isOpen:"..tostring(isOpen).." name:"..txt:GetData(s_id,TxtFactory.S_SUIT_NAME))
		while true do
	        if isOpen == nil or tonumber(isOpen) ~= 1 then
				break
			end
			local box = newobject(Util.LoadPrefab("UI/Suit/BtnSelect"))
	    	box.name=tostring(i)
		    box.transform.parent=self.SelectIconsParent
		    box.transform.localPosition = UnityEngine.Vector3.zero
		    box.transform.localScale = UnityEngine.Vector3.one
		    box.transform.rotation=UnityEngine.Vector3.zero
			-- 添加按钮监听脚本
			local  bm=box:AddComponent(UIButtonMessage.GetClassType())
			bm.target=self.UIPanel_Suit.gameObject
			bm.functionName="OnClick"
			local  bm1=box:AddComponent(UIButtonMessage.GetClassType())
			bm1.target=self.UIPanel_Suit.gameObject
			bm1.functionName="OnPress"
			bm1.trigger=1
			local  bm2=box:AddComponent(UIButtonMessage.GetClassType())
			bm2.target=self.UIPanel_Suit.gameObject
			bm2.functionName="OnRelease"
			bm2.trigger=2
			self.suitObjs[i]=box      --------- 按钮obj 存放的tabel
			self:bindBoxWithData(box,suitData[i]) --------- 设置单个框
        	break
    	end
	
	end
	self:updateScrollArraw()          --------- 移动箭头按钮显隐
	-- warn("UISuitScene:initSuitBox---#suitdata="..#suitData)
	if #suitData > 0 then
		self.boxUnitLenght = 1/#suitData
	end
end

--[[
设置一个选项框
box gameObject
data 绑定数据
]]
function UISuitScene:bindBoxWithData(box,data)
	local superscript= box.gameObject.transform:Find("Superscript") --  图标左上角等级 parent
	local superscriptLabel=superscript:Find("Label"):GetComponent("UILabel")    -- 等级label
	local icon = box.gameObject.transform:Find("Icon"):GetComponent("UISprite")  -- 套装 或萌宠 图标
	local lock = box.gameObject.transform:Find("Lock").gameObject  -- 锁图标
	local id = data[TxtFactory.SUIT_ID] --套装id
	local s_id = data[TxtFactory.SUIT_CONFIG_ID] --套装静态id
	local lv = data[TxtFactory.SUIT_LVL] --套装等级

	if tonumber(lv)==0 then 
		superscript.gameObject:SetActive(false)
		lock:SetActive(true)
	else
		superscript.gameObject:SetActive(true) 
		superscriptLabel.text="Lv"..tostring(lv)
		lock:SetActive(false)
	end

    local txt = TxtFactory:getTable(TxtFactory.SuitTXT)
	local iconName =txt:GetData(s_id,TxtFactory.S_SUIT_ICON_ATLAS) --获取icon，可能会该
	local iconName = tostring(iconName)
	if iconName == "Tz_boy_icon" then
		local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		if user[TxtFactory.USER_SEX] == 1 then
			iconName = "Tz_girl_icon"
		end
	end
	icon.spriteName=tostring(iconName)

	LuaShell.addUserData(superscriptLabel)
	LuaShell.addUserData(icon)

end


--清除属性
function UISuitScene:ClearSuitAttributes()
	local childLength=self.SuitAttributesParent.childCount
	for i=1,childLength do
		GameObject.Destroy(self.SuitAttributesParent:GetChild(i-1).gameObject)
	end
end


--更新套装详细信息
function UISuitScene:updateSelection(name)
	if name ~= nil and tonumber(name)~=nil then
		self.selected_index = tonumber(name)
	end
	local suitTxt = TxtFactory:getTable(TxtFactory.SuitTXT)
	local materialTxt = TxtFactory:getTable(TxtFactory.MaterialTXT)
	local txt = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
	local suitData = txt[TxtFactory.CUR_SUITS][self.selected_index]

	local id = suitData[TxtFactory.SUIT_ID]
	local config_id =suitData[TxtFactory.SUIT_CONFIG_ID]
	local lv = suitData[TxtFactory.SUIT_LVL] --当前选中套装等级
    local isMax = suitTxt:GetData(config_id,TxtFactory.S_SUIT_MAX) --更改等级最大化判断
    -- print("&suitupdate&"..tostring(id).." "..tostring(config_id).." "..tostring(lv).." "..tostring(isMax))
    --[[
    设置右下角升级条件信息
    ]]
	local setDescription = function () 
		local info = ""
		local gold = suitTxt:GetData(config_id,TxtFactory.S_SUIT_GOLD) --升级钻石和金币不共存
		if gold ~= nil and gold ~= "" and gold ~= "0" then
			self.ConsumptionDescribeCoin.gameObject:SetActive(true)
			self.ConsumptionDescribeCrystal.gameObject:SetActive(false)
			info=tostring(gold)
		else
			local diamonds= suitTxt:GetData(config_id,TxtFactory.S_SUIT_DIAMONDS)
			info=tostring(diamonds)
			self.ConsumptionDescribeCoin.gameObject:SetActive(false)
			self.ConsumptionDescribeCrystal.gameObject:SetActive(true)
		end
		if isMax then
			info = ""
			self.ConsumptionDescribeCoin.gameObject:SetActive(false)
			self.ConsumptionDescribeCrystal.gameObject:SetActive(false)
		end
		local material = suitTxt:GetData(config_id,TxtFactory.S_SUIT_MATERIAL) --升级材料可以同时存在
		if material ~= nil and material ~= "" then
			local  teMaterial= string.split(material,"=")
			-- print(lv.."材料："..tostring(teMaterial[1]))
			local m_id=teMaterial[1]
			local nums = teMaterial[2]
			local materialName=materialTxt:GetData(m_id,TxtFactory.S_MATERIAL_NAME)
			info = info.." （"..materialName.."X"..nums.."）"
		end
		self.ConsumptionDescribeLabel.text=info
	end
	setDescription() --设置右下角升级条件信息
    --[[
    设置升级效果属性
    ]]
    local setUpGradeAttr = function () 
		self:ClearSuitAttributes()

		------------套装升级显示说明
		local attrConfig = {
		    {TxtFactory.S_SUIT_BASE_HP,"基础体力"}, --基础hp
			{TxtFactory.S_SUIT_ADD_KILLSCORE,"击杀得分"}, --击杀额外得分
			{TxtFactory.S_SUIT_COLLECTIONS_SCORE,"收集得分"}, --收集物额外得分
			{TxtFactory.S_SUIT_SCORE_PEN,"表现加成",1}, --得分加成
		}
		for i=1,#attrConfig do
			local tempAttr = attrConfig[i]
			local attribute = newobject(Util.LoadPrefab("UI/Suit/Attribute"))
			attribute.transform.parent=self.SuitAttributesParent
			attribute.transform.localPosition =UnityEngine.Vector3.zero
			attribute.transform.localScale = UnityEngine.Vector3.one
			attribute.transform.rotation=UnityEngine.Vector3.zero
			attribute.transform:Find("Label0"):GetComponent("UILabel").text= tempAttr[2]

			local  isBfHao = tempAttr[3] == 1 and true or false -- 使用百分号
			if isBfHao then
				local  vvalu1 = tonumber(suitTxt:GetData(config_id,tempAttr[1]))
				attribute.transform:Find("Label1"):GetComponent("UILabel").text = string.format("%4.2f", vvalu1*100).."%"
			else
				attribute.transform:Find("Label1"):GetComponent("UILabel").text = suitTxt:GetData(config_id,tempAttr[1])
			end
			--print ("-------------------function UISuitScene:updateSelection(name) "..tostring(config_id).." "..tostring(tempAttr[1]))
			if isMax==true or lv==0 then
				attribute.transform:Find("Standard").gameObject:SetActive(false)
				attribute.transform:Find("Label2").gameObject:SetActive(false)
			else
				attribute.transform:Find("Standard").gameObject:SetActive(true)
				local new_id = tonumber(config_id)+1
				if isBfHao then
					local  vvalu2 = tonumber(suitTxt:GetData(new_id,tempAttr[1]))
					attribute.transform:Find("Label2"):GetComponent("UILabel").text = string.format("%4.1f", vvalu2*100)..'%'
				else
					attribute.transform:Find("Label2"):GetComponent("UILabel").text = suitTxt:GetData(new_id,tempAttr[1])
				end
			end
		end
		self.SuitAttributesGrid.repositionNow=true
    end
    setUpGradeAttr()
    
    --[[更新与等级相关信息]]
	self.ButtonBuy.gameObject:SetActive(false)
	self.ButtonBuy1.gameObject:SetActive(false)
	self.ButtonUpgrade.gameObject:SetActive(false)
	self.ButtonMax.gameObject:SetActive(false)

	local init_id = suitTxt:GetData(id, TxtFactory.S_SUIT_INIT)
	if tonumber(lv) == 0 then --未解锁
		self.unlockTip.gameObject:SetActive(true)
		self.unlockTip:GetChild(0):GetComponent("UILabel").text = tostring(suitTxt:GetData(init_id,"DRESS_DESC"))
		self.ButtonBuy.gameObject:SetActive(true)
	elseif tonumber(lv) > 0 then --可以解锁
		self.unlockTip.gameObject:SetActive(false)
		if isMax == true then  -- 升级满判断
			self.ButtonMax.gameObject:SetActive(true)
		else
			self.ButtonUpgrade.gameObject:SetActive(true)
		end
		
		self.SelectedTick.parent=self.suitObjs[self.selected_index].gameObject.transform
		self.SelectedTick.localPosition=Vector3.zero
		self.SelectedTick.gameObject:SetActive(true)
		
	end

	self.SelectedBox.parent=self.suitObjs[self.selected_index].gameObject.transform
	self.SelectedBox.localPosition=Vector3.zero
	self.SelectedBox.gameObject:SetActive(true)

	self.SuitNameSprite.text =suitTxt:GetData(config_id,TxtFactory.S_SUIT_NAME)
	self.LvParent.gameObject:SetActive(not isMax)
	self.LabelLv.text = lv
	self.DescribeLabel.text = suitTxt:GetData(config_id,TxtFactory.S_SUIT_DESCRIBE)--设置套装信息
    --[[设置3D模型
	-- self.PlayerName=self.suitManager.nameTable[teButtonindex]
	-- if teButtonindex~=self.SelectIndex and self.PlayerName~=nil then
	-- 	self.ModelCtr:Load3DModel(self.PlayerName,self.suitManager.url) 		--设置3D模型
	-- end
	-- self.SelectIndex=teButtonindex
    ]]
    self.modelShow:ChooseSuit(id) -- 显示对应模型

	self:bindBoxWithData(self.suitObjs[self.selected_index],suitData) --------- 设置单个框  lv数值有更新
end


--直接购买
function UISuitScene:BuyDirectly()
	self:BuySuit()
end

--购买功能
function UISuitScene:BuySuit()
	if(self:playerIsHave())then
		--购买发送协议以后需要添加
		self:promptWordShow("尚未开放")
	end
end

--退出前发送数据
function UISuitScene:sendMsgBeforeQuit()
	local txt = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
	if txt[TxtFactory.CUR_SUITS][self.selected_index][TxtFactory.SUIT_LVL] >0 then
		txt[TxtFactory.SUIT_SELECTED_INDEX] = self.selected_index
		self.suitManager:sendSuitSelection()
	end
end

--返回按钮
function UISuitScene:BackBtn()
	self:sendMsgBeforeQuit()
 --    self:ChangScene(SceneConfig.buildingScene)
    self.openViewClass:SetActive(true)
	self:SetActive(false)
end

function UISuitScene:SetActive(enable)
	self.UIPanel_Suit:SetActive(enable)
	self.modelShow:SetActive(enable, self.modelShow.suit)
	self.effect_levelup.gameObject:SetActive(false)
end

--向左移动按钮
function UISuitScene:MoveLeft()
	-- self.ScrollPanel.localPosition=self.ScrollPanel.localPosition+Vector3(self.boxUnitLenght,0,0)
	-- self.ScrollPanelOffset.clipOffset=self.ScrollPanelOffset.clipOffset+UnityEngine.Vector2(-self.boxUnitLenght,0)
	-- self.scroll_left_index = self.scroll_left_index - 1
	self.ScrollBar.value = self.ScrollBar.value - self.boxUnitLenght
	self:updateScrollArraw()
end

--向右移动按钮
function UISuitScene:MoveRight()
	-- self.ScrollPanel.localPosition=self.ScrollPanel.localPosition+Vector3(-self.boxUnitLenght,0,0)
	-- self.ScrollPanelOffset.clipOffset=self.ScrollPanelOffset.clipOffset+UnityEngine.Vector2(self.boxUnitLenght,0)
	-- self.scroll_left_index = self.scroll_left_index + 1
	self.ScrollBar.value = self.ScrollBar.value + self.boxUnitLenght
	self:updateScrollArraw()
end

--移动按钮显隐
function UISuitScene:updateScrollArraw()
	-- local txt = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
	-- local left = self.scroll_left_index
	-- local length = #txt[TxtFactory.CUR_SUITS]
	--print ("----------function UISuitScene:updateScrollArraw() "..tostring(left).." "..tostring(length))
	self.ButtonLeft.gameObject:SetActive(false)--(self.ScrollBar.value > 0.001)
	self.ButtonRight.gameObject:SetActive(false)--(self.ScrollBar.value < 0.999)
end

--矫正滑动框位置
function UISuitScene:CorrectBoxPosition()
	--print ("--------- function UISuitScene:CorrectBoxPosition() 1")
	if self.targetPositionX==nil then 
		--print ("--------- function UISuitScene:CorrectBoxPosition() 2")
		--self.targetPositionX = self.ScrollPanel.localPosition.x
		return
	end
	if self.ScrollPanel.localPosition.x~=self.targetPositionX then
		--print ("--------- function UISuitScene:CorrectBoxPosition() 3")
		self.targetPositionX=self.ScrollPanel.localPosition.x
		return
	end

	self.scroll_left_index = math.floor(math.abs(self.ScrollPanel.localPosition.x)/self.boxUnitLenght+0.5)+1
	self.ScrollPanel.localPosition=Vector3(-(self.scroll_left_index-1)*self.boxUnitLenght,0,0) 
	self.ScrollPanelOffset.clipOffset=self.boxClipOffset + UnityEngine.Vector2((self.scroll_left_index-1)*self.boxUnitLenght,0)
	self.targetPositionX=nil
	self:updateScrollArraw()
end

--升级 购买是否满足条件
function UISuitScene:playerIsHave()
		--金币不足提示

	local suitTxt = TxtFactory:getTable(TxtFactory.SuitTXT)
	local materialTxt = TxtFactory:getTable(TxtFactory.MaterialTXT)
	local txt = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
	local suitData = txt[TxtFactory.CUR_SUITS][self.selected_index]

	local id = suitData[TxtFactory.SUIT_ID]
	local config_id =suitData[TxtFactory.SUIT_CONFIG_ID]
	local lv = suitData[TxtFactory.SUIT_LVL] --当前选中套装等级
    --print (tostring(id).." "..tostring(config_id).." "..tostring(lv).." "..tostring(isMax))
    --[[
    设置右下角升级条件信息
    ]]
	local info
	local gold = suitTxt:GetData(config_id,TxtFactory.S_SUIT_GOLD) --升级钻石和金币不共存
	local memDataCacheTxt = TxtFactory:getTable(TxtFactory.MemDataCache)
	self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	if gold ~= nil and gold ~= "" then
		info=tonumber(gold)
		if(info > self.UserInfo[TxtFactory.USER_GOLD] )then
			self:promptWordShow("金币不足")
    -- self.wordPrompt.text = word
			return false
		end

	else
		local diamonds= suitTxt:GetData(config_id,TxtFactory.S_SUIT_DIAMONDS)
		info=tonumber(diamonds)
		if(info > self.UserInfo[TxtFactory.USER_DIAMOND] )then
			self:promptWordShow("钻石不足")
			return false
		end
	end
	local material = suitTxt:GetData(config_id,TxtFactory.S_SUIT_MATERIAL) --升级材料可以同时存在
	if material ~= nil and material ~= "" then
		local  teMaterial= string.split(material,"=")
		-- print(lv.."材料："..tostring(teMaterial[1]))
		local m_id=teMaterial[1]
		local nums = teMaterial[2]
		if(tonumber(nums)>memDataCacheTxt:getMaterialCount(m_id))then
			self:promptWordShow("材料不足")
			return false
		end
	end
	return true
end

function UISuitScene:Upgrade()
	if(self:playerIsHave())then
		self.suitManager:sendSuitUpgrade(self.selected_index)
	end

end

--升级成功处理
function UISuitScene:updateSuccess(cid)
	local suitTxt = TxtFactory:getTable(TxtFactory.SuitTXT)
	local txt = TxtFactory:getMemDataCacheTable(TxtFactory.SuitInfo)
	-- 升级特效
	self.effect_levelup.gameObject:SetActive(true)
	self.effect_levelup:Play()
	local suitData = txt[TxtFactory.CUR_SUITS][self.selected_index]
	local config_id = tonumber(suitData[TxtFactory.SUIT_CONFIG_ID])
	
	local coins, diamond = self:GetUpgradeNeed(config_id)
	local memData =  TxtFactory:getTable(TxtFactory.MemDataCache)
	memData:AddUserInfo(-coins, -diamond) -- 扣除金币钻石
	self:UpdatePlayerInfo()

	config_id = cid
	suitData[TxtFactory.SUIT_CONFIG_ID] = config_id
	suitData[TxtFactory.SUIT_LVL] = suitTxt:GetData(config_id,TxtFactory.S_SUIT_LVL)
	local boolMaxLevel = suitTxt:GetData(config_id, TxtFactory.S_SUIT_MAX)

	self:updateSelection(nil)
	if boolMaxLevel then
		self.sceneParent:GetMailList()
	end
end

function UISuitScene:GetUpgradeNeed(suitid)
	local suitTxt = TxtFactory:getTable(TxtFactory.SuitTXT)
	local coins = tonumber(suitTxt:GetData(suitid, "GOLD"))
    local diamond = tonumber(suitTxt:GetData(suitid, "DIAMONDS"))
    if coins == nil then coins = 0 end
    if diamond == nil then diamond = 0 end

    return coins, diamond
end

function UISuitScene:SetOpenViewClass(openViewClass)
    self.openViewClass = openViewClass
end
