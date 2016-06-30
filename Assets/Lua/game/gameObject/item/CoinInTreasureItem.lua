--[[
CoinInTreasureItem
author:Huqiuxiang
宝箱里的金币组 
]]

CoinCoinInTreasureItemCoinState={
  Popup=0,
  Suspension=1,
  Attract=2,
}

CoinInTreasureItem = class(EliminateItemGroup)
CoinInTreasureItem.role = nil
CoinInTreasureItem.colliderGroup = nil --收集物碰撞体
CoinInTreasureItem.type = "EliminateItemGroup" --收集道具类型
CoinInTreasureItem.state = 0  --状态 0为开始弹出去  1为吸向人物

CoinInTreasureItem.FlowOutTime = 2  --弹开持续时间
CoinInTreasureItem.FlowWaitTime = 5 --悬浮时间
CoinInTreasureItem.FlowInSpeed = 3    --吸向人物速度
CoinInTreasureItem.FlowOutSpeed = 0.4 --弹开速度

CoinInTreasureItem.coinGroupTable = nil
CoinInTreasureItem.itemType = "coin"

CoinInTreasureItem.randomItem = 5 --爆出吸收物件数量

function CoinInTreasureItem:Awake() 
    --print ("-----------------------function CoinInTreasureItem:Awake()  "..tostring(self.gameObject.name))
    --self.super.Awake(self)
    self:initParam()

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self

end

--[[
初始化参数
]]
function CoinInTreasureItem:initParam()
  --print ("-----------------------function CoinInTreasureItem:initParam()  ")
      if self.itemLinks == nil then
          self.itemLinks = {}
      end

      --self.itemGroup = {}
      self.coinGroupTable = {}

      -- 随机收集物
      local time = os.time()--设置随机种子
      math.randomseed(time)
      local nub = math.random(1,#CollectItemsTab)
      self.itemType = CollectItemsTab[nub]

      --创建金币
      for i = 1 , self.randomItem do
          local item  = PoolFunc:pickObjByPrefabName("Items/"..self.itemType)
          item.transform.parent = self.gameObject.transform
          item.transform.localPosition = Vector3(0,0,0)
          item.transform.localScale = Vector3(1.5,1.5,1.5)
          item.transform.rotation = Quaternion.Euler(0,90,0)
          self.coinGroupTable[i] = item -- 加入table 便于操作

          --添加碰撞
          local collider = item.gameObject:GetComponent(UnityEngine.BoxCollider.GetClassType())
          if collider == nil then
              collider = item.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
          end
          collider.isTrigger = true
          collider.center=UnityEngine.Vector3(0,0,0)
          collider.size=Vector3(0.7,0.7,0.7)

          --[[设置刚体]]
          local rigidBody = item.gameObject:GetComponent(UnityEngine.Rigidbody.GetClassType())
          if rigidBody == nil then
              rigidBody = item.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
          end
          rigidBody.useGravity = false
          rigidBody.isKinematic = false
          rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll
      end
    
      self.effectTab = {}
      self.effectNub = 0 -- 吃金币特效数量
end


--启动事件--
function CoinInTreasureItem:Start()
end

function CoinInTreasureItem:Update()
	  self.super.Update(self)
    self:FlowAction()
end

--与主角碰撞逻辑，外部调用
function CoinInTreasureItem:touchedWithPlayer( item )
	  self.super.touchedWithPlayer(self,item)
end

function CoinInTreasureItem:doTriggerEnter(role)
	  self.super.doTriggerEnter(self,role)
end

function CoinInTreasureItem:FlowAction()
    if self.state == CoinCoinInTreasureItemCoinState.Popup then --弹出去状态
       self:FlowOut()
    elseif self.state == CoinCoinInTreasureItemCoinState.Suspension then --悬浮状态
       self:FlowWait()
    elseif self.state == CoinCoinInTreasureItemCoinState.Attract then --吸向人物状态
       self:FlowIn()
    end
end



--金币弹出去状态
function CoinInTreasureItem:FlowOut()
	self.FlowOutTime = self.FlowOutTime - 1
	--print("self.FlowOutTime"..self.FlowOutTime)
	   for i = 1 , #self.coinGroupTable do
            local dir = UnityEngine.Quaternion.Euler(0, 0, 180-(180*i)/self.randomItem) * UnityEngine.Vector3(ConfigParam.CoinExplodeRadius,0,0);
    	    self.coinGroupTable[i].gameObject.transform:Translate(dir.x *self.FlowOutSpeed,dir.y*self.FlowOutSpeed,dir.z*self.FlowOutSpeed, Space.World)
       end
      if self.FlowOutTime <= 0 then -- 悬浮
            self.state = 1
      end
end

-- 金币悬浮状态
function CoinInTreasureItem:FlowWait()
     self.FlowWaitTime = self.FlowWaitTime - 1
        if self.FlowWaitTime <= 0 then -- 悬浮
          for i = 1 , #self.coinGroupTable do
               local collider = self.coinGroupTable[i].gameObject:GetComponent('BoxCollider')
               collider.isTrigger = false
          end
            self.state = 2
      end
end

--金币吸向人物状态
function CoinInTreasureItem:FlowIn()
	if #self.coinGroupTable <= 0 then
		return
	end
	 for i = 1 , #self.coinGroupTable do
            if self.coinGroupTable[i]~=nil then
                self.coinGroupTable[i].gameObject.transform.position =  Vector3.MoveTowards(self.coinGroupTable[i].gameObject.transform.position, self.role.gameObject.transform.position,Time.deltaTime * self.FlowInSpeed*8)
            end
      end
end

--生成宝箱金币
-- function createFollowItems(role,num)
--     	local obj=GameObject.New()
--         obj:SetActive(false)
--         local item = obj:AddComponent(BundleLua.GetClassType())
--         item.luaName = "CoinInTreasureItem"
--         --print ("-----------------------------function createFollowItems(role,num) "..tostring(180-(90*k)/num))
--         LuaShell.setPreParams(obj.gameObject:GetInstanceID(),{ItemConstant.FOLLOW,role.gameObject:GetInstanceID(),num})--预置构造参数
--         obj.transform.position = role.gameObject.transform.position
--         obj:SetActive(true)
-- end