--[[
	音符
	作者：秦仕超
]]

ItemNotes=class(EliminateItem)
ItemNotes.roleName="ItemNotes"

ItemNotes.startPosition=nil 		------开始位置
ItemNotes.endPosition=nil 			------终止位置
ItemNotes.MoveTime=0 				------移动时间
function ItemNotes:Awake()
	self.super.Awake(self)
	if self.bundleParams ~= nil and self.bundleParams.Length ~= 0 then 
    	self.startPosition=self.bundleParams[1]
    	self.endPosition=self.bundleParams[2]
    end
end

function ItemNotes:Start()
	self.super.Start(self)
end

function ItemNotes:Update()
	self.super.Update(self)
	if self.MoveTime<1 and self.gameObject~=nil then
		self.MoveTime=(self.MoveTime+UnityEngine.Time.deltaTime)*2
		self.gameObject.transform.position=Vector3.Lerp(self.startPosition
		,self.endPosition,self.MoveTime)
	end

end

function ItemNotes:FixedUpdate()
	self.super.FixedUpdate(self)
end

function ItemNotes:OnTriggerEnter(gameObj)
	self.super.OnTriggerEnter(self,gameObj)
end

function ItemNotes:doTriggerEnter(role)
	self.super.doTriggerEnter(self,role)
end




