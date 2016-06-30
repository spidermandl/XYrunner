--[[
套装界面 deprecated
作者：秦仕超
]]

UpgradeType={
	Upgrade=1,
	suit=0,
	Mount=1,
}
------套装TXT表title
SuitTxtTitle={
	ID="ID",
	NAME="NAME",
	DESCRIBE="DRESSDESC",
	UPGOLD="GOLD",
	UPDIAMONDS="DIAMONDS",
	UPMATERIAL="MATERIAL",
}
---------坐骑TXT表title
MountTxtTitle={
	ID="ID",
	NAME="NAME",
	DESCRIBE="PETDESC",
	UPGOLD="UPGOLD",
	UPDIAMONDS="UPDIAMOND",
	UPMATERIAL="MATERIAL",
}

-----------坐骑显示属性title
MountShowTitle={
	{icon="品质",key="RANK"},
	{icon="延缓体力",key="SLOWHP"},
	{icon="击杀额外得分",key="ADDATKSC"},
	{icon="CD时间类",key="CD_TIME"},
	{icon="收集物得分",key="GOLD_SCORE"},
	{icon="音符基础分",key="NOTE"},
}

------------套装显示属性title
SuitShowTitle={
	{icon="品质",key="RANK"},
	{icon="基础hp",key="BASE_HP"},
	{icon="击杀额外得分",key="ADD_KILLSCORE"},
	{icon="收集物额外得分",key="GOLD_SCORE"},
	{icon="得分加成",key="SCORE_PEN"},
	{icon="红色金币",key="RED_SCORE"},
}

------------3D模型URL
ModelURL={
	suitURL="Player/",
	mountURL="Monster/",
}

-----------套装模型名字
SuitName={
	"player",
	"zhi_yuan",
}
-----------坐骑模型名字
MountName={
	"blackcat",
	"flightTortoise",
	"blackcat",
}

UISuitLua=class(BaseUILua)

UISuitLua.tag = "UISuitLua"
UISuitLua.roleName = "UISuitLua"

UISuitLua.Type=nil 					------套装类型
UISuitLua.TxtTitle=nil 				------使用中的文本头
UISuitLua.url=nil 					------3D模型路径

UISuitLua.nameTable=nil 				------使用的3D模型名字
function UISuitLua:Awake()
	-- if self.bundleParams ~= nil and self.bundleParams.Length ~= 0 then 
 --    	self.Type=self.bundleParams[1]
 --    else
 --    	self.Type=UpgradeType.suit
 --    end
 	self.Type=UpgradeType.suit
    if self.Type==UpgradeType.suit then  -- 套装scene
    	self.TxtTitle=SuitTxtTitle
    	self.AttributeTitle=SuitShowTitle  -- 显示label对应 为套装
    	self.SuitTxtInstance = TxtFactory:getTable("SuitTXT")  
 		self.url=ModelURL.suitURL -- 套装模型 地址目录 对应
 		self.nameTable=SuitName
	elseif self.Type==UpgradeType.mount then   -- 萌宠 scene
		self.TxtTitle=MountTxtTitle
		self.AttributeTitle=MountShowTitle    -- 显示label对应 为萌宠
		self.SuitTxtInstance = TxtFactory:getTable("MountTXT")
 		self.url=ModelURL.mountURL -- 萌宠模型 地址目录 对应
 		self.nameTable=MountName
	end
	-- print("TYPE:"..self.Type)
	-- for k,v in pairs(self.TxtTitle) do
	-- 	print(k.."#"..v)
	-- end
	self:Init()  -- 加载面板
end

function UISuitLua:Start()
	
end

function UISuitLua:Update()
	self:CorrectBoxPosition()---矫正滑动框
	self:Rotating3DModel()-----3D旋转
end


-----------------------套装界面功能-------------------------------------------------------------------------------------------
UISuitLua.MaxLv=8 									-----------最大等级数

UISuitLua.SuitTxtInstance=nil 						-----------套装数据类指针
UISuitLua.MaterialTxtInstance=nil 					-----------材料数据类指针

