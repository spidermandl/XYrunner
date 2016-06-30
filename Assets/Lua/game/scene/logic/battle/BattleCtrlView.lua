--[[
author:Desmond
跑酷控制UI
]]
BattleCtrlView = class()

BattleCtrlView.scene = nil --场景scene

BattleCtrlView.uiRolling=nil							--UIRolling的实例
BattleCtrlView.player=nil							--Desmond的实例

-------------------------------------------------UIGame界面控制--------------------------------------------------------------------------
BattleCtrlView.UIGame=nil			--UIGame界面
BattleCtrlView.bloodFront=nil		--血条前板
BattleCtrlView.bloodFrontH=nil		--血条渐变板
BattleCtrlView.bloodNumOldH=0		--血量渐变前的比例值
BattleCtrlView.bloodNums=1			--血量比例值（当前血量与总血量之比）
BattleCtrlView.bloodNumsOld=0		--血量变化前的比例值
BattleCtrlView.targetTime=0			--目标时间（血量变化时的插值时间）
BattleCtrlView.bloodIsChanged=false	--血量是否改变

BattleCtrlView.skillSprite = nil    --技能图标
BattleCtrlView.skillButton = nil    --技能按钮
BattleCtrlView.skillLabel = nil     --技能标签
BattleCtrlView.cupLabel=nil			--奖杯Label
BattleCtrlView.coinLabel=nil			--金币Label


BattleCtrlView.holy = nil --神圣总长度
BattleCtrlView.holyLabel = nil --神圣进度说明

BattleCtrlView.scoreAddition = nil -- 加成得分对象
BattleCtrlView.scoreAdditionValueLabel = nil -- 加成分数显示
BattleCtrlView.addScoreAnimations = nil -- 动画(位移)
BattleCtrlView.tweenScale = nil  -- 缩放动画
BattleCtrlView.scoreAdditionIsShow = false -- 加成的对象是否在显示
BattleCtrlView.scoreAdditionShowTime = 0 -- 显示的时间
BattleCtrlView.skillCdTime = 0  -- 队长主动技能CD时间
BattleCtrlView.skillCdSprite = 0  -- 队长主动技能CD时间
BattleCtrlView.skillStarTime = 0 -- 技能开始时间
BattleCtrlView.skillCDOver = false -- 技能是否结束
BattleCtrlView.cdByTime = true --技能CD按时间及时
--BattleCtrlView.openSpeedUpTime = 0 -- 打开速度提升提示的时间

BattleCtrlView.skillSpriteName = nil --播放的技能名称
BattleCtrlView.petSpriteName = nil --放技能的宠物

BattleCtrlView.skillAminations = nil -- 技能动画
BattleCtrlView.speedUpAminatios = nil -- 速度提升动画

function BattleCtrlView:Awake()
	self.uiRolling = BattleRolling.new()

end

function BattleCtrlView:Start()
	self:initUIGame()
	self:SetScoreAdditionPetIcon()
	
end

--由于场景切换时取消物体活跃，启动后update先运行，所以update中的组件都要判定是否为空
function BattleCtrlView:Update()
	if self.player == nil then
		self.player=LuaShell.getRole(LuaShell.DesmondID)
		return
	end

	-- self.uiRolling:DoRolling()
	self.cupLabel.text = tostring(self.player.score)
	self.coinLabel.text = tostring(self.player.money)
	self:UpdateUIGameGetBlood()
	self:UpdateUIGameBlood()

	self:updateHolyProgress()
	
	if UnityEngine.Time.time - self.scoreAdditionShowTime > 1.5 and self.scoreAdditionIsShow then
		self:TweenPositionCallback()
	end
	--[[
	if UnityEngine.Time.time - self.openSpeedUpTime > 1 then
		self:CloseSpeedUp()
	end
	]]--
	self:UpdataSkillCd()
	
end

