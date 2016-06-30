--[[
author:sunkai
模式选择
]]

require "game/scene/logic/building/ItemSeletModel"

SelectModeView = class()
SelectModeView.panel = nil
SelectModeView.scene = nil 
SelectModeType ={
	OneMode = 1 ,
	TwoMode = 2,
}
local ItemModeData = {
	[1] = {
		[1] = {icon = "chenjianjvqing",modelSprite = "chenjianjvqingz",},
		[2] = {icon = "chenjianwujin",modelSprite = "chenjianwujinz",},
	},
	[2] = {
		[1] = {icon = "chenjianduobao",modelSprite = "chenjianduobaoz",},
		[2] = {icon = "chenjiantianti",modelSprite = "chenjiantiantiz",},
		[3] = {icon = "chenjiantianti",modelSprite = "chenjianduizhanz",},
	}
}

function SelectModeView:init(targetScene)
	self.scene = targetScene
	self.uiRoot = targetScene.uiRoot
	--if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/SelectModeView"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3.zero
    	self.panel.gameObject.transform.localScale = Vector3.one
	--end
	self.ItemObjList = {}	
	self.Grid = getUIGameObject(self.panel,"UI/Scroll View/Grid")
	self.scene:boundButtonEvents(self.panel)

end

function SelectModeView:SetData(type)
	self.type = type
	self:InitItems()
end

function SelectModeView:InitItems()
	GamePrintTable(ItemModeData)
	local  bbtn = nil
	local itemObj 
	local btnToKey = {
	["chenjianduobao"] = "夺宝奇兵",
	["chenjiantianti"] = "天梯排行",
  }

	for i = 1, #ItemModeData[self.type] do
		local data = ItemModeData[self.type]
		itemObj = newobject(Util.LoadPrefab("UI/ItemSeletModel"))
		self.ItemObjList[i] = itemObj
		local item  = ItemSeletModel.new()
		item:init(self.scene,itemObj,self.Grid)
		item:SetData(data[i],i)
		
		--if  "chenjianduobao" == data[i].icon then
			bbtn = itemObj
			-- 夺宝奇兵,等级开启
			if self.scene.FunctionOpen == nil then
				-- self.scene.FunctionOpen = FunctionOpenView.new()
		  --   	self.scene.FunctionOpen:Init(self.scene,true)
			end
			local kk = btnToKey[data[i].icon]
			if kk ~= nil then
				--self.scene.FunctionOpen:UpdataOtherBtn(kk,bbtn,"Texture")
			end
		--end
	end
	local grid = getUIComponent(self.Grid,"UIGrid")
	grid:Reposition()
	grid.repositionNow = true


end

function SelectModeView:BtnClick(btn)
	local array = string.split(btn.name,"_")
	local index = tonumber(array[2])
	
	if self.type ==  SelectModeType.OneMode then
		if index == 1 then 
			--剧情模式
			if RoleProperty.test == true then
				self.scene:ChangScene(SceneConfig.testScene)
			else
				--self.scene:ChangScene(SceneConfig.storyScene)
				self.scene:OpenChapterScene()
			end
			
		elseif index ==2 then
			--无尽模式
			   TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,2)
    			--self.scene:ChangScene(SceneConfig.endlessScene)
				self.scene:OpenEndlessScene()
		end
	elseif self.type == SelectModeType.TwoMode then
		if index == 1 then 
			--夺宝
			   --self.scene:ChangScene(SceneConfig.snathScene)
			   self.scene:OpenSnatchScene()
		elseif index ==2 then
			--天梯
			self.scene:UIBuilding_LadderBtn()
		elseif index == 3 then
			-- 世界对战
			--print("世界对战")
			self.scene:OpenAsyncPvpView()
		end
	end
	self:CloseWnd()
end


function SelectModeView:CloseWnd()
	destroy(self.panel)
end

function SelectModeView:SetActive(enable)
	
end


