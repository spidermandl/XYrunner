--[[
author:Desmond
scene基类
]]
BaseScene = class(BaseBehaviour)
BaseScene.promptWordShowView = nil -- 提示类界面
BaseScene.errorMessageView = nil -- 服务器错误提示
BaseScene.gotoStoreView = nil -- 金币钻石不足打开商城界面
BaseScene.storeView = nil -- 商城界面
BaseScene.itemTips = nil --道具tips
BaseScene.itemGetPath = nil --道具寻路
BaseScene.rewardItemsView = nil -- 奖励界面
BaseScene.RetrunDelegate = nil -- 界面返回时候的监听事件
BaseScene.currentView = nil --当前显示的view
BaseScene.isChangingScene = false -- 是否正在切场景


--绑定ui 事件
function BaseScene:boundButtonEvents(uiobj)
    if uiobj == nil then -- hanli_xiong
        error("BaseScene:boundButtonEvents(uiobj) error:uiobj == nil!")
        return
    end
    local buttons = uiobj.transform:GetComponentsInChildren(UIButtonMessage.GetClassType())
    local length = buttons.Length-1 
    for i=0,length do
        local obj = System.Array.GetValue(buttons,i)
        obj.target = self.sceneTarget
        --LuaShell.addUserData(obj)
        -- self:SetButtonTarget(obj,self.sceneTarget)
    end
end


-- 按钮uimessage 赋值静态方法
function BaseScene:SetButtonTarget(btn,target)
    local btnMes = btn.gameObject.transform:GetComponent("UIButtonMessage")
    if btnMes ~=nil then
    	btnMes.target = target
	end
end
--延迟3d点击
function BaseScene:SetIsDelayModelClick(time)
    coroutine.start(DelayModelClick,self,time)
end
--在update里面 可参照剧情使用
function BaseScene:GetIsDelayModelClick()
    if self.CloseWndNoClickModel == nil then
        self.CloseWndNoClickModel = false
    end
    return self.CloseWndNoClickModel
end

--延迟3d点击
function DelayModelClick(self,time)
    self.CloseWndNoClickModel = true
    local delayTime = 0.2
    if time~= nil then
        delayTime = time
    end
    coroutine.wait(delayTime)
    self.CloseWndNoClickModel = false
end



-- 监听事件脚本添加
function BaseScene:AddUIButtonCtrlOnObj(uiRoot,luaName)
    local sceneTarget = GameObject.New(luaName)
    sceneTarget.transform.parent = uiRoot.gameObject.transform
    sceneTarget:SetActive(false)
    local ctrl = sceneTarget:AddComponent(UIButtonCtrl.GetClassType())
    ctrl.luaName = luaName --"UICtrlBuildingLua"
    local item = sceneTarget:AddComponent(BundleLua.GetClassType())
    item.luaName = luaName
    sceneTarget:SetActive(true)
    return sceneTarget
end

-- 监听事件脚本添加
function BaseScene:AddUIButtonCtrlOnObjNil(uiRoot,luaName)
    local sceneTarget = GameObject.New(luaName)
    sceneTarget.transform.parent = uiRoot.gameObject.transform
    sceneTarget:SetActive(false)
    return sceneTarget
end
--是否选中ui
--true:选中 false:未选中
function BaseScene:uiSelected(uiCamera)
    local ray = uiCamera:ScreenPointToRay(Input.mousePosition)
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil,UnityEngine.Mathf.Infinity,2^UnityEngine.LayerMask.NameToLayer("UI"))
    if flag == true then --判断是否点中ui
        --print ("---------------function FarmManagement:buildingSelected() ")
        return true
    end
    return false
end

-- 适配
function BaseScene:SetUiAnChor()
    local buttons = self.uiRoot.transform:GetComponentsInChildren(UIAnchor.GetClassType())
    local camera = self.uiRoot.transform:FindChild("CameraUI"):GetComponent(UnityEngine.Camera.GetClassType())
    local length = buttons.Length-1 
    for i=0,length do
        local obj = System.Array.GetValue(buttons,i)
        obj.uiCamera = camera
        -- self:SetButtonTarget(obj,self.sceneTarget)
    end
end

--切换view
function BaseScene:changeView(view)
    self.currentView:hide()
    self[view]:show()
    self.currentView = self[view]

