--[[
author: yingdehu
sunkai 修改
场景大关选择
]]
require "game/scene/logic/chapter/ChapterManagement"

ChapterScene = class (BaseScene)

ChapterScene.management = nil --数据模型
ChapterScene.infoTxt = nil -- 章节进度记录信息缓存

ChapterScene.item = nil   --关卡点击物品
ChapterScene.itemParent = nil --关卡点击物品父级

ChapterScene.sceneParent = nil -- 打开这个界面的场景

-- 关卡转盘相关配置
ChapterScene.levelEggPrefabs = { -- <关卡蛋预设名>表格
    ["default"] = "Level/scenes_level_bata02 1",
    [101] = "Level/scenes_level_demo01",
    [102] = "Level/scenes_level_sea01",
    [103] = "Level/scenes_level_town01",
    [104] = "Level/scenes_level_village01",
    [105] = "Level/scenes_level_cave01",
    [106] = "Level/scenes_level_sea01",
    [107] = "Level/scenes_level_sea01",
    [108] = "Level/scenes_level_sea01",
}

ChapterScene.levelCircleTable = { -- 关卡转盘配置项 by hanli_xiong
    levelPanelEulerAngles = UnityEngine.Vector3(0, 0, -10), -- 关卡圈初始倾斜角度
    levelPanelPos = UnityEngine.Vector3(-30, 10.8, 0), -- 关卡圈初始坐标
    totleLevels = 8, -- 总关卡数
    eggsNum = 24, -- 关卡蛋总数
    preAngle = 360/24, -- 间隔角度
    --滑动 当前蛋的特效数值
    eggScaleTo = Vector3(0.9,0.9,0.9),
     eggRotationTo =  Vector3(1,1,-30),
    eggBeginScale = Vector3(0.6,0.6,0.6),
    eggBeginRotation = Vector3(1,1,1),
    AniTime = 0.6,
}


-- UI面板
ChapterScene.uictrl = nil -- UI控制器
ChapterScene.uiTopPanelObj = nil --顶部面板
ChapterScene.levelInfoLabel = nil
ChapterScene.chapterSceneObj = nil -- 场景对象

function ChapterScene:Awake()
	--print("-----------------BaseBehaviour Awake--->>>-----------------")
    --GamePrint("2222222222222")
    self.mainCamera = find("Camera"):GetComponent(UnityEngine.Camera.GetClassType())
	SetCameraParam(1007,self.mainCamera)
	--加载数据
    self.management = ChapterManagement.new()
    self.management:Awake(self)
   -- self.uiRoot = newobject(Util.LoadPrefab("UI/battle/UI Root"))
	--self.uiRoot.name = 'UI Root'
    self.uiRoot = find("UI Root")
    self.itemParent = GameObject.New()
    self.itemParent.name = "ChapterItemContainer"
   -- self.itemParent = find("sceneUI")
    
    self.uictrl = UICtrlBase.new()
    self.ChapterObjList = {}
    --前一个章节
    self.onceLevelIndex = nil
    --开始镜头动画
    --self.mainCamera = find("MainCamera"):GetComponent(UnityEngine.Camera.GetClassType())     --查找主摄像头
   -- self.bStartAnimation = true
   -- self.CurrentFov = self.mainCamera.fieldOfView --获取摄像机的视距
    --self.mainCamera.fieldOfView = ConfigParam.SelectChapterMinFov
    self.chapterSceneObj  =newobject(Util.LoadPrefab("Level/ChapterScene"))
    self.uiCamera = find("CameraUI"):GetComponent(UnityEngine.Camera.GetClassType())
    self.uictrl:Awake()
    self:InitUI()
end

--启动事件--
function ChapterScene:Start()
   -- self:InitUI()
   --iTween.CameraFadeAdd(); 
   --iTween.CameraFadeTo(iTween.Hash("amount", 1, "time", 2, "delay", 1));
    
    self.infoTxt = TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
    if self.infoTxt == nil or self.infoTxt[TxtFactory.CUR_BATTLE_ID] == nil then
        --获取关卡进度信息
        self.management:sendChapterInfo()
    else
        self:CreatPanel()
    end
    -- self:CreatPanel()
