--[[
author:Desmond
所有场景动态物件集合,Object管理父类
lua层执行lua update 和 fixupdate
]]
ObjectGroup = class (BaseBehaviour)
ObjectGroup.objGroup = nil --obj组  gameobject id ==> obj
ObjectGroup.role = nil --主角
ObjectGroup.name = "ObjectGroup"

function ObjectGroup:Awake()
	self.objGroup = {}
end

--[[增加 object]]
function ObjectGroup:addObject( obj )
	self.objGroup[obj.gameObject:GetInstanceID()] = obj
end
--[[移除 object]]
function ObjectGroup:removeObject( obj )
    self.objGroup[obj.gameObject:GetInstanceID()] = nil
    PoolFunc:inactiveObj(obj.gameObject)
end


function ObjectGroup:Update()
    for k,v in pairs(self.objGroup) do --遍历group 执行c＃绑定lua update
    	if v ~= nil then
    		v:Update()
    	end
    end
end

function ObjectGroup:FixedUpdate()    
    for k,v in pairs(self.objGroup) do --遍历group 执行c＃绑定lua FixedUpdate
    	if v ~= nil then
    		v:FixedUpdate()
    	end
    end
end

function ObjectGroup:LateUpdate()    
    for k,v in pairs(self.objGroup) do --遍历group 执行c＃绑定lua LateUpdate
        if v ~= nil then
            v:LateUpdate()
        end
    end
end