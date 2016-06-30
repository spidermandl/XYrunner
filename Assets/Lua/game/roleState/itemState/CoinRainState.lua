--[[
	金币雨状态（这里用来创建金币）
	作者：秦仕超
]]

CoinRainState=class(IState)
CoinRainState._name = "CoinRainState"

CoinRainState.ScreenW=nil   			------------屏幕宽度
CoinRainState.Hight=nil 				------------屏幕高度
CoinRainState.player=nil 			---------------主角实例
CoinRainState.playerPosition=nil		---------------主角位置

CoinRainState.coinNums=40 			------------总金币数
CoinRainState.coinNum=5 			------------金币数
CoinRainState.diamondNums=10 		------------钻石总数
CoinRainState.diamondNum=2 			------------钻石数
CoinRainState.deTimeCreate=0		-------------生成时间
CoinRainState.roleName="CoinRainState"  ---------------名字
function CoinRainState:Enter(role)
	self.super.Enter(self,role)
	self.player=LuaShell.getRole(LuaShell.DesmondID)
	-- self.myCarmera=self.player.camera
	self.coinNums=PetStaticTable.CoinRainCoinNum
	self.diamondNums=PetStaticTable.CoinRainDiamondNum
end

function CoinRainState:Excute(role,dTime)
	self.super.Excute(self,role,dTime)

	if self.coinNums>0 or self.diamondNums>0 then
		if self.deTimeCreate>0.2 then
			-- local num1 = UnityEngine.Random.Range(0,self.coinNum)
			-- self.coinNums=self.coinNums-num1
			-- if num1>self.coinNums then
			-- 	num1=self.coinNums
			-- end
			-- local num2 = UnityEngine.Random.Range(0,self.diamondNum)
			-- self.diamondNums=self.diamondNums-num2
			-- if num2>self.diamondNums then
			-- 	num2=self.diamondNums
			-- end
			if self.player.property.PetSuitName ==self._name then
				self:CreatCoinRain(role,PetStaticTable.CreateCoin,self.coinNum)
			else
				self:CreatCoinRain(role,PetStaticTable.CreateCoin,self.coinNum)
				self:CreatCoinRain(role,PetStaticTable.CreateDiamond,self.diamondNum)
			end
			self.coinNums=self.coinNums-self.coinNum
			self.diamondNums=self.diamondNums-self.diamondNum
			self.deTimeCreate=0
		else
			self.deTimeCreate=self.deTimeCreate+dTime
		end
	else
		role.stateMachine:removeSharedState(self)
		role.stateMachine.lastStrintTime=UnityEngine.Time.time
	end
end

function CoinRainState:Exit(role)
	self.super.Exit(self,role)
end

----生成金币雨
function CoinRainState:CreatCoinRain(...)
	local args = {...}
	self.playerPosition=self.player.gameObject.transform.position
	for i=1,args[3] do
       
        local startPosition=self.playerPosition+Vector3(UnityEngine.Random.Range(PetStaticTable.CoinRainLeft,PetStaticTable.CoinRainRight),8,0)--左-5，右15
     	CreateThings(args[1],args[2],PetStaticTable.CoinItemLua,startPosition,args[1].gameObject.transform.parent,{ItemCoinConstant.RAIN})
    end

end