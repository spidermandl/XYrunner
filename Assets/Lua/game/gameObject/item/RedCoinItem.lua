--[[
RedCoinItem
author:Huqiuxiang
红金币  --注意宝箱位置可能需要摆放
]]

RedCoinItem = class(EliminateItemGroup)
RedCoinItem.role = nil
RedCoinItem.itemGroup = nil  --收集物物体
RedCoinItem.colliderGroup = nil --收集物碰撞体
RedCoinItem.turnItem = nil --开关物体
RedCoinItem.isTurnOn = 0  -- 0 为没踩到开关， 1 为踩到开关

function RedCoinItem:Awake()
   self:creatItem()
   self:creatCoin()
   self:creatTreasureBox()
   self:creatUI()
   self.stateMachine = StateMachine.new()
   self.stateMachine.role = self
end

function RedCoinItem:Start()
	if self.role == nil then
		self.role=LuaShell.getRole(LuaShell.DesmondID)
		return
	end
end

function RedCoinItem:Update()
	 self.distance = self.gameObject.transform.position.x - self.role.character.transform.position.x  -- 与主角距离
    if self.distance < ConfigParam.objectDestroyByCameraDis then
        LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁对象
    end
	-- self.super.Update(self)
	if self.isTurnOn == 0 then
		-- self:turnOn() --踩开关方法
	elseif self.isTurnOn == 1 then
        self:CoinAction() --判断金币被吃光执行方法
	end

end

function RedCoinItem:FixedUpdate()
end

function RedCoinItem:OnTriggerEnter( gameObj )
	self.super.OnTriggerEnter(self,gameObj)
end

function RedCoinItem:OnMsgTriggerEnter( item,gameObj )
	self.super.OnMsgTriggerEnter(self,item,gameObj)
end
--与主角碰撞逻辑，外部调用
function RedCoinItem:touchedWithPlayer( item )
		-- print(tostring(item.gameObject.name))
	if self.role ~= nil then
        local buff = self.role.stateMachine:getSharedState("AntiMagnetState")
        if buff ~= nil then --判断是否有 无法收集物品状态
            return
        end
    end
	
	if item == self.turnItem then 
        self:turnOn()
		return
	end
	--self.super.touchedWithPlayer(self,item)	
	for i , v in ipairs(self.CoinGroup) do
		if v == item then
		    table.remove(self.CoinGroup,i)
		end
	end
	self.uiLabel.text = #self.CoinGroup
	destroy(item)
end

function RedCoinItem:doTriggerEnter(role)
	self.super.doTriggerEnter(self,role)
end

--创建金币
RedCoinItem.CoinGroup = nil  --金币组
RedCoinItem.coinNub = 0 
function RedCoinItem:creatCoin()
	self.CoinGroup = {}

	 if type(self.bundleParams) == "table" then
	 	 for i = 5 , table.getn(self.bundleParams) do
             local array = lua_string_split(self.bundleParams[i],",")
             local coin = newobject(Util.LoadPrefab("Items/coin"))
             coin.gameObject.transform.parent = self.gameObject.transform
             coin.gameObject.transform.position = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞位置
             self.coinNub = self.coinNub + 1
             self.CoinGroup[self.coinNub] = coin  -- obj 添加到tabel

            local collider = coin.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
	    	collider.isTrigger = false
	    	collider.center=UnityEngine.Vector3(0,0.6,0)
	    	collider.size=coin.transform.localScale

    	    --[[设置刚体]]
		    local rigidBody = coin.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
		    rigidBody.useGravity = false
		    rigidBody.isKinematic = false
		    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll

		    coin:SetActive(false)
	 	 end
	 end
end

--创建开关
function RedCoinItem:creatItem()
   if type(self.bundleParams) == "table" then
   	   self.turnItem = newobject(Util.LoadPrefab("Items/redCoinTurnOnItem")) 
   	   self.turnItem.transform.parent = self.gameObject.transform
   	   local array = lua_string_split(self.bundleParams[2],",")
   	   self.turnItem.transform.position = Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))

   	        local collider = self.turnItem.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
	    	collider.isTrigger = false
	    	collider.center=UnityEngine.Vector3(0,0.6,0)
	    	collider.size=self.turnItem.transform.localScale
            print(tostring(collider.isTrigger))
    	    --[[设置刚体]]
		    local rigidBody = self.turnItem.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
		    rigidBody.useGravity = false
		    rigidBody.isKinematic = false
		    rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll
   end
end

RedCoinItem.treasureBox = nil -- 宝箱物体
--创建宝箱
function RedCoinItem:creatTreasureBox()
       self.treasureBox = newobject(Util.LoadPrefab("Items/treasure_box_item"))
   	   local array = lua_string_split(self.bundleParams[4],",")
   	   self.treasureBox.transform.position = Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
   	   self.treasureBox:SetActive(false)
end


--开关触发判断
function RedCoinItem:turnOn()

       self.isTurnOn = 1
       for i=1,#self.CoinGroup do
      	    self.CoinGroup[i]:SetActive(true)
       end
       self.uiLabelPanel:SetActive(true)
	
end

RedCoinItem.treasureItemIsCreat = 0
--吃金币方法 
function RedCoinItem:CoinAction()
	--print(#self.CoinGroup)
	--吃光所有金币
    if self.treasureItemIsCreat == 1 then
    	return
    end

	if #self.CoinGroup <=0 then
		--print("吃光所有金币")
        self.uiLabelPanel:SetActive(false)
		--创建宝箱
		self.treasureBox:SetActive(true)
        self.treasureItemIsCreat = 1
	end
end

RedCoinItem.uiLabelPanel = nil
RedCoinItem.uiLabel = nil 
function RedCoinItem:creatUI()
	self.uiLabelPanel = newobject(Util.LoadPrefab("UI/RedCoinItemLabel")) 
	self.uiLabelPanel.gameObject.transform.position = Vector3.zero
	self.uiLabelPanel.gameObject.transform.parent =  self.gameObject.transform
	self.uiLabel = self.uiLabelPanel.gameObject.transform:FindChild('Label').transform:GetComponent('UILabel')
	self.uiLabel.text = #self.CoinGroup
	self.uiLabelPanel:SetActive(false)
end
