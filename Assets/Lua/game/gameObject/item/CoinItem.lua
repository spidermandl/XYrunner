--[[
   author:Desmond
   drepcated
   金币道具
]]
ItemCoinConstant = {
    FOLLOW = 1, --跟随吸收金币
    THROW = 2,  --抛出的金币
    RAIN=3, 	--金币雨的金币
}

CoinItem = class(EliminateItem)

CoinItem.coinType=nil 						--------金币类型

CoinItem.StartTime=nil 						--------开始时间

CoinItem.player=nil 						--------主角
CoinItem.StartPosition=nil 					--------开始位置

CoinItem.Endposition=nil 					--------停止的位置
CoinItem.StartSpeed=2 						--------初始速度

CoinItem.isFinish=false 					--------是否已经完成操作
function CoinItem:Awake()

	if self.bundleParams ~= nil and self.bundleParams.Length ~= 0 then 
    	self.coinType=self.bundleParams[1]
    	if self.coinType==ItemCoinConstant.THROW then
    		self.Endposition=self.bundleParams[2]
    	elseif self.coinType=="" then

    	end
    	-- self.role = LuaShell.getRole(self.bundleParams[2])
    	-- self.utterAngle=self.bundleParams[3]
    else
    	self.coinType=ItemCoinConstant.FOLLOW
    end

    self.bundleParams=nil
	self.super.Awake(self)


end

function CoinItem:Start()
	self.super.Start(self)
	self.player=LuaShell.getRole(LuaShell.DesmondID)
	self.StartTime=UnityEngine.Time.time
	self.StartPosition=self.gameObject.transform.position

	if self.coinType==ItemCoinConstant.FOLLOW then
		self.stateMachine:changeState(ItemFlowState.new())
	elseif self.coinType==ItemCoinConstant.THROW then
		self.stateMachine:changeState(ItemTrowState.new())
	end
end

function CoinItem:Update()
	self.super.Update(self)
	if self.coinType==ItemCoinConstant.RAIN then
		self:RainCoin()
	end
end

function CoinItem:FixedUpdate()
	self.super.FixedUpdate(self)
end

function CoinItem:OnTriggerEnter(gameObj)
	self.super.OnTriggerEnter(self,gameObj)
end

function CoinItem:doTriggerEnter(role)
	self.super.doTriggerEnter(self,role)
end

-- ---------------跟随操作-----------
-- function CoinItem:Flow()
-- 	self.gameObject.transform.position=Vector3.Lerp(self.StartPosition
-- 		,self.player.gameObject.transform.position,(UnityEngine.Time.time-self.StartTime)*3)
-- end

-- ----------------抛洒操作-----------

-- function CoinItem:Trow()
-- 	if self.isFinish then
-- 		return
-- 	end
-- 	local detime=(UnityEngine.Time.time-self.StartTime)*2
-- 	if detime<1 then
		
-- 		self.gameObject.transform.localPosition=Vector3.Lerp(Vector3.zero
-- 		,self.Endposition,detime)--+Vector3(0,(UnityEngine.Mathf.Sin(180*detime))*4,0) 
-- 		+Vector3.Lerp(Vector3(0,0,0),Vector3(0,9,0),detime<0.5 and detime or 1-detime)
-- 	else
-- 		self.isFinish=true
-- 	end
-- end

----------------金币雨--------------
function CoinItem:RainCoin()
	if self.isFinish then
		return
	end
	if self:isOnGround(self) then
		-- GameObject.Destroy(self.gameObject)
		self.isFinish=true
	end
	self.gameObject.transform:Translate(-0.1,-0.2,0,Space.World)
end


--[[ 地面判断 ]]
function CoinItem:isOnGround(role)
	local pos = role.gameObject.transform.position
	pos.y=pos.y + 0.1
	local flag,hitinfo = UnityEngine.Physics.Raycast (pos, 
		UnityEngine.Vector3.down, nil, 1)

    if flag ==true then
    	flag = false
        local obj = LuaShell.getRole(hitinfo.collider.gameObject:GetInstanceID())
        if obj ~= nil then
        	if tostring(obj.type) == "RoadSurface" then
        		flag = true
        	end
        end
    end

	return flag
end