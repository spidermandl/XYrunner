--[[
author:gaofei
问卷调查
]]


SurveyUI = class()


SurveyUI.scene = nil -- 依附的场景对象
SurveyUI.gameObject = nil -- UI对象xuanz

SurveyUI.items = {} -- 存放所有的问题

SurveyUI.filltopic = {} -- 填空题答案
SurveyUI.choosetopic = {} -- 选择题答案


-- 初始化UI
function SurveyUI:Init(targetscene)
	
	self.scene = targetscene
    -- 初始化UI
    self.gameObject = self.scene:LoadUI("Survey/SurveyUI") 
	
	-- 初始化preb
	local obj = self.gameObject.transform:Find("Anchors/Scroll View/Table")
	
	-- 初始化问题
	self.surey_config_txt = TxtFactory:getTable(TxtFactory.SurveyConfigTXT)
	for i = 1 , self.surey_config_txt:GetLineNum() do
		if tonumber(self.surey_config_txt:GetData(i,"QUE_TYPE")) == 1 then
			-- 选择题
			self.items[i] = newobject(Util.LoadPrefab("UI/Survey/ChooseTopic"))
			
			local chooseParent = self.items[i].transform:Find("Grid")
			local chooseGrid = chooseParent.transform:GetComponent("UIGrid")
			local chooseResulr = {}
			chooseResulr[1] = self.surey_config_txt:GetData(i,"AN_DSC_A")
			chooseResulr[2] = self.surey_config_txt:GetData(i,"AN_DSC_B")
			chooseResulr[3] = self.surey_config_txt:GetData(i,"AN_DSC_C")
			chooseResulr[4] = self.surey_config_txt:GetData(i,"AN_DSC_D")
			chooseResulr[5] = self.surey_config_txt:GetData(i,"AN_DSC_E")
			chooseResulr[6] = self.surey_config_txt:GetData(i,"AN_DSC_F")
			
			for j = 1 , #chooseResulr do
				if chooseResulr[j] == "" then
					break
				end
				local chooseObj =  newobject(Util.LoadPrefab("UI/Survey/SurveyToggle"))
				chooseObj.transform:Find("Label"):GetComponent("UILabel").text = chooseResulr[j]
				chooseObj.transform:GetComponent("UIToggle").Group = i
				chooseObj.name = "Toggle"..j
				chooseObj.transform.parent = chooseParent.transform
				chooseObj.transform.localPosition = Vector3.zero
    			chooseObj.transform.localScale = Vector3.one
			end
			
			chooseGrid:Reposition()
			chooseGrid.repositionNow = true
		else
			-- 填空题
			self.items[i] = newobject(Util.LoadPrefab("UI/Survey/FillTopic"))
		end
		-- 设置题目
		local titleObj = self.items[i].transform:Find("Title")
		titleObj:GetComponent("UILabel").text = i.."."..self.surey_config_txt:GetData(i,"QUE_DSC")
		self.items[i].name = tostring(i)
		self.items[i].transform.parent = obj.transform
		self.items[i].transform.localPosition = Vector3.zero
    	self.items[i].transform.localScale = Vector3.one
	end
	-- 添加提交按钮
	local surveySnedBtn = newobject(Util.LoadPrefab("UI/Survey/SurveySendBtn"))
	surveySnedBtn.transform.parent = obj.transform
	surveySnedBtn.transform.localPosition = Vector3.zero
   surveySnedBtn.transform.localScale = Vector3.one
	
	local itemTable = obj:GetComponent("UITable")
	itemTable:Reposition()
	itemTable.repositionNow = true
   	self.scene:boundButtonEvents(self.gameObject)
 	self:HiddenSurveyView()
end

--激活问卷调查界面
function SurveyUI:ShowSurveyView()
	self.gameObject:SetActive(true)
end

-- 隐藏问卷调查界面
function SurveyUI:HiddenSurveyView()
	self.gameObject:SetActive(false)
end

-- 设置选择的答案
function SurveyUI:SetTopicValue()
	local choosetopicIndex = 1
	local filltopicIndex = 1
	for i= 1,#self.items do
		local _input =  self.items[i].transform:Find("Input")
		if _input ~= nil then
			-- 非必选题
			self.choosetopic[choosetopicIndex] = _input:GetComponent("UIInput").value
			choosetopicIndex = choosetopicIndex + 1
		else
			self.filltopic[filltopicIndex] = self:GetAnswerValue(i)
			filltopicIndex = filltopicIndex + 1
		end
	end
	
end

function SurveyUI:GetAnswerValue(index)

	for i = 1 , 6 do
		local _toggle = self.items[index].transform:Find("Grid/Toggle"..i)
		if _toggle == nil then
			return 0
		end
		local _uiToggle = _toggle:GetComponent("UIToggle")
		if _uiToggle.value == true then
			return index * 10 + i
		end
	end
	return 0
	
end

-- 判断是否有选择题没有填
function SurveyUI:IsCanSubmit()

	for i = 1 , #self.filltopic do
		if tonumber(self.filltopic[i]) == 0 then
			return false
		end
	end
	return true
end

-- 发送消息
function SurveyUI:SurveySendOnClick()
	self:SetTopicValue()
	if not(self:IsCanSubmit()) then
		local word = "您还有题目没有做完"
		self.scene:promptWordShow(word)
		return
	end
	self:SendSurveyMessage()
end

--获取玩家装备信息 (发送)
function SurveyUI:SendSurveyMessage()
    local json = require "cjson"
	local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
      	local msg = {result=self.filltopic,result_txt=self.choosetopic}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.QuestAnswerRequest()
        for i = 1 , #self.filltopic do
		      --printf("petid ==="..curDefendPets[i])
             message.result:append(self.filltopic[i])
	    end
		 for i = 1 , #self.choosetopic do
		      --printf("petid ==="..curDefendPets[i])
             message.result_txt:append(self.choosetopic[i])
	    end
        strr = ZZBase64.encode(message:SerializeToString())
    end
   -- local msg = {result=self.filltopic,result_txt=self.choosetopic}
  --  local strr = json.encode(msg)
    local param = {
              code = MsgCode.QuestAnswerRequest,
              data = strr, -- strr
             }
    if  self.userTable == nil then
		 self.userTable = TxtFactory:getTable("UserTXT")
	end
    MsgFactory:createMsg(MsgCode.QuestAnswerResponse,self)
    NetManager:SendPost(NetConfig.SURVEY,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))
    -- print("获取玩家装备信息 发送")
end

function SurveyUI:SurveyMessageListen(info)
	local json = require "cjson"
  	local tab = json.decode(info.data)
	printf('result=='..tab.result)
	if tonumber(tab.result) == 1 then
		-- 成功
		--printf('success')
		local word = "问卷调查成功，奖励已经发放至您的邮箱，请前去领取！"
		self.scene:promptWordShow(word)
		self:HiddenSurveyView()
		local userInfo = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
		userInfo[TxtFactory.USER_STATUS] = 1
		self.scene:SetSurveyBtn()
		--邮件刷新
		self.scene:GetMailList()
	else
		-- 失败
		local word = "问卷调查调查失败"
		self.scene:promptWordShow(word)
		
	end
end

-- 关闭界面
function SurveyUI:SurverUICloseBtnOnClick()
	self:HiddenSurveyView()
end