end
--切换scene
function BaseScene:ChangScene(SceneStr)
    if not self.isChangingScene then
        --releaseMemory()
        self.isChangingScene = true
        GamePrint("----------------function BaseScene:ChangScene(SceneStr) "..SceneStr)
        SceneConfig.nextScene = SceneStr
        if self.uiRoot == nil then
            self.uiRoot = find("UI Root")
        end
        --local uiloading = newobject(Util.LoadPrefab("UI/loading/LoadingText"))
        -- if SceneConfig.nextScene ~= SceneConfig.buildingScene and SceneConfig.nextScene ~= SceneConfig.loginScene then
        --     UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(SceneConfig.nextScene)
        --     return
        -- end

        UnityEngine.SceneManagement.SceneManager.LoadSceneAsync(SceneConfig.transationScene)
        GamePrint("ui root : "..self.uiRoot.name)
     
        -- uiloading.gameObject.transform.parent = self.uiRoot.transform
        -- uiloading.transform.localPosition = Vector3.zero
        -- uiloading.transform.localScale = Vector3.one

        -- local manager = TxtFactory:getTable(TxtFactory.UITransitionManager)
        -- manager:push(SceneStr,true)

    end
end

--销毁--
function BaseScene:OnDestroy()
    GamePrint("-----------------BaseScene:OnDestroy-->>>-----------------")
    --Util.UserdataGC()
    -- LuaShell.clear()
    -- releaseMemory()
end


-- 注册错误消息提示
function BaseScene:ShowErrorMessage(scene,error_code,error_info)
   -- printf("error_code =="..error_code)
   --[[
    E_UNKNOW          = 10000 //服务器未知错误
	E_INVALID_PARAM   = 10001 //前端参数错误
	E_INVALID_LEN     = 10002 //非法长度
	E_INVALID_NAME    = 10003 //非法名字
	E_EXIST_NAME      = 10004 //名字或账户已存在
	E_INVALID_PWD     = 10005 //密码错误
	E_INVALID_SESSION = 10006 //无效的session_id,sdk
	E_INVALID_DEVICE  = 10007 //无效的设备号
	E_NOTEXIST_AC     = 10008 //不存在的账号
	E_TOKEN_TIMEOUT   = 10009 //token已过期
]]--
    local textsConfigTXT =  TxtFactory:getTable(TxtFactory.TextsConfigTXT) 
    if error_code == 10000 then
        scene:promptWordShow(textsConfigTXT:GetText(1001))
    elseif error_code == 10001 then
        scene:promptWordShow(textsConfigTXT:GetText(1002))
    elseif error_code == 10002 then
        scene:promptWordShow(textsConfigTXT:GetText(1003))
    elseif error_code == 10003 then
        scene:promptWordShow(textsConfigTXT:GetText(1004))
    elseif error_code == 10004 then
        scene:promptWordShow(textsConfigTXT:GetText(1005))
    elseif error_code == 10005 then
        scene:promptWordShow(textsConfigTXT:GetText(1006))
    elseif error_code == 10006 then
        scene:promptWordShow(textsConfigTXT:GetText(1002))
    elseif error_code == 10007 then
       scene:promptWordShow(textsConfigTXT:GetText(1007))
    elseif error_code == 10008 then
        scene:promptWordShow(textsConfigTXT:GetText(1008))
    elseif error_code == 10009 then
        scene:promptWordShow(textsConfigTXT:GetText(1002))
    elseif error_code == 10010 then
        scene:promptWordShow(error_info)
    elseif error_code == 10011 then  
        scene:ErrorMessageViewShow(textsConfigTXT:GetText(1009))
        --self:ChangScene("ui_login")
    end
    
end

--设置update是否执行
function BaseScene:setUpdate( lock )
    local array = self.gameObject:GetComponents(BundleLua.GetClassType())
    for i=0,array.Length-1 do
        local lua = System.Array.GetValue(array,i)
        lua.isUpdate = lock
    end
end

-- 隐藏或者显示主界面 hanli_xiong
-- 做统一处理如:播放动画,背景蒙黑等
function BaseScene:SetActive(enable)
    -- body
end

-- 提示文字显示
function BaseScene:promptWordShow(word,model)
    if self.promptWordShowView == nil then
        self.promptWordShowView = PromptWordShowView.new()
    end
    self.promptWordShowView:init(self,word,model)
    -- self.wordPrompt.text = word
end

-- 服务器错误提示
function BaseScene:ErrorMessageViewShow(word)
    if self.errorMessageView == nil then
        self.errorMessageView = ErrorMessageView.new()
    end
    self.errorMessageView:init(self,word)
end

function BaseScene:ShowShop(type)
    if self.storeView == nil then
		self.storeView = StoreView.new()
		self.storeView:init(self)
	end
    self.storeView:ShowView()
    self.storeView:InitData(type)
end

-- 金币钻石不足打开商城界面
function BaseScene:OpenGotoStoreView(word,type)
    if self.gotoStoreView == nil then
        self.gotoStoreView = GotoStoreView.new()
    end
    self.gotoStoreView:init(self,word,type)