end


-- 加载界面
function ChapterScene:LoadUI(name)
    local path = "UI/"..name
    local obj = newobject(Util.LoadPrefab(path))
    obj.gameObject.transform.parent = self.uiRoot.gameObject.transform
    obj.gameObject.transform.localPosition = Vector3.zero
    obj.gameObject.transform.localScale = Vector3.one
    return obj
end

function ChapterScene:Update()
    if self:uiSelected(self.uiCamera) then
		return
	end
	
    self:MoveAction()

    --print("-----------------Desmond Update-->>>-----------------")
end

function ChapterScene:FixedUpdate()
	-- body
end

--更新关卡
function ChapterScene:updateChapter()
    -- body
end

-- 初始化UI
function ChapterScene:InitUI()
  self.sceneTarget = self:AddUIButtonCtrlOnObj(self.uiRoot,"UICtrlChapterLua")
    self.uiTopPanelObj = self.uictrl:LoadUIPrefab("UI/Chapter/PanelTopUI")
   self:boundButtonEvents(self.uiTopPanelObj)
end

function ChapterScene:ChapterSceneBackBtnOnClick()
    self:SetActive(false)
    --self.sceneParent:SetIsBuildScene(true)
    self.sceneParent:SetActive(true)
    SetCameraParam(1006,self.mainCamera)
end

function ChapterScene:SetActive(active)
    if active then
        SetCameraParam(1007,self.mainCamera)
        --self:InitUI()
    end
    self.itemParent.gameObject:SetActive(active)
    self.chapterSceneObj:SetActive(active)
    self.uiTopPanelObj:SetActive(active)
end


-- 显示关卡等级
function ChapterScene:ShowLevelInfo(levelId)
    if self.levelInfoLabel == nil then
        self.levelInfoLabel = self.uiTopPanelObj.transform:Find("UI/UIGame/LevelInfo")
    end
    if levelId == nil then
        self.levelInfoLabel.gameObject:SetActive(false)
    else
        self.levelInfoLabel.gameObject:SetActive(true)
        self.levelInfoLabel:GetComponent('UILabel').text = "Level " .. levelId
         iTween.ScaleTo( self.ChapterObjList[self:GetCurEggIndex()],self.levelCircleTable.eggScaleTo, self.levelCircleTable.AniTime);
         iTween.RotateTo( self.ChapterObjList[self:GetCurEggIndex()], self.levelCircleTable.eggRotationTo, self.levelCircleTable.AniTime);
        if self.onceLevelIndex ~= self:GetCurEggIndex() then
            if self.onceLevelIndex~= nil then
               iTween.ScaleTo( self.ChapterObjList[self.onceLevelIndex], self.levelCircleTable.eggBeginScale, self.levelCircleTable.AniTime);
               iTween.RotateTo( self.ChapterObjList[self.onceLevelIndex], self.levelCircleTable.eggBeginRotation, self.levelCircleTable.AniTime);
            end  
        end
        self.onceLevelIndex = self:GetCurEggIndex() 
      
    end
end

--－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－ 转盘代码
ChapterScene.moveBasePoint = nil -- 起始点
ChapterScene.distance = nil --鼠标移动距离
ChapterScene.angle = nil --旋转角度
ChapterScene.angleT = 0 
ChapterScene.pointer = nil -- 关卡指针偏移角度
ChapterScene.isMove = false --是否在旋转
ChapterScene.levelIndexTable = {} -- [关卡等级] = 转盘对应旋转角
ChapterScene.chapterItemFlag = "ChapterItem"
--播放解锁章节的特效
--当期解锁的
ChapterScene.CurrentUnlockItem = nil
--当前已解锁的
ChapterScene.CurrentLockItem= nil
ChapterScene.CurrentChapterId = 0
ChapterScene.IsPlayAnimation = false
--播放解锁章节的特效
    
