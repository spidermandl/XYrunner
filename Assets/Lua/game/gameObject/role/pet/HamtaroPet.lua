--[[
  哈姆太郎
  作者：huqiuxiang
]]
HamtaroPet = class (BasePet)
HamtaroPet.roleName = "hamtaro"
HamtaroPet.player=nil 	 ----------------------主角实例

function HamtaroPet:Awake()
    self:ObjCreat()
end

--启动事件--
function HamtaroPet:Start()
	self.super.Start(self)
    self.stateMachine:changeState(HamtaroThrowingItemsState.new()) 
end



function HamtaroPet:OnTriggerEnter( gameObj )
end

function HamtaroPet:itweenCallback()
end

function HamtaroPet:ObjCreat()
	--[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character  = --newobject(ioo.LoadPrefab("Monster/"..self.roleName))
        -- newobject(Util.LoadPrefab("Pet/"..self.roleName))
        newobject(Util.LoadPrefab("Pet/LittleBear"))
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
        self.character.transform.localScale = UnityEngine.Vector3(2,2,2)
        self.character.transform.rotation = Quaternion.Euler(0,90,0)
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
end
