--[[
	宠物；坐骑；套装中用到的静态数据
	作者：秦仕超
]]


PetStaticTable = {
	PetTriggerDistance=15, 				---------场景中摆放的宠物触发距离 如：阿狸
	ChinchillasPositionX=8, 			---------龙猫生成位置的X轴
	ChinchillasPositionY=5, 			---------龙猫生成位置的Y轴
	UFOMountMagnetDistance=10, 			---------UFO坐骑磁力范围
---------------------草泥马中音符的位置---------------------------------------------------------
	PositionOffsetStart=Vector3(3,0,0),		--------音符初始位置偏移
	PositionOffsetEnd=Vector3(7,0,0),		--------音符终止位置偏移
	PositionOffsetEnd1=Vector3(9,0,0), 		--------音符终止位置偏移
	PositionOffsetEnd2=Vector3(11,0,0), 	--------音符终止位置偏移
--------------------------------------------------------------------------------------
	CreateCoin="coin" ,						--------动态生成金币的名字
	CreateDiamond="treasure_box",			--------动态生成钻石的名字
	CoinItemLua="CoinItem" ,				--------金币的lua脚本
	GMHorseMountNotes="coin", 				--------草泥马吐出的音符名字
	NotesLua="ItemNotes", 					--------音符的lua脚本名
	RhubarbDuckMountState=1.5, 				--------彩虹猫速度倍数

	RhubarbDuckMountSpeedTime=4, 			--------大黄鸭和变色UFO加速时间
	TeemoShowTime=2, 						--------提莫现形时间

	ChobeThrowingThingsX=8, 				--------丘比扔的东西相对人向前的位置
	ChobeThrowingThingsSpeed=10, 			--------丘比扔的东西相对人的速度

	MeowsThrowingCoinsNum=5,				--------喵喵扔的金币数
	MeowsThrowingCoinsLeft=5,	 			--------喵喵扔东西的左侧范围 相对喵喵 十倍值
	MeowsThrowingCoinsRight=100, 			--------喵喵扔东西的右侧范围 相对喵喵 十倍值

	CoinRainLeft=5,							--------金币雨左边界
	CoinRainRight=20, 						--------金币雨右边界
	CoinRainCoinNum=20, 					--------金币雨生成金币数
	CoinRainDiamondNum=5, 					--------金币雨生成钻石数
}

----------宠物类型，用于分辨普通和变色，或道具-------------------------------
PetType={
	Ordinary=0, 					---------普通宠物
	Discoloration=1, 				---------变色的宠物
	props=2 						---------场景中的临时道具
}