UISuitLua.RightChild=nil 							-----------面板右侧的部分中的总子物体 可能用于界面动画
UISuitLua.SuitNameSprite=nil 						-----------套装名字Sprite
UISuitLua.LvParent=nil 								-----------等级父物体
UISuitLua.LabelLv=nil 								-----------等级label
UISuitLua.SuitAttributeTitleSprite=nil 				-----------套装属性主题sprite
UISuitLua.DescribeLabel=nil 						-----------套装描述label
UISuitLua.SuitAttributesParent=nil 					-----------套装属性的父物体
UISuitLua.SuitAttributesGrid=nil 					-----------套装属性的父物体上绑定的UIGrid
UISuitLua.ButtonBuy=nil 							-----------购买按钮
UISuitLua.ButtonBuy1=nil 							-----------直接购买按钮
UISuitLua.ButtonUpgrade=nil 						-----------升级按钮
UISuitLua.ButtonMax=nil 							-----------最高级别

UISuitLua.ConsumptionDescribe=nil 					-----------消耗描述
UISuitLua.ConsumptionDescribeIcon=nil				-----------消耗描述Icon
UISuitLua.ConsumptionDescribeLabel=nil  			-----------消耗描述Label

UISuitLua.ButtonLeft=nil 							-----------向左按钮
UISuitLua.ButtonRight=nil 							-----------向右按钮

UISuitLua.ScrollPanel=nil 							-----------滑动框
UISuitLua.ScrollPanelOffset=nil 					-----------显示区域的纠正（滑动框上的UIPanel脚本）

UISuitLua.SelectIconsParent=nil 					-----------滑动框中选项的父物体
UISuitLua.BtnSelect=nil 							-----------选择按钮
UISuitLua.SelectedBox=nil 							-----------选择光标框
UISuitLua.SelectedTick=nil 							-----------选择光标勾

UISuitLua.SelectLength=15							-----------选择框中选项的个数
UISuitLua.SelectIndex=0 							-----------指针，用于区分选中对象


UISuitLua.targetPositionX=nil						-----------目标位置的X轴，用于矫正滑动框

UISuitLua.UnlockConditions=nil 						-----------解锁条件
UISuitLua.UnlockConditionsLabel=nil 				-----------解锁条件label
UISuitLua.Model3D=nil 								-----------3D模型
UISuitLua.Trigget3D=nil 							-----------3D触发器
UISuitLua.StartTriggetPosition=nil 					-----------3D触发器开始的位置

UISuitLua.SuitTable=nil 		---------------显示的套装数据
UISuitLua.SuitLength=nil 		---------------SuitTable表中数据行数
UISuitLua.IdTable=nil 			---------------套装ID存储
UISuitLua.SuitGOTable=nil 		---------------套装选择按钮存储

UISuitLua.isRotating=false 		---------------是否旋转
UISuitLua.positionIndex=0 		---------------滑动框中显示的第一个图标指针
UISuitLua.rotationNum=0 		---------------3d模型旋转y值


UISuitLua.nowSuitIndexID=0 		---------------当前选中的套装指针ID 当前使用的套装

UISuitLua.nowSuitID=0 			---------------当前选中的套装指针ID 用于升级
UISuitLua.nowSuitLv=0 			---------------当前选中套装的等级


UISuitLua.AttributeTitle=nil 		---------------属性key值表
------------------临时使用--------------------------------------------------

-- UISuitLua.suiteLockState=0 			-------------套装解锁状态

--------------------------------------------------------------------
UISuitLua.PlayerName=nil 		--------------当前3D模型名字

