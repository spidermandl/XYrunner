--[[
  author:Desmond
  ui 控制父类
]]
BaseUILua = class(BaseBehaviour)

BaseUILua.scene = nil --场景scene
BaseUILua.uiroot = nil --根ui

BaseUILua.effect = nil  -- 屏幕点击特效
BaseUILua.effect_name = "ef_ui_click"

BaseUILua.uiCamera = nil  -- UIRoot下面的2D摄像机
BaseUILua.bButtonEffect= true --是否播放通用的按钮声音

function BaseUILua:Awake()
   -- self:setUpdate(false)
	self.uiroot = find("UI Root")
	self.scene = LuaShell.getRole(find("sceneUI"):GetInstanceID())
	self.effect = nil
	if find('CameraUI') ~= nil then
		self.uiCamera = find('CameraUI'):GetComponent(UnityEngine.Camera.GetClassType())
	else
		self.uiCamera = find('Camera'):GetComponent(UnityEngine.Camera.GetClassType())
	end
end

function BaseUILua:Update()
	if (Input.GetMouseButtonDown(0)) then
		--GamePrintTable("self.roleName == " ..self.roleName)
		--self.dddeee.sd1  = 22
		self:PlayMouseEffect()
	end
end

function BaseUILua:PlayMouseEffect( ... )
	-- body
	if self.effect == nil then
		--self.effect = find(self.effect_name)
		if self.effect == nil then
			self.effect  = newobject(Util.LoadPrefab("Effects/UI/ef_ui_click"))
			self.effect.name = self.effect_name
		end
		--effect = PoolFunc:pickObjByPrefabName("Effects/UI/ef_ui_click")
		SetEffectOrderInLayer(self.effect,100)
	end

	self.effect:SetActive(false)
	if self.uiCamera == nil then
		self.uiCamera = find('CameraUI'):GetComponent(UnityEngine.Camera.GetClassType())
	end

	local  effect_pos = Camera.ScreenToWorldPoint(self.uiCamera,UnityEngine.Vector3(Input.mousePosition.x,Input.mousePosition.y,0)) 
	self.effect.transform.position = effect_pos
   	self.effect.transform.localScale = Vector3.one
	self.effect:SetActive(true)

end
function BaseUILua:OnDestroy()
	GameObject.Destroy(self.effect)
	self.effect = nil
end

--设置update是否执行
function BaseUILua:setUpdate( lock )
	local array = self.gameObject:GetComponents(BundleLua.GetClassType())
	for i=0,array.Length-1 do
		local lua = System.Array.GetValue(array,i)
    	lua.isUpdate = lock
    end
end

--在onclik 里面使用
--播放通用的按钮声音
function BaseUILua:PlayButEffectSound()
	if self.bButtonEffect then
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)
	end
	self.bButtonEffect = true
end

--播放其他按钮的声音
function BaseUILua:PlayOtherEffectSound(effectSound)
		self.bButtonEffect = false
		TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(effectSound)
end

-- 公共的控制名称
function BaseUILua:UIPanelControl(button)
	--print("BaseUILua:UIPanelControl" .. button.name)
	local flag = false -- 监听事件是否成功
	
	if self.scene == nil then
		self.scene = LuaShell.getRole(find("sceneUI"):GetInstanceID())
	end
	local action = button.name
	--print ("action "..action )
	if action == "CommonRewardItemsGetUI_OKBtn" then -- 关闭奖励物品界面
		self.scene:rewardItemsClose()
		flag = true
	elseif action == "CommonPromptUI_Background" then -- 提示板 关闭按钮
        self.scene:promptWordShowClose()
        flag = true
	elseif action == "PlayerTopInfo_BtnReturn" then
		--print("PlayerTopInfo_BtnReturn")
		if self.scene.RetrunDelegate ~=nil then
			self.scene.RetrunDelegate(self.scene)
			--self.scene.RetrunDelegate = nil
		else
			error("self.scene.RetrunDelegate ==nil")
		end
		flag = true
	elseif button.transform.parent.gameObject.name  == "tili" then
		if self.scene.playerTopInfoPanel then
			self.scene.playerTopInfoPanel:AddStrength()
		end
		flag = true
	elseif button.transform.parent.gameObject.name == "coins" then
		if self.scene.playerTopInfoPanel then
			self.scene.playerTopInfoPanel:AddGold()
		end
		flag = true
	elseif button.transform.parent.gameObject.name  == "zuanshi" then
		if self.scene.playerTopInfoPanel then
			self.scene.playerTopInfoPanel:AddDiamond()
		end
		flag = true
	elseif action == "StoreGiftBagBtn" then
		self.scene.storeView:StoreGiftBagBtnOnClick()
		flag = true
	elseif action == "StoreBuildBtn" then
		self.scene.storeView:StoreBuildBtnOnClick()
		flag = true
	elseif action == "StoreResourceBtn" then
		self.scene.storeView:StoreResourceBtnOnClick()
		flag = true
	elseif action == "StorePayBtn" then
		self.scene.storeView:StorePayBtnOnClick()
		flag = true
	elseif action == "StoreCloseBtn" then
		self.scene.storeView:HiddenView()
		flag = true
	elseif action == "StoreBuyBtn" then
		self.scene.storeView:StoreBuyBtnOnClick(button)
		flag = true
	elseif action == "StoreItemInfo" then
		self.scene.storeView:StoreItemInfoOnClick(button)
		flag = true
	elseif action == "ConsultCanleBtn" then
		 self.scene.consultBoxView:close()
		 flag = true
	elseif action == "ConsultOkBtn" then
		self.scene.consultBoxView:OkBtnClick()
		flag = true
	end

	return flag 
end