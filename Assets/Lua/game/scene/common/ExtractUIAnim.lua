--[[
author:huqiuxiang
ui 抽取动画 (蛋,宝箱)
]]
ExtractUIAnim = class()
ExtractUIAnim.animPanel = nil -- 动画面板
ExtractUIAnim.effect = nil -- 特效
ExtractUIAnim.iconRoot = nil -- 抽取道具生成的root
ExtractUIAnim.scene = nil -- 抽取类所对应的场景
ExtractUIAnim.sceneView = nil -- 抽取的逻辑类
ExtractUIAnim.sceneTarget = nil -- 对应的buttonTarget
ExtractUIAnim.whiteView = nil -- 白屏
ExtractUIAnim.rewardModel = nil -- 奖品模型贴图
ExtractUIAnim.animType = 1 -- 抽取播放的类型 0 为蛋 1 为宝箱左  2 为宝箱右
ExtractUIAnim.extractType = nil -- 抽取类型 判断单抽 十连抽  1 为单抽 10 为十连抽
ExtractUIAnim.egg = nil -- 蛋模型
ExtractUIAnim.chest_a = nil -- 左边宝箱模型
ExtractUIAnim.chest_b = nil -- 右边宝箱模型
ExtractUIAnim.showItemObj = nil -- 抽到的物品
ExtractUIAnim.showPetModel = nil -- 抽到的物品

-- 初始化
function ExtractUIAnim:init(sceneUI)
	self.sceneView = sceneUI 
	self.scene = sceneUI.scene -- 抽取的逻辑类所对应的uiscene
	self.sceneTarget = sceneUI.sceneTarget -- 抽取的逻辑类所对应的监听类obj
	self.animPanel = self.scene:LoadUI("common/eggAnimPanel")
	-- self.moveRoot = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/moveroot")
	self.iconRoot = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/iconPosition") -- 抽取道具生成的root
	-- self.ef_ui_mc_bg = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/ef_ui_mc_bg")
	--SetEffectOrderInLayer(self.effect,1) -- 设置特效层
	self.animPanel.gameObject:SetActive(false) -- 隐藏
	self.bg = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/bg0")
	self.whiteView = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/white")
	-- self.whiteView.gameObject:SetActive(false)
	self.rewardModel = self.animPanel.transform:FindChild("AnimUI/UI/RewardShow")
	self.showPetModel = self.animPanel.transform:FindChild("AnimUI/UI/RewardShow/RewardShow")
	self.rewardModel.gameObject:SetActive(false)
	self.egg =  self.animPanel.gameObject.transform:FindChild("egg_anim")
	self.chest_a =  self.animPanel.gameObject.transform:FindChild("chest_a_anim")
	self.chest_b =  self.animPanel.gameObject.transform:FindChild("chest_b_anim")
	self:playSuiLieEffect()
end
function ExtractUIAnim:playSuiLieEffect()
	local effectName = "ef_ui_egg_suilie"
	if self.sceneView._name ~= nil and self.sceneView._name == "EquipExtract" then
		effectName = "ef_ui_baoxiang_kai"
	end
	self.effect = self.animPanel.gameObject.transform:FindChild("effect")
	if self.effect ~= nil and self.effect.name == effectName then

	else
		if self.effect~=nil then
			self.effect.gameObject:SetActive(false)
		end
		self.effect = newobject(Util.LoadPrefab("Effects/UI/"..effectName))
		self.effect.gameObject.name = "effect"
		self.effect.transform.parent = self.animPanel.gameObject.transform
		self.effect.transform.localPosition = Vector3(0,0,-187)
		self.effect.transform.localScale = Vector3.one
		SetEffectOrderInLayer(self.effect,1) -- 设置特效层
	end
end
function ExtractUIAnim:SetBgAction(active)
	self.bg.gameObject:SetActive(active)
end

-- 类型判断
function ExtractUIAnim:typeCheck()
	self.egg.gameObject:SetActive(false)
	self.chest_a.gameObject:SetActive(false) 
	self.chest_b.gameObject:SetActive(false)
	-- 根据类型显示相应模型
	--GamePrint("self.animType    :"..self.animType)
	if self.animType == 1 then 
		self.egg.gameObject:SetActive(true)
		self.iconRoot.gameObject.transform.localPosition = Vector3(0,-20,0)
		local effect = self.egg.gameObject.transform:FindChild("ef_ui_choujiang_doudan")
		SetEffectOrderInLayer(effect,4)
	elseif self.animType == 2 then
		self.chest_a.gameObject:SetActive(true)
		local chest_a_animator = self.chest_a.gameObject.transform:GetChild(0):GetComponent("Animator")
		chest_a_animator:Play("open")
		self.iconRoot.gameObject.transform.localPosition = Vector3(0,-39,-200) --  要把ui item放宝箱里
	elseif self.animType == 3 then
		self.chest_b.gameObject:SetActive(true)
		local chest_b_animator = self.chest_b.gameObject.transform:GetChild(0):GetComponent("Animator")
		chest_b_animator:Play("open")
		self.iconRoot.gameObject.transform.localPosition = Vector3(0,-39,-200) --  要把ui item放宝箱里
	end
