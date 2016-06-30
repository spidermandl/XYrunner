--[[
    author:Huqiuxiang
    登陆注册ui逻辑 UILogInScene
    
]]

require "game/scene/logic/account/AccountManagement"
require "game/scene/logic/account/ActiveAccountView"
require "game/scene/logic/account/RegisterView"

UILogInScene = class (BaseScene)

UILogInScene.accountmanagement = nil --玩家信息管理类

UILogInScene.logInPanel = nil
UILogInScene.UsernameText = nil -- 登陆输入框
UILogInScene.PasswordText = nil  -- 注册输入框
UILogInScene.SeverListPanel = nil
UILogInScene.ServerlistTabelPanel = nil   -- 根据服务器 动态生成的服务器列表
UILogInScene.ServerlistUIServerlistTabelClose = nil -- 
UILogInScene.ServerlistUIServerlistLabel = nil -- 当前选定的服务器列表
UILogInScene.ServerlistTabel = nil -- 服务器list获得的tabel
UILogInScene.isSelectTabel = nil   -- 选中的那列tabel信息

UILogInScene.UseChannelLogin = RoleProperty.isSDK -- 使用渠道登陆 by:hanli_xiong
UILogInScene.diceSpriteAnimation = nil -- 骰子动画
UILogInScene.BeginLoginPannel = nil -- 选择登录方式界面

UILogInScene.registerView = nil --注册界面

function UILogInScene:Awake()
    self.accountmanagement = AccountManagement.new()
    self.accountmanagement.scene = self
    self.accountmanagement:Awake()
    self.uiRoot = find("UI Root")
    -- newobject(Util.LoadPrefab("UI/battle/UI Root"))
    -- self.uiRoot.name = 'UI Root'
    
    --self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UILogInListenerLua")
    if self.UseChannelLogin then -- 如果使用渠道登陆
        self:creatBeginLogIn()
    else
        self:creatLogInPanel()
        -- self:creatCharacterPanel()
    end
    --创建ui
   --self:boundButtonEvents(self.uiRoot)
end

--启动事件--
function UILogInScene:Start()
    
end

function UILogInScene:Update()
end

function UILogInScene:FixedUpdate()
end

-- 创建登陆面板
function UILogInScene:creatBeginLogIn()
    self.BeginLoginPannel = newobject(Util.LoadPrefab("UI/login/BeginLoginUI"))
    self.BeginLoginPannel.transform.localPosition = Vector3.zero
    self.BeginLoginPannel.transform.localScale = Vector3.one

    AddonClick(getChildByPath(self.BeginLoginPannel,"BeginLoginUI/AccountLogin"),
        function()
            TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)
            self:AccountLogin()
        end
    )

end

-- 打开注册界面
function UILogInScene:OpenRegisterView()
    if self.registerView == nil then
        self.registerView = RegisterView:new()
        self.registerView:init(self)
    end
    -- 关闭登录界面
    self.logInPanel:SetActive(false)
    self.registerView:ShowView()
end

function UILogInScene:RegisterUIBackBtnOnClick()
    self.logInPanel:SetActive(true)
    self.registerView:HiddenView()
end


-- 问卷调查ui 事件方法
function UILogInScene:RegisterUIEvent( fName,... )
    --printf('fName=='..fName)
	self.registerView[fName](self.registerView,...)
end

-- 创建登陆面板
function UILogInScene:creatLogInPanel()
    self.logInPanel = newobject(Util.LoadPrefab("UI/login/LogInUI"))
    self.logInPanel.transform.parent = self.uiRoot.transform
    self.logInPanel.transform.localPosition = Vector3.zero
    self.logInPanel.transform.localScale = Vector3.one
    self.UsernameText = getObjectComponent(find("usernameText"),"UIInput") 
    --find("usernameText").gameObject.transform:GetComponent("UIInput")
    self.PasswordText = getObjectComponent(find("passwordText"),"UIInput")
    --find("passwordText").gameObject.transform:GetComponent("UIInput")
    local userTxt  =  TxtFactory:getTable(TxtFactory.UserTXT)
    if userTxt:getValue("Username") ~="" then
        self.UsernameText.value= userTxt:getValue("Username") 
        self.PasswordText.value = userTxt:getValue("Password") 
    end
    
    AddonClick(getChildByPath(self.logInPanel,"UI/UIGame/Center/LogInUIRegisterBtn"),
        function()
            TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)
            self:OpenRegisterView()
        end
    )
    AddonClick(getChildByPath(self.logInPanel,"UI/UIGame/Center/LogInUILogInBtn"),
        function()
            TxtFactory:getTable(TxtFactory.SoundManagement):PlayEffect(SoundType.button)
            self:LogInBtnAction()
            --self:ChangScene(SceneConfig.buildingScene)
        end
    )