------初始化
function UISuitLua:Init()
	


	self.Model3D=self.gameObject.transform:Find("Camera3D"):Find("Cube")

	local uiPanel = self.gameObject.transform:Find("Camera"):Find("Panel")
	local uiLeft = uiPanel:Find("Left")
	self.RightChild = uiPanel:Find("Right"):Find("RightChild")
	local uiInformationPanel = self.RightChild:Find("InformationPanel")
	self.SuitNameSprite=uiInformationPanel:Find("SuitName"):GetComponent("UISprite")
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
	self.ConsumptionDescribeIcon=self.ConsumptionDescribe:Find("Icon"):GetComponent("UISprite")
	self.ConsumptionDescribeLabel=self.ConsumptionDescribe:Find("Label"):GetComponent("UILabel")

	self.UnlockConditions=uiLeft:Find("UnlockConditions")
	self.UnlockConditionsLabel=self.UnlockConditions:Find("Label"):GetComponent("UILabel")
	self.Trigget3D=uiLeft:Find("3DTrigget")
	self.ButtonLeft=uiLeft:Find("BtnLeft")
	self.ButtonRight=uiLeft:Find("BtnRight")

	self.ScrollPanel = uiLeft:Find("ScrollPanel")
	self.ScrollPanelOffset=self.ScrollPanel:GetComponent("UIPanel")
	self.SelectIconsParent=self.ScrollPanel:Find("SelectIcons")
	self.BtnSelect=self.SelectIconsParent:Find("BtnSelect")
	self.SelectedBox=self.ScrollPanel:Find("SelectedBox")
	self.SelectedTick=self.ScrollPanel:Find("SelectedTick")
 	self.SelectedBox.gameObject:SetActive(false)
 	self.SelectedTick.gameObject:SetActive(false)

 	self.MaterialTxtInstance=TxtFactory:getTable("MaterialTXT")

 	self:DoData() -- 处理数据分出套装种类

 	self:GetServerData()  -- 获取服务器数据
 	self:SetBoxs()  -- 设置滑动框

 	self:ChangeSelect(1,false)
end
---------------------------获取服务器数据--------------------------------------------------------------------------

function UISuitLua:GetServerData()
	
	-- self.SuitTable[102]=102002
	self.SuitTable[101]=101008
	self.SuitTable[102]=102005
	self.SuitTable[103]=103000
	self.SuitTable[104]=104000

	self.SuitTable[101008]=2
	self.SuitTable[102008]=2
	self.SuitTable[103008]=1
	self.SuitTable[104008]=0

end

--------------------------填写label数据---------------------------------------------------------------------
--------------设置解锁条件（传入label显示）
function UISuitLua:SetUnlockConditions(info)
	self.UnlockConditionsLabel.text=info
end

---------------设置套装信息
function UISuitLua:SetSuitInfo(name,lv,info)
	self.SuitNameSprite.spriteName=tostring(name)
	self.LvParent.gameObject:SetActive(lv>0)
	self.LabelLv.text=tostring(lv)
	self.DescribeLabel.text=tostring(info)
end

----------------提取属性数据
function UISuitLua:GetSuitAttributesData(id)
	local tesuitAttributesTable = {}
	for i=1,#self.AttributeTitle do
		local teAttributes = {}
		teAttributes["icon"] = self.AttributeTitle[i]["icon"]
		local key = self.AttributeTitle[i]["key"]
		teAttributes["info"] = self.SuitTxtInstance:GetData(id,key)
		if self:QueryLv(id)==self.MaxLv then
			teAttributes["nextInfo"] =nil
		else
			teAttributes["nextInfo"] = self.SuitTxtInstance:GetData(id+1,key)
		end
		tesuitAttributesTable[i]=teAttributes
	end
	return tesuitAttributesTable
end


----------------设置套装属性
function UISuitLua:SetSuitAttributes(id)
	self:ClearSuitAttributes()
	local  SuitAttributesTable= self:GetSuitAttributesData(id)
	for i=1,#SuitAttributesTable do
		local teAttributes = SuitAttributesTable[i]
		self:SetSuitAttribute(teAttributes["icon"],teAttributes["info"],teAttributes["nextInfo"],tostring(i))
	end
	self.SuitAttributesGrid.repositionNow=true
end

