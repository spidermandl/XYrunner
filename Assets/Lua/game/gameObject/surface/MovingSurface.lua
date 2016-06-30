--[[
移动路面
author:Desmond
]]
MovingSurface = class(BaseSurface)
MovingSurface.type = "MovingSurface"
MovingSurface.role = nil --主角

MovingSurface.upSurface = nil 
MovingSurface.downSurface = nil
MovingSurface.animator = nil--self.character:GetComponent("Animator")
function MovingSurface:Awake()
    self.gameObject.name = self.type
    self.super.Awake(self)
end

function MovingSurface:initParam()
    self.super.initParam(self)

    local center = self.gameObject.transform.localPosition
    local scale = self.gameObject.transform.localScale
    --self.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)

    if type(self.bundleParams) == "table" then  --参数从json中读入,动态加载时生效
        local su = PoolFunc:pickObjByPrefabName("Surface/"..self.bundleParams["material_id"])
        su.gameObject.transform.parent = self.gameObject.transform
        su.gameObject.transform.localPosition = UnityEngine.Vector3(0,0,0)
        --su.gameObject.transform.localScale = self.bundleParams['childLocalScale']
        su.gameObject.transform.parent = self.gameObject.transform.parent
        self.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)
        su.gameObject.transform.parent = self.gameObject.transform
        --su.gameObject.transform.localScale = UnityEngine.Vector3(localScale.x, localScale.y, localScale.z)
        self.surface = su
        self.surface.gameObject.name = "clouds"
        self.animator = self.surface.gameObject:GetComponent("Animator")
	end
    
    -------------------------上面-------------------------
    local obj = PoolFunc:pickObjByLuaName("RoadSurface") --从内存池中读取
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())

    obj.transform.parent = self.gameObject.transform
    obj.transform.localPosition = UnityEngine.Vector3(0,scale.y/2,0)
    obj.transform.localRotation = Quaternion.Euler(0,0,0)
    obj.transform.localScale = UnityEngine.Vector3(scale.x,0.1,scale.z)
    
    
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = "RoadSurface"
        LuaShell.setPreParams(obj:GetInstanceID(),nil)--预置构造参数
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua:initParam()
    end
    obj:SetActive(true)
    self.upSurface = LuaShell.getRole(obj:GetInstanceID())

    -------------------------下面-------------------------
    obj = PoolFunc:pickObjByLuaName("RoadSurface") --从内存池中读取
    obj:SetActive(false)
    local sub = obj:GetComponent(BundleLua.GetClassType())

    obj.transform.parent = self.gameObject.transform
    obj.transform.localPosition = UnityEngine.Vector3(0,-scale.y/2,0)
    obj.transform.localRotation = Quaternion.Euler(0,0,0)
    obj.transform.localScale = UnityEngine.Vector3(scale.x,0.1,scale.z)
    
    if sub == nil then --第一次创建物体
        sub = obj:AddComponent(BundleLua.GetClassType())
        sub.luaName = "RoadSurface"
        LuaShell.setPreParams(obj:GetInstanceID(),nil)--预置构造参数
    else --重用加载
        local lua = LuaShell.getRole(obj:GetInstanceID())
        lua:initParam()
    end
    obj:SetActive(true)
    
    self.downSurface = LuaShell.getRole(obj:GetInstanceID())
    -------------------------左面-------------------------
 --    local width = 0.1
 --    obj = PoolFunc:pickObjByLuaName("HangingSurface")
 --    obj:SetActive(false)
 --    local sub = obj:GetComponent(BundleLua.GetClassType())
    
 --    obj.transform.parent = self.gameObject.transform
 --    obj.transform.localPosition = UnityEngine.Vector3(-scale.x/2+width/2,0,0)
 --    obj.transform.localRotation = Quaternion.Euler(0,0,0)
 --    obj.transform.localScale = UnityEngine.Vector3(width,scale.y-width,scale.z)

 --    if sub == nil then --第一次创建物体
 --        sub = obj:AddComponent(BundleLua.GetClassType())
 --        sub.luaName = "HangingSurface"
 --        LuaShell.setPreParams(obj:GetInstanceID(),nil)--预置构造参数
 --    else --重用加载
 --        local lua = LuaShell.getRole(obj:GetInstanceID())
 --        lua:initParam()
 --    end
 --    obj:SetActive(true)

 --    -------------------------右面-------------------------
 --    obj = PoolFunc:pickObjByLuaName("HangingSurface")
 --    obj:SetActive(false)
 --    local sub = obj:GetComponent(BundleLua.GetClassType())

	-- obj.transform.parent = self.gameObject.transform
 --    obj.transform.localPosition = UnityEngine.Vector3(scale.x/2-width/2,0,0)
 --    obj.transform.localRotation = Quaternion.Euler(0,0,0)
 --    obj.transform.localScale = UnityEngine.Vector3(width,scale.y-width,scale.z)
    
 --    if sub == nil then --第一次创建物体
 --        sub = obj:AddComponent(BundleLua.GetClassType())
 --        sub.luaName = "HangingSurface"
 --        LuaShell.setPreParams(obj:GetInstanceID(),nil)--预置构造参数
 --    else --重用加载
 --        local lua = LuaShell.getRole(obj:GetInstanceID())
 --        lua:initParam()
 --    end
 --    obj:SetActive(true)

end
--冷藏自身
function MovingSurface:inactiveSelf()
    --self.itemManager:removeObject(self)
    if self.surface ~= nil then
    	PoolFunc:inactiveObj(self.surface)
    end

    if self.upSurface ~= nil then
		PoolFunc:inactiveObj(self.upSurface)
    end

    if self.downSurface ~= nil then
		PoolFunc:inactiveObj(self.downSurface)
    end

    self.super.inactiveSelf(self)
end







