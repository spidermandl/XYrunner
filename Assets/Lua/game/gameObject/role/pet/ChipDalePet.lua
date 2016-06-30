--[[
  author：huqiuxiang
  松鼠大作战 ChipDalePet
  玩家遇到后扔出一个巨大的苹果，可以用冲刺技能击碎，如果击碎会暴出大量收集物（修改：跳跃触发）
]]

ChipDalePet = class (BasePet)
ChipDalePet.roleName = "chipDale"
ChipDalePet.player=nil 	 ----------------------主角实例

function ChipDalePet:Awake()
    self.super.Awake()
end

--启动事件--
function ChipDalePet:Start()
	self.super.Start(self)
    self.super.BaseScenePetCreat(self,LuaShell.getRole(LuaShell.DesmondID))
    self.stateMachine:changeState(ChipDaleThrowingItemState.new()) 
end


function ChipDalePet:OnTriggerEnter( gameObj )
end

function ChipDalePet:itweenCallback()
end

-- 两只不同模型的松鼠 作不同处理 （标记）
function ChipDalePet:init()
	--[[设置角色]]
    if self.gameObject.transform:Find(self.roleName) == nil then
        self.character  = newobject(Util.LoadPrefab("Pet/"..self.roleName))
        self.character.transform.parent=self.gameObject.transform
        self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
        self.character.transform.localScale = UnityEngine.Vector3(2,2,2)
        self.character.transform.rotation = Quaternion.Euler(0,90,0)
    else
        self.character = self.gameObject.transform:Find(self.roleName)
    end
end