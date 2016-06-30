--[[
author:huqiuxiang
某些物体下 子金币组 通用 
]]
CoinGroupInObj = class(EliminateItemGroup)
CoinGroupInObj.role = nil

CoinGroupInObj.coinGroupTable = {}
function CoinGroupInObj:Awake()
	self.coinGroupTable = {}
   --遍历子物体 放入tabel
   self.stateMachine = StateMachine.new()
   self.stateMachine.role = self
end

function CoinGroupInObj:Start()
	-- print(#self.coinGroupTable)
end

function CoinGroupInObj:Update()
	self.super.Update(self)
end

function CoinGroupInObj:FixedUpdate()
end

function CoinGroupInObj:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

function CoinGroupInObj:OnMsgTriggerEnter( item,gameObj )
	self.super.OnMsgTriggerEnter(self,item,gameObj)
end
--与主角碰撞逻辑，外部调用
function CoinGroupInObj:touchedWithPlayer( item )
	self.super.touchedWithPlayer(self,item)	
	-- for i , v in ipairs(self.coinGroupTable) do
	-- 	if v == item then
	-- 	    table.remove(self.coinGroupTable,i)
	-- 	end
	-- end
	-- print("self.coinGroupTable"..#self.coinGroupTable)
end

function CoinGroupInObj:doTriggerEnter(role)
	self.super.doTriggerEnter(self,role)
end
