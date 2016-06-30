--[[
author:Desmond
所有item集合,item管理
]]
ItemGroup = class (ObjectGroup)
ItemGroup.name = "ItemGroup" 
ItemGroup.objTab = nil
ItemGroup.rhubarDuckPointArray = nil --大黄鸭飞行点
ItemGroup.revivePointArray = nil
ItemGroup.holyLandingArray = nil

function ItemGroup:addObject(obj)
    if self.objTab == nil then
        self.objTab = {}
    end
    self.objTab[obj.gameObject:GetInstanceID()] = obj
    self.super.addObject(self,obj)
end
function ItemGroup:changeItemByDistance(distance,itemId)
    for k , v in pairs(self.objGroup) do
        if v ~= nil and v.type == "EliminateItemGroup" then
            v:checkChange(distance,itemId)
        end
    end
end
--加入大黄鸭飞行点
function ItemGroup:addDuckPoint(pos)
    if self.rhubarDuckPointArray == nil then
        self.rhubarDuckPointArray = {}
    end
    table.insert(self.rhubarDuckPointArray,pos)
end
--加入神圣模式降落点
function ItemGroup:addHolyLandingPoint(pos)
    if self.holyLandingArray == nil then
        self.holyLandingArray = {}
    end
    table.insert(self.holyLandingArray,pos)
end

--加入重生复活点
function ItemGroup:addRevivePoint(pos)
    if self.revivePointArray == nil then
        self.revivePointArray = {}
    end
    table.insert(self.revivePointArray,pos)
end

--获取比玩家x轴远，但是距离最近那个点
--没有则返回nil
function ItemGroup:getNearestRhubarDuckPointMarkByType(player_x)
    for i=1,#self.rhubarDuckPointArray do
        if self.rhubarDuckPointArray[i].x - player_x >=0 then
            return self.rhubarDuckPointArray[i]
        end
    end
end

--获取比玩家x轴远，但是距离最近那个点
--没有则返回nil
function ItemGroup:getNearestRevivePointMarkByType(player_x)
    for i=1,#self.revivePointArray do
        if self.revivePointArray[i].x - player_x >=0 then
            local point = self.revivePointArray[i]
            table.remove(self.revivePointArray,i)
            return point
            
        end
    end
end
--获取比玩家x轴远，但是距离最近那个点
--没有则返回nil
function ItemGroup:getNearestHolyLandingPointMarkByType(player_x)
    if self.holyLandingArray == nil then
        return nil
    end
    for i=1,#self.holyLandingArray do
        if self.holyLandingArray[i].x - player_x >=0 then
            return self.holyLandingArray[i]
        end
    end
end


--获取比玩家x轴远，但是距离最近那个点
--没有则返回nil
function ItemGroup:getNearestPointMarkByType(pointType)
	local left_x = nil
    local key = nil
    for k,v in pairs(self.objTab) do --遍历group 执行c＃绑定lua update
        if v ~= nil and v.type == pointType and v:getPlayerDistance() > 0 then
            --GamePrint("找到了复活点-- :  "..tostring(v.gameObject.transform.position))
            local x = v.gameObject.transform.position.x
            if left_x == nil or  x < left_x  then
                left_x = x
                key = k
            end
        end
    end
    --[[ --现在只找前面的点
    --如果不是大黄鸭点，没有比玩家远的点，就找最近的点
    if pointType ~= "RhubarbDuckPointMark" and key == nil then
        for k,v in pairs(self.objGroup) do 
            if v ~= nil and v.type == pointType  then
                local x = v.gameObject.transform.position.x
                if left_x == nil or  x < left_x  then
                    left_x = x
                    key = k
                end
            end
        end
    end
    ]]
    if key ~= nil then
        local value = self.objTab[key].gameObject
        self.objTab[key] = nil --移除已经获取过的点
        return value
    end
    return nil
end
