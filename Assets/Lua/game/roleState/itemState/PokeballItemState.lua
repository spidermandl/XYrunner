--[[
author:huqiuxiang
精灵球碰到状态 PokeballItemState
]]
PokeballItemState = class (IState)

PokeballItemState._name = "PokeballItemState"
PokeballItemState.animator = nil
PokeballItemState.randomItem = 5 --爆出吸收物件数量
PokeballItemState.effect = nil 

function PokeballItemState:Enter(role)
    -- self.animator = role.item:GetComponent("Animator")
    -- self.animator:Play("explode")
    print("精灵球碰到状态")
    local player = LuaShell.getRole(LuaShell.DesmondID)
    -- 生成皮卡丘
    local pet =  newobject(Util.LoadPrefab("Pet/pet_Pikachu"))
    local mX = 7 -- 皮卡丘距离精灵球
    pet.gameObject.transform.position = role.gameObject.transform.position
    pet.gameObject.transform:Translate(mX,0,0,Space.World)   
    pet.transform.rotation = Quaternion.Euler(0,90,0)
end

function PokeballItemState:Excute(role,dTime)
	-- local animInfo = self.animator:GetCurrentAnimatorStateInfo(0)
	-- if animInfo.normalizedTime >= 1.0 then --动画结束
 --        local child = role.gameObject.transform:GetChild(0)
 --        child.gameObject:SetActive(false)
	-- end
end

function PokeballItemState:Exit(role,dTime)
    if self.effect ~= nil then
        GameObject.Destroy(self.effect)
    end
end