----------------设置一个属性
function UISuitLua:SetSuitAttribute(icon,info,nextInfo,name)
	if info==nil or info=="" then
		return
	end
	local attribute = self:Clone("Attribute",self.SuitAttributesParent,Vector3.zero,name)
	attribute.transform:Find("Label0"):GetComponent("UILabel").text=icon
	attribute.transform:Find("Label1"):GetComponent("UILabel").text=tostring(info)
	if nextInfo==nil then
		attribute.transform:Find("Standard").gameObject:SetActive(false)
		attribute.transform:Find("Label2").gameObject:SetActive(false)
	else
		attribute.transform:Find("Standard").gameObject:SetActive(true)
		attribute.transform:Find("Label2"):GetComponent("UILabel").text=nextInfo
	end
end

----------------清除属性
function UISuitLua:ClearSuitAttributes()
	local childLength=self.SuitAttributesParent.childCount
	for i=1,childLength do
		GameObject.Destroy(self.SuitAttributesParent:GetChild(i-1).gameObject)
	end
end

----------------设置物品消耗
function UISuitLua:SetConsumption(idlv,lv)
	local icon = ""
	local info = ""
	if lv>0 then
		local gold = self.SuitTxtInstance:GetData(idlv,self.TxtTitle.UPGOLD)
		if gold~=nil and gold~="" then
			icon="jinbi-(3)"
			info=tostring(gold)
		else
			local diamonds= self.SuitTxtInstance:GetData(idlv,self.TxtTitle.UPDIAMONDS)
			if diamonds~=nil and diamonds~="" then
				icon="zuanshi-(3)"
				info=tostring(diamonds)
			end
		end
		local material = self.SuitTxtInstance:GetData(idlv,self.TxtTitle.UPMATERIAL)
		if material~=nil and material~="" then
			local  teMaterial= string.split(material,"=")
			-- print(lv.."材料："..tostring(teMaterial[1]))
			local materID=teMaterial[1]
			local nums = teMaterial[2]
			local materialName=self.MaterialTxtInstance:GetData(materID,self.TxtTitle.NAME)
			info=info.." （"..materialName.."X"..nums.."）"
		end
	end
	
	self.ConsumptionDescribeIcon.spriteName=icon
	self.ConsumptionDescribeLabel.text=info
end

---------------设置购买按钮
function UISuitLua:SetBuyButton(name)
	self.ButtonBuy.gameObject:SetActive(false)
	self.ButtonBuy1.gameObject:SetActive(false)
	self.ButtonUpgrade.gameObject:SetActive(false)
	self.ButtonMax.gameObject:SetActive(false)
	if name==0 then
		self.ButtonBuy.gameObject:SetActive(true)
	elseif name==1 then
		self.ButtonBuy1.gameObject:SetActive(true)
	elseif name==2 then
		self.ButtonUpgrade.gameObject:SetActive(true)
	else
		self.ButtonMax.gameObject:SetActive(true)
	end

end

-----------------------------------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------------------------
-------------处理数据分出套装种类
function UISuitLua:DoData()
	
	local SuitTXTLength=table.getn(self.SuitTxtInstance.TxtArray)
	self.IdTable={}
	self.SuitTable={}
	print("SuitTXTLength:"..tostring(SuitTXTLength))
	for i=1,SuitTXTLength do

		local id=self.SuitTxtInstance:GetLine(i)[0]
		-- print(i.."WWWWW"..id)

---------------------------提取ID------------------------------------------------
			local ID=UnityEngine.Mathf.Floor(id/1000) 
			local isNewId = true
			local length=table.getn(self.IdTable)
			for j=1,length do
				if ID==self.IdTable[j] then
					isNewId=false
					break
				end
			end
			if isNewId then
				self.IdTable[length+1]=ID
				ID=ID*1000
				-- print(self.IdTable[length+1].."DFFFDFDF:"..ID)
				self.SuitTable[self.IdTable[length+1]]=ID
				-- self.SuitTable[length+1]=self.SuitTxtInstance:GetLineByID(tostring(ID))
			end
---------------------------------------------------------------------------------			
	end
	self.SuitLength=table.getn(self.IdTable)
	-- print("XCXCXCXCXC:"..table.getn(self.IdTable))
	-- for i=1,table.getn(self.IdTable) do
	-- 	print(i..":SuitTable:"..tostring(self.SuitTable[self.IdTable[i]]))
	-- end
