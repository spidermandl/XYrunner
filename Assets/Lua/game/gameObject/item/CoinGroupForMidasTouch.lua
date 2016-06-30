--[[
author:赵名飞
产生的金币组
]]
CoinGroupForMidasTouch = class(EliminateItemGroup)

CoinGroupForMidasTouch.role = nil
CoinGroupForMidasTouch.type = "CoinGroupForMidasTouch" --收集道具类型
CoinGroupForMidasTouch.coinGroupTable = nil
CoinGroupForMidasTouch.recycleTable = nil --存放消除的物体

CoinGroupForMidasTouch.FlowInSpeed = 14
CoinGroupForMidasTouch.itemLinks = nil --模型和主键联接

CoinGroupForMidasTouch.itemManager = nil
CoinGroupForMidasTouch.waitTime = 0.5 --等待时间
CoinGroupForMidasTouch.startTime = 0 --开始时间

function CoinGroupForMidasTouch:Awake()
	self.super.Awake(self)
end
function CoinGroupForMidasTouch:initParam()
	self.super.initParam(self)
	self.startTime = UnityEngine.Time.time
end
--启动事件--
function CoinGroupForMidasTouch:Start()
	self.super.Start(self)
end

function CoinGroupForMidasTouch:Update()
    --print( #self.coinGroupTable)
	if self.role == nil then
	    self.role=LuaShell.getRole(LuaShell.DesmondID)
	    return
	end
	if UnityEngine.Time.time - self.startTime < self.waitTime then
		return
	end
    self.distance = self.gameObject.transform.position.x - self.role.character.transform.position.x  -- 与主角距离
    if self.distance < ConfigParam.objectDestroyByCameraDis then
        self:inactive()--冷藏对象
    end

    self.stateMachine:runState(UnityEngine.Time.deltaTime)
    local buff = self.role.stateMachine:getSharedState("MagnetState") or self.role.stateMachine:getSharedState("ThroughoutMagentState")
    local debuff = self.role.stateMachine:getSharedState("AntiMagnetState")
    local pos = self.role.gameObject.transform.position
    pos.y = pos.y + 1
    -- 磁铁状态
    if buff ~= nil and debuff == nil and self.role.stateMachine:getState() ~= "DeadState" then
        buff.distance = (buff._name == "MagnetState" and ConfigParam.CoinDistance or 30)
        for i = 1, #self.coinGroupTable do
            if  UnityEngine.Vector3.Distance(self.coinGroupTable[i].gameObject.transform.position, self.role.character.transform.position)< buff.distance then
                self.coinGroupTable[i].gameObject.transform.position =  Vector3.MoveTowards(self.coinGroupTable[i].gameObject.transform.position, pos,Time.deltaTime * self.FlowInSpeed*2)
            end
        end
    end
end

--冷藏物体
function CoinGroupForMidasTouch:inactive()
	self.super.inactive(self)
end
--冷藏物体
function CoinGroupForMidasTouch:inactiveItem(item)
	self.super.inactiveItem(self,item)
end
--与主角碰撞逻辑，外部调用
function CoinGroupForMidasTouch:touchedWithPlayer( item )
	self.super.touchedWithPlayer(self,item)
end