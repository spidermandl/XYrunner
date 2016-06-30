--[[
功能开启
作者：吴高文
]]

FunctionOpenView = class()

FunctionOpenView.scene = nil -- 依附的场景对象
--FunctionOpenView.BuildingBtnAPanel = nil -- 功能按钮

FunctionOpenView.FunctionOpenTxt = nil -- 功能开启表
FunctionOpenView.JieSuoTiaoJianTXT = nil --解锁条件
FunctionOpenView.OpenShowHelp = nil
FunctionOpenView.FunctionOpenInfo = nil --开启纪录

local  BtnsName = {
	["任务"] = "Building_Task",
	["装备"] = "BtnRes_Building-UI 4",
	["坐骑"] = "BtnRes_Building-UI 3",
	["问卷调查"] = "Building_Survey",
}

local BuildData = --城建的详细类型
{
	--[[[11001] = 1, --娃娃机枢纽
	[11002] = 2, --游戏币小屋
	[11003] = 3, --仓库
	[11004] = 4, --萌宠驿站
	[11005] = 5, --萌宠小屋
	[11006] = 6, --萌宠炼金所
	[11007] = 7, --礼品小卖部
	[11008] = 8, --泡泡小酒吧
	[11009] = 9, --萌宠公交站
	[11013] = 13,--萌宠装备屋
	[11010] = 10,--萌萌服装店]]
	["坐骑"]     = {9,"11009001"},--萌宠公交站
	["装备"]     = {13,"11013001"},--萌宠装备屋
	["天梯排行"]  = {11,"11011001"},--天梯竞技场
	["夺宝奇兵"]  = {12,"11012001"},--夺宝奇兵营地
}

FunctionOpenView.BtnList = nil -- 功能对应的按钮

FunctionOpenView.FinishFun = nil
local CurLevel = nil --开始等级
-- 初始化UI
function FunctionOpenView:Init(targetscene,isNotUpdata)
	self.scene = targetscene
	--self.BuildingBtnAPanel = parent
	self.FunctionOpenTxt = TxtFactory:getTable(TxtFactory.FunctionOpenTXT)
	self.JieSuoTiaoJianTXT = TxtFactory:getTable(TxtFactory.JieSuoTiaoJianTXT)
	if isNotUpdata == true then
		return
	end

	--  在主城时才做刷新
	if targetscene.isBuildScene ~= nil and targetscene.isBuildScene == true then

		local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		self.FunctionOpenInfo = TxtFactory:getMemDataCacheTable(TxtFactory.FunctionOpenInfo)

		if  self.FunctionOpenInfo == nil then
			self.FunctionOpenInfo = {
				["BigFun"] = {},
				[TxtFactory.SmallFun] = {},
				StarLevel = UserInfo[TxtFactory.USER_LEVEL], -- 开始等级
			}
			CurLevel = self.FunctionOpenInfo.StarLevel

			TxtFactory:setMemDataCacheTable(TxtFactory.FunctionOpenInfo,self.FunctionOpenInfo)
			self:InitJieSuoFunction()
		end

		if CurLevel == nil then
	    	CurLevel = UserInfo[TxtFactory.USER_LEVEL]
	    	--GameWarnPrint("初始化等级 ！！！！！＝"..CurLevel)
		else
			--GameWarnPrint("刷新等级 ！！！！！＝"..CurLevel)
		end



		self:Updata()
		self:UpdataSuoFunction()
	end

end

function FunctionOpenView:GetBtn(name)
	if BtnsName[name] == nil then
		return nil
	end
	return find(BtnsName[name])
end

function FunctionOpenView:GetBtn1(name)
	if BuildData[name] == nil then
		return nil,nil,nil
	end
	local nn = BuildData[name][2]
	--GamePrint("BuildData ="..nn.."|| allBuilds ="..find("allBuilds").name)
	return find("allBuilds").transform:FindChild(nn),
	find("buildNameParent").transform:FindChild(nn)
end
function FunctionOpenView:Getlable1(parent)

	local go = parent.transform:FindChild("OpenTips1(Clone)")
	if go == nil then
		local obj = newobject(Util.LoadPrefab("UI/OpenTips1"))--self.scene:LoadUI("OpenTips1") --GameObject.New()
		--obj.layer = parent.layer
		go = obj.transform;
		go.parent = parent.transform
		go.localScale = Vector3.one
		go.localPosition = Vector3(0,0,0)
		go.localRotation = Quaternion.identity
	end

 	local  tarObj = parent:GetComponent("UIButton").tweenTarget;
	local  tarsp = tarObj:GetComponent("UISprite")
	local bg = go:FindChild("Bg")
	local bgsp = bg:GetComponent("UISprite")
	bg.position = tarObj.transform.position;
	bgsp.atlas = tarsp.atlas
	bgsp.spriteName = tarsp.spriteName

	return go:FindChild("Label"):GetComponent("UILabel")
