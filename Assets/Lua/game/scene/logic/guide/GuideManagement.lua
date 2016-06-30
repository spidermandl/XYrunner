--[[
author:huqiuxiang
新手引导
]]

GuideManagement = class()
GuideManagement.scene = nil
GuideManagement.stepScene = nil 
GuideManagement.effect = nil 
GuideManagement.GudieRunningSceneTXT = nil 
GuideManagement.userTable = nil -- 玩家数据表

function GuideManagement:init(targetscene)
	self.scene = targetscene
  self.userTable = TxtFactory:getTable(TxtFactory.UserTXT) 

end

-- 新手引导进度 发送
function GuideManagement:sendGuideProgress(progress)
  -- local guide = user[TxtFactory.USER_GUIDE] -- 获取进度
  self:setValue(TxtFactory.UserInfo,TxtFactory.USER_GUIDE,progress)
  print("progress 进度"..progress)
	local json = require "cjson"
   local strr = nil
	 if AppConst.isPBencrypted == false then --pb不加密
       local msg = { guide = progress}
        strr = json.encode(msg)
    else
        --设置pb data
        local message = charinfo_pb.UpdateGuideRequest()
        message.guide = progress
        strr = ZZBase64.encode(message:SerializeToString())
    end
	--local msg = { guide = progress}
   -- local strr = json.encode(msg)
    local param = {
              code = MsgCode.UpdateGuideRequest,
              data = strr, -- strr
             }

    MsgFactory:createMsg(MsgCode.UpdateGuideResponse,self)
    NetManager:SendPost(NetConfig.GUIDE_PROGRESS,json.encode(param)..'|'..self.userTable:getValue('Username')..':'..self.userTable:getValue('access_token'))

end

-- 新手引导进度 返回
function GuideManagement:getGuideProgress(info)
	
end

--为数据表赋值
function GuideManagement:setValue( tName,column,value)
    TxtFactory:setValue(tName,column,value)
end