end


------------设置滑动框
function UISuitLua:SetBoxs()
	self.SuitGOTable={}

	print("套装个数："..self.SuitLength)
	for i=1,self.SuitLength do
		print("1BtnSelect"..i)
		local go=self:Clone("BtnSelect",self.SelectIconsParent,Vector3.zero,tostring(i))
				print("2BtnSelect"..i)
		local  bm=go:AddComponent(UIButtonMessage.GetClassType())
				print("3BtnSelect"..i)
		bm.target=self.gameObject
				print("4BtnSelect"..i)
		bm.functionName="OnClick"
		local  bm1=go:AddComponent(UIButtonMessage.GetClassType())
		bm1.target=self.gameObject
		bm1.functionName="OnPress"
		bm1.trigger=1
		local  bm2=go:AddComponent(UIButtonMessage.GetClassType())
		bm2.target=self.gameObject
		bm2.functionName="OnRelease"
		bm2.trigger=2

		
		self.SuitGOTable[i]=go
		self:SetBoxByIndex(i) 		---------设置单个框
	end
	self:ShowOrHidButton()
end

------------设置一个选项框
function UISuitLua:SetBoxByIndex(index)
	local go = self.SuitGOTable[index]
	local superscript= go.gameObject.transform:Find("Superscript")
	local superscriptLabel=superscript:Find("Label"):GetComponent("UILabel")
	local icon = go.gameObject.transform:Find("Icon"):GetComponent("UISprite")
	local lock = go.gameObject.transform:Find("Lock").gameObject

	local id = self.IdTable[index]
	local lvID = self.SuitTable[id]
	local teSuiteLockState= self.SuitTable[id*1000+self.MaxLv]  --------------------------------等待服务器填数据  套装解锁状态

	local lv = self:QueryLv(lvID)
	if lv==0 then 
		superscript.gameObject:SetActive(false)
		lvID=lvID+self.MaxLv
	else
		superscript.gameObject:SetActive(true)
		superscriptLabel.text="Lv"..tostring(lv)
	end
	print("等级:"..tostring(lvID))
	local iconName =self.SuitTxtInstance:GetData(lvID,"ICON_ATLAS") -------获取icon，可能会该--------
	icon.spriteName=tostring(iconName)
	if teSuiteLockState==0 or teSuiteLockState==1 then ---未满足解锁条件
		lock:SetActive(true)
	elseif teSuiteLockState==2 then ----以解锁
		lock:SetActive(false)
	end

end



-----------------克隆物体
function UISuitLua:Clone(targetName,parent,position,name)
	local go = newobject(Util.LoadPrefab("UI/UIComponent/"..targetName))
	go.name=name
    go.transform.parent=parent
    go.transform.localPosition = position
    go.transform.localScale = UnityEngine.Vector3(1,1,1)
    go.transform.rotation=UnityEngine.Vector3(0,0,0)
    return go
end

