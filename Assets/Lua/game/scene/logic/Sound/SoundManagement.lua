--[[
author:sunkai
跑酷声音
]]
SoundManagement = class()
SoundManagement.tag = "SoundManagement"
SoundManagement.effectVolume = nil --特效音量
SoundManagement.backVolume = nil --背景音量

SoundType = {}
SoundType.button = 1	--点击按钮
SoundType.forest  = 2	--	森林音乐
SoundType.desert = 3	--	沙漠音乐
SoundType.cave  = 4	--	洞窟音乐
SoundType.seaside  = 5	--	海边音乐
SoundType.cornfield  = 6	--	麦田音乐
SoundType.Town  = 7	--	小镇音乐
SoundType.main  = 8	--	城建主界面
SoundType.popupbox_open  = 9	--	弹出框开启
SoundType.popupbox_close	 = 10	--弹出框关闭
SoundType.resource_get  = 11	--	获得奖励、资源
SoundType.levelup = 12	--	【升级、合成】成功
SoundType.variation_success = 13	--	融合变异（强宠）
SoundType.buy_success = 14	--	购买资源、道具成功
SoundType.recharge_success = 15	--	充值成功
SoundType.gacha_10 = 16	--	十连抽
SoundType.gacha_1 = 17	--	单抽（暂用）
SoundType.rangeup = 18	--	角色排名上升、超越
SoundType.buliding_levelup = 19	--	建筑升级成功
SoundType.buliding_move = 20	--	建筑移动成功
SoundType.map_clean = 21	--	清楚地图障碍物（石头、树木）
SoundType.buliding_collect = 22	--	建筑收集金币成功
SoundType.run_attack	 = 23	--角色攻击
SoundType.run_jump = 24	--	角色跳跃
SoundType.run_skill = 25	--	角色释放技能
SoundType.run_collect = 26	--	搜集物品
SoundType.run_bigcoin = 27	--	触发宏金币
SoundType.run_hurt = 28	--	角色受伤
SoundType.item_shield = 29	--	道具-护盾、磁铁、冲击波
SoundType.item_invincible = 30	--	道具-无敌
SoundType.item_duck = 31	--	道具-大黄鸭
SoundType.result_success = 32	--	结算界面-成功
SoundType.result_falid = 33	--	结算界面-失败
SoundType.result_score = 34	--	结算界面-分数跳动


--初始化
function SoundManagement:Init()

	-- local obj  = GameObject.New()
	-- obj.name = "AudioSound"
	-- self.AudioSound = obj:AddComponent(UnityEngine.AudioSource.GetClassType())
	
	--  GameObject.DontDestroyOnLoad(obj)
	--  self.AudioEffect = {}
	--  self.AudioEffectNum = 3
	--  local effectObj = nil
	--  for i = 1, self.AudioEffectNum do 
	-- 	effectObj= GameObject.New()
	-- 	effectObj.name = "AudioEffect"
	-- 	self.AudioEffect[i] = obj:AddComponent(UnityEngine.AudioSource.GetClassType())
	-- 	effectObj.transform.parent = obj.transform
	-- end
	-- self.AudioEffectIndex = 1
	-- self.TableData =  TxtFactory:getTable(TxtFactory.SoundTXT)

	if Util.HasKey("AudioEffect") == true then
		self:SetEffectVolume(tonumber(Util.GetString("AudioEffect")))
	else
		self:SetEffectVolume(0.5)
	end
	
	if Util.HasKey("AudioSound") == true then
		self:SetSoundVolume(tonumber(Util.GetString("AudioSound")))
	else
		self:SetSoundVolume(0.5)
	end
end

--播放背景音乐
function SoundManagement:PlayBackGroundSound(MusicId)
	local data = TxtFactory:getTable(TxtFactory.SoundTXT)
	local name = data:GetData(MusicId, "SOUND_NAME")
    Util.PlayBackGroundSound('Sound/background/'..name)
end

--播放音效
function SoundManagement:PlayEffect(MusicId,position,volume)
	local data = TxtFactory:getTable(TxtFactory.SoundTXT)
	local name = data:GetData(MusicId, "SOUND_NAME")
	local clip = Util.LoadAudioClipByPath('Sound/sound/',name)
	--clip.loop = tonumber(data:GetData(id, "LOOP")) == 1
	if position == nil then
		position = Vector3.zero
	end
	if volume == nil then
		volume = self.effectVolume
	end
    Util.PlayEffectSound(clip,position,volume)

end

-- 设置音效音量
function SoundManagement:SetEffectVolume(volume)
	Util.SetString("AudioEffect", tostring(volume))
	self.effectVolume = volume
end


-- 设置背景音乐音量
function  SoundManagement:SetSoundVolume(volume)
	Util.SetString("AudioSound", tostring(volume))
	Util.SetSoundVolume(volume)
end






