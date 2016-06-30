--[[
草泥马坐骑状态
作者：秦仕超
]]
GMHorseMountState = class (BaseMountState) 

GMHorseMountState._name = "GMHorseMountState"

-- GMHorseMountState.PositionOffsetStart=Vector3(3,0,0)		--------音符初始位置偏移
-- GMHorseMountState.PositionOffsetEnd=Vector3(7,0,0)			--------音符终止位置偏移
-- GMHorseMountState.PositionOffsetEnd1=Vector3(9,0,0) 		--------音符终止位置偏移
-- GMHorseMountState.PositionOffsetEnd2=Vector3(11,0,0) 		--------音符终止位置偏移
GMHorseMountState.isColor=false 							--------是否为变色版
GMHorseMountState.RunTime=0 								--------------执行时间
GMHorseMountState.player=nil 								--------主角实例

function GMHorseMountState:Enter(role)
end

function GMHorseMountState:Excute(role,dTime)
	self.RunTime=self.RunTime+UnityEngine.Time.deltaTime
	if self.RunTime>self.player.property.PetMountCd then
		if self.isColor then
			self:CreateNotes(role,PetStaticTable.PositionOffsetEnd,PetStaticTable.PositionOffsetEnd1,PetStaticTable.PositionOffsetEnd2)
		else
			self:CreateNotes(role,PetStaticTable.PositionOffsetEnd)
		end
		self.RunTime=0
	end
end

function GMHorseMountState:Exit(role)
	-- self.super.Exit(self,role)
end

---------生成音符
function GMHorseMountState:CreateNotes( ... )--参数1、role；2、endPosOff1；3、endPosOff2；4、endPosOff3
	local args = {...}
	local startPos = args[1].gameObject.transform.position+PetStaticTable.PositionOffsetStart
	local endPos ={} 
	endPos[0]=args[1].gameObject.transform.position+args[2]
	local Length = table.getn(args)
	if Length>2 then
		endPos[1]= args[1].gameObject.transform.position+args[3]
		endPos[2]= args[1].gameObject.transform.position+args[4]
	end
	for i=1,Length-1 do
        CreateThings(args[1],PetStaticTable.GMHorseMountNotes,PetStaticTable.NotesLua,startPos,args[1].gameObject.transform.parent.parent,{startPos,endPos[i-1]})
    end
end