function BattleCtrlView:initUIGame()
	-- fjc self.UIGame=self.gameObject:GetComponent("Transform"):Find("UIGame")
	self.UIGame=find("UIGame")--:GetComponent("Transform")--:GetComponent("Transform"):Find("UIGame")
	-- print("fjc-------------self.UIGame.name-------------"..self.UIGame.name)
	self.bloodFront=getChildByPath(self.UIGame,"LeftUp/blood/BloodFront") --self.bloodTrans:Find("BloodFront")
	self.bloodFrontH=getChildByPath(self.UIGame,"LeftUp/blood/BloodFrontH") --self.bloodTrans:Find("BloodFrontH")
	self.cupLabel=getObjectComponent(self.UIGame,"UILabel","LeftUp/cups/Label") --leftUp:Find("cups"):Find("Label"):GetComponent("UILabel")
	self.coinLabel=getObjectComponent(self.UIGame,"UILabel","LeftUp/coins/Label") --leftUp:Find("coins"):Find("Label"):GetComponent("UILabel")

	self.holy = getChildByPath(self.UIGame,"bottom/power/BloodFrontH")
	self.holyLabel = getObjectComponent(self.UIGame,"UILabel","bottom/power/progressLabel") --getUIComponent(power,"progressLabel","UILabel")

	self.skillSprite = getObjectComponent(self.UIGame,"UISprite","LeftDown/BtnSpeedUp") --leftDown:Find("BtnSpeedUp"):GetComponent("UISprite")
	self.skillButton = getObjectComponent(self.UIGame,"UIButton","LeftDown/BtnSpeedUp")--leftDown:Find("BtnSpeedUp"):GetComponent("UIButton")
	self.skillLabel = getObjectComponent(self.UIGame,"UILabel","LeftDown/BtnSpeedUp/Label") --leftDown:Find("BtnSpeedUp"):Find("Label"):GetComponent("UILabel")
	self.skillCdSprite = getObjectComponent(self.UIGame,"UISprite","LeftDown/BtnSpeedUp/Sprite") --leftDown:Find("BtnSpeedUp"):Find("Sprite"):GetComponent("UISprite")
	--self.speedUpObj = self.UIGame:Find("SpeedUp")
	--self:CloseSpeedUp()
	--local bottom = self.UIGame:Find("bottom")
	local battleType = TxtFactory:getValue(TxtFactory.UserInfo,TxtFactory.USER_BATTLE_TYPE) --获取战斗类型
	getChildByPath(self.UIGame,"bottom").gameObject:SetActive(RoleProperty.isHolyOpen and (battleType == 2 or battleType == 4  or battleType == 6))

	self.skillSpriteName = getObjectComponent(self.UIGame,"UISprite","Skill/SkillName")--skill:Find("SkillName"):GetComponent("UISprite")
	self.petSpriteName = getObjectComponent(self.UIGame,"UISprite","Skill/Icon")--skill:Find("Icon"):GetComponent("UISprite")
	--GamePrint("------------"..BundleLua.GetClassType())
	self.skillAminations = getObjectComponent(self.UIGame,TweenPosition.GetClassType(),"Skill/Icon") --skill:GetComponents(TweenPosition.GetClassType())
	self.speedUpAminatios = getObjectComponents(self.UIGame,TweenPosition.GetClassType(),"SpeedUp") --self.UIGame:Find("SpeedUp"):GetComponents(TweenPosition.GetClassType())
	
end

--更新当前血量
function BattleCtrlView:UpdateUIGameGetBlood()
	self.bloodNums=self.player:getStanimaPer()
	if self.bloodNums~=self.bloodNumsOld then
		self:SetBloods(self.bloodNums)
	end
end
function BattleCtrlView:ShowWhite()
	local uitween = getObjectComponent(self.UIGame,"UIPlayTween","whiteBg")--self.whiteBg:GetComponent("UIPlayTween")
    uitween:Play(true)
end

--血量变化
function BattleCtrlView:SetBloods(bloodNum)
    --print ("---------------function BattleCtrlView:SetBloods(bloodNum) "..tostring(bloodNum))
	if bloodNum<0 then
		bloodNum=0 
	end
	if bloodNum>1 then
		bloodNum=1
	end
	if self.bloodFront==nil or self.bloodFrontH==nil then
		return 0
	end
	self.bloodNumsOld=self.bloodFront.localScale.x
	self.bloodNums=bloodNum
	if self.bloodNumsOld-self.bloodNums>RoleProperty.StaminaConsumedSpeedMutation and self.bloodIsChanged==false then
		self.bloodIsChanged=true
		self.bloodNumOldH=self.bloodNumsOld
		self.bloodFrontH.localScale=Vector3(self.bloodNumOldH,1,1)
		self.targetTime=UnityEngine.Time.time
	end
	self.bloodFront.localScale=Vector3(bloodNum,1,1)
	-- print("fjc----------self.bloodFront.localScale----------------"..self.bloodFront.localScale.x)
end

-- 血量渐变
function BattleCtrlView:UpdateUIGameBlood()
	if self.bloodIsChanged and self.bloodFrontH~=nil then
		local TarTime=UnityEngine.Time.time-self.targetTime--UnityEngine.Time.deltaTime
		if TarTime<0.5 then
			TarTime=0
		else
			TarTime=TarTime-0.5
		end
		local bloodH=UnityEngine.Mathf.Lerp(self.bloodNumOldH,self.bloodNums-0.1,TarTime)
		self.bloodFrontH.localScale=Vector3(bloodH,1,1)
		if bloodH<self.bloodNums then
			self.bloodIsChanged=false
			self.bloodFrontH.localScale=Vector3(0,1,1)
		end
	end
