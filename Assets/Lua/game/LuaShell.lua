--[[
  author Desmond
  与c＃ BaseLua 绑定，为lua逻辑层封装一层通用shell
]]

require "Common/define"
require "Common/functions"
require "Common/ZZBase64"

LuaShell = {}
local coreList = {}--存放所有和c#绑定的lua对象
LuaShell.DesmondID = nil --主角id
local userData = {} --user data 管理
local assetData = {} --镜像 管理

--[[
清理corelist
]]
function LuaShell.clear()
    for key, value in pairs(coreList) do      
        coreList[key] = nil 
        if value ~= nil then
            value.gameObject = nil
        end
    end 

    local cSharpObjs = #userData
    for i=1,cSharpObjs do
        local obj = table.remove(userData)
        if obj ~= nil then
            destroy(obj)
        end
    end

    for key,value in pairs(assetData) do
        if value ~= nil then
            --GameObject.Destroy(key)
            destroy(key)
            --UnityEngine.Resources.UnloadAsset(key)
            --Util.UserdataGC()
            assetData[key] = nil
        end
    end

    LuaShell.DesmondID = nil
end
--[[反射出lua类，并插入corelist
    instanceID c#对象唯一id
    在awake前先被调用

    param: instanceID 父gameobject唯一id
           name 调用lua类名
           params 初始化参数 由c＃传入

]]
function LuaShell.setCore( instanceID,name,gameObj,params)
    --print('----------------------------setCore '..tostring(name)..' '..tostring(instanceID))
    if name == nil or _G[name]==nil then
        --print('----------------------------function LuaShell.setCore( instanceID,name,gameObj,params) 2 ')
        return
    end
    local core = _G[name].new()
    --[设置初始化参数]
    local preParams = nil
    if coreList[instanceID] ~=nil then --由lua传入
        preParams = coreList[instanceID]
    end
    if params == nil then
        params = preParams
    end

    coreList[instanceID] = core

    LuaShell.runFunc(instanceID,"setParent",gameObj,params)
end

function LuaShell.Awake(instanceID)
    LuaShell.runFunc(instanceID,"Awake")
    -- for k=1 , #coreList do
    --     core = coreList[k]
    --     if core[2] == true then
    --         core[1]:Awake()
    --     end
    -- end
end

--启动事件--
function LuaShell.Start(instanceID)
    --print ("--------------------------------function LuaShell.Start(instanceID) >>>>>>>>---------------"..tostring(instanceID))
    LuaShell.runFunc(instanceID,"Start")

end

function LuaShell.Update(instanceID)
    --print("------------------function LuaShell.Update(instanceID) ")
    LuaShell.runFunc(instanceID,"Update")

end

function LuaShell.OnEnable(instanceID)
    LuaShell.runFunc(instanceID,"OnEnable")
end

function LuaShell.OnDisable(instanceID)
    LuaShell.runFunc(instanceID,"OnDisable")
end

function LuaShell.FixedUpdate( instanceID )
    LuaShell.runFunc(instanceID,"FixedUpdate")
end

function LuaShell.LateUpdate( instanceID )
    LuaShell.runFunc(instanceID,"LateUpdate")
end

function LuaShell.OnGUI(instanceID)
    LuaShell.runFunc(instanceID,"OnGUI")

end

function LuaShell.OnAnimatorIK(instanceID)
    --print ("-------------------------- >>>>>>>> LuaShell.OnAnimatorIK(instanceID)")
    LuaShell.runFunc(instanceID,"OnAnimatorIK")
end


function LuaShell.DoAction(instanceID,action)
    LuaShell.runFunc(instanceID,"DoAction",action)

end

function LuaShell.DoUIButton(instanceID,buttonType,button)
    --print ("---------------------------------function LuaShell.DoUIButton(instanceID,buttonType,button) ")
    LuaShell.runFunc(instanceID,"DoUIButton",buttonType,button)
end

function LuaShell.OnTriggerEnter( instanceID,gameObj )
    --print ("---------------------LuaShell.OnTriggerEnter-->>>"..tostring(instanceID))
    --print ("---------------------other-->>>"..tostring(gameObj.gameObject:GetInstanceID()))
    LuaShell.runFunc(instanceID,"OnTriggerEnter",gameObj)

end

function LuaShell.OnTriggerStay( instanceID,gameObj )
    --print ("---------------------LuaShell.OnTriggerStay-->>>"..tostring(instanceID))
    --print ("---------------------other-->>>"..tostring(gameObj.gameObject:GetInstanceID()))
    LuaShell.runFunc(instanceID,"OnTriggerStay",gameObj)

