--[[
author:Huqiuxiang
萌宠感叹号弹出信息界面
]]

PetinfoView = class ()
PetinfoView.petIconInfoPanel = nil -- 面板
PetinfoView.petManagement = nil -- 萌宠管理器
PetinfoView.scene = nil
-- 萌宠信息icon界面
function PetinfoView:creatIconInfoPanel(root,tid,scene,Petdata)
    if self.petIconInfoPanel ~= nil then
        destroy(self.petIconInfoPanel)
    end

    if self.petManagement == nil then
    	self.petManagement = PetManagement.new() -- 萌宠管理器
    end

    self.petIconInfoPanel = newobject(Util.LoadPrefab("UI/Pet/PetInfoUI"))
    self.scene = scene
	self.petIconInfoPanel.gameObject.transform.parent = root.transform
    self.petIconInfoPanel.gameObject.transform.localPosition = Vector3.zero
    self.petIconInfoPanel.gameObject.transform.localScale = Vector3.one
    self.petIconInfoPanel.gameObject.transform.localPosition = Vector3(0,0,-400)

    local _txt = TxtFactory:getTable(TxtFactory.MountTXT)
    local petTable = TxtFactory:getTable("MountTypeTXT")
    local petMainSkillTabel = TxtFactory:getTable("PetSkillMainTXT")
    local petPassiveSkillTabel = TxtFactory:getTable("PetSkillPassiveTXT")

    local ui = self.petIconInfoPanel.gameObject.transform:FindChild("UI")
    local root = ui.gameObject.transform:FindChild("PetInfoUI_infoIconRoot")
    local btype = ui.gameObject.transform:FindChild("type")
    local nameLabel = btype.gameObject.transform:FindChild("name"):GetComponent("UILabel")

    local closeBtn = ui.gameObject.transform:FindChild("PetInfoUI_close")
    local closeBtnMes = closeBtn.gameObject.transform:GetComponent("UIButtonMessage")
    closeBtnMes.target = scene.sceneTarget

    --关闭
    AddonClick(closeBtn,function( ... )
        -- body
        self.scene:petIconInfoPanel_closeBtn()
    end)

    -- local tid = self.petManagement:idDataForTid(id)
    local ctid = _txt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类

    local icon = scene:creatPetIconBig(tid,root)
    icon.gameObject.transform.localPosition = Vector3.zero
    icon.gameObject.transform.localScale = Vector3.one

    local infoBtn = icon.gameObject.transform:FindChild("petIconInfoBtn")
    infoBtn.gameObject:SetActive(false)

    local nameData = petTable:GetData(ctid,"NAME")
    nameLabel.text = nameData

    -- 品质更改外框
    local rankData = petTable:GetData(ctid,"RANK_ICON_2")
    local rankIcon = btype.gameObject.transform:FindChild("pank"):GetComponent("UISprite")
    rankIcon.spriteName = rankData

    local desText = btype.gameObject.transform:FindChild("desLabel"):GetComponent("UILabel")
    local desKeyLabel = btype.gameObject.transform:FindChild("desKeyLabel"):GetComponent("UILabel")
    self:iconInfoPanelDescript(tid,desKeyLabel,desText)

    -- 技能显示
    local skillMainId = petTable:GetData(ctid,"ACTIVE_SKILLS") -- 主动技能ID
    local skillPassiveId = petTable:GetData(ctid,"PASSIVE_SKILLS") -- 被动技能ID

    -- 获得该宠物信息(服务器同步信息)
    local thisPetInfo = self.petManagement:GetPetInfoById(tid)
    if thisPetInfo then
        skillMainId = thisPetInfo.skill1 -- 主动技能ID
        skillPassiveId = thisPetInfo.skill2 -- 被动技能ID
    end
    --GamePrintTable("skillMainId :"..tostring(skillMainId))
    local skillMainData = petMainSkillTabel:GetData(skillMainId,"SKILL_NAME")

    local skillMainLevel = thisPetInfo ~= nil and thisPetInfo.skill1_lv or 1 --petMainSkillTabel:GetSkillLevel(skillMainId)
    local skillMainText = btype.gameObject.transform:FindChild("skill1/attDes"):GetComponent("UILabel")
    local skillLevelLabel = btype.gameObject.transform:FindChild("skill1/level"):GetComponent("UILabel")
    --GamePrintTable("skillMainData =="..tostring(skillMainData))
    skillMainText.text = tostring(skillMainData)
    skillLevelLabel.text = "lv."..tostring(skillMainLevel)

    if skillMainData == nil then
        skillMainText.text  = "无"
        skillLevelLabel.text = ""
    end
    local skillPassiveData = petPassiveSkillTabel:GetData(skillPassiveId,"SKILL_NAME")
    local skillPassiveText = btype.gameObject.transform:FindChild("skill2/attDes"):GetComponent("UILabel")
    skillPassiveText.text = tostring(skillPassiveData)

    if skillPassiveData == nil then
        GamePrintTable("被动技能 id 。。skillPassiveId＝"..skillPassiveId)
        skillPassiveText.text  = "无"
    end

    local skillExtText = btype.gameObject.transform:FindChild("skill3/attDes"):GetComponent("UILabel")
    skillExtText.text = "暂无"

    -- 已经拥有的宠物
    if Petdata ~= nil then

        skillLevelLabel.text = "lv."..tostring(Petdata.skill1_lv)
        local sNAME2 = petPassiveSkillTabel:GetData(Petdata.skill2,"SKILL_DESC")
        --GamePrintTable("sNAME2"..sNAME2)
        if sNAME2 ~= nil and sNAME2 ~= "" then
            sNAME2 = string.gsub(sNAME2,"*",tostring(Petdata.skill2_val))
            skillPassiveText.text  = sNAME2
        end
        local maxLv = petMainSkillTabel:GetData(skillMainId,"SKILL_MAX_LV")
        if maxLv ~= nil then
            if tonumber(Petdata.skill1_lv) >= tonumber(maxLv) then
                skillLevelLabel.text = "lv.MAX"
            end
        end
    end


end

-- 萌宠界面显示属性
function PetinfoView:iconInfoPanelDescript(tid,desKeyLabel,desText)
    self.scene:iconInfoPanelDescript(tid,desKeyLabel,desText)
    --[[local mountTxt = TxtFactory:getTable(TxtFactory.MountTXT)
            local petTable = TxtFactory:getTable("MountTypeTXT")
            local ctid = mountTxt:GetData(tid, TxtFactory.S_MOUNT_TYPE) -- 种类
            local per = mountTxt:GetData(tid, "ADDSC")
            local value = mountTxt:GetData(tid, "ADDHP") .. "\n" ..
                tonumber(per)*100 .. "%" .. "\n" ..
                mountTxt:GetData(tid, "ADDATKSC") .. "\n" ..
                mountTxt:GetData(tid, "COLLECTIONS_SCORE")
            desText.text = value
        
            desKeyLabel.text = mountTxt.Attribute.ADDHP .. "\n" ..
                mountTxt.Attribute.ADDSC .. "\n" ..
                mountTxt.Attribute.ADDATKSC .. "\n" ..
                mountTxt.Attribute.GOLD_SCORE
            -- return value]]
end

function PetinfoView:closeBtn()
	destroy(self.petIconInfoPanel)
end
