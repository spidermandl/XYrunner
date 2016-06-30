--[[
author:Desmond
无尽关卡结算
]]
BattleEndlessResult = class()
BattleEndlessResult.scene = nil

BattleEndlessResult.panel = nil -- 面板
BattleEndlessResult.name = "BattleEndlessResult" --类名


BattleEndlessResult.modelShow = nil -- 3D模型

function BattleEndlessResult:Awake()

end

function BattleEndlessResult:InitPanel()
    self.panel = newobject(Util.LoadPrefab("UI/Endless/EndlessSettlementUI"))
    self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
    
    self.scoresLab = getUIComponent(self.panel,"UI/title/setLabel","UILabel")
    self.goldLab = getUIComponent(self.panel,"UI/addSet/setLabel","UILabel")
    
    self.expLab = getUIComponent(self.panel,"UI/addSet/ExpValue","UILabel")

    --不显示功能
    local friendInfo = getUIGameObject(self.panel,"UI/friendInfo")
    friendInfo.gameObject:SetActive(false)

    local additems = getUIGameObject(self.panel,"UI/addItems")
    additems.gameObject:SetActive(false)

    local weekBadge = getUIGameObject(self.panel,"UI/title/icon")
    weekBadge.gameObject:SetActive(false)

    self.scene:boundButtonEvents(self.panel)
    self.panel:SetActive(false)
end

function BattleEndlessResult:InitData()
     local role = LuaShell.getRole(LuaShell.DesmondID)
    
     self.scoresLab.text = math.floor(role:getScoreResult())
     self.goldLab.text = math.floor(role:getMoneyResult())
     self.expLab.text = math.floor(role:getExpResult())
end

--激活结算面板
function BattleEndlessResult:showEndlessResult()
    if self.panel == nil then 
        self:InitPanel()
    end
	self.panel:SetActive(true)
    
    self:AddRoleMode()
    self:InitData()
end

-- 设置3d模型
function BattleEndlessResult:AddRoleMode()

	
	--模型
	self.modelShow = ModelShow.new()
    self.modelShow:Init(self)

	-- 显示人物模型预览
    local UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    self.modelShow:ChooseCharacter(UserInfo[TxtFactory.USER_SEX])
    self.modelShow:petShow()
end

-- 确定按钮
function BattleEndlessResult:okBtn()
	--self.scene:ChangScene(SceneConfig.buildingScene)
    self.scene:EndLessResultFinsh()
end

-- 分享按钮
function BattleEndlessResult:shareBtn()
	print("分享按钮")
end

-- 获取类名
function BattleEndlessResult:getName()
    return self.name 
end