--[[
   author:huqiuxiang
   用于对话逻辑 UIDialogue
]]

UIDialogue = class ()
UIDialogue.panel = nil
UIDialogue.infoTab = nil -- 存放对话内容
UIDialogue.progress = nil
UIDialogue.labelText = nil 
UIDialogue.item = nil 
UIDialogue.GudieDialogTXT = nil 
UIDialogue.UserTxt = nil 
UIDialogue.characterIcon = nil 
UIDialogue.petTable = nil 

UIDialogue.right = nil 
UIDialogue.left = nil 
UIDialogue.center = nil 
UIDialogue.centerText = nil
UIDialogue.rightIcon = nil
UIDialogue.rightText = nil
UIDialogue.rightName = nil 

UIDialogue.leftIcon = nil
UIDialogue.leftText = nil
UIDialogue.leftName = nil 

-- 创建ui
function UIDialogue:init(uiParent,textTab,item)
	self.UserTxt = TxtFactory:getTable(TxtFactory.UserTXT)
	self.petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	self.GudieDialogTXT = TxtFactory:getTable(TxtFactory.GudieDialogTXT) 
	self.panel = newobject(Util.LoadPrefab("UI/battle/DialogueUI"))
	self.panel.gameObject.transform.parent = uiParent.gameObject.transform
	self.panel.gameObject.transform.localScale = Vector3.one
	self.infoTab = textTab
	self.item = item
	self.progress = 1

	self.right = self.panel.gameObject.transform:FindChild("UI/right")
	self.left = self.panel.gameObject.transform:FindChild("UI/left")
	self.center = self.panel.gameObject.transform:FindChild("UI/center")
	self.centerText = self.panel.gameObject.transform:FindChild("UI/center/DialogueUI_textBackground/Label"):GetComponent("UILabel")
	self.leftText = self.panel.gameObject.transform:FindChild("UI/left/DialogueUI_textBackground/Label"):GetComponent("UILabel")
	self.rightText = self.panel.gameObject.transform:FindChild("UI/right/DialogueUI_textBackground/Label"):GetComponent("UILabel")
	self.leftIcon = self.panel.gameObject.transform:FindChild("UI/left/DialogueUI_character/icon"):GetComponent("UITexture")
	self.rightIcon = self.panel.gameObject.transform:FindChild("UI/right/DialogueUI_character/icon"):GetComponent("UITexture")
	self.leftName = self.panel.gameObject.transform:FindChild("UI/left/DialogueUI_name/Label"):GetComponent("UILabel")
	self.rightName = self.panel.gameObject.transform:FindChild("UI/right/DialogueUI_name/Label"):GetComponent("UILabel")
	-- local t = find("DialogueUI_textBackground")
	-- self.labelText = t.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
	-- self.labelText.text = self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"CONTENT")
	-- local c = find("DialogueUI_character")
	-- self.characterIcon = c.gameObject.transform:FindChild("icon")
	self:characterShow()

end

-- 按钮点击事件
function UIDialogue:btnOnClick()
	self.progress = self.progress + 1


    -- for i = 1, #self.infoTab do
    --     tab[i] = self.GudieDialogTXT:GetData(tonumber(self.infoTab[i]),"CONTENT")
    -- end

	if self.infoTab ~= nil then
		if self.progress > #self.infoTab then
			destroy(self.panel)
			self.item.dialogueIsOver = true
			self.item:dialogIsOver()
			return
		end
	end
	-- print(self.infoTab[self.progress])
	-- 文字提示
	-- self.labelText.text = self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"CONTENT")
	self:characterShow()
	-- self.labelText.text = self.infoTab[self.progress]
end

-- 人物显示
function UIDialogue:characterShow()
	local place = self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"PLACE")
	if place == "1" then
		-- self.characterIcon.gameObject.transform.localPosition = Vector3(400,-100,0)
		self:showRight()
	elseif place == "0" then
		self:showLeft()
		-- self.characterIcon.gameObject.transform.localPosition = Vector3(-400,-100,0)
	elseif place == "-1" then	
		-- self.characterIcon.gameObject:SetActive(false)
		self:shwoCenter()
	end
end

-- 显示左边
function UIDialogue:showLeft()
	self.left.gameObject:SetActive(true)
	self.right.gameObject:SetActive(false)
	self.center.gameObject:SetActive(false)
	-- self.leftText.text = self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"CONTENT")
	self:setIcon(self.leftText,self.leftIcon,self.leftName)
end

-- 显示右边
function UIDialogue:showRight()
	self.right.gameObject:SetActive(true)
	self.left.gameObject:SetActive(false)
	self.center.gameObject:SetActive(false)
	-- self.rightText.text = self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"CONTENT")
	self:setIcon(self.rightText,self.rightIcon,self.rightName)
end

function UIDialogue:shwoCenter()
	self.right.gameObject:SetActive(false)
	self.left.gameObject:SetActive(false)
	self.center.gameObject:SetActive(true)
	self.centerText.text = self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"CONTENT")
end

-- 人物显示名字
function UIDialogue:setIcon(dText,dIcon,dName)
	local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
	--print ("--------------function UIDialogue:setIcon(dText,dIcon,dName) "..tostring(self.infoTab[self.progress]))
	dText.text = self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"CONTENT")
	local id = tonumber(self.GudieDialogTXT:GetData(tonumber(self.infoTab[self.progress]),"CHAR_ID"))
	-- print("人物id"..id)
	if id == 999 then
		local sex = 0
		sex = UserInfo[TxtFactory.USER_SEX]
		-- sex = self.UserTxt:getValue('sex')
		-- print("性别"..sex)
		if sex == 0 then
			--dIcon.spriteName = "Player_male_talk"
			dIcon.mainTexture = Util.LoadPrefabByPath("BigPic/","Player_male_talk")
		else
			--dIcon.spriteName = "Player_girl_talk"
			dIcon.mainTexture = Util.LoadPrefabByPath("BigPic/","Player_girl_talk")
		end
		dIcon:MakePixelPerfect()
		dName.text = UserInfo[TxtFactory.USER_NAME]
		return
	end
	dIcon.mainTexture = Util.LoadPrefabByPath("BigPic/",self.petTable:GetData(id,"PET_TALK"))
	dIcon:MakePixelPerfect()
	dName.text = self.petTable:GetData(id,"NAME")
end