--初始化时创建面板
function ChapterScene:CreatPanel()
    self.infoTxt = TxtFactory:getMemDataCacheTable(TxtFactory.ChapterInfo)
    local index = 1
    local radius =  math.abs(self.levelCircleTable.levelPanelPos.x)
    --播放解锁章节的特效
    --当期解锁的
    self.CurrentUnlockItem = nil
    --当前已解锁的
    self.CurrentLockItem= nil
    
    local isCurrentUnlock = false
    self.IsPlayAnimation = false
    --播放解锁章节的特效
    
    for a = 0, (360 - self.levelCircleTable.preAngle), self.levelCircleTable.preAngle do
        local prefabName = self.levelEggPrefabs["default"]
        local infoId = self:parseLevelNum(index) + 100
        local pos = UnityEngine.Vector3(radius, 0, 0)
        
        --需要播放解锁特效时生成两个 判断当前有没有这个
        
        --   暂时屏蔽 一堆bug  gaofei
        --[[
        if Util.HasKey("CurrentChapterID") and infoId == tonumber(Util.GetString("CurrentChapterID"))
         and self.infoTxt.chapter_info[infoId] and (not self.IsPlayAnimation) 
         then
            prefabName = self.levelEggPrefabs["default"]
            pos = UnityEngine.Vector3(radius, 0, 0)
            local trans =  self:CreatItem(index, prefabName)
            trans.localPosition = pos
            trans:RotateAround(self.itemParent.transform.position, self.itemParent.transform.up, -a)
            isCurrentUnlock = true
            self.CurrentLockItem = trans
            self.IsPlayAnimation = true
            self.CurrentChapterId = infoId
        end
        ]]--
        if self.infoTxt.chapter_info[infoId] then -- 如果改章节已经解锁
            
            prefabName = self.levelEggPrefabs[infoId]
            pos = UnityEngine.Vector3(radius, -4, 0)
        end
    
         
        local trans = self:CreatItem(index, prefabName)
        self.ChapterObjList[index] = self.item
        if isCurrentUnlock then
           self.CurrentUnlockItem =  trans
           isCurrentUnlock = false
        end
        
        trans.localPosition = pos
        trans:RotateAround(self.itemParent.transform.position, self.itemParent.transform.up, -a)
        
        -- print("index = " .. index .. "angle = " .. -a)
        self.levelIndexTable[index] = -a
        index = index + 1
    end
    -- 初始化关卡转盘形态
    self.itemParent.transform.position = self.levelCircleTable.levelPanelPos
    self.itemParent.transform:Rotate(self.levelCircleTable.levelPanelEulerAngles)
    self.pointer = self.levelIndexTable[1]
    self:ShowLevelInfo(1)
     
    if self.infoTxt.cur_battle_id == nil then
        self.pointer = self.levelIndexTable[1]
        self:ShowLevelInfo(1)
    else
        local chapterTable =  TxtFactory:getTable(TxtFactory.ChapterTXT) 
        local chapterID = chapterTable:GetData(self.infoTxt.cur_battle_id,TxtFactory.S_CHAPTER_TYPE)
        self:TurnToFront(chapterID % 100)
    end
    
    if self.IsPlayAnimation then
        self:SetIsDelayModelClick(3)
        self:PlayOpenChapter()
        self.CurrentUnlockItem.gameObject:SetActive(false)
        self.IsPlayAnimation = false
    end
end

--开启章节播放动画
function ChapterScene:PlayOpenChapter()
    -- 暂时屏蔽  (一堆bug)  gaofei 