end

function LuaShell.OnTriggerExit( instanceID,gameObj )
    --print ("---------------------other-->>>"..tostring(gameObj.gameObject:GetInstanceID()))
    LuaShell.runFunc(instanceID,"OnTriggerExit",gameObj)

end

function LuaShell.OnCollisionEnter( instanceID,collision )
    LuaShell.runFunc(instanceID,"OnCollisionEnter",collision)

end

function LuaShell.OnCollisionStay( instanceID,collision )
    LuaShell.runFunc(instanceID,"OnCollisionStay",collision)
    
end

function LuaShell.OnCollisionExit( instanceID,collision )
    LuaShell.runFunc(instanceID,"OnCollisionExit",collision)
    
end
--子物体消息
function LuaShell.OnMsgTriggerEnter(obj,gameObj)
    LuaShell.runFunc(obj.transform.parent.gameObject:GetInstanceID(),"OnMsgTriggerEnter",obj,gameObj)
end


--销毁--
function LuaShell.OnDestroy(instanceID)
    LuaShell.runFunc(instanceID,"OnDestroy")
    local c = coreList[instanceID]
    if c ~= nil then
        coreList[instanceID] = nil
    end
end

--itween回调
function LuaShell.itweenCallback(instanceID)
    LuaShell.runFunc(instanceID,"itweenCallback")
end

--[[方法反射，调用core中方法]]
function LuaShell.runFunc( instanceID,func,... )
    --print('---------------------------- '..tostring(func)..' '..tostring(instanceID))
    local core = coreList[instanceID]
    if core ~= nil then
        core[func](core,...)
    end
end
---------------------------------------------------------------------------------------------------------------------------
----------------------------------------------lua逻辑代码里的调用方法---------------------------------------------------------
--加入userdata
function LuaShell.addUserData( userdata,isAsset )
    if isAsset ~= nil then
        --GamePrint("---------function LuaShell.addUserData( userdata,isAsset ) 1")
        if assetData[userdata] == nil then
            --GamePrint("---------function LuaShell.addUserData( userdata,isAsset ) 2")
            assetData[userdata] = true
        end
        return
    end
    table.insert(userData,userdata)
end


function LuaShell.getRole( roleID )
    return coreList[roleID]
end

function LuaShell.setPreParams( ojbID,params )
    coreList[ojbID] = params
end
--[[响应trigger事件]]
function LuaShell.doTriggerEnter( passiveID,roleID )
    local role = coreList[roleID]
    local passive = coreList[passiveID]
    if role ~=nil and passive ~=nil and role.tag == 'Desmond' then --和Desmond碰撞　
        --passive[1]:OnDestroy()
        passive:doTriggerEnter(role)
    end
end

--[[响应trigger事件]]
function LuaShell.doTriggerExit( passiveID,roleID )
    local role = coreList[roleID]
    local passive = coreList[passiveID]
    if role ~=nil and passive ~=nil and role.tag == 'Desmond' then --和Desmond碰撞　
        --passive[1]:OnDestroy()
        passive:doTriggerExit(role)
    end
end

function LuaShell.doCollision( passiveID,roleID )
    local role = coreList[roleID]
    local passive = coreList[passiveID]
    if role ~=nil and passive ~=nil and role.tag == 'Desmond' then --和Desmond碰撞　
        --passive[1]:OnDestroy()
        passive:doCollision(role)
    end
end


--主角与物体碰撞，收集物检测
function LuaShell.EliminateCollisionFromDesmond(collision)
    --print ("-------function LuaShell.EliminateCollisionFromDesmond(collision)")
    local obj = LuaShell.getRole(collision.gameObject.transform.parent.gameObject:GetInstanceID())
    if obj == nil then 
        return
    end
    if obj.type ~= "EliminateItemGroup" and obj.type ~= "CoinGroupForMidasTouch" then
        return
    end
    
    obj:touchedWithPlayer(collision.gameObject)
end

--获取动态创建碰撞物载入loader
function LuaShell.getBattleObjectLoader()
    local scene = find (ConfigParam.SceneOjbName)
    local luaObj = LuaShell.getRole(scene.gameObject:GetInstanceID())
    if luaObj ~= nil and luaObj.name == "BattleScene" then
        return luaObj:getObjLoader()
    end
end

--获取动态创建碰撞物载入loader
function LuaShell.getBattleCamera()
    local scene = find (ConfigParam.SceneOjbName)
    local luaObj = LuaShell.getRole(scene.gameObject:GetInstanceID())
    if luaObj ~= nil and luaObj.name == "BattleScene" then
        return luaObj:getCamera()
    end
end















