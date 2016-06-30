--[[
  author:Desmond
  吸收物件
  1.可选道具类型
  2.可设置数值
]]
 
ItemConstant = {
    STATIC = 0, --默认静态物件
    FOLLOW = 1, --跟随吸收物件
    MAGNET = 2, --磁铁跟随物件
}
EliminateItem = class(BaseBehaviour)

EliminateItem.item = nil
EliminateItem.collider = nil
EliminateItem.type = nil --收集道具类型
EliminateItem.role = nil --主角实例

EliminateItem.utterAngle=nil

EliminateItem.stateMachine = nil

function EliminateItem:Awake()    
	--print("-----------------EliminateItem Awake--->>>---------------"..tostring(self.bundleParams))

    self.item = self.gameObject.transform:GetChild(0)
    self.item.localPosition = UnityEngine.Vector3(0,0,0)
     
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true
    if self.type == ItemConstant.FOLLOW then --跟随
        self.collider.isTrigger = false
    end
    self.collider.center = UnityEngine.Vector3(0,self.item.transform.localScale.y/2,0)
    local bound = self.item.transform.localScale
    self.collider.size = UnityEngine.Vector3(bound.x,bound.y,bound.z)
    

    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self

end

--启动事件--
function EliminateItem:Start()
    self.role=LuaShell.getRole(LuaShell.DesmondID)
    --print("-----------------EliminateItem Start--->>>-----------------")
    if self.type == ItemConstant.FOLLOW then
    	local dir = UnityEngine.Quaternion.Euler(0, 0, self.utterAngle) * UnityEngine.Vector3(ConfigParam.CoinExplodeRadius,0,0);
    	self.gameObject.transform:Translate(dir.x,dir.y,dir.z, Space.World)
        self.collider.isTrigger = true
        --进入爆破状态
        local explodeS = CoinTailState.new()
        explodeS.player = self.role
        self.stateMachine:changeState(explodeS)
    elseif self.type == ItemConstant.MAGNET then
    --------------------------------秦仕超添加用作磁铁------------------------------------------------------------------------    
        local magnet = ItemMagnetState.new()
        magnet.player = self.role
        self.stateMachine:changeState(magnet)
    -----------------------------------------------------------------------------------------------------------  
    end
end

function EliminateItem:Update()
    self.distance = self.gameObject.transform.position.x - self.role.character.transform.position.x  -- 与主角距离
    if self.distance < ConfigParam.objectDestroyByCameraDis then
        LuaShell.OnDestroy(self.gameObject:GetInstanceID()) --销毁对象
    end
end
function EliminateItem:FixedUpdate()
    self.stateMachine:runState(UnityEngine.Time.fixedDeltaTime)
end


function EliminateItem:OnTriggerEnter( gameObj )
    if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return
    end
    
    LuaShell.OnDestroy(self.gameObject:GetInstanceID())
end

function EliminateItem:doTriggerEnter(role)
    LuaShell.OnDestroy(self.gameObject:GetInstanceID())
    GameObject.Destroy(self.gameObject)
end

-- --静态方法，生成随机吸收物件
-- function createFollowItems(role,num)
--     for k=1 , num do
--     	local obj=GameObject.New()
--         obj:SetActive(false)
--         local item = obj:AddComponent(BundleLua.GetClassType())
--         item.luaName = "EliminateItem"
--         --print ("-----------------------------function createFollowItems(role,num) "..tostring(180-(90*k)/num))
--         LuaShell.setPreParams(obj.gameObject:GetInstanceID(),{ItemConstant.FOLLOW,role.gameObject:GetInstanceID(),180-(180*k)/num})--预置构造参数
--         obj.transform.position = role.gameObject.transform.position
--         obj:SetActive(true)
--     end

-- end


--------生成物品
--1、role；2、物品名；3、luaName 4、位置；
--5、父物体；6、传递的参数
function CreateThings( ... )
    local args={...}
    local character  =
        newobject(Util.LoadPrefab("Items/"..tostring(args[2])))
        character:SetActive(false)
        local item = character:AddComponent(BundleLua.GetClassType())
        character.name="Things"
        item.luaName =args[3]
        if args[6]~=nil then
            LuaShell.setPreParams(character:GetInstanceID(),args[6])--预置构造参数
        end
        character.transform.parent=args[5]
        -- character.transform.rotation=Vector3(0,0,0)
        character.transform.position=args[4]
        character:SetActive(true)
    return character
end

