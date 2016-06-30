--[[
author:Desmond
建筑信息面板
]]

BuildingInfo = class()

BuildingInfo.scene = nil -- 依附的场景对象
--BuildingInfo.topName = nil -- 上方名字
BuildingInfo.name = nil -- 名字
BuildingInfo.lvl = nil -- 等级
BuildingInfo.describe = nil -- 描述
BuildingInfo.infoLabel = nil --信息
BuildingInfo.modelShow = nil --modelShow


-- 初始化UI
function BuildingInfo:Init(targetscene)
	self.scene = targetscene
    self.modelShow = targetscene.modelShow
	self.gameObject = self.scene:LoadUI("Building/buildMessage")
    self.gameObject.transform.localScale = UnityEngine.Vector3.one
    --self.topName = self.gameObject.transform:FindChild("UI/title/titlebg/title"):GetComponent("UILabel")
    BuildingInfo.name = self.gameObject.transform:FindChild("UI/title/info/top/Label"):GetComponent("UILabel")
    BuildingInfo.lvl = self.gameObject.transform:FindChild("UI/title/info/top/lvRight/Label"):GetComponent("UILabel")
    BuildingInfo.describe = self.gameObject.transform:FindChild("UI/title/Label"):GetComponent("UILabel")
    BuildingInfo.infoLabel = self.gameObject.transform:FindChild("UI/title/info/infoLabel"):GetComponent("UILabel")
    self:SetActive(false)
end

function BuildingInfo:SetActive(active)
	self.gameObject:SetActive(active)
    self.modelShow:SetActive(active)
end


--设置面板信息
--建筑id
function BuildingInfo:setInfo( building )
	local build_txt = TxtFactory:getTable(TxtFactory.BuildingTXT) --获取建筑表
    local buildId = building:getBuildingId()
    self.modelShow:ChooseBuilding(buildId)
    local lvl = build_txt:GetBulidLevelById(buildId)
    --self.topName.text = build_txt:GetData(buildId,TxtFactory.S_BUILDING_NAME)
    self.name.text = build_txt:GetData(buildId,TxtFactory.S_BUILDING_NAME)
    self.describe.text = build_txt:GetData(buildId,TxtFactory.S_BUILDING_DESC)
    local buildType = build_txt:GetData(buildId,TxtFactory.S_BUILDING_TYPENAME)  --小屋的类型
    self.lvl.text = lvl
    if buildType == 1 then
        self.infoLabel.text = "[643000]结算得分加成：[-] [e87173]"..build_txt:GetData(buildId,TxtFactory.S_BUILDING_PEN).."[-]"
    elseif buildType == 2 then
        self.infoLabel.text = "[643000]产出速度：[-] [e87173]"..build_txt:GetData(buildId,TxtFactory.S_BUILDING_SPEED).."[-]\n".."[643000]生产上限：[-] [e87173]"..build_txt:GetData(building:getBuildingId()-1+lvl,TxtFactory.S_BUILDING_MAXGOLD).."[-]"
    elseif buildType == 3 then
        self.infoLabel.text = "[643000]仓库容量：[-] [e87173]"..build_txt:GetData(buildId,TxtFactory.S_BUILDING_CAPACITY).."[-]"
    elseif buildType == 5 then
        self.infoLabel.text = "[643000]人口上限：[-] [e87173]"..build_txt:GetData(buildId,TxtFactory.S_BUILDING_CAPACITY).."[-]"
    else
        self.infoLabel.text = ""
    end
end



