--[[
坐骑基类
作者：秦仕超
]]

BaseMount=class(BaseBehaviour)


BaseMount.character =nil  --prefab
BaseMount.animator = nil
BaseMount.roleName =nil
BaseMount.stateMachine = nil
-- BaseMount.parent=nil
BaseMount.rotation=nil
BaseMount.position=nil


BaseMount.player=nil                         ----主角实例
function BaseMount:Awake()
    print("-----------------BasePet Awake--->>>-----------------")
    -- [[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character  = --newobject(ioo.LoadPrefab("Pet/"..self.roleName))
        newobject(Util.LoadPrefab("Pet/"..self.roleName))
        self.character.name=self.roleName
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.rotation=self.rotation
        self.character.transform.position= self.position
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
    
    
end



-- 启动事件--
function BaseMount:Start()
    self.stateMachine = StateMachine.new()
    self.stateMachine.role = self
end

function BaseMount:Update()
end

function BaseMount:FixedUpdate()
	self.stateMachine:runState(UnityEngine.Time.deltaTime)
end

--动态创建 pet--
--[[
role: 主角
position:生成位置
]]
function  createMount(role,position,luaName)
    if position~=nil then
        local pet=GameObject.New()
        pet.name="MountParent"
        pet:SetActive(false)
        local item = pet:AddComponent(BundleLua.GetClassType())
        item.luaName = luaName
        pet:SetActive(true)
        
        pet.transform.position = role.gameObject.transform.position
        pet.transform.parent = role.gameObject.transform.parent
        pet.gameObject.transform.localScale = UnityEngine.Vector3(1,1,1)
        return LuaShell.getRole(pet:GetInstanceID())
    end
    return nil

end