end

-- 创建选择服务器面板
function  UILogInScene:creatSerListPanel()
    self.SeverListPanel = newobject(Util.LoadPrefab("UI/login/ServerlistUI"))
    self.SeverListPanel.transform.parent = self.uiRoot.transform
    self.SeverListPanel.transform.localPosition = Vector3.zero
    self.SeverListPanel.transform.localScale = Vector3.one

    self.ServerlistTabelPanel = find("ServerlistUIServerlistTabelBg")
    self.ServerlistUIServerlistLabel = getObjectComponent(find("ServerlistUIServerlistLabel"),"UILabel")
    --find("ServerlistUIServerlistLabel").gameObject.transform:GetComponent("UILabel")

    if self.isSelectTabel ~= nil then -- 如果点了切换账号按钮 之前的信息清理
         GameObject.Destroy(self.isSelectTabel)
         self.isSelectTabel = nil
    end

    local grid = find("ServerlistUIServerlistTabelGrid")
    local listItem = grid.transform:GetChild(0)
    local UI = find("ServerlistUICtrUI")
    for i = 1 , #self.ServerlistTabel do 
        local obj = newobject(listItem.gameObject)
        obj:SetActive(true)
        obj.gameObject.transform.parent = grid.transform
        obj.gameObject.transform.localScale = Vector3(1,1,1)
        obj.gameObject.name = self.ServerlistTabel[i].name
        local t = getObjectComponent(obj,"UILabel")
        --obj.gameObject.transform:GetComponent("UILabel")
        t.text = self.ServerlistTabel[i].name

        local  bm = obj:AddComponent(UIButtonMessage.GetClassType())
        bm.target = UI.gameObject
        bm.functionName = "OnClick"
    end
    getObjectComponent(grid,"UIGrid"):Reposition()
    --grid:GetComponent("UIGrid"):Reposition()
    getObjectComponent(grid.transform.parent,"UIScrollView"):ResetPosition()
    --grid.transform.parent:GetComponent("UIScrollView"):ResetPosition()
    self:ServerlistTabBtnAction(self.ServerlistTabel[1].name)
    self.ServerlistTabelPanel.gameObject:SetActive(false)

    AddonClick(getChildByPath(self.SeverListPanel,"ServerlistUICtrUI/UIGame/Center/ServerlistUIStartGameBtn"),
        function()
            self:StartGameBtnAction()
        end)

    AddonClick(getChildByPath(self.SeverListPanel,"ServerlistUICtrUI/UIGame/Center/ServerlistUIChangeIDBtn"),
        function()
            self:ChangeIDBtnAction()
        end)
    
    
end

-- 创建 键人物面板
function UILogInScene:creatCharacterPanel()

    self.SeverListPanel:SetActive(false)
    -- 关闭注册界面
    if self.registerView ~= nil then
        self.registerView:HiddenView()
    end
    self.registerScene = newobject(Util.LoadPrefab("BigRes/login_scene"))
    self.CharacterCreatPanel = newobject(Util.LoadPrefab("UI/SelectCharacterUI"))
    self.CharacterCreatPanel.gameObject.transform.position = Vector3.zero
    self.diceSpriteAnimation =  getObjectComponent(self.CharacterCreatPanel,"UISpriteAnimation","UI/UIGame/ChooseActor/nickName/SelectCharacterUIShaiziBtn/Background")
                                --trans:GetComponent("UISpriteAnimation")
    self.diceSpriteAnimation:Pause()

    local go = find("SelectCharacterUICharacterDesript")
    self.CharacterDescript = getObjectComponent(go,"UILabel")
                            --go:GetComponent("UILabel")
    self.CharBoy = go.transform.parent:Find("boy").gameObject
    self.CharGirl = go.transform.parent:Find("girl").gameObject
    self.ChacarterName = getObjectComponent(find("SelectCharacterUINameInputLabel"),"UIInput")
                            --find("SelectCharacterUINameInputLabel").gameObject.transform:GetComponent("UIInput")


    
    self.modCtr = LogInSceneCreatModelCtr.new()
    self.modCtr:creatModel()  -- 创建模型


    -- -- 创建男女模型
    -- self.ChacarterManModel = newobject(Util.LoadPrefab("Player/desmond"))
    -- self.ChacarterManModel.transform.position = Vector3.zero
    -- local Vx = -1
    -- local Vy = -0.5
    -- local Vz = -1
    -- self.ChacarterManModel.transform:Translate(Vx,Vy,Vz,Space.World)
    -- self.ChacarterManModel.transform.rotation = Quaternion.Euler(0,135,0)
    -- self.ChacarterManModel.transform.localScale = Vector3(0.5,0.5,0.5)
    -- self.ChacarterManModel.gameObject.layer = UnityEngine.LayerMask.NameToLayer("UI")

    -- self:setEntity(ModelTable["desmond"],self.ChacarterManModel)
    -- 初始选中男人
    self.ChacarterSex = 0
    
    -- 初始化名字
    self:suijiName(self.ChacarterSex)
    self:ManSelectBtnAction()
    
    AddonClick(getChildByPath(self.CharacterCreatPanel,"UI/UIGame/ChooseActor/nickName/SelectCharacterUIShaiziBtn"),function()
        self:suijiNameBtnAction()
    end)

    AddonClick(getChildByPath(self.CharacterCreatPanel,"UI/UIGame/ChooseActor/SelectCharacterUIRolemanBtn"),function()
        self:ManSelectBtnAction()
    end)

    AddonClick(getChildByPath(self.CharacterCreatPanel,"UI/UIGame/ChooseActor/SelectCharacterUIRolewomanBtn"),function()
        self:WoManSelectBtnAction()
    end)
    
    AddonClick(getChildByPath(self.CharacterCreatPanel,"UI/UIGame/Center/SelectCharacterUIDoBtn"),function()
        self:CharacterOkBtnAction()
    end)