end

-- 关闭文字提示
function BaseScene:promptWordShowClose()
    self:SetIsDelayModelClick()
    self.promptWordShowView:close()
end

--道具tips
function BaseScene:ShowItemTips(itemId)
    if self.itemTips == nil then
        self.itemTips = ItemTips.new()
    end
    self.itemTips:init(self,itemId)
end
-- 关闭文字提示
function BaseScene:CloseItemTips()
    self.itemTips:close()
end
--道具寻路
function BaseScene:ShowItemGetPath(itemId)
    if self.itemGetPath == nil then
        self.itemGetPath = ItemGetPath.new()
    end
    self.itemGetPath:init(self,itemId)
end
--跳转商店
function BaseScene:ItemGetPathGotoStore()
    self.itemGetPath:GotoStore()
end
--跳转副本
function BaseScene:ItemGetPathGotoFuben()
    self.itemGetPath:GotoFuben()
end
-- 关闭道具寻路
function BaseScene:CloseItemGetPath()
    self.itemGetPath:close()
end
function BaseScene:UpdatePlayerInfo()
    if self.playerTopInfoPanel then
          self.playerTopInfoPanel:InitData()
    end
end

-- 奖励物品界面显示
function BaseScene:rewardItemsShow(items,isMerge) -- items 是一个数组的类型的tab
    if items~=nil and #items>0 then
        self.rewardItemsView = RewardItemsShow.new()
        self.rewardItemsView:init(self,items,isMerge)
    end
end

-- 奖励物品界面关闭
function BaseScene:rewardItemsClose()

    self.rewardItemsView:closePanel()
end

-- 提示文字显示 含有按钮cancle ok
function BaseScene:ConsultBoxViewShow(word,okDel,model)
    if self.consultBoxView == nil then
        self.consultBoxView = ConsultBoxView.new()
    end
    self.consultBoxView:init(self,word,okDel,model)
    -- self.wordPrompt.text = word
end

--gold,diamond,exp,strength,explorer_gold 夺宝币,itemInfoList,equipInfoList,petInfoList
function BaseScene:CreatItemList(serverData)
   local retObjTable ={}
   if serverData.itemInfoList~=nil then
        for i = 1,#serverData.itemInfoList do 
    
            local data = serverData.itemInfoList[i]
            local id = data.tid
            local num = data.add_num 
            
            local item = self:CreateItem(id,num,1)
            table.insert(retObjTable,item.ItemObj)
        end
    end
    if serverData.equipInfoList~= nil then
        for i = 1,#serverData.equipInfoList do
            local data = serverData.equipInfoList[i]
            local id = data.tid
            local num = nil 
            local item = self:CreateItem(id,num,2)
            table.insert(retObjTable,item.ItemObj)
        end
     end
    if serverData.petInfoList~=nil then
        for i = 1,#serverData.petInfoList do 
            local data = serverData.petInfoList[i]
            local id = data.tid
            local num = nil
            
            local item = self:CreateItem(id,num,3)
            table.insert(retObjTable,item.ItemObj)
        end
    end
    
    if serverData.gold~= nil and serverData.gold >0 then
        local item = self:CreateItem(serverData.gold,serverData.gold,4)
          item:SetBg(false)
           table.insert(retObjTable,item.ItemObj)
    end
    
     if serverData.diamond~= nil and serverData.diamond >0 then
        local item = self:CreateItem(serverData.diamond,serverData.diamond,5)
          item:SetBg(false)
           table.insert(retObjTable,item.ItemObj)
    end
    
    if serverData.exp~= nil and serverData.exp >0 then
        local item = self:CreateItem(serverData.exp,serverData.exp,6)
          item:SetBg(false)
           table.insert(retObjTable,item.ItemObj)
    end
    if serverData.strength~= nil and serverData.strength >0 then
        local item = self:CreateItem(serverData.strength,serverData.strength,7)
        item:SetBg(false)
        table.insert(retObjTable,item.ItemObj)
    end
    if serverData.explorer_gold~= nil and serverData.explorer_gold >0 then
        local item = self:CreateItem(serverData.explorer_gold,serverData.explorer_gold,8)
        item:SetBg(false)
        table.insert(retObjTable,item.ItemObj)
    end
    return retObjTable
end


function BaseScene:CreateItem(id,num,type)
    local item = ItemLevelReward.new()
    local itemObj = newobject(Util.LoadPrefab("UI/Chapter/ItemLevelReward"))
    item:init(self,itemObj)
    item:SetData(id,type)
    if type<4 then
        item:SetCount(num)
    else
        item:SetOtherCount(num)
    end
    item:SetBg(true)
    return item
end

