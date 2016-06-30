--[[
author:gaofei
选择驻守萌宠界面
]]

SnatchPetDefendView = class ()

SnatchPetDefendView.scene = nil --场景scene
SnatchPetDefendView.panel = nil -- 界面

SnatchPetDefendView.petItems = nil -- 存放每个宠物对象

-- 初始化
function SnatchPetDefendView:init(targetScene)
	self.scene = targetScene
	self.panel = newobject(Util.LoadPrefab("UI/Snatch/SnatchPetDefend"))
	self.panel.transform.parent = self.scene.uiRoot.gameObject.transform
    self.panel.transform.localPosition = Vector3.zero
    self.panel.transform.localScale = Vector3.one
    self.grid = self.panel.transform:Find("Anchors/UI/Scroll View/Grid")
    --self.scene:boundButtonEvents()
	
end

-- 初始化数据
function SnatchPetDefendView:InitData()
	self:ClearRivalInfoItems()
	
	local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
	local petTab = petInfo[TxtFactory.BIN_PETS]
		-- 已经召唤的
        
    ---  测试代码
    local defendPets  = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)
    
    for i = 1 , #defendPets do
        printf("gaofei ===="..defendPets[i])
    end
    
    
	for i = 1, #petTab do 
		local tid = petTab[i].tid
		local icon = self:creatPetIcon(tid,self.grid,self.panel,self:CheckPetState(petTab[i].id))
		icon.name = petTab[i].id
        self.petItems[i] = icon
	end
     local itemGrid = self.grid:GetComponent("UIGrid")
	itemGrid:Reposition()
	itemGrid.repositionNow = true
    self.scene:boundButtonEvents(self.panel)
end


-- 创建萌宠小icon
function SnatchPetDefendView:creatPetIcon(tid,grid,target,pet_state)
    local petTable = TxtFactory:getTable("MountTypeTXT")
    local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
    local ctid = _txt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
    local starNum = _txt:GetData(tid, TxtFactory.S_MOUNT_STAR) -- 星级
    local level = _txt:GetData(tid, TxtFactory.S_MOUNT_LVL) -- 等级

    local icon = newobject(Util.LoadPrefab("UI/Pet/MypetIcon"))
    icon.gameObject.transform.parent = grid.gameObject.transform
    icon.gameObject.transform.localScale = Vector3(1,1,1)
     -- 添加按钮监听脚本
    local  seletePetIcon = icon.gameObject.transform:FindChild("SeletePetIcon")
    local  bm = seletePetIcon.gameObject:AddComponent(UIButtonMessage.GetClassType())
  --  bm.target = self.sceneTarget -- target.gameObject
    bm.functionName = "OnClick"
    bm.trigger = 0

    local starGrid = icon.gameObject.transform:FindChild("starGrid")
    local starGridCo = starGrid.gameObject.transform:GetComponent("UIGrid")
    for i=0, starGrid.childCount-1 do
        starGrid:GetChild(i).gameObject:SetActive(i < starNum)
    end
    starGridCo:Reposition() -- 自动排列

    -- 品质更改外框
    local rankData = petTable:GetData(ctid,"RANK_ICON")
    local rankIcon = icon.gameObject.transform:FindChild("iconback"):GetComponent("UISprite")
    rankIcon.spriteName = rankData
    -- GetComponent<UISprite>().spriteName

    -- 名字更改
    local nameData = petTable:GetData(ctid,"NAME")
    local nameLabel = icon.gameObject.transform:FindChild("name").gameObject.transform:GetComponent("UILabel")
    nameLabel.text = nameData

    -- 信息按钮
    local infoBtn = icon.gameObject.transform:FindChild("petIconInfoBtn")
    local infoBtnMes = infoBtn.gameObject.transform:GetComponent("UIButtonMessage")
    infoBtnMes.target = self.sceneTarget --target.gameObject

    -- 碎片
    local pieceNum = icon.gameObject.transform:FindChild("pieceNum")
    pieceNum.gameObject:SetActive(false)

    -- icon设置
    local iconPic = icon.gameObject.transform:FindChild("icon"):GetComponent("UISprite")
    iconPic.spriteName = petTable:GetData(ctid,"PET_ICON")
    
    local levelLabel = icon.transform:FindChild("levelLabel")-- 更新等级信息
    levelLabel.gameObject:SetActive(true)
    local plabel = levelLabel:GetChild(0):GetComponent("UILabel")
	plabel.text = "lv." .. tostring(level)
    
    local joinTag = icon.transform:FindChild("tag") -- 上场标识
	joinTag.gameObject:SetActive(pet_state ~= 0)

    return icon
end

-- 清除数据
function SnatchPetDefendView:ClearRivalInfoItems()
	if self.petItems ~= nil then
		for i = 1 , # self.petItems do
			if self.petItems[i] ~= nil then
				GameObject.Destroy(self.petItems[i])
			end
		end
	end
	self.petItems = {}
end

-- 点击宠物上阵
function SnatchPetDefendView:SeletePetIconOnClick(obj)
 --   printf("buttonName==="..obj.transform.parent.name)
    
  --  if self:CheckPetState()
    local pet_index = self:CheckPetState(tonumber(obj.transform.parent.name))
    if pet_index ~= 0 then
        -- 下阵
        local defendPets  = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)
        defendPets[pet_index] = 0
        TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS,defendPets)
    else
        -- 上阵
        self:CheckEmptyPlace(tonumber(obj.transform.parent.name))
    end
    -- 刷新据点界面
    self.scene:StrongholdRefreshDefendPet()
    self:HiddenView()
end

-- 判断该宠物有没有上阵
function SnatchPetDefendView:CheckPetState(pet_id)
    local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)  
    local defendPets  = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)
    
    local pet_index = 0
    for i = 1 , #defendPets do
        if defendPets[i] == pet_id then
            -- 已经上阵(点击为下阵)
          --  pet_index = i
           -- defendPets[i] = 0
           -- TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS,defendPets)
            return i
        end
    end
    return 0
end

-- 判断有没有位置可以添加
function SnatchPetDefendView:CheckEmptyPlace(pet_id)
    local petInfo = TxtFactory:getMemDataCacheTable(TxtFactory.PetInfo)
    local defendPets  = TxtFactory:getValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS)
    for i = 1 , #defendPets do
        if defendPets[i] == 0 then
            -- 有空位置添加
            defendPets[i] = pet_id
            TxtFactory:setValue(TxtFactory.SnatchInfo,TxtFactory.SNATCH_DEFENGPETS,defendPets)
            return true
        end
    end
    return false
end

--激活暂停界面
function SnatchPetDefendView:ShowView()
	self.panel:SetActive(true)
end

-- 冷藏界面
function SnatchPetDefendView:HiddenView()
	self.panel:SetActive(false)
end