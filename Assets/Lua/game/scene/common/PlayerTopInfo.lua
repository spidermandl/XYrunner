--[[
author:Gaofei
玩家顶部信息  -- 体力  金币   钻石
]]
PlayerTopInfo = class()
PlayerTopInfo.scene = nil

PlayerTopInfo.panel = nil -- 面板
PlayerTopInfo.name = "PlayerTopInfo"

function PlayerTopInfo:Init(type)
	self.panel = newobject(Util.LoadPrefab("UI/common/PlayerTopInfo"))
    self.panel.name = self.name
    self.scene = LuaShell.getRole(find("sceneUI"):GetInstanceID())
    self.scene:boundButtonEvents(self.panel)
    local top 
    --有返回
    local top1 = self.panel.transform:Find("UI")
    --无返回
    local top2 = self.panel.transform:Find("UI1")
    if type == "HaveReturn" then
	   top = getUIGameObject(top1,"right")
       top2.gameObject:SetActive(false)
       self.returnBtn = getUIGameObject(self.panel,"UI/PlayerTopInfo_BtnReturn") 
    elseif type =="NoneReturn" then
        top = top2
        top1.gameObject:SetActive(false)
    else
       top = top2
        top1.gameObject:SetActive(false)
       -- error("type is error")
    end
    
    self.playerDiamond = top:Find("zuanshi/Label"):GetComponent("UILabel")
    self.playerGold = top:Find("coins/Label"):GetComponent("UILabel")
    self.playerStrength = top:Find("tili/Label"):GetComponent("UILabel")
    local tileEf = top:Find("tili/ef_ui_tili"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
    SetEffectOrderInLayer(tileEf,3)
    local goinsEf = top:Find("coins/ef_ui_coins"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
    SetEffectOrderInLayer(goinsEf,3)
    local zuanshiEf = top:Find("zuanshi/ef_ui_zuanshi"):GetComponent(UnityEngine.ParticleSystem.GetClassType())
    SetEffectOrderInLayer(zuanshiEf,3)
    self:InitData()
end

function PlayerTopInfo:SetActive(active)
    self.panel.gameObject:SetActive(active)
end


-- 设置父节点
function PlayerTopInfo:SetParent(parentObj)
	self.panel.transform.parent = parentObj.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
end

-- 初始化数据
function PlayerTopInfo:InitData()
    --GamePrint( "    PlayerTopInfo:InitData     ")
   
    
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)   
	self.playerGold.text = tonumber(self.UserInfo[TxtFactory.USER_GOLD])
    self.playerDiamond.text = tonumber(self.UserInfo[TxtFactory.USER_DIAMOND])
    self.playerStrength.text = tonumber(self.UserInfo[TxtFactory.USER_STRENGTH])
end

-- 点击添加体力
function PlayerTopInfo:AddStrength()
   -- printf('增加体力')
    self:ShowShop(3)
end

-- 点击添加金币
function PlayerTopInfo:AddGold()
   -- printf('增加金币')
    self:ShowShop(3)
end

-- 点击充值
function PlayerTopInfo:AddDiamond()
   -- printf('增加钻石')
  self:ShowShop(4)
end

function PlayerTopInfo:ShowShop(type)
    if self.scene.storeView == nil then
		self.scene.storeView = StoreView.new()
		self.scene.storeView:init(self.scene)
	end
    self.scene.storeView:ShowView()
    self.scene.storeView:InitData(type)
end


