--[[
  伊丽莎白  
  作者：huqiuxiang
]]
ElizabethPet = class (BasePet)
ElizabethPet.roleName = "Elizabeth"
-- ElizabethPet.player=nil 	 ----------------------主角实例
ElizabethPet.isRaising=false ----------------------是否举牌
ElizabethPet.tarPositon=nil  ----------------------伊丽莎白的位置
ElizabethPet.thingsName="coin" 	 ----------------------牌上的物体名字
ElizabethPet.dis = 10

ElizabethPet.coinGroupTable = nil
ElizabethPet.coinGroupItem = nil 
ElizabethPet.coinPos = nil 
ElizabethPet.coinObj = nil 
ElizabethPet.coinArrange = nil
ElizabethPet.itemType = "" -- 收集物类型
ElizabethPet.typeTab = nil   -- 不同类型存放Tab
ElizabethPet.typeTabNub = 1
ElizabethPet.coinStartn = 1
ElizabethPet.coinPosNub = 0
ElizabethPet.time = 0
ElizabethPet.TargetTime= 6                 ---------当time达到此值时显示金币

function ElizabethPet:Awake()
    self:creatCoinGroup()
end

--启动事件--
function ElizabethPet:Start()
      self.super.Start(self)
      self.stateMachine:changeState(ElizabethRaisingState.new())
end


function ElizabethPet:OnTriggerEnter( gameObj )
end


function ElizabethPet:itweenCallback()
    -- self.super.itweenCallback(self)
end

--创建金币组 ＋ 伊丽莎白物体
function ElizabethPet:creatCoinGroup()
    self.coinGroupTable = {}
    self.coinPos = {}
    self.coinObj = {}
    self.coinArrange = {}
    local obj = newobject(Util.LoadPrefab("Items/CoinGroupInObj"))
    obj.gameObject.transform.parent = self.gameObject.transform
    obj.gameObject.transform.localPosition = Vector3.zero
    self.coinGroupItem = LuaShell.getRole(obj.gameObject:GetInstanceID())

    --读jos数据
    if type(self.bundleParams) == "table" then 

      -- 伊丽莎白物体创建
      self.character = newobject(Util.LoadPrefab("Pet/"..self.roleName))
      self.character.transform.parent=self.gameObject.transform
      self.character.transform.localPosition = UnityEngine.Vector3(0,0,0)
      self.character.transform.localScale = UnityEngine.Vector3(2,2,2)
      self.character.transform.rotation = Quaternion.Euler(0,90,0)
      self.gameObject.name = tostring(self.bundleParams[2])

      -- self.itemType = tostring(self.bundleParams[#self.bundleParams])

      self.itemType = self:typeTabDo() -- 返回随机类型

      self:elizabethChangeSkin() -- 根据类型换贴图

      for i = 4 , #self.bundleParams-1 do
       --print(self.bundleParams[i])
       local array = lua_string_split(self.bundleParams[i],",")
       local itemsType = tostring(array[5])

       if self.itemType == "TreasureItem" and itemsType == self.itemType then -- 宝箱类型
          local treasureBox = newobject(Util.LoadPrefab("Items/treasure_box_item"))
          treasureBox.gameObject.transform.position = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞位置
          treasureBox.gameObject.transform.localScale = Vector3(tonumber(array[4]),tonumber(array[4]),tonumber(array[4]))
          treasureBox.gameObject.transform.parent = obj.gameObject.transform 
          self.coinPosNub = 1
          self.coinGroupItem.coinGroupTable[self.coinPosNub] = treasureBox
          treasureBox.gameObject:SetActive(false)
          return
       end

       if itemsType == self.itemType then   --  收集物
           local coin = newobject(Util.LoadPrefab("Items/"..self.itemType))
           coin.gameObject.transform.parent = obj.gameObject.transform
           coin.gameObject.transform.position = UnityEngine.Vector3(tonumber(array[1]),tonumber(array[2]),tonumber(array[3])) --碰撞位置
           coin.gameObject.transform.localScale = Vector3(tonumber(array[4]),tonumber(array[4]),tonumber(array[4]))

           coin.gameObject.name = "coin"..i
            --添加碰撞
           local collider = coin.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
           collider.isTrigger = false
           collider.center=UnityEngine.Vector3(0,0,0)
           collider.size=Vector3(0.7,0.7,0.7)

           --[[设置刚体]]
           local rigidBody = coin.gameObject:AddComponent(UnityEngine.Rigidbody.GetClassType())
           rigidBody.useGravity = false
           rigidBody.isKinematic = false
           rigidBody.constraints = UnityEngine.RigidbodyConstraints.FreezeAll
           self.coinPosNub = self.coinPosNub + 1
           self.coinPos[self.coinPosNub] = tonumber(array[1]) -- 坐标position添加到table
           self.coinObj[self.coinPosNub] = coin  -- obj 添加到tabel
           self.coinGroupItem.coinGroupTable[self.coinPosNub] = coin
           coin.gameObject:SetActive(false)
       end
       
      end
  
    end

end

-- 伊丽莎白换贴图
function ElizabethPet:elizabethChangeSkin()
     local mater = self.character.transform:Find("Npc_Ylsb"):GetComponent("SkinnedMeshRenderer").material
     if self.itemType == "coin" then
         mater.mainTexture = UnityEngine.Resources.Load("Models/Npc/Npc_Ylsb/Tex/Npc_Ylsb")
     elseif self.itemType == "diamond" then
         mater.mainTexture = UnityEngine.Resources.Load("Models/Npc/Npc_Ylsb/Tex/Npc_Ylsb")
     elseif self.itemType == "TreasureItem" then
         mater.mainTexture = UnityEngine.Resources.Load("Models/Npc/Npc_Ylsb/Tex/Npc_Ylsb")
     else
         mater.mainTexture = UnityEngine.Resources.Load("Models/Npc/Npc_Ylsb/Tex/Npc_Ylsb")
     end
    
end

function ElizabethPet:typeTabDo()
      self.typeTab = {}
      self.typeTab[1] = "null"
      for s = 4 , #self.bundleParams-1 do
           local array = lua_string_split(self.bundleParams[s],",")
           local itemsType = tostring(array[5])
           if self.typeTab[self.typeTabNub] ~= itemsType then
                  self.typeTabNub = self.typeTabNub + 1
                  self.typeTab[self.typeTabNub] = itemsType
           end
      end
      local nub = math.random(2,#self.typeTab)
      -- print("#self.typeTab     "..#self.typeTab)
      return self.typeTab[nub]
end


--金币显示
function ElizabethPet:CoinShowAction()
  for i=1,#self.coinGroupItem.coinGroupTable do
    if self.coinGroupItem.coinGroupTable[i].gameObject.transform.position.x  - self.role.gameObject.transform.position.x < self.dis and self.coinGroupItem.coinGroupTable[i].gameObject.transform.position.x  - self.role.gameObject.transform.position.x >= 0 then
         self.coinGroupItem.coinGroupTable[i].gameObject:SetActive(true)
    end
  end
end

