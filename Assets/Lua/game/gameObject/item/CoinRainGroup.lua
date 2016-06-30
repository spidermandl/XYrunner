--CoinRainGroup
--[[
author:huqiuxiang
金币雨
]]
CoinRainGroup = class(EliminateItemGroup)
CoinRainGroup.role = nil
CoinRainGroup.coinVspeed = 3 --金币向下
CoinRainGroup.coinHspeed = 2.5 -- 金币向左速度
CoinRainGroup.coinGroupTable = {}


function CoinRainGroup:Awake()
	--print ("-----------------------function CoinRainGroup:Awake()  "..tostring(self.gameObject.name))
	self.coinGroupTable = {}
    --遍历子物体 放入tabel
    self:initParam()
    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
end

function CoinRainGroup:Update()
	self.super.Update(self)
	self:CoinRainMove()
end

--与主角碰撞逻辑，外部调用
function CoinRainGroup:touchedWithPlayer( item )
	  self.super.touchedWithPlayer(self,item)
end

function CoinRainGroup:doTriggerEnter(role)
	  self.super.doTriggerEnter(self,role)
end

--单个金币金币生成
function CoinRainGroup:initParam()
	-- print("单个金币金币生成")
	if self.itemLinks == nil then
        self.itemLinks = {}
    end
	self.coinGroupTable = {}
	for i=1,3 do  
		-- local time = os.time()--设置随机种子
  --     	math.randomseed(time) 	 
		--随机生成位置
    	local v = math.random(1,10)
    	local h = math.random(1,10)
		local coin = PoolFunc:pickObjByPrefabName("Items/coin")


		coin.transform.parent = self.gameObject.transform
    	coin.transform.localPosition = Vector3(0,0,0)
    	coin.transform.localScale = Vector3(0.7,0.7,0.7)
    	coin.transform.rotation = Quaternion.Euler(0,90,0)
    	self.coinGroupTable[i] = coin -- 加入table 便于操作

		coin.gameObject.transform:Translate(0,10+v*2,20+h*2)

	 	local collider = coin.gameObject:GetComponent(UnityEngine.BoxCollider.GetClassType())
        if collider == nil then
            collider = coin.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
        end
        collider.isTrigger = false
        collider.center=UnityEngine.Vector3(0,0,0)
        collider.size=Vector3(0.7,0.7,0.7)   --item.transform.localScale

            --[[设置刚体]]
        local rigidBody = coin.gameObject:GetComponent(UnityEngine.Rigidbody.GetClassType())
        if rigidBody == nil then
            rigidBody = coin.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
        end
        rigidBody.useGravity = false
        rigidBody.isKinematic = false
        rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

        self.itemLinks[coin] = "800101"

      	self.effectTab = {}
      	self.effectNub = 0 -- 吃金币特效数量
	 end

end

--金币组移动
function CoinRainGroup:CoinRainMove()
 for i=1,#self.coinGroupTable do
	self.coinGroupTable[i].gameObject.transform:Translate(0,0,-0.1*self.coinVspeed)
	self.coinGroupTable[i].gameObject.transform:Translate(0,-0.1*self.coinHspeed,0)
 end
end