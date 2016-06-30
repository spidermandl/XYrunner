--[[
author:Desmond
管理场景元素路径动画item
]]
AnimTriggerItem = class(BaseItem)
AnimTriggerItem.animObjects = nil --动画物件列表

function AnimTriggerItem:Awake()

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(0,0,0)
    
    self.super.Awake(self)
    --self:initParam()

end

--初始化
function AnimTriggerItem:initParam()
    local json = require "cjson"
    local util = require "3rd/cjson.util"
    local param = self.bundleParams
    self.animObjects = {}
	--print ("-------------------function AnimTriggerItem:initParam() 1 "..tostring(self.gameObject.transform.localPosition))
    local array = lua_string_split(param['trigger_localPosition'],",")
    local trigger_offset_pos = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
    self.gameObject.transform.position = self.gameObject.transform.position + trigger_offset_pos
	array = lua_string_split(param['trigger_localRotation'],",")
	array = lua_string_split(param['trigger_localScale'],",")
	self.gameObject.transform.localScale = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
    local array = lua_string_split(param['trigger_size'],",")
    self.collider.size =  UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞大小
    
    --GamePrint (tostring("--------------------------function AnimTriggerItem:initParam() 1"))
    local objects = param['objects']
    for i=1,#objects do --创建动画元素
        --GamePrint (tostring("--------------------------function AnimTriggerItem:initParam() 2"))
	    local obj = PoolFunc:pickObjByLuaName(objects[i]['luaName']) --从内存池中读取
	    --print ("----------------------function AnimTriggerItem:initParam() "..tostring(obj:GetInstanceID()))
	    obj:SetActive(false)
	    local sub = obj:GetComponent(BundleLua.GetClassType())
        
        array = lua_string_split(objects[i]['localPosition'],",")
        obj.transform.parent = self.gameObject.transform
	    obj.transform.localPosition = 
	    		UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
	    		- trigger_offset_pos
	    --print ("-------------------function AnimTriggerItem:initParam() 2 "..tostring(obj.transform.localPosition))
	    array = lua_string_split(objects[i]['localRotation'],",")
	    obj.transform.localRotation = Quaternion.Euler(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
	    array = lua_string_split(objects[i]['localScale'],",")
	    obj.transform.localScale = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
	    array = lua_string_split(objects[i]['childLocalScale'],",")
        objects[i]['childLocalScale'] = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
        local objParam = clone(objects[i])
        objParam.param = objects[i]["material_id"] --enemy中使用

	    if sub == nil then --第一次创建物体
	        sub = obj:AddComponent(BundleLua.GetClassType())
	        sub.luaName = objects[i]['luaName']
	        LuaShell.setPreParams(obj:GetInstanceID(),objParam)--预置构造参数
	    else --重用加载
	        local lua = LuaShell.getRole(obj:GetInstanceID())
	        lua.bundleParams = objParam
	        lua:initParam()
	    end
        --GamePrint("------------function AnimTriggerItem:initParam() "..tostring(obj.name).." "..tostring(obj.transform.localPosition))
	    obj:SetActive(true)

	    table.insert(self.animObjects,LuaShell.getRole(obj:GetInstanceID()))
    end

    self.super.initParam(self)
end

function AnimTriggerItem:Update() --不能重载父类方法

end

function AnimTriggerItem:OnTriggerEnter(gameObj)
    local flag = self.super.OnTriggerEnter(self,gameObj)
    if flag == false then
        return
    end

    --GamePrint ("----------------function AnimTriggerItem:OnTriggerEnter(gameObj) ")
    for i=1,#self.animObjects do --激活动画
        -- if self.animObjects[i].playPathAnim == nil then
            
        -- else
    	   self.animObjects[i]:playPathAnim()
        --end
    end

end