end

-- 开始播放动画
function ExtractUIAnim:getOkBtn()
	local btn = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/items")
	local okBtn = btn.gameObject.transform:FindChild("OKBtn")
	if okBtn == nil then
		okBtn = btn.gameObject.transform:FindChild("Extract_rewardItemOkBtn")
	end
	return okBtn
end
function ExtractUIAnim:startAnim(finishDelegate,isPet)
	self.animPanel.gameObject:SetActive(true)
	self:typeCheck()
	-- 隐藏特效
	self.effect.gameObject:SetActive(false) 
	-- 隐藏按钮
	local btn = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/items")
	btn.gameObject:SetActive(false)
	local okBtn = btn.gameObject.transform:FindChild("OKBtn")
	if okBtn == nil then
		okBtn = btn.gameObject.transform:FindChild("Extract_rewardItemOkBtn")
	end
	okBtn.name = "Extract_rewardItemOkBtn"
	self.scene:SetButtonTarget(okBtn,self.sceneTarget) -- 给ok按钮 赋监听obj

	-- 清root
	-- if self.iconRoot.gameObject.transform.childCount > 0 then
	-- 	destroy(self.iconRoot.gameObject.transform:GetChild(0).gameObject)
	-- end
	local grid = self.iconRoot:GetComponent('UIGrid')
	grid:Reposition()
	
	self.iconRoot.gameObject:SetActive(false)
	if self.extractType == 1 then

		coroutine.start(ExtractUIAnimDoing,self,finishDelegate,isPet) -- 单抽流程
	elseif self.extractType == 20 then
		coroutine.start(ChapterAnimDoing,self,finishDelegate) -- 播放章节解锁特效
	else
		coroutine.start(ExtractUIAnimTenDoing,self) -- 十连抽流程
	end
	
end

--播放章节解锁特效
function ChapterAnimDoing(selfScene,finishDelegate)
	--local effectTrans = self.animPanel.transform:FindChild("ef_ui_choujiang_bg")
	--effectTrans.gameObject:SetActive(false)
	coroutine.wait(0.5)
	selfScene:creatEffect() -- 播放打开特效
	coroutine.wait(1)
	selfScene.effect.gameObject:SetActive(false)
	selfScene.whiteView.gameObject:SetActive(true)
	coroutine.wait(1)
	selfScene.whiteView.gameObject:SetActive(false)
	finishDelegate(selfScene.scene) -- 动画播放完毕 播放奖励面板
end




-- 动画播放过程 单抽
function ExtractUIAnimDoing(selfScene,finishDelegate,isPet)
	coroutine.wait(1)
	selfScene:creatEffect() -- 播放打开特效
	coroutine.wait(1.5)
	if finishDelegate then
		finishDelegate(selfScene)
	end
	selfScene:animIsOver(isPet) -- 动画播放完毕 播放奖励面板
end

-- 播放特效
function ExtractUIAnim:creatEffect()
	self.effect.gameObject:SetActive(true)
	self.iconRoot.gameObject:SetActive(true) 
	self:iconAnim()
end

-- 弹出items
function ExtractUIAnim:showItems()
	self.iconRoot.gameObject:SetActive(true) 
	self:iconAnim()
end

-- 动画结束 单抽
function ExtractUIAnim:animIsOver(isPet)

	local btn = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/items")
	btn.gameObject:SetActive(true)
	-- 生成特效

	local item_effect = btn.transform:FindChild("effect")
	if item_effect ~= nil then
		item_effect.gameObject:SetActive(false)
	end
	if isPet then
		if item_effect ~= nil then
			item_effect.gameObject:SetActive(true)
		else
			item_effect  = newobject(Util.LoadPrefab("Effects/UI/ef_ui_choujiang_bg"))
			item_effect.gameObject.name = "effect"
			item_effect.transform.parent = btn.transform
			item_effect.transform.localPosition = Vector3.zero
			item_effect.transform.localScale = Vector3.one
		end
	end
end

-- 确定按钮
function ExtractUIAnim:okBtn()
	-- 清item的root
	local count = self.iconRoot.gameObject.transform.childCount
	if self.iconRoot.gameObject.transform.childCount > 0 then
		for i = 1 , count do
			destroy(self.iconRoot.gameObject.transform:GetChild(i-1).gameObject) 
		end
		
	end
	self.animPanel.gameObject:SetActive(false)
	self.rewardModel.gameObject:SetActive(false)
end

