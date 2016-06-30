--[[
     PetForSettlement 结算怪生成管理
     作者：胡秋翔
]]

PetForSettlement = class ()

function PetForSettlement:searchPet()
	local petName = nil
	local role = LuaShell.getRole(LuaShell.DesmondID)
    -- print("role"..tostring(role))
    for i , v in ipairs(role.property.PetTabel) do -- 遍历结算宠
        if v == "LittleBear" then
             petName = v
             self:creatPet(petName)
        end
    end
	
end

function PetForSettlement:creatPet(petName)
    local pet=GameObject.New()
    pet:SetActive(false)
    local item = pet:AddComponent(BundleLua.GetClassType())
    -- local petName=role.property.PetFlightName
    item.luaName = PetFollowerName[petName]
    pet:SetActive(true)

    pet.transform.position = Vector3(-1.3,-0.5,0)
end