end
function FunctionOpenView:Getlable2(parent)
	local go = parent.transform:FindChild("OpenTips2(Clone)")
	if go == nil then
		local obj = self.scene:LoadUI("OpenTips2") --GameObject.New()
		--obj.layer = parent.layer
		go = obj.transform;
		go.parent = parent.transform
		go.localScale = Vector3.one
		go.localPosition = Vector3(0,0,0)
		go.localRotation = Quaternion.identity
	end

	return go:FindChild("Label"):GetComponent("UILabel"),
		   go:FindChild("Name"):GetComponent("UILabel")
end
FunctionOpenView.showList = nil
function FunctionOpenView:GetShowList()
	return self.showList
end

function FunctionOpenView:Updata()

	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local newlv = UserInfo[TxtFactory.USER_LEVEL]

    self.showList = {}
    --初始化table item
    local  TxtLines = self.FunctionOpenTxt.TxtLines
    local  TxtTitle = self.FunctionOpenTxt.TxtTitle
    local  id_name,id_lv ,id_diag = TxtTitle.MODULE -1,TxtTitle.LV -1,TxtTitle.DIALOG -1

	for i=1,#TxtLines do
		local ddata = TxtLines[i]
		local name = ddata[id_name]
		local llv = tonumber(ddata[id_lv])
		local dia = ddata[id_diag]

		if llv <= CurLevel then
		    --已开放
		    self:OpenBtn(name)
		elseif llv > CurLevel and llv <= newlv then
			--新开放
			table.insert(self.showList,{name,dia,self:NewBtn(name)})
		elseif llv > newlv then
			--未开放
			self:LockBtn(name,llv)
		end
	end

	CurLevel = newlv
	if self.showList == nil or #self.showList < 1 then
		if self.OpenShowHelp ~= nil then
			self.OpenShowHelp.gameObject:SetActive(false)
		end
		return
	end
	--GameWarnPrint("#showList ="..#self.showList)
	local  UIRoot = find("UI Root")
	self.OpenShowHelp = UIRoot.transform:FindChild("OpenShowHelp(Clone)")
	if self.OpenShowHelp == nil then
		local obj = self.scene:LoadUI("OpenShowHelp") --GameObject.New()
		--obj.name = "OpenShowHelp"
		obj.layer = UIRoot.layer
		self.OpenShowHelp  = obj.transform;
		self.OpenShowHelp.parent = UIRoot.transform
		self.OpenShowHelp.localScale = Vector3.one
		self.OpenShowHelp.localPosition = Vector3.zero
		self.OpenShowHelp.localRotation = Quaternion.identity
	end

	
	self.scene:boundButtonEvents(self.OpenShowHelp.gameObject)
	self:ShowHelp(self.showList[1][1])
end

function FunctionOpenView:DestryLock(parent,child)
	-- body
	local go = parent.transform:FindChild(child)
	if go ~= nil then
		destroy(go.gameObject)
	end

end
function  FunctionOpenView:LockBtn(name,llv)
	local btn = self:GetBtn(name)
	if btn ~= nil then
		self:Getlable1(btn).text = llv.."级解锁"
		btn:GetComponent('BoxCollider').enabled = false
		--self:Testtt(btn)
	end

	local btn1,btn2 = self:GetBtn1(name)
	if btn1 ~= nil and btn2 ~= nil then
		btn1 ,btn2 = btn1.gameObject,btn2.gameObject
		btn2.transform:FindChild("name").gameObject:SetActive(false)
		btn2.transform:FindChild("p_bg").gameObject:SetActive(false)
		local  lab1 ,lab2  = self:Getlable2(btn2)
		lab1.text = llv.."级解锁" 
		lab2.text = name
		btn1:GetComponent('BoxCollider').enabled = false
	end
end

function FunctionOpenView:Testtt(btn)
	-- body
	btn:GetComponent('BoxCollider').enabled = true

	local uie = btn:GetComponent('UIEventListener')
	if uie == nil then
		uie = btn:AddComponent(UIEventListener.GetClassType())
	end

	local  mycall = function()
		-- body
		error("dddddddddddd")
	end
	uie.onClick = mycall;

end
function  FunctionOpenView:NewBtn(name)
	local ret = {}
	local btn = self:GetBtn(name)
	if btn ~= nil then
		btn:GetComponent('BoxCollider').enabled = false
		self:DestryLock(btn,"OpenTips1(Clone)")
		table.insert(ret,btn)
		--GameWarnPrint("NewBtn.name ="..btn.name)
		--btn:GetComponent('UIButton').defaultColor = Color.New(1,0,0,1)--Color.new()
		--btn:GetComponent('UIButton'):SetState(0,false)
	end
	local btn1,btn2 = self:GetBtn1(name)
	if btn1 ~= nil and btn2 ~= nil then
		btn1 ,btn2 = btn1.gameObject,btn2.gameObject
		btn2.transform:FindChild("name").gameObject:SetActive(true)
		btn2.transform:FindChild("p_bg").gameObject:SetActive(true)
		self:DestryLock(btn2,"OpenTips2(Clone)")
		btn1:GetComponent('BoxCollider').enabled = false
		table.insert(ret,btn1)
	end
	return ret
end

function  FunctionOpenView:OpenBtn(name)
	local btn = self:GetBtn(name)
	if btn ~= nil then
		btn:GetComponent('BoxCollider').enabled = true
		self:DestryLock(btn,"OpenTips1(Clone)")
		--GameWarnPrint("OpenBtn.name ="..btn.name)
		btn:GetComponent('UIButton').defaultColor = Color.New(1,1,1,1)--Color.new()
		btn:GetComponent('UIButton'):SetState(0,false)
	end
	local btn1,btn2 = self:GetBtn1(name)
	if btn1 ~= nil and btn2 ~= nil then
		btn1 ,btn2 = btn1.gameObject,btn2.gameObject
		btn2.transform:FindChild("name").gameObject:SetActive(true)
		btn2.transform:FindChild("p_bg").gameObject:SetActive(true)
		self:DestryLock(btn2,"OpenTips2(Clone)")
		btn1:GetComponent('BoxCollider').enabled = true
	end
end

function FunctionOpenView:ShowHelp(name)
	self.OpenShowHelp:FindChild('Main/Label'):GetComponent("UILabel").text = name

	local btnOk  = self.OpenShowHelp:FindChild("Main/Open_ButtonOk")
    -- 添加按钮监听脚本
	local  bm = btnOk.gameObject:AddComponent(UIButtonMessage.GetClassType())
	bm.target = self.scene.sceneTarget
	bm.functionName = "OnClick"

	local btnGoto  = self.OpenShowHelp:FindChild("Main/Open_ButtonGoTo")
    -- 添加按钮监听脚本
	bm = btnGoto.gameObject:AddComponent(UIButtonMessage.GetClassType())
	bm.target = self.scene.sceneTarget
	bm.functionName = "OnClick"

	-- 图片
	local uisprite  = self.OpenShowHelp:FindChild('Main/Sprite'):GetComponent("UISprite")

	if BuildData[name] ~= nil then
		uisprite.atlas = Util.PreLoadAtlas("UI/Picture/GiftIcon")
		local build_txt = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表
	    uisprite.spriteName = build_txt:GetData(BuildData[name][2],"BUILDING_ICON")
	else
		local  ubi = self:GetBtn(name):GetComponent("UIButton")
		local spObj = ubi.tweenTarget
		local tarsp = spObj:GetComponent("UISprite")
		uisprite.atlas  = tarsp.atlas;
		uisprite.spriteName  = tarsp.spriteName;
	end

	--uievent.onClick = DelegateFactory.Action_GameObject(ffun)
end

function FunctionOpenView:Close()

	if self.OpenShowHelp ~= nil then
		self.OpenShowHelp.gameObject:SetActive(false)
	end
end

function FunctionOpenView:GetGotoInfo(name)
	local btn = self.GetBtn(name)
	local ty = BuildData[name] ~= nil and BuildData[name][1] or nil
	return btn,ty
end

function FunctionOpenView:GetlableTexture(parent,texName)

	local go = parent.transform:FindChild("OpenTips1(Clone)")
	if go == nil then
		local obj = self.scene:LoadUI("OpenTips1") --GameObject.New()
		--obj.layer = parent.layer
		go = obj.transform;
		go.parent = parent.transform
		go.localScale = Vector3.one
		go.localPosition = Vector3(0,0,0)
		go.localRotation = Quaternion.identity
	end
	go:FindChild("Bg").gameObject:SetActive(false)
	local Texture = parent.transform:FindChild(texName)
	local TextureNew = newobject(Texture.gameObject).transform
	TextureNew.parent = go
	TextureNew.localScale = Vector3.one
	TextureNew.position = Texture.position

	--local txc = getUIComponent(TextureNew..gameObject,"Texture","UITexture")
	local txc = TextureNew:GetComponent('UITexture')
	txc.color = Color.New(0.5,0.5,0.5,1)
	return go:FindChild("Label"):GetComponent("UILabel")
end
function FunctionOpenView:UpdataOtherBtn(nameID,btn,texName)
    local  ddata = self.FunctionOpenTxt:GetLineByName(nameID)
    if ddata == nil then
    	return
    end
    local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    local newlv = UserInfo[TxtFactory.USER_LEVEL]
    local  TxtTitle = self.FunctionOpenTxt.TxtTitle
    local  id_name,id_lv ,id_diag = TxtTitle.MODULE -1,TxtTitle.LV -1,TxtTitle.DIALOG -1
	--local name = ddata[id_name]
	local llv = tonumber(ddata[id_lv])
	--GameWarnPrint("btn =="..btn.name.."||layer ="..btn.layer)
	if newlv < llv then
		if texName ~= nil then
			self:GetlableTexture(btn,texName).text = llv.."级解锁"
		else
			self:Getlable1(btn).text = llv.."级解锁"
		end
		btn:GetComponent('BoxCollider').enabled = false
	else
		local uibtn = btn:GetComponent('UIButton')
		if uibtn ~= nil then
			uibtn.defaultColor = Color.white;
			uibtn:SetState(0,false) --Color.New(1,1,1,1)--Color.new() tarsp.color = Color.white
		end
		btn:GetComponent('BoxCollider').enabled = true
		self:DestryLock(btn,"OpenTips1(Clone)")
	end

end
function FunctionOpenView:InitJieSuoFunction( ... )
	--GamePrintTable("InitJieSuoFunction InitJieSuoFunction")
	-- body
	local TxtLines = self.JieSuoTiaoJianTXT.TxtLines
	local TxtTitle = self.JieSuoTiaoJianTXT.TxtTitle
	local tTab = {}
	for i = 1,#TxtLines do
		local llineData = TxtLines[i]
		local iid = llineData[TxtTitle.ID -1]
		--GamePrintTable(tostring(iid))
		if not self:UpdataFunctionOpen(tonumber(iid),llineData) then
			table.insert(tTab,iid)
		end
	end
	self.FunctionOpenInfo[TxtFactory.SmallFun] = tTab
	GamePrintTable("InitJieSuoFunction InitJieSuoFunction")
	-- body
	local ss =  TxtFactory:getMemDataCacheTable(TxtFactory.FunctionOpenInfo)

	GamePrintTable(ss)
end

function FunctionOpenView:UpdataSuoFunction( ... )
	-- body
	local curSmallFun = self.FunctionOpenInfo[TxtFactory.SmallFun]
	local newTable = {}
	for i=1,#curSmallFun do
		--print(i)
		local iid = curSmallFun[i]
		local r1,r2 = self:UpdataFunctionOpen(tonumber(iid),llineData)
		if  r1 == true then
			-- 提示玩家功能开启
			self.scene:promptWordShow(r2)
		else
			table.insert(newTable,iid)
		end 
	end
end
function FunctionOpenView:CheckIsTiaoJian(...)
	local args = {...}
	local tty = args[1][1]
	GamePrintTable(args)
	if tonumber(tty) == 1 then
		-- 检查玩家等级
		local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    	local newlv = UserInfo[TxtFactory.USER_LEVEL]
    	return newlv >= tonumber(args[1][2])
	end
	return false
end

function FunctionOpenView:UpdataFunctionOpen(id,llineData)

	if llineData == nil then
		llineData = self.JieSuoTiaoJianTXT:GetLineByID(id)
	end
	if llineData == nil then
		return
	end

	local TxtTitle = self.JieSuoTiaoJianTXT.TxtTitle
	local idAnd ,idOr = TxtTitle.AND_EVENT_LINE - 1,TxtTitle.OR_EVENT_LINE -1
	local  andList,orList = llineData[idAnd],llineData[idOr]
	-- and条件
	local rret = true
	if andList ~= nil and andList ~= "" then
		andList = string.gsub(andList,'"',"")
		andList = lua_string_split(andList,"|")
		for i = 1, #andList do
			local vv = andList[i]
			vv = lua_string_split(vv,"=")
			if #vv < 2 then
				GameWarnPrint("and条件配置错误。id。"..id)
				rret = false
				break
			end
			if not self:CheckIsTiaoJian(vv) then
				rret = false
				break
			end	
		end
		GamePrintTable("and条件 ="..tostring(rret))
		if rret == false then
			return false,llineData[TxtTitle.EVENT_NO_DESC_TIPS -1]
		end
	end

	GamePrintTable("and条件 ="..tostring(rret))
	if orList ~= nil and orList ~= "" then
		rret = false
		orList = string.gsub(orList,'"',"")
		orList = lua_string_split(orList,"|")

		for i = 1,#orList do
			local vv = orList[i]
			vv = lua_string_split(vv,"=")
			if #vv < 2 then
				GameWarnPrint("or条件配置错误。id。"..id)
				rret = false
				break
			end
			if  self:CheckIsTiaoJian(vv) then
				rret = true
				break
			end	

		end
	end
	GamePrintTable("or条件 ="..tostring(rret))
	if rret == false then
		return false,llineData[TxtTitle.EVENT_NO_DESC_TIPS -1]
	else
		return true,llineData[TxtTitle.EVENT_DESC_TIPS -1]
	end
end






