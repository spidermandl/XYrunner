--[[
伊丽莎白举牌状态
]]
ElizabethRaisingState = class (BasePetState) 
ElizabethRaisingState._name = "ElizabethRaisingState"
ElizabethRaisingState.character=nil
ElizabethRaisingState.player = nil  -- 主角
ElizabethRaisingState.state = 0 -- 状态 0 为待机状态 1 为举牌状态

function ElizabethRaisingState:Enter(role)
    self.super.Enter(self,role)
    self.animator = role.character:GetComponent("Animator")
    self.animator:Play("idle")
    self.player = LuaShell.getRole(LuaShell.DesmondID)
    self.state = 0 
end

ElizabethRaisingState.coinDis = 25
ElizabethRaisingState.eDis = 20 
function ElizabethRaisingState:Excute(role,dTime)
    if self.state == 0 then -- 到达距离举牌子
          if role.gameObject.transform.position.x  - self.player.gameObject.transform.position.x < role.dis and role.gameObject.transform.position.x  - self.player.gameObject.transform.position.x >= 0 then
               self.animator:Play("attack")
               self.state = 1
          end
    elseif self.state == 1 then  --  显示金币
        self:CoinShowAction(role)
    end 
end

function ElizabethRaisingState:Exit(role)
	self.super.Exit(self,role)
end

--金币显示
function ElizabethRaisingState:CoinShowAction(role)
  for i=1,#role.coinGroupItem.coinGroupTable do
    if role.coinGroupItem.coinGroupTable[i].gameObject.transform.position.x  - self.player.gameObject.transform.position.x < role.dis and role.coinGroupItem.coinGroupTable[i].gameObject.transform.position.x  - self.player.gameObject.transform.position.x >= 0 then
         role.coinGroupItem.coinGroupTable[i].gameObject:SetActive(true)
         -- local luaObj = LuaShell.getRole(role.coinGroupItem.coinGroupTable[i].gameObject:GetInstanceID())
         if role.itemType == "TreasureItem" then
                 table.remove(role.coinGroupItem.coinGroupTable,i) -- 因为宝箱在生成时当收集物加入 收集物Tab 会触发磁铁效果 所以要从tab移除
         end
         -- print("伊丽莎白创建的收集物 类型 ："..luaObj.itemType)
    end
  end
end