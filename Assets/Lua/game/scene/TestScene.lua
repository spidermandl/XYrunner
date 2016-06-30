--[[
author:Desmond
测试scene
]]
TestScene = class(BaseScene)

TestScene.name = "TestScene" --类名

TestScene.grid = nil --ui根节点
TestScene.item = nil


function TestScene:Awake()

    TxtFactory:getTable(TxtFactory.MemDataCache):initAccount({}) --初始化玩家信息

	--创建ui
	self.grid = find("itemsGrid").transform
	self.item = find("level_name")
    local txt = TxtFactory:getTable(TxtFactory.ChapterTXT)
    --print ("--------function TestScene:Awake() "..tostring(txt:GetLineNum()))
    for i = 1 , txt:GetLineNum() do
        local go = newobject(self.item.gameObject)
        go.transform.parent = self.grid
        go.transform.localScale = UnityEngine.Vector3(3,3,3)
        go:SetActive(true)
        go.name = txt:GetData(i,'ScenesId')
        go:GetComponent("UILabel").text = go.name
        --print (go.name)
    end

    local txt = TxtFactory:getTable(TxtFactory.EndlessTXT)
    --print ("--------function TestScene:Awake() "..tostring(txt:GetLineNum()))
    for i = 1 , txt:GetLineNum() do
        local go = newobject(self.item.gameObject)
        go.transform.parent = self.grid
        go.transform.localScale = UnityEngine.Vector3(3,3,3)
        go:SetActive(true)
        go.name = txt:GetData(i,'NAME')
        go:GetComponent("UILabel").text = go.name
        --print (go.name)
    end
    --设置速度
    -- local txt = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    -- txt[TxtFactory.USER_MOVE_SPEED] = 9
end

--启动事件--
function TestScene:runTest(name)
    print(" TestScene:runTest(name) : "..name)
    TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE,-1)
    TxtFactory:setValue(TxtFactory.UserInfo,TxtFactory.USER_STORY,name)
    self:ChangScene("level_story")
end
