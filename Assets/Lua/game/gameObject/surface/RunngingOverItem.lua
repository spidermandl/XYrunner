-- 碰到该物品游戏结束

RunngingOverItem = class (BaseBehaviour)
RunngingOverItem.roleName = "RunngingOverItem"
RunngingOverItem.collider = nil 

function RunngingOverItem:Awake()
    if ConfigParam.FilterColliderMash == true then--去碰撞物mesh
        -- destroy(self.gameObject:GetComponent(UnityEngine.MeshFilter.GetClassType()))
     --    destroy(self.gameObject:GetComponent(UnityEngine.MeshRenderer.GetClassType()))
    end

    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true
    self.collider.center=UnityEngine.Vector3(-1,0,0)
    --self.gameObject.transform.rotation = Quaternion.Euler(0,-90,0)
    self.collider.size=UnityEngine.Vector3(2,20,1)
    --self:Create()
end

--启动事件--
function RunngingOverItem:Start()
end


function RunngingOverItem:FixedUpdate()
end

function RunngingOverItem:Update()
end

function RunngingOverItem:Create()
        --[[设置碰撞体]]
    self.collider = self.gameObject:AddComponent(UnityEngine.BoxCollider.GetClassType())
    self.collider.isTrigger = true
   -- self.collider.center=UnityEngine.Vector3(0,0.8,0)
    self.collider.size=UnityEngine.Vector3(10,100,10)
    -- self.collider.size.x = 10
    -- self.collider.size.y = 40
    -- self.collider.size.z = 10
end

function RunngingOverItem:OnTriggerEnter( gameObj )
	if gameObj.gameObject:GetInstanceID() ~= LuaShell.DesmondID then --与主角碰撞
        return
    end
    local des = LuaShell.getRole(LuaShell.DesmondID)  
    local scene = find(ConfigParam.SceneOjbName)
    local battleScene = LuaShell.getRole(scene.gameObject:GetInstanceID())
    if battleScene.BattleGuideView.isGuideLevel == true then
        --return
        if battleScene.BattleGuideViewFinish == true then
            return
        end
        --des.stateMachine:addSharedState(BlockState.new())-- 被墙格挡状态
        battleScene.mainCamera.stateMachine:changeState(CameraStayState.new())
        battleScene:VictoryUIPanelShow(nil,nil)
        battleScene.BattleGuideViewFinish = true
        return
    end

    --local des = LuaShell.getRole(LuaShell.DesmondID)  
    if des.stateMachine.sharedStates["PathFindingState"] then
        --如果有自动寻路状态，进入冲刺结算状态
        des.stateMachine:addSharedState(FinalSpurtState.new())
    else
        des.stateMachine:changeState(VictoryState.new())
    end
    
    --FailedState VictoryState
    print("GameOver")

   --[[刷新 新手引导进度
    local battleScene = GetCurrentSceneUI()
    if battleScene.BattleGuideView.isGuideLevel == true  then
        battleScene.BattleGuideView:GuideIsFinish()
    end]]
end