--[[
    self.animView = ExtractUIAnim.new() -- 创建动画类
    self.scene =self
     self.animView:init(self)
    self.animView.extractType = 20 -- 动画类型十连抽
	self.animView.animType = 0 -- 抽取类型  0 为蛋 1 为宝箱左  2 为宝箱右
    self.animView:SetBgAction(false)
	-- print("抽取动画类型"..anType)
	-- 播放动画
    local finishDelegate = function (scene)
       --播放完成以后 

       scene.CurrentUnlockItem.gameObject:SetActive(true)
       scene.CurrentLockItem.gameObject:SetActive(false)
       Util.SetString("CurrentChapterID","-1")
    end
	self.animView:startAnim(finishDelegate)    
    ]]--
end



--创建关卡点击物品
function ChapterScene:CreatItem(index, prefabName)


    self.item = newobject(Util.LoadPrefab(prefabName))
    self.item.transform.parent = self.itemParent.transform
    self.item.transform.localScale = UnityEngine.Vector3(0.66, 0.66, 0.66);
    -- self.item.gameObject.transform:LookAt(self.itemParent.transform) -- 全部向圆心看齐
    self.item.name = self.chapterItemFlag .. " " .. index
    local collider = self.item:GetComponent(UnityEngine.BoxCollider.GetClassType())
    collider.isTrigger = true
   
    return self.item.gameObject.transform
end

-- 打印关卡转盘的欧拉角
function ChapterScene:PrintEulerAngles()
    local euler = self.itemParent.transform.eulerAngles
    --warn("欧拉角:" .. "x=" .. euler.x .. "y=" .. euler.y .. "z=" .. euler.z)
    local rotation = self.itemParent.transform.rotation
    --warn("四元数:" .. "x=" .. rotation.x .. "y=" .. rotation.y .. "z=" .. rotation.z)
end

--旋转
function ChapterScene:MoveAction()

    if self.angleT > 0 then
        self.isMove = true
        local direction = -self.angle/math.abs(self.angle) -- 旋转方向
        local speed = self.levelCircleTable.preAngle * Time.deltaTime * 2 -- 旋转速度
        self.angleT = self.angleT - speed
        -- self.itemParent.transform:Rotate(Vector3(0,-self.angle/math.abs(self.angle)*2,0))
        self.itemParent.transform:Rotate(Vector3(0, direction * speed, 0))
        -- self.itemParent.transform.rotation = Quaternion.AngleAxis(15, Vector3(math.sin(a), math.cos(a), 0))
    elseif self.angleT < 0 then
        local direction = -self.angle/math.abs(self.angle) -- 旋转方向
        self.itemParent.transform:Rotate(Vector3(0, direction * self.angleT, 0)) -- 转过头调整
        self.angleT = 0
        -- self:PrintEulerAngles()
        self:ShowLevelInfo(self:GetCurLevel())
    end

    if Input.GetMouseButton(0) then
        self:MoveChapter()
        return
    end

    self:CheckClickItem()

    self.isMove = false
    self.moveBasePoint = nil
    self.distance = nil
end

function ChapterScene:MoveChapter(distance)
    --开启章节播放动画的时候是不能移动的   
    if self:GetIsDelayModelClick() then
        return
    end
    
    if self.isMove == true then
        return
    end
    if self.moveBasePoint == nil then 
        self.moveBasePoint = Input.mousePosition
        return
    end
    local a = Input.mousePosition
    local b = self.moveBasePoint 
    self.distance = a.x - b.x
    local hmove = Input.GetAxis("Mouse X") -- 水平方向位移
    if distance ~= nil then
        hmove = distance
    end
    if math.abs(self.distance) > 50 then
        self.isMove = true 
        self.moveBasePoint = Input.mousePosition
        self.angle = self.levelCircleTable.preAngle * self.distance/math.abs(self.distance)
        self.angleT = math.abs(self.angle)
        self.pointer = self.pointer + self.angle
        self.pointer = self.pointer % -360
    end
    -- if math.abs(hmove) > 0.5 then
    --     self.isMove = true
    --     self.angle = self.levelCircleTable.preAngle * hmove/math.abs(hmove)
    --     self.angleT = math.abs(self.angle)
    --     self.pointer = self.pointer + self.angle
    --     self.pointer = self.pointer % -360
    -- end
