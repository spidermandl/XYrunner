--[[
author:gaofei
活动界面
]]

ActivityView = class ()

ActivityView.scene = nil --场景scene
ActivityView.panel = nil -- 界面

--ActivityView.activityGrids = nil -- 存储七个活动界面

ActivityView.cur_activity_index = nil  -- 当前的活动界面

ActivityView.maxActivityCount = nil  -- 活动的最大数量

ActivityView.titleLabel = nil -- 活动标题
ActivityView.contentLabel = nil --活动内容

-- 初始化
function ActivityView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Activity/ActivityView"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
	
	--self.activityGrids = {}
	--[[
	for i = 1 , 7 do
		self.activityGrids[i] = self.panel.transform:Find("Anchors/UI/Scroll View/Activity_"..i)
	end
	]]--
	
	
	self.titleLabel = self.panel.transform:Find("Anchors/UI/Title"):GetComponent("UILabel")
	self.contentLabel = self.panel.transform:Find("Anchors/UI/Scroll View/Activity_1/ActivityItem/Label"):GetComponent("UILabel")
	
	self.pageLabel = self.panel.transform:Find("Anchors/UI/Page"):GetComponent("UILabel")
	self.itemsScrollView = self.panel.transform:Find("Anchors/UI/Scroll View"):GetComponent("UIScrollView")
    self.scene:boundButtonEvents(self.panel)
	
	
	
	self.systemNoticeConfigTXT = TxtFactory:getTable(TxtFactory.SystemNoticeConfigTXT)
	self.maxActivityCount = tonumber(self.systemNoticeConfigTXT:GetLineNum())
end

function ActivityView:SetActivityIndex(activity_index)
	self.cur_activity_index = activity_index
	self:RefreshActivityView()
end

-- 刷新界面


-- 上一个活动界面
function ActivityView:ActivityLeftBtnOnClick()
	
	if self.cur_activity_index <= 1 then
		self.cur_activity_index = self.maxActivityCount
	else
		self.cur_activity_index = self.cur_activity_index -1
	end
	
	self:RefreshActivityView()
	
end

-- 下一个活动界面
function ActivityView:ActivityRightBtnOnClick()
	--printf("count ==".. #self.activityGrids)
	
	if self.cur_activity_index >= self.maxActivityCount then
		self.cur_activity_index = 1
	else
		self.cur_activity_index = self.cur_activity_index +1
	end
	self:RefreshActivityView()
	
end

-- 刷新界面
function ActivityView:RefreshActivityView()
	--printf("index =="..self.cur_activity_index)
	--[[
	for i = 1 , #self.activityGrids do
		self.activityGrids[i].gameObject:SetActive(i == self.cur_activity_index)
	end
	self.itemsScrollView:ResetPosition()
	self.pageLabel.text = self.cur_activity_index.."/"..#self.activityGrids
	]]--
	
	local title_info = self.systemNoticeConfigTXT:GetData(self.cur_activity_index,"TITLE")
	local content_info = string.gsub(self.systemNoticeConfigTXT:GetData(self.cur_activity_index,"CONTEXT"), "###", "\n")
	
	self.titleLabel.text = title_info
	self.contentLabel.text = content_info
	self.itemsScrollView:ResetPosition()
	self.pageLabel.text = self.cur_activity_index.."/"..self.maxActivityCount
end


-- 关闭活动界面
function ActivityView:ActivityCloseBtnOnClick()
	self:HiddenView()
end

--激活暂停界面
function ActivityView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function ActivityView:HiddenView()
	self.panel:SetActive(false)
end

