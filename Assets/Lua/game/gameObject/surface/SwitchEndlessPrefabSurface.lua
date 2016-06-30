SwitchEndlessPrefabSurface = class(BaseSurface)
SwitchEndlessPrefabSurface.type = "SwitchEndlessPrefabSurface"
SwitchEndlessPrefabSurface.role = nil --主角

function SwitchEndlessPrefabSurface:Awake()
	self.gameObject.name = self.type
    
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = false
    self.collider.center=UnityEngine.Vector3(0,0,0)

    self.super.Awake(self)
end

function SwitchEndlessPrefabSurface:initParam()
    self.super.initParam(self)
end

--启动事件--
function SwitchEndlessPrefabSurface:Start()
    --print("-----------------RoadSurface Start--->>>-----------------")
    if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
        if ConfigParam.isSceneObjLoadDynamic == false then
            destroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
            destroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
        end
    end
    
end


function SwitchEndlessPrefabSurface:OnCollisionEnter( collision )
	--print("-----------------RoadSurface OnCollisionEnter--->>>-----------------")
	if collision.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --非与主角碰撞
        -- 注了下面两行为了 金币的collider.isTrigger为false  人能吃到金币
        -- local collider = collision.gameObject:GetComponent("BoxCollider")
        -- collider.isTrigger = true
		return
	end

end