end

function ChapterScene:CheckClickItem()
    if not Input.GetMouseButtonUp(0) then
        return
    end
   
    if self.isMove == true then
        return
    end
    -- 射线查询
    local ray = self.mainCamera:ScreenPointToRay(Input.mousePosition)
    local flag,hitinfo = UnityEngine.Physics.Raycast (ray, nil, 500)
    if flag == false then
        return
    elseif string.find(hitinfo.collider.gameObject.name, self.chapterItemFlag) then
        local strTable = lua_string_split(hitinfo.collider.gameObject.name, ' ') -- 解析关卡名
        if #strTable < 2 then
            return
        end
        local chooseId = self:parseLevelNum(tonumber(strTable[2]))
        if chooseId == self:GetCurLevel() then
            self:BtnNextLevelAction()
            return
        end
        if math.abs(chooseId - self:GetCurLevel()) == 1 then -- 点中左边或者右边的关卡蛋
            self:MoveChapter(self:GetCurLevel() - chooseId) 
        else
            self:MoveChapter(chooseId - self:GetCurLevel())
        end
    end
end

-- 把对应关卡的关卡蛋转到最前端
function ChapterScene:TurnToFront(levelId)
    -- 得到目标关卡蛋的偏移角度
    local a = self.levelIndexTable[levelId]
    -- 旋转关卡转盘到目标关卡
    if a ~= nil then
        self.itemParent.transform:Rotate(Vector3(0, -a, 0))
        self.pointer = a
        self:ShowLevelInfo(levelId)
    else
        warn("找不到这个关卡ID:" .. levelId)
    end
end

-- 得到当前指向的关卡等级
function ChapterScene:GetCurLevel()
    local curlevel = 1
    for k, v in pairs(self.levelIndexTable) do
        if v == self.pointer then
            curlevel = k
            break
        end
    end
    return self:parseLevelNum(curlevel)
end

--获得当前第几个蛋
function ChapterScene:GetCurEggIndex()
        local curlevel = 1
    for k, v in pairs(self.levelIndexTable) do
        if v == self.pointer then
            curlevel = k
            break
        end
    end
    return curlevel
end

-- 把关卡蛋号码转换成关卡ID (私有)
function ChapterScene:parseLevelNum(levelNum)
    local id = levelNum % self.levelCircleTable.totleLevels
    if id == 0 then
        id = self.levelCircleTable.totleLevels
    end
    return id
end

--－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－ 转盘代码

--点击选择关卡蛋 跳转选自关卡场景
function ChapterScene:BtnNextLevelAction()
    -- 确定关卡大章
    local targetChapter = 100 + self:GetCurLevel()

    if not self.infoTxt.chapter_info[targetChapter] then -- 如果改章节没有解锁
        warn("章节" .. targetChapter .. "尚未解锁！")
        self:promptWordShow("该章节尚未解锁！")
        return
    end
   
    self.infoTxt[TxtFactory.SELECTED_CHAPTER_ID] =targetChapter
    print("关卡大章---" .. targetChapter)
    -- 加载小关场景
	self:OpenLevelScene()
   -- self:ChangScene(SceneConfig.selectChapterScene)
    
end

-- 设置打开这个界面的场景
function ChapterScene:SetSceneTarget(sceneParent)
	self.sceneParent = sceneParent
    self.UIChild = sceneParent.UIChild
end

-- 打开剧情界面(大关卡)
function ChapterScene:OpenLevelScene()
    self:SetActive(false)
    self:GetUIChild(SceneConfig.selectChapterScene):SetActive(true)
    self:GetUIChild(SceneConfig.selectChapterScene):SetSceneTarget(self)
    self:GetUIChild(SceneConfig.selectChapterScene):SetSceneTargetCameraId(1007)
    
   -- self:SetIsBuildScene(false)
end

function ChapterScene:GetUIChild(name)
    return self.UIChild:Get(name)
end