---------------更改选中
function UISuitLua:ChangeSelect(buttonName,isSelect)
	local teButtonindex = tonumber(buttonName)
	
	print("ChangeSelect:"..buttonName)
	
	local id = self.IdTable[teButtonindex]
	local lvID = self.SuitTable[id]
	local teSuiteLockState= self.SuitTable[id*1000+self.MaxLv]  --------------------------------等待填写  解锁状态
	local lv = self:QueryLv(lvID)

	self:SetConsumption(lvID,lv) 	---------设置消耗信息

	if lv==0 then
		lvID=lvID+self.MaxLv
	end
	self.nowSuitLv=lv

	self:SetSuitAttributes(lvID) 				---------设置属性

	if teSuiteLockState==nil or teSuiteLockState==0 then ---未满足解锁条件
		self.UnlockConditions.gameObject:SetActive(true)
		self.UnlockConditionsLabel.text=""-------------------解锁条件
		self:SetBuyButton(1)
	elseif teSuiteLockState==1 then ---满足解锁条件但未解锁
		self.UnlockConditions.gameObject:SetActive(false)
		self:SetBuyButton(0)
	elseif teSuiteLockState==2 then ----以解锁
		self.UnlockConditions.gameObject:SetActive(false)
		if lv==self.MaxLv then
			self:SetBuyButton(3)
		else
			self:SetBuyButton(2)
		end
		-------------------------光标选中
		if isSelect then
			self.SelectedTick.parent=self.SuitGOTable[teButtonindex].gameObject.transform
			self.SelectedTick.localPosition=Vector3.zero
			self.SelectedTick.gameObject:SetActive(true)
			self.nowSuitIndexID=lvID
		end
	end

	self.SelectedBox.parent=self.SuitGOTable[teButtonindex].gameObject.transform
	self.SelectedBox.localPosition=Vector3.zero
	self.SelectedBox.gameObject:SetActive(true)

	local suitname=self.SuitTxtInstance:GetData(tostring(lvID),self.TxtTitle.NAME)
	local info=self.SuitTxtInstance:GetData(tostring(lvID),self.TxtTitle.DESCRIBE)
	self:SetSuitInfo(suitname,lv,info) 									---------设置套装信息

	self.PlayerName=self.nameTable[teButtonindex]
	if teButtonindex~=self.SelectIndex and self.PlayerName~=nil then
		self:Load3DModel(self.PlayerName) 		---------------------设置3D模型
	end
	self.SelectIndex=teButtonindex
		
end

------------查询等级
function UISuitLua:QueryLv(ID)
	local lv = string.sub(ID,4)
	lv=tonumber(lv)
	return lv
end
--------------------直接购买------------------------------------------------------------
function UISuitLua:BuyDirectly()
	self:BuySuit()
end

--------------------购买功能-----------------------------------------------------
function UISuitLua:BuySuit()
	self.nowSuitLv=self.nowSuitLv+1
	local id=self.IdTable[self.SelectIndex]
	self.SuitTable[id*1000+self.MaxLv]=2
	self.SuitTable[id]=self.SuitTable[id]+1
	self:ChangeSelect(self.SelectIndex,false)
	self:SetBoxByIndex(self.SelectIndex)
end
--------------------升级功能----------------------------------------------------------------
function UISuitLua:Upgrade()
	self.nowSuitLv=self.nowSuitLv+1
	local id=self.IdTable[self.SelectIndex]
	self.SuitTable[id]=self.SuitTable[id]+1
	self:ChangeSelect(self.SelectIndex,false)
	self:SetBoxByIndex(self.SelectIndex)
end


--------------------3D旋转操作----------------------------------------------------------------
-----------加载3d模型
function UISuitLua:Load3DModel(targetName)
	self:Clear3DModel()
	local go = newobject(Util.LoadPrefab(self.url..targetName))
	-- go.name=name
    go.transform.parent=self.Model3D.transform
    go.transform.localPosition = Vector3.zero
    go.transform.localScale = UnityEngine.Vector3(1,1,1)
    go.transform.rotation=UnityEngine.Vector3(0,0,0)
end

-----------清除3D模型
function UISuitLua:Clear3DModel()
	if self.Model3D.childCount==0 then
		return
	end
	GameObject.Destroy(self.Model3D:GetChild(0).gameObject) 
	self.rotationNum=0
	self.Model3D.localRotation=UnityEngine.Quaternion.Euler(0,0,0)
end

-----------启动旋转
function UISuitLua:StartRotating( ... )
	self.isRotating=true
	self.StartTriggetPosition=UnityEngine.Input.mousePosition
end

---------------结束旋转
function UISuitLua:EndRotating( ... )
	self.isRotating=false
end

--------Update中调用
function UISuitLua:Rotating3DModel()
	if self.isRotating then
		local dePositionx=UnityEngine.Input.mousePosition.x-self.StartTriggetPosition.x
		self.rotationNum=self.rotationNum-dePositionx*0.5
		self.Model3D.localRotation=UnityEngine.Quaternion.Euler(0,self.rotationNum,0)
		self.StartTriggetPosition=UnityEngine.Input.mousePosition
	end
