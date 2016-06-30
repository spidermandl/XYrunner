--[[
author:Desmond
面板父类
]]
BaseSurface = class (BaseBehaviour)

BaseSurface.surface = nil
BaseSurface.collider = nil
BaseSurface.type = "surface" --关卡物件类型
BaseSurface.left_x = 0 --平面最左端
BaseSurface.surfaceChildModel = nil --子物体

BaseSurface.surfaceManager = nil --平面管理器

function BaseSurface:Awake()
    self.surfaceManager = PoolFunc:pickSingleton("SurfaceGroup") --获取怪物管理器
    local lua = self.gameObject:GetComponent(BundleLua.GetClassType()) --移除lua update
    lua.isUpdate = false

    self:initParam()
end

--初始化参数 外部调用
function BaseSurface:initParam()
    self.surfaceManager:addObject(self) --加入面板
    if self.bundleParams == nil then
        return
    end
    self.left_x = self.bundleParams['left_x']

end

function BaseSurface:Update()
    --[[
        按照与主角的距离删除对象
    ]]
    if self.role == nil then
        self.role = LuaShell.getRole(LuaShell.DesmondID) 
        return
    end
    
    local distance = 2 * self.gameObject.transform.position.x - self.left_x - self.role.gameObject.transform.position.x  -- 与主角距离
    if distance < ConfigParam.objectDestroyByCameraDis then
        --LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁敌对象
        --PoolFunc:inactiveObj(self.gameObject)
        self:inactiveObj()
    end

end

--冷藏自己
function BaseSurface:inactiveObj()
    --关闭动画
    if self.bundleParams ~= nil and self.bundleParams['path'] ~=nil then
        iTween.Stop(self.gameObject)
    end

    self.surfaceManager:removeObject(self)
end

--播放路径动画
function BaseSurface:playPathAnim()
    local paths = self.bundleParams['path']
    if paths == nil then
        return
    end
    
    local path = paths[1]
    local itweenSpeed = tonumber(path['speed'])
    local itweenDelayTime = tonumber(path['delay'])
    local itweenLoopType = path['loopType']
    local itweenEaseType = path['easeType']
    if path['rotateAngle'] ~= nil then
        local array = lua_string_split(path['rotateAngle'],",")
        self.itweenRotateAngle = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3]))
    end
    local itweenNodePath = {}
    local nodes = path['nodes']
    for i=1,#nodes do --初始化 itemGroup
        array = lua_string_split(nodes[i],",") --参数间分割符
        --print (tostring(nodes[i]))
        table.insert(itweenNodePath,
            UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])))
    end


    local param = System.Collections.Hashtable.New()

    local nodePath = System.Array.CreateInstance(UnityEngine.Vector3.GetClassType(),#itweenNodePath)
    for i=1,#itweenNodePath do
        itweenNodePath[i] = self.gameObject.transform.position + itweenNodePath[i]
        nodePath:SetValue(itweenNodePath[i],i-1)
    end
    param:Add('path',nodePath)
    param:Add('speed',itweenSpeed)
    param:Add('easeType',itweenEaseType)
    param:Add('loopType',itweenLoopType)
    param:Add('delay',itweenDelayTime)
    --print (self.gameObject.name)
    iTween.MoveTo(self.gameObject, param)
    --self.gameObject.transform:Translate(0,10,0)
end