-- 播放icon上升动画
function ExtractUIAnim:iconAnim()
	local pos = self.iconRoot.localPosition
	self.iconRoot.localPosition = Vector3(pos.x, 105, pos.z)
	-- 白屏
	local uitween = self.whiteView:GetComponent("UIPlayTween")
	uitween.resetOnPlay = true
	uitween:Play(true)
	self.egg.gameObject:SetActive(false)
	-- if self.iconRoot.gameObject.transform.localPosition.y < 105 then
	-- 	self.iconRoot.gameObject.transform:Translate(0,0.04,0,Space.World)
	-- end
end

-- 获取物品生成root
function ExtractUIAnim:getItemRoot()
	return self.iconRoot.gameObject
end

-- 显示奖品模型
function ExtractUIAnim:ShowRewardModel(enable)
	self.rewardModel.gameObject:SetActive(enable)
	self.egg.gameObject:SetActive(not enable)
	--[[
	local effectTrans = self.animPanel.transform:FindChild("ef_ui_choujiang_bg")
	effectTrans.gameObject:SetActive(true)
	SetEffectOrderInLayer(effectTrans,4) -- 设置特效层
	]]
end

------------------------------------------------------- 十连抽 --------------------------------------------------
-- 动画播放过程
function ExtractUIAnimTenDoing(selfScene)
	coroutine.wait(1)
	selfScene:creatEffect_ten() -- 十连抽动画播放特效
	coroutine.wait(1)
	selfScene:animIsOver_ten() -- 十连抽箱子动画结束 播放白屏
	coroutine.wait(0.5)
	selfScene:showItems_ten() -- 十连抽 播放白屏时显示icon
	coroutine.wait(1)
	selfScene:whiteViewIsOver_ten() -- 十连抽 播放白屏时显示icon
end

-- 十连抽动画播放特效
function ExtractUIAnim:creatEffect_ten()
	self.effect.gameObject:SetActive(true)
end

-- 十连抽箱子动画结束 播放白屏
function ExtractUIAnim:animIsOver_ten()
	-- self.whiteView = self.scene:LoadUI("common/WhiteBgAnimUI")
	-- self.whiteView.gameObject.transform.localPosition = Vector3(0,0,-400)

end

-- 十连抽 播放白屏时显示icon
function ExtractUIAnim:showItems_ten()
	-- print("显示道具")
	self.iconRoot.gameObject:SetActive(true)
	self.iconRoot.gameObject.transform.localPosition = Vector3(0,30,0)
	local btn = self.animPanel.gameObject.transform:FindChild("AnimUI/UI/items")
	btn.gameObject:SetActive(true)
	self:typeCheck_ten() -- 根据类型 隐藏相应的模型
end

-- 类型判断
function ExtractUIAnim:typeCheck_ten()
	if self.animType == 1 then
		self.egg.gameObject:SetActive(false)
	elseif self.animType == 2 then
		self.chest_a.gameObject:SetActive(false)
		self.effect.gameObject:SetActive(false)
	elseif self.animType == 3 then
		self.chest_b.gameObject:SetActive(false)
		self.effect.gameObject:SetActive(false)
	end
end

-- 十连抽 播放白屏时显示icon
function ExtractUIAnim:whiteViewIsOver_ten()
	-- self.whiteView.gameObject:SetActive(false)
end

function ExtractUIAnim:WaitShowItem()
    coroutine.start(self.ShowItemObj,self)
end

function ExtractUIAnim:ShowItemObj()
 	coroutine.wait(2)
	self.rewardModel.gameObject:SetActive(true)
end

-- 没有抽到宠物显示其他icon对象
function ExtractUIAnim:ShowItem(atlasName,spriteName,count)
	self.rewardModel.gameObject:SetActive(false)
	if self.showItemObj == nil then
		self.showItemObj = newobject(Util.LoadPrefab("UI/Activity/GiftItem"))
	end
	--GamePrint("--------"..atlasName)
	--GamePrint("--------"..spriteName)
	local icon = self.showItemObj.transform:Find("icon"):GetComponent("UISprite")
	self.showItemObj.transform:Find("num"):GetComponent("UILabel").text = count
	icon.atlas =  Util.PreLoadAtlas("UI/Picture/"..atlasName)
	icon.spriteName = spriteName
	self.showItemObj.transform.parent = self.rewardModel
	self.showItemObj.transform.localPosition = Vector3.zero
	self.showItemObj.transform.localScale = Vector3.one
	self:WaitShowItem()
	if self.showItemObj.transform:FindChild("ef_ui_mc_bg") == nil then
		local effect = newobject(Util.LoadPrefab("Effects/UI/ef_ui_mc_bg"))
		effect.gameObject.name = "ef_ui_mc_bg"
		effect.transform.parent = self.showItemObj.transform
		effect.transform.localPosition = Vector3.zero
		effect.transform.localScale = Vector3.one
	end
end

-- 是显示萌宠还是物品
function ExtractUIAnim:ShowPetOrShowItem(active)
	if self.showItemObj ~= nil then
		self.showItemObj:SetActive(not(active))
	end
	self.showPetModel.gameObject:SetActive(active)
end