end

-- 创建激活账号界面
function UILogInScene:CreateActiveAccountView()
    self.ActiveAccountPanel = ActiveAccountView.new()
    self.ActiveAccountPanel:Init()
end

--------------------------------------------------------------------- 选择登陆方式 ---------------------

-- 渠道登陆
function UILogInScene:AccountLogin()
    if self.UseChannelLogin then
        PlatformAction.CallAction(PlatformAction.ActionLogin, "1", self, self.OnChannelLogin)
        return
    end
end

-- 渠道登陆回调事件
function UILogInScene:OnChannelLogin(info)
    -- warn("info:" .. tostring(info))
    local json = require "cjson"
    -- local jstr = json.decode("{\"content\":{\"user\":\"testrunner\",\"ssid\":\"g8m1868t565c2407025e1\",\"did\":\"863234025172264\"},\"ret\":\"1\"}")
    local jstr = json.decode(info)
    local ret = jstr.ret
    local content = jstr.content
    if tonumber(ret) == 1 and content ~= nil then
        GamePrint("登陆成功!")
        -- 发送ssid给服务器
        -- print(content.user .. "&" .. content.ssid .. "&" .. content.did)
        --self.accountmanagement:sendXYLogin(content.user, content.ssid, content.did)
        self.accountmanagement:sendSDKLogin(content.user, content.ssid, content.did,content.provider)
    else
        GamePrint("登陆失败!")
        -- 询问玩家退出还是继续登陆
    end
end

--------------------------------------------------------------------- 登陆注册 ---------------------
-- 登陆按钮事件(发送)
function UILogInScene:LogInBtnAction()
    -- print("点击了登陆按钮".." 用户名 :"..self.UsernameText.value.." 密码 :"..self.PasswordText.value)
    if self.UsernameText.value == "" then
        print("用户名不能为空")
        return
    end
    if self.PasswordText.value == "" then
        print("密码不能为空")
        return
    end

    self.accountmanagement:sendLogin(self.UsernameText.value,self.PasswordText.value)

end

-- 注册按钮事件(发送)
function UILogInScene:RegisterBtnAction(userName,password)
  	-- print("点击了注册按钮".." 用户名 :"..self.UsernameText.value.." 密码 :"..self.PasswordText.value)
     --[[
  	if self.UsernameText.value == "" then
           print("用户名不能为空")
           return
  	end
  	if self.PasswordText.value == "" then
  		 print("密码不能为空")
  		 return
  	end
    ]]--
    self.accountmanagement:sendRegister(userName,password)

end


-- 获取服务器消息（返回）
function UILogInScene:ServerListFromSer(response)
    if self.BeginLoginPannel then
        GameObject.Destroy(self.BeginLoginPannel)
    end
    --GameObject.Destroy(self.logInPanel)
    self.logInPanel:SetActive(false)
    self.ServerlistTabel = response.server_list
    --print("获取服务器消息"..self.ServerlistTabel[1].ro)
    self:creatSerListPanel()
   
end

-------------------------------------------------------------------------------------  服务器获取 -------------------
-- 选择服务器按钮
function UILogInScene:SelectServerBtnAction()
    print("选择服务器按钮")
    self.ServerlistTabelPanel.gameObject:SetActive(true)
end

-- 切换账号按钮
function UILogInScene:ChangeIDBtnAction()
    print("切换账号按钮")
    GameObject.Destroy(self.SeverListPanel)
    self:StartCreatPanel()
    self:boundButtonEvents(self.uiRoot)
