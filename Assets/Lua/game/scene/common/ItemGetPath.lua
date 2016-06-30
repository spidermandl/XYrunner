--[[
	赵名飞
	道具寻路类
]]
ItemGetPath = class()
ItemGetPath.panel = nil
ItemGetPath.sceneTarget = nil
ItemGetPath.scene = nil 

function ItemGetPath:init(targetScene,itemId)
	self.scene = targetScene
	self.sceneTarget = targetScene.sceneTarget
	self.uiRoot = targetScene.uiRoot
	
	if self.panel == nil then
		self.panel = newobject(Util.LoadPrefab("UI/common/ItemGetPath"))
    	self.panel.gameObject.transform.parent = self.uiRoot.gameObject.transform
    	self.panel.gameObject.transform.localPosition = Vector3(0,0,-400)
    	self.panel.gameObject.transform.localScale = Vector3.one
    	self.panel:SetActive(false)
    	self.scene:boundButtonEvents(self.panel)
	end
	self:SetInfo(itemId)
	self.scene:boundButtonEvents(self.panel)
end
function ItemGetPath:SetInfo(itemId)

	local materialTXT = TxtFactory:getTable(TxtFactory.MaterialTXT)
    local from = materialTXT:GetData(itemId,"COME_FROM")
    if from == "" then
    	return
    end
    self.panel:SetActive(true)
    local ChapterTxt  = TxtFactory:getTable(TxtFactory.ChapterTXT)
    local desc = ChapterTxt:GetData(from,"Name")
    local map = ChapterTxt:GetData(from,TxtFactory.S_CHAPTER_TYPE) % 100
    local info = self.panel.gameObject.transform:FindChild("Anchors/info"):GetComponent("UILabel")
    info.text = "[824614]该道具可以从副本：\n[-][cc5f2f]第"..map.."章节 "..desc.."[-][824614]中获取"
end
--跳转商店
function ItemGetPath:GotoStore( ... )
	self:ShowShop(3)
end
--跳转副本
function ItemGetPath:GotoFuben( ... )
	--print("跳转副本")
	--self.scene:ChangScene(SceneConfig.storyScene)
	self:close()
	if self.scene.buildingUpgrade ~= nil then
		GamePrint("self.scene.buildingUpgrade ~= nil")
		self.scene.buildingUpgrade.gameObject:SetActive(false)
	end
	self.scene:OpenChapterScene()
end
function ItemGetPath:ShowShop(type)
    if self.scene.storeView == nil then
		self.scene.storeView = StoreView.new()
		self.scene.storeView:init(self.scene)
	end
    self.scene.storeView:ShowView()
    self.scene.storeView:InitData(type)
end
function ItemGetPath:close()
	self.panel:SetActive(false)
end