end

--[[更新神圣进度]]
function BattleCtrlView:updateHolyProgress()
	if RoleProperty.isHolyOpen == true then
		self.holy.transform.localScale= Vector3(self.player:getHoly()/100,1,1)
		self.holyLabel.text = tostring(math.floor(self.player:getHoly()))..'%' 
	end
end
--设置技能按钮隐藏显示
function BattleCtrlView:setActiveSkillBtn(flg)

	if self.scene.BattleGuideView.isGuideLevel == true then
		return
	end
	getChildByPath(self.UIGame,"LeftDown/BtnSpeedUp").gameObject:SetActive(flg)
	--self.UIGame:Find("LeftDown"):Find("BtnSpeedUp").gameObject:SetActive(flg)
	--GamePrint(self.sdsdsd.aasd2)
end
--更新技能相关信息
function BattleCtrlView:setSkillView(icon_name,num)
	if icon_name ~= nil then
		self.skillSprite.spriteName = icon_name
		self.skillButton.normalSprite = icon_name
		self.skillButton.hoverSprite = icon_name
		self.skillButton.pressedSprite = icon_name
		-- self.skillButton.disabledSprite = 'jinengtb2'
		--self.skillButton.isEnabled = true
	else
		self.skillSprite.spriteName = 'jinengtb2'
		self.skillButton.normalSprite = 'jinengtb2'
		self.skillButton.hoverSprite = 'jinengtb2'
		self.skillButton.pressedSprite = 'jinengtb2'
		--self.skillButton.isEnabled = false
	end

	if num ~=nil then
		self.skillLabel.text = num
	end
end

function BattleCtrlView:SetInvisible()
	self.UIGame.gameObject:SetActive(false)
end
-------------------------------------------------数字滚动接口-------------------------------------------------------------------

--添加数字滚动
function BattleCtrlView:AddRolling(labelName,labelType,targetLabel,from,to,allTime)
	self.uiRolling:AddRolling(labelName,labelType,targetLabel,from,to,allTime)
end

--停止指定labelName滚动
function BattleCtrlView:StopRolling(labelName)
	self.uiRolling:StopRolling(labelName)
end

--停止所有滚动
function BattleCtrlView:StopRollingAll()
	self.uiRolling:StopRollingAll()
end


-- 获取到当前可以加成得分的宠物
function BattleCtrlView:GetScoreAdditionPetIds()
	local pets = {}
	
	local petTable = TxtFactory:getTable(TxtFactory.MountTXT)
    local  petTab = TxtFactory:getTable(TxtFactory.MemDataCache):getCurPetTab()
    -- print("上次萌宠数量"..petTab[1])
    local petid_index = 1
    for i =1, #petTab do
        --local id = self.petTable:GetData(i,'ID')
        
        local COLLECTIONS_SCORE = petTable:GetData(petTab[i],"COLLECTIONS_SCORE")
		local ADDATKSC= petTable:GetData(petTab[i],"ADDATKSC")
		if tonumber(COLLECTIONS_SCORE) ~= 0 or tonumber(ADDATKSC) ~= 0 then
			-- 有加成
			pets[petid_index] = petTab[i]
			petid_index = petid_index + 1
		end
    end
	return pets
end

