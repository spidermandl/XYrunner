--[[
author:huqiuxiang
公告系统
]]


BroadCastView = class()

BroadCastView.scene = nil -- 依附的场景对象
BroadCastView.panel = nil -- 面板
BroadCastView.management = nil -- 数据管理器
BroadCastView.gameObject = nil --fjc

-- 初始化UI
function BroadCastView:Init(targetscene)
	print("BroadCastView:Init")
	self.scene = targetscene
	self.gameObject = self.scene:LoadUI("BroadCastWeb")
	local trans = self.gameObject.transform:GetChild(0)
	sprite = trans:GetChild(3)--:GetComponent("UIWidget")
	piont = trans:GetChild(3):GetChild(0)
	--local  trans1 = trans:GetChild()
	--local trans = self.gameObject.transform:FindChild
	--print("fjc---tans  "..tostring(sprite.spriteName))
	-- print("fjc---tans1  "..tostring(sprite.transform.lossyScale.x))
	--self.camera = self.scene.camera:GetComponent(UnityEngine.Camera.GetClassType())
	-- x=(0-sprite.transform.lossyScale.x)*2
	-- y=(0+sprite.transform.lossyScale.y)*2
	w=430
	h=220
	x=piont.transform.position.x
	y=piont.transform.position.y
	
	-- local  trans1 = self.scene.cameraView:WorldToScreenPoint(UnityEngine.Vector3(self.gameObject.transform.x,self.gameObject.transform.y,-10))
	screenPoint = self.scene.UICameraView:WorldToScreenPoint(UnityEngine.Vector3(x,y,0))
	print("fjc---screenPoint---   "..tostring(screenPoint).."   "..screenPoint.x)
	--local  trans1 = UnityEngine.Camera.main.WorldToScreenPoint(x,y,-10)
	--print("fjc---tans1  "..tostring(trans1)..tostring(trans1.position.x))
     BundleTools.CreateWebView(screenPoint.x,screenPoint.y,w,h,"http://www.baidu.com")
	-- BundleTools.CreateWebView(10,10,400,400,"http://www.baidu.com")
	-- self.management = TaskManagement.new()
	-- self.management:Awake(self)
	-- self.management:SendSystemTask()

end

-- 创建面板
function BroadCastView:creatPanel()
	self.panel = self.scene:LoadUI("UI/BroadCastWeb")
	self.panel.gameObject.transform.localPosition = Vector3(0,0,0)
    self.panel.gameObject.transform.localScale = Vector3.one

    -- local trans = self.panel.transform:Find("Wnd")
    -- self.itemsScrollView = trans:Find("ScrollView"):GetComponent("UIScrollView")
    -- self.itemsGrid = trans:Find("ScrollView/Grid")

    -- self:listUpdate()
end
 

-- 更新list
function BroadCastView:listUpdate()
	local TaskInfo = TxtFactory:getMemDataCacheTable(TxtFactory.TaskInfo)
	if TaskInfo.bin_tasks == nil or TaskInfo == nil then
		return
	end

	for i = 1, #TaskInfo.bin_tasks do 	
		local icon = self:creatItem(TaskInfo.bin_tasks[i])
	end

	local grid = self.itemsGrid.gameObject.transform:GetComponent("UIGrid")
    grid:Reposition() -- 自动排列
end

-- 每日任务关闭
function BroadCastView:closePanel()
	destroy(self.panel)
end

-- 创建单个任务itme
function BroadCastView:creatItem(data)
	local icon = newobject(Util.LoadPrefab("UI/Task/TaskItemPre"))
	icon.gameObject.transform.parent = self.itemsGrid.gameObject.transform
	icon.gameObject.transform.localScale = Vector3.one

	local state = icon.gameObject.transform:FindChild("State")
	local stateLabel = state.gameObject.transform:FindChild("Label"):GetComponent("UILabel")
	local icon = state.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
	-- 完成
	if data.status == 1 then
		icon.spriteName = "wanchentb"
		stateLabel.text = "完成"
	end

	-- 未完成
	if data.status == 0 then
		icon.spriteName = "jinxingzhongtb"
		stateLabel.text = "未完成"
	end

	return icon 
end
