--[[
author:Desmond
http返回消息分发
]]
MsgFactory = {}

-- MsgFactory.MesId = 0 -- 发送消息序列号 1 为游客注册， 2 为用户密码注册 3 登陆验签 4 获取服务器列表 5 创建角色  6 获取角色信息
-- MsgFactory.UISuitScene = nil -- ui坐骑 套装 逻辑类
-- MsgFactory.UILogInScene = nil -- ui登陆 
-- MsgFactory.UIEquipScene = nil -- ui装备
-- MsgFactory.callback = nil --消息接受回调对象

MsgFactory.msgTable = {}

function MsgFactory:createMsg(msgid,callback,funName,msgObj) -- funName 消息回调函数名字
	--print ("----------------------MsgFactory:createMsg "..tostring(msgid))
	local msg = self.msgTable[msgid]



	if msg == nil then
		if msgObj ~= nil then
			msg = msgObj
			--self.msgTable[msgid] = msg
		else
			if msgid == MsgCode.GuestMsg then
				msg = GuestMsg.new()
		         
			elseif msgid == MsgCode.RegisterMsg then
		        msg = RegisterMsg.new()

			elseif msgid == MsgCode.LoginMsg then
				msg = LoginMsg.new()

			elseif msgid == MsgCode.XYLoginMsg then
				msg = LoginMsg.new()
			
		elseif msgid ==MsgCode.SDKLoginMsg then
			msg = LoginMsg.new()

			elseif msgid == MsgCode.ServerListMsg then
		        msg = ServerListMsg.new()

			elseif msgid == MsgCode.RegisterResponse then
		        msg = RoleCreatMsg.new()

			elseif msgid == MsgCode.GetCharInfoResponse then
		        msg = RoleInfoGetMsg.new()

		    elseif msgid == MsgCode.SelectAvatorResponse then
		        msg = SuitSelectMsg.new()

		    elseif msgid == MsgCode.UpgradeAvatorResponse then
		        msg = SuitLevelUp.new()

		    elseif msgid == MsgCode.SelectHorseResponse then
		        msg = MountSelectMsg.new()

		    elseif msgid == MsgCode.EquipsListResponse then
		        msg = EquipInfoGetMsg.new()

		    elseif msgid == MsgCode.UnlockSlotResponse then
		        msg = EquipSlotAddMsg.new()

		    elseif msgid == MsgCode.EquipItemResponse then
		        msg = EquipItemMsg.new()

		    elseif msgid == MsgCode.UnEquipReponse then
		        msg = UnEquipMsg.new()

		    elseif msgid == MsgCode.EquipUpgradeResponse then
		        msg = EquipLevelUpMsg.new()

		    elseif msgid == MsgCode.EquipMergeReponse then
		        msg = EquipMergeMsg.new()

		    elseif msgid == MsgCode.EquipLotteryResponse then
		        msg = EquipExtractMsg.new()

		    elseif msgid == MsgCode.GetBattleListResponse then
		    	msg = ChapterInfoMsg.new()

			elseif msgid == MsgCode.SelPetResponse then
		    	msg = PetJoinMsg.new()

	    	elseif msgid == MsgCode.ItemListResponse then
		    	msg = MaterialInfoMsg.new()

		    elseif  msgid == MsgCode.UpgradePetResponse then
		    	msg = PetLevelUpMsg.new()

		    elseif msgid == MsgCode.StartBattleResponse then
		    	msg = StartRunningMsg.new()
				
			 elseif msgid == MsgCode.CupGetResponse then
		    	msg = CupGetMsg.new()
	        
	        elseif msgid == MsgCode.EndBattleStartResponse then
	        	msg = EndStartRunningMsg.new()

	        elseif msgid == MsgCode.EndBattleEndResponse then
	        	msg = EndBattleEndMsg.new()
				
			elseif msgid == MsgCode.EndBattleResponse then
				msg = EndBattleMsg.new()

		    elseif msgid == MsgCode.PetMergeReponse then
		    	msg = PetMergeMsg.new()
	        
		    elseif msgid == MsgCode.PetLotteryResponse then
		    	msg = PetLotteryMsg.new()

		    elseif msgid == MsgCode.GetGiftResponse then
		    	msg = GiftExchageMsg.new()

		    elseif msgid == MsgCode.GetMailListResponse then
		    	msg = EmailListMsg.new()

			elseif msgid == MsgCode.GetMailItemResponse then
		    	msg = EmailRewardMsg.new()

		    elseif msgid == MsgCode.TaskListResponse then
		    	msg = TaskListMsg.new()

		    elseif msgid == MsgCode.TaskCommitResponse then
		    	msg = TaskCommitMsg.new()

		    elseif msgid == MsgCode.UpdateGuideResponse then
		    	msg = UpdateGuideMsg.new()

		    elseif msgid == MsgCode.RankListResponse then
		    	msg = RankListMsg.new()
		    	
		    elseif msgid == MsgCode.PetCallingResponse then
		    	msg = PetCallingMsg.new()

		    elseif msgid == MsgCode.PetVariationResponse then
		    	msg = PetVariationMsg.new()

			elseif msgid == MsgCode.BuyItemResponse then
		    	msg = BuyItemMsg.new()

			elseif msgid == MsgCode.QuestAnswerResponse then
		    	msg = QuestAnswerMsg.new()
		    elseif msgid == MsgCode.BuildListResponse then
		    	msg = BuildingInfoMsg.new()
		    elseif msgid == MsgCode.BuildUpgradeResponse then
		    	msg = BuildingUpLvMsg.new()
		    elseif msgid == MsgCode.BuildGainResponse then
		   		msg = BuildingFetchMsg.new()
			elseif msgid == MsgCode.ExplorerListResponse then
		    	msg = ExplorerListMsg.new()
			elseif msgid == MsgCode.ExplorerStartResponse then
		    	msg = ExplorerStartMsg.new()
			elseif msgid == MsgCode.ExplorerEndResponse then
		    	msg = ExplorerEndMsg.new()
			elseif msgid == MsgCode.ExplorerInfoResponse then
		    	msg = ExplorerInfoMsg.new()
			elseif msgid == MsgCode.ExplorerOccupyResponse then
		    	msg = ExplorerOccupyMsg.new()
		    elseif msgid == MsgCode.ShopListResponse then
		    	msg = StoreInfoMsg.new()
			elseif msgid == MsgCode.StoreBuyItemResp then
		    	msg = StoreBuyItemMsg.new()
			elseif msgid == MsgCode.ExplorerDenfenseResponse then
		    	msg = ExplorerDenfenseMsg.new()
			elseif msgid == MsgCode.ExplorerGainResponse then
		    	msg = ExplorerGainMsg.new()
		    elseif msgid == MsgCode.RecommendFriendResponse then
		    	msg = RecommendFriendMsg.new()
		    elseif msgid == MsgCode.FriendAddResponse then
		    	msg = FriendAddMsg.new()
		    elseif msgid == MsgCode.FriendListResponse then
		    	msg = FriendListMsg.new()
		    elseif msgid == MsgCode.FriendAcceptResponse then
		    	msg = FriendAcceptMsg.new()
		    elseif msgid == MsgCode.GiveStrengthResponse then
		    	msg = GiveStrengthMsg.new()
		    elseif msgid == MsgCode.FriendChallengeResponse then
		    	msg = FriendChallengeMsg.new()
		    elseif msgid == MsgCode.FriendAckChallengeResponse then
		    	msg = FriendReplyChallengeMsg.new()
		    elseif msgid == MsgCode.FriendRemoveResponse then
		   		msg = FriendRemoveMsg.new()
		   	elseif msgid == MsgCode.FriendFindResponse then
		   		msg = FriendFindMsg.new()
			elseif msgid == MsgCode.LadderInfoResponse then
				msg = LadderInfoMsg.new()
			elseif msgid == MsgCode.LadderRaceBeginResponse then
				msg = LadderRaceBeginMsg.new()
			elseif msgid == MsgCode.LadderRaceEndResponse then
				msg = LadderRaceEndMsg.new()
			elseif msgid == MsgCode.LadderLevelConfirmResponse then
				msg = LadderLevelConfirmMsg.new()
			elseif msgid == MsgCode.LadderListResponse then
				msg = LadderListMsg.new()
			elseif msgid == MsgCode.LadderUpgradeStartResponse then
				msg = LadderUpgradeStartMsg.new()
			elseif msgid == MsgCode.LadderUpgradeEndResponse then
				msg = LadderUpgradeEndMsg.new()
			elseif msgid == MsgCode.LadderChallengeResponse then
				msg = LadderChallengeMsg.new()
			elseif msgid == MsgCode.ExplorerDataResponse then
				msg = ExplorerDataMsg.new()	
			elseif msgid == MsgCode.ExplorerReferResponse then
				msg = ExplorerReferMsg.new()
			elseif msgid == MsgCode.TaskStatusResponse then
				msg = TaskStatusMsg.new()
			elseif msgid == MsgCode.SevenLoginResponse then
				msg = SevenLoginMsg.new()
			elseif msgid == MsgCode.PetListResponse then
				msg = PetListMsg.new()
			elseif msgid == MsgCode.UseItemResponse then
				msg = UseItemMsg.new()
		    elseif msgid == MsgCode.RankMatchResponse then
				msg = RankMatchMsg.new()
			elseif msgid == MsgCode.RankChallengeResponse then
				msg = RankChallengeMsg.new()
			end
		end
		self.msgTable[msgid] = msg
	end

	-- EquipLevelUpMsg
	msg.callback = callback
	msg.funName = funName
end

function MsgFactory:Excute(data)
	-- print("data"..tostring(data))
    -- local isError = MsgFactory:errorCheck()
	local json = require "cjson"
	local obj = json.decode(data)

	if obj == nil then 
		return
	end
    local msg = self.msgTable[obj.code]
    if msg ~= nil then
    	msg:Excute(obj)
	else
		-- 出现了错误
		GetCurrentSceneUI():ShowErrorMessage(GetCurrentSceneUI(),tonumber(obj.error_code),obj.error_info)
    end

end

function MsgFactory:errorCheck()
	
end