end

-- 开始游戏按钮
function UILogInScene:StartGameBtnAction()
    print("开始游戏按钮")
    if self.isSelectTabel ~= nil then
        self.accountmanagement:sendRoleInfo()
    else
        print("服务器不为空")
    end
end

-- 关闭服务器列表按钮
function UILogInScene:ServerlistUIServerlistTabelCloseBtnAction()
    print("关闭服务器列表按钮")
    self.ServerlistTabelPanel.gameObject:SetActive(false)
end

--  选中某个服务器
function UILogInScene:ServerlistTabBtnAction(name)
   -- print("选中了 "..name.." 区")
    for i , v in ipairs(self.ServerlistTabel) do -- 通过名字比对 所在tabel
         if v.name == name then
             self.isSelectTabel = v 
         end
    end
   self.ServerlistUIServerlistLabel.text = name
   self.ServerlistTabelPanel.gameObject:SetActive(false)

   AppConst.SocketAddress = self.isSelectTabel.url
   -- print("当前服务器"..self.isSelectTabel.name)
end

-- 获取角色信息回调
function UILogInScene:StartGameBtnBack()
    self.UserInfo =  TxtFactory:getMemDataCacheTable(TxtFactory.UserInfo)
    
    DataCollector.SetAccount(tostring(self.UserInfo[TxtFactory.USER_MEMBERID]))
    DataCollector.SetAccountName(tostring(self.UserInfo[TxtFactory.USER_NAME]))
    DataCollector.SetLevel(tonumber(self.UserInfo[TxtFactory.USER_LEVEL]))
end


UILogInScene.CharacterCreatPanel = nil 
UILogInScene.CharacterDescript = nil
UILogInScene.CharBoy = nil
UILogInScene.CharGirl = nil
UILogInScene.ChacarterSex = nil 
UILogInScene.ChacarterName = nil 
UILogInScene.modCtr = nil 

-----------------------------------------------------------------------  选择角色  -------------------
-- 选中男角色
function UILogInScene:ManSelectBtnAction()
  local t = "请赐予我追逐风的力量"
  local sex = 0
--   if self.ChacarterSex ~= sex then
--        -- print("之前人物性别 "..self.ChacarterSex)
--         self:suijiName(sex)
--   end
  
  self.modCtr:manDo()
  self:isSelectCharacter(t,sex)
end

-- 选中女角色
function UILogInScene:WoManSelectBtnAction()
  local t = "大家都拜倒在我的运动裤下"
  local sex = 1
--   if self.ChacarterSex ~= sex then
--       -- print("之前人物性别 "..self.ChacarterSex)
--         self:suijiName(sex)
--   end

  self.modCtr:womanDo()
	self:isSelectCharacter(t,sex)
end

-- 确定按钮(创建角色 发送)
function UILogInScene:CharacterOkBtnAction()
    if self.ChacarterName.value == "" or self.ChacarterName.value == "请输入昵称" then
        print("输入的角色名不为空")
        GetCurrentSceneUI():promptWordShow("输入的角色名不为空!")
        return
    end

    self.accountmanagement:sendCreateRole(self.ChacarterSex,self.ChacarterName.value)
end

-- （创建角色 返回) 
function UILogInScene:CharacterCreatFromSer()
    local user = TxtFactory:getTable("UserTXT")
    -- user:setSexName(self.ChacarterName.value,self.ChacarterSex)  -- 保存昵称 性别(昵称可能会因为服务器延时而改动 不是发送那个)
    

    local info = user:getValue("RoleForAccont")
    -- for i = 1 , #info do

    -- end
    if info == nil then
        info = {"",}
    end

    info[#info+1] = user:getValue("Username")
    user:setRoleForAccont(info)

    self.accountmanagement:sendRoleInfo()
end


-- 关闭按钮 (后退按钮)
function UILogInScene:CharacterCloseBtnAction()
    print("人物创建 后退按钮")
    GameObject.Destroy(self.CharacterCreatPanel)
    self:creatSerListPanel()
end

-- 
function UILogInScene:isSelectCharacter(word,sex)
  self.CharacterDescript.text = word
  self.ChacarterSex = sex
  self.CharBoy:SetActive(sex == 0)
  self.CharGirl:SetActive(sex == 1)
end

-- 随机人名字按钮
function UILogInScene:suijiNameBtnAction()

   -- 播放动画
   self.diceSpriteAnimation:Play()
   
   self:suijiName(self.ChacarterSex)
end

function UILogInScene:suijiName(sex)
  
    local txt = TxtFactory:getTable(TxtFactory.CharNamesTXT)
    self.ChacarterName.value = txt:RandomName()
end
