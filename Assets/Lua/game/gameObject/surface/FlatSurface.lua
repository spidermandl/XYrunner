--[[
  author:Desmond
  普通平面,正上面行走，侧面是墙，阻挡
]]

FlatSurface = class(BaseSurface)
FlatSurface.type = "FlatSurface"
FlatSurface.role = nil --主角

function FlatSurface:Awake()
    self.gameObject.name = self.type
    self.super.Awake(self)
end

function FlatSurface:initParam()
    self.super.initParam(self)
    local center = self.gameObject.transform.localPosition
    local scale = self.gameObject.transform.localScale
    
    -------------------------上面-------------------------
    local obj = PoolFunc:pickObjByLuaName("RoadSurface") --从内存池中读取
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())
    
    obj.transform.parent = self.gameObject.transform.parent
    obj.transform.localPosition = UnityEngine.Vector3(center.x,center.y+scale.y/2,center.z)
    obj.transform.localRotation = Quaternion.Euler(0,0,0)
    obj.transform.localScale = UnityEngine.Vector3(scale.x,0.1,scale.z)
    
    local param = {}
    param.left_x = center.x - scale.x / 2
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = "RoadSurface"
        LuaShell.setPreParams(obj:GetInstanceID(),param)--预置构造参数
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua.bundleParams = param
        lua:initParam()
    end
    obj:SetActive(true)

    -------------------------下面-------------------------
    
    
    obj = PoolFunc:pickObjByLuaName("CeilingSurface") --从内存池中读取
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())

    param.left_x = center.x - scale.x / 2
    obj.transform.parent = self.gameObject.transform.parent
    obj.transform.localPosition = UnityEngine.Vector3(center.x,center.y-scale.y/2,center.z)
    obj.transform.localRotation = Quaternion.Euler(0,0,0)
    obj.transform.localScale = UnityEngine.Vector3(scale.x,0.1,scale.z)
    
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = "CeilingSurface"
        LuaShell.setPreParams(obj:GetInstanceID(),param)--预置构造参数
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua.bundleParams = param
        lua:initParam()
    end
    obj:SetActive(true)
    
    local width = 0.1
    -------------------------左面-------------------------
    obj = PoolFunc:pickObjByLuaName("HangingSurface")
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())

    obj.transform.parent = self.gameObject.transform.parent
    obj.transform.localPosition = UnityEngine.Vector3(center.x - scale.x/2 + width/2, center.y, center.z)
    obj.transform.localRotation = Quaternion.Euler(0,0,0)
    obj.transform.localScale = UnityEngine.Vector3(width,scale.y-width,scale.z)
    
   -- local data = self.bundleParams["playerWallData_Left"]
   -- obj.name = tostring(data['isCanPlayWall'])
    param = self.bundleParams["playerWallData_Left"]
    if type(param)~="table" then
        param = {}
    end
    param.left_x = center.x - scale.x / 2
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = "HangingSurface"
        LuaShell.setPreParams(obj:GetInstanceID(),param)--预置构造参数
        --LuaShell.setPreParams(obj:GetInstanceID(),nil)--预置构造参数
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua.bundleParams = param
        lua:initParam()
    end
    
    obj:SetActive(true)

    -------------------------右面-------------------------
    obj = PoolFunc:pickObjByLuaName("HangingSurface")
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())

    obj.transform.parent = self.gameObject.transform.parent
    obj.transform.localPosition = UnityEngine.Vector3(center.x + scale.x/2 - width/2, center.y, center.z)
    obj.transform.localRotation = Quaternion.Euler(0,0,0)
    obj.transform.localScale = UnityEngine.Vector3(width,scale.y-width,scale.z)
    
    param = self.bundleParams["playerWallData_Right"]
    if type(param)~="table" then
        param = {}
    end
    param.left_x = center.x - scale.x / 2
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = "HangingSurface"
        LuaShell.setPreParams(obj:GetInstanceID(),param)--预置构造参数
        --LuaShell.setPreParams(obj:GetInstanceID(),nil)--预置构造参数
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua.bundleParams = param
        lua:initParam()
        
    end
    
    obj:SetActive(true)
	

    self.surfaceManager:removeObject(self)
end