end

--------------------滑动操作-----------------------------------------------------------------
--------向左移动按钮
function UISuitLua:MoveLeft()
	self.ScrollPanel.localPosition=self.ScrollPanel.localPosition+Vector3(130,0,0)
	self.ScrollPanelOffset.clipOffset=self.ScrollPanelOffset.clipOffset+UnityEngine.Vector2(-130,0)
	self.positionIndex=self.positionIndex-1
	self:ShowOrHidButton()
end

--------向右移动按钮
function UISuitLua:MoveRight()
	self.ScrollPanel.localPosition=self.ScrollPanel.localPosition+Vector3(-130,0,0)
	self.ScrollPanelOffset.clipOffset=self.ScrollPanelOffset.clipOffset+UnityEngine.Vector2(130,0)
	self.positionIndex=self.positionIndex+1
	self:ShowOrHidButton()
end

---------移动按钮显隐
function UISuitLua:ShowOrHidButton()
	if self.positionIndex<1 then
		self.ButtonLeft.gameObject:SetActive(false)
	else
		self.ButtonLeft.gameObject:SetActive(true)
	end
	if self.SuitLength-self.positionIndex<5 then
		self.ButtonRight.gameObject:SetActive(false)
	else
		self.ButtonRight.gameObject:SetActive(true)
	end
end

----矫正滑动框位置
function UISuitLua:CorrectBoxPosition()
	if self.targetPositionX==nil then 
		return
	end

	if self.ScrollPanel.localPosition.x~=self.targetPositionX then
		self.targetPositionX=self.ScrollPanel.localPosition.x
		return
	end

	for i=0,self.SelectLength do
		local ScrollPanelX = -self.ScrollPanel.localPosition.x
		if ScrollPanelX<i*130+65 and ScrollPanelX>(i-1)*130+65 then
			self.ScrollPanel.localPosition=Vector3(-i*130,0,0) 
			self.ScrollPanelOffset.clipOffset=UnityEngine.Vector2(120+i*130,80)
			self.positionIndex=i
			break
		end
	end
	self.targetPositionX=nil
	self:ShowOrHidButton()
	print("位置")
end

-----------------------按钮功能--------------------------------------------------------------------------------------------

--外部调用接口
function UISuitLua:DoUIButton(buttonType,button)
	--print("按钮名字"..button.name.."::Type::"..buttonType)
	
	if buttonType=="OnClick" then
		self:OnClick(button)
	elseif buttonType=="OnPress" then
		self:OnPress(button)
	elseif buttonType=="OnRelease" then
		self:OnRelease(button)
	elseif buttonType=="OnDoubleClick" then
		-- self:OnDoubleClick(button)
	end
end

--点击事件
function UISuitLua:OnClick(button)
	local flag = self.super.UIPanelControl(self,button)
    if flag == true then
        return
    end
	
	print("OnClick:"..button.name)
	if button.name=="BtnLeft" then
		self:MoveLeft()
	elseif button.name=="BtnRight" then
		self:MoveRight()
	elseif button.name=="BtnBuy" then
		self:BuySuit()
	elseif button.name=="BtnBuy1" then
	--------直接购买
		self:BuyDirectly()
	elseif button.name=="BtnUpgrade" then
		self:Upgrade()
	elseif button.name=="BtnReturn" then
		self.scene:ChangScene(SceneConfig.buildingScene)
	else
		self:ChangeSelect(button.name,true)
		-- self:CorrectBoxPosition()
	end
	    self:PlayButEffectSound()
end

--按下事件
function UISuitLua:OnPress(button)
	print("OnPress:"..button.name)
	if button.name=="Trigget3D" then
	-- if button.name=="Cube" then
		self:StartRotating()
	end
end

--释放事件
function UISuitLua:OnRelease(button)
	print("OnRelease:"..button.name)
	if button.name=="Trigget3D" then
	-- if button.name=="Cube" then
		self:EndRotating()
	else
		self.targetPositionX=0
	end
end