-- 设置当前可以加成得分对象里面的宠物Icon
function BattleCtrlView:SetScoreAdditionPetIcon()
	local petTable = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	local petIds =  self:GetScoreAdditionPetIds()
	if #petIds == 0 then
		return
	end
	
	self.scoreAddition = getChildByPath(self.UIGame,"ScoreAddition_"..#petIds)
	self.scoreAdditionValueLabel = getObjectComponent(self.UIGame,"UILabel","ScoreAddition_"..#petIds.."/Label")
	--self.scoreAddition:Find("Label"):GetComponent("UILabel")
	self.addScoreAnimations = getObjectComponents(self.UIGame,TweenPosition.GetClassType(),"ScoreAddition_"..#petIds) 
	--self.scoreAddition:GetComponents(TweenPosition.GetClassType())
	self.tweenScale = getObjectComponent(self.UIGame,"TweenScale","ScoreAddition_"..#petIds)
	--self.scoreAddition:GetComponent("TweenScale")
	for i =1 ,#petIds do
		local ctid = tonumber(string.sub(tostring(petIds[i]),1,-5)) 
		local petIconName = petTable:GetData(ctid,"FIGHT_ICON")
		-- local iicon = self.scoreAddition:Find("Icon"..i)
		-- iicon:GetComponent("UISprite").spriteName = petIconName
		getObjectComponent(self.UIGame,"UISprite","ScoreAddition_"..#petIds.."/Icon"..i).spriteName = petIconName
		--[[
		if petIconName == nil then
			GameWarnPrint("找不到战斗图片..FIGHT_ICON"..tostring(ctid).."|| petIds[i] ="..tostring(petIds[i]))

		else
			if iicon == nil then
				iicon:GetComponent("UISprite").spriteName = petIconName
			end
		end
		]]--
	end
	
end

-- 设置当前可以加成得分对象里面的数值
function BattleCtrlView:SetScoreAdditionValue(addScoreValue)
	if self.scoreAddition == nil then -- 没有可以加成的宠物
		return
	end
	if self.scoreAdditionIsShow then
		return
	end
	self.scoreAddition.gameObject:SetActive(true)
	self.scoreAdditionValueLabel.text = addScoreValue
	-- 播放动画(播放结束隐藏GameObject)
	--self.tweenPosition:ResetToBeginning()
	--self.tweenPosition:PlayForward()  
	
	local length = self.addScoreAnimations.Length-1 
	for i=0,length do
		local tweenPosition = System.Array.GetValue(self.addScoreAnimations,i)
		--render.sortingOrder = order
		tweenPosition:ResetToBeginning()
		tweenPosition:PlayForward() 
	end
	
	
	self.tweenScale:ResetToBeginning()
	self.tweenScale:PlayForward()  
	   
	self.scoreAdditionIsShow = true
	self.scoreAdditionShowTime = UnityEngine.Time.time 
	
end

-- 动画结束后处理的逻辑
function BattleCtrlView:TweenPositionCallback()
	self.scoreAdditionIsShow = false
	self.scoreAddition.gameObject:SetActive(false)
end

-- 设置队长主动技能冷却时间
function BattleCtrlView:SetSkillCDTime(cdTime,notTime)
	if cdTime == nil then
		error("技能CD时间为nil")
		return
	end
	self.skillCdTime = 1/cdTime
	self.skillCdSprite.fillAmount = 1
	self.skillStarTime = UnityEngine.Time.time
	self.skillCDOver = true
	if notTime then
		self.cdByTime = false
	else
		self.cdByTime = true
	end
end
-- 根据值减少技能cd
function BattleCtrlView:ReduceSkillCd(value)
	if not(self.skillCDOver) or self.cdByTime then
		return
	end
	self.skillCdSprite.fillAmount = self.skillCdSprite.fillAmount - value
	if self.skillCdSprite.fillAmount <=0 then
		self.skillCDOver = false
	end
end
-- 更新技能遮罩面积
function BattleCtrlView:UpdataSkillCd()
	if not(self.skillCDOver) or not(self.cdByTime) then
		return
	end
	local time = UnityEngine.Time.time
	self.skillCdSprite.fillAmount = 1 - (self.skillCdTime*(time-self.skillStarTime))
	if self.skillCdSprite.fillAmount <=0 then
		self.skillCDOver = false
	end
end

-- 设置速度提升
function BattleCtrlView:OpenSpeedUp()
	--self.speedUpObj.gameObject:SetActive(true)
	--self.openSpeedUpTime = UnityEngine.Time.time
	-- 播放动画
	--GamePrint("速度改变")
	local length = self.speedUpAminatios.Length-1 
	for i=0,length do
		local tweenPosition = System.Array.GetValue(self.speedUpAminatios,i)
		--render.sortingOrder = order
		tweenPosition:ResetToBeginning()
		tweenPosition:PlayForward() 
	end
end

--[[
function BattleCtrlView:CloseSpeedUp()
	--self.speedUpObj.gameObject:SetActive(false)
end
]]--

-- 放技能显示ui动画 skillid(播放的技能id) petid(宠物id)
function BattleCtrlView:PlaySkillAmination(skillid,petid)
	
	-- 设置宠物的头像 技能名
	local petskillData = TxtFactory:getTable(TxtFactory.PetSkillMainTXT) --宠物主动技能表
	self.skillSpriteName.spriteName = petskillData:GetData(skillid,"SKILL_NAME_ICON")
	local petData = TxtFactory:getTable(TxtFactory.MountTypeTXT)
	self.petSpriteName.spriteName=petData:GetItemIcon(petid,"PetIcon")
	-- 播放动画
	local length = self.skillAminations.Length-1 
	for i=0,length do
		local tweenPosition = System.Array.GetValue(self.skillAminations,i)
		--render.sortingOrder = order
		tweenPosition:ResetToBeginning()
		tweenPosition:PlayForward() 
	end
end
