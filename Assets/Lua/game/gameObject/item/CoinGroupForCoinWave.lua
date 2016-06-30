--[[
author:huqiuxiang
金币冲击波生成的 子金币组 
]]
CoinGroupForCoinWave = class(EliminateItemGroup)
CoinGroupForCoinWave.role = nil
CoinGroupForCoinWave.coinGroupTable = {}
CoinGroupForCoinWave.timeState = 0
CoinGroupForCoinWave.waitTime = 15
CoinGroupForCoinWave.startTime = 0

function CoinGroupForCoinWave:Awake()
	self.coinGroupTable = {}
   --遍历子物体 放入tabel
   self.stateMachine = StateMachine.new()
   self.stateMachine.role = self
end

function CoinGroupForCoinWave:Start()
	-- print(#self.coinGroupTable)
end

function CoinGroupForCoinWave:Update()
    self.super.Update(self)
    self:follow()
end

function CoinGroupForCoinWave:FixedUpdate()
end

function CoinGroupForCoinWave:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

function CoinGroupForCoinWave:OnMsgTriggerEnter( item,gameObj )
	self.super.OnMsgTriggerEnter(self,item,gameObj)
end
--与主角碰撞逻辑，外部调用
function CoinGroupForCoinWave:touchedWithPlayer( item )
	self.super.touchedWithPlayer(self,item)	
	-- for i , v in ipairs(self.coinGroupTable) do
	-- 	if v == item then
 --      -- print("ENTER 删除经闭")
	-- 	    table.remove(self.coinGroupTable,i)
	-- 	end
	-- end
 --    destroy(item)
end

function CoinGroupForCoinWave:doTriggerEnter(role)
	self.super.doTriggerEnter(self,role)
end

function CoinGroupForCoinWave:follow(role)
    self.startTime = self.startTime + 1
    if self.startTime == self.waitTime then
    	 self.timeState = 1
    end
    if self.timeState == 1 and #self.coinGroupTable ~= 0 then
      -- print(#self.coinGroupTable)
	  for i = 1, #self.coinGroupTable do
         -- if  UnityEngine.Vector3.Distance(self.coinGroupTable[i].gameObject.transform.position, self.role.character.transform.position)< ConfigParam.CoinDistance then
               -- local dy = self.role.character.gameObject.transform.position.y-self.coinGroupTable[i].gameObject.transform.position.y
               -- local dx = self.role.character.gameObject.transform.position.x-self.coinGroupTable[i].gameObject.transform.position.x

               -- local Vx = ConfigParam.CoinExplodeVelocity*dx/math.sqrt(dy*dy+dx*dx)
               -- local Vy = ConfigParam.CoinExplodeVelocity*dy/math.sqrt(dy*dy+dx*dx)
               -- self.coinGroupTable[i].gameObject.transform:Translate(Vx*0.02*self.FlowInSpeed,Vy*0.02*self.FlowInSpeed,0,Space.World)
         -- end
          self.coinGroupTable[i].gameObject.transform.position =  Vector3.MoveTowards(self.coinGroupTable[i].gameObject.transform.position, self.role.gameObject.transform.position,Time.deltaTime * self.FlowInSpeed*3)
      end
  end
end
