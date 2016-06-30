--[[
   author:huqiuxiang
   新手引导1 关卡开头 Item
]]
ChapterGuideItem = class (BaseItem)
ChapterGuideItem.type = 'ChapterGuideItem'

function ChapterGuideItem:Awake()
	-- print("-----------------StaminaBottle Awake--->>>-----------------")
    self.super.Awake(self)
    self:closeIcon()
end

--启动事件--
function ChapterGuideItem:Start()
end


function ChapterGuideItem:closeIcon()
    local scene = find("sceneUI")
    local sceneLua = LuaShell.getRole(scene.gameObject:GetInstanceID())

   local user = TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
   local step = user[TxtFactory.USER_GUIDE] -- 获取进度
    -- print("当前进度"..step)
    if step == 1 then -- 进度1 全部隐藏按钮
        sceneLua.attackBtn = find("BtnAttack") 
        sceneLua.attackBtn.gameObject:SetActive(false)
        sceneLua.skillBtn = find("BtnSpeedUp")
        sceneLua.skillBtn.gameObject:SetActive(false)
        sceneLua.jumpBtn = find("BtnJump")
        sceneLua.jumpBtn.gameObject:SetActive(false)
        self:roleSet()

    elseif step == 3 then -- 进度2 隐藏技能按钮
        sceneLua.jumpBtn = find("BtnJump")
        sceneLua.attackBtn = find("BtnAttack") 
        local skillBtn = find("BtnSpeedUp")
        skillBtn.gameObject:SetActive(false)
    end
    
end

function ChapterGuideItem:roleSet()
    local buff = CantDiveState.new()
    buff.stage = 1 
    self.role=LuaShell.getRole(LuaShell.DesmondID)
    self.role.stateMachine:addSharedState(buff)
end