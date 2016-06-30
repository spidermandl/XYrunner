
--输出日志--
function log(str)
    Util.Log(str)
end

--打印字符串--
function print(str) 
	Util.Log(str)
end

--错误日志--
function error(str) 
	if str == nil then
		return
	end
	GamePrint("----------"..tostring(str))
	Util.LogError(str)
end

--警告日志--
function warn(str) 
	Util.LogWarning(str)
end

--清除内存
function releaseMemory()
	--LuaShell.clear()
	Util.releaseMemory()
end
--查找对象--
function find(str)
	return GameObject.Find(str);
end

--[[
获取相对路径的component
parent:父gameobject
sType:component的类型
path:相对parent的路径
]]
function getObjectComponent( parent,sType,path)
	local target = parent
	if path ~= nil then
		target = getChildByPath(parent,path)
	end
	local component = target:GetComponent(sType)
	LuaShell.addUserData(component)
	return component
end

--[[
获取相对路径的component
parent:父gameobject
sType:component的类型
path:相对parent的路径
]]
function getObjectComponents( parent,sType,path)
	local target = parent
	if path ~= nil then
		target = getChildByPath(parent,path)
	end
	--GamePrint("----------function getObjectComponents( parent,sType,path) "..tostring(sType))
	local components = target:GetComponents(sType)
	local length = components.Length-1 
	for i=0,length do
		LuaShell.addUserData(System.Array.GetValue(components,i))
	end
	return components
end

--获取子物件
function getChildByPath(parent,path)
	local target = parent.gameObject.transform:FindChild(path)
	if target == nil then
		error("get child object path error : "..tostring(path))
		return
	end
	return target
end


--获得控件
function getUIComponent(parentObj,str,componentStr)
	if componentStr == nil then
		if parentObj ~= nil then
			local comp = parentObj:GetComponent(str);
			if(comp~=nil)then
				return comp
			else
				error("parentObj get component error : "..str)
				return nil 
			end
		else
			error("parentObj is error : ")
		end
	end
	
	local targetObj = getUIGameObject(parentObj,str)
	if targetObj~=nil then
		local comp = targetObj:GetComponent(componentStr);
		if comp~=nil then
			return comp
		else
			error("parentObj get child component error : "..str)
			return nil 
		end
	end
	return nil
end

--查找对象通过父类
function getUIGameObject(parentObj,str)
	if(parentObj ~=nil )then
		local targetObj = parentObj.gameObject.transform:FindChild(str);
		if(targetObj ~=nil)then
			return targetObj;
		else
			error("parentObj get child error : "..str)
			return targetObj
		end
		
	else
		error("parentObj is nil error")
		return parentObj
	end
end

function SetGameObjectLayer(parentObj,targetLayerObj)
	   local childObjArray = parentObj.transform:GetComponentsInChildren(UnityEngine.Transform.GetClassType())
	   for i = 1 , childObjArray.Length do
		  childObjArray[i-1].gameObject.layer =targetLayerObj.gameObject.layer
	   end
end

function destroy(obj)
	GameObject.Destroy(obj);
end

function newobject(prefab)
	--GamePrint("-----------function newobject(prefab) "..tostring(prefab))
	--LuaShell.addUserData(prefab,true)
	local target =  GameObject.Instantiate(prefab)
	--LuaShell.addUserData(target)
	return target
end


--创建面板--
function createPanel(name)
	PanelManager:CreatePanel(name)
end

function child(str)
	return transform:FindChild(str)
end

function subGet(childNode, typeName)		
	return child(childNode):GetComponent(typeName)
end

function findPanel(str) 
	local obj = find(str);
	if obj == nil then
		error(str.." is null")
		return nil
	end
	return obj:GetComponent("BaseLua")
end

--lua字符串分割 Desmond　
function lua_string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

function  SetSprite( gameObj ,name)
	gameObj:GetComponent("UISprite").spriteName = name  
end

function GetSpriteName( gameObj )
	return gameObj:GetComponent("UISprite").spriteName
end

-- 设置特效Renderer的OrderInLayer  -- obj(需要修改层的对象) -- order(需要设置的层级)
function SetEffectOrderInLayer(obj,order)
	local renders  = obj.transform:GetComponentsInChildren(UnityEngine.Renderer.GetClassType())
	local length = renders.Length-1 
	for i=0,length do
		local render = System.Array.GetValue(renders,i)
		render.sortingOrder = order
	end
	
end

-- 获取到当前secenUI
function GetCurrentSceneUI()
	local sceneUI = find("sceneUI")
	return LuaShell.getRole(sceneUI.gameObject:GetInstanceID())
end

-- 游戏输出方法
function GamePrint(str)
	if RoleProperty.isOutputLog then
		print(str)
	end
	
end

-- 游戏内警告输出
function GameWarnPrint(str)
	if RoleProperty.isOutputLog then
		warn(str)
	end
end
function destroyUIButtonMessage(btn)

	local UIRoot = find("UI Root")
	local uieArrey = btn.gameObject:GetComponentsInChildren(UIButtonMessage.GetClassType(),true)
	GamePrint("destroyUIButtonMessage ="..tostring(uieArrey.Length))
	for i = 0,uieArrey.Length -1 do
		uieArrey[i].target = UIRoot
		GameObject.Destroy(uieArrey[i])
	end

end
--根据玩家昵称获取玩家名字
function GetFriendNameByNick(nickname)
	local str = ""
	if nickname == nil or nickname == "" then --服务器添加的电脑人，没名字
	    str = "教官"
	else
		str = nickname
		if pcall(ZZBase64.decode,nickname) then --检查是否能转换为汉字
			str = ZZBase64.decode(nickname)
	   	end
	end
	return str
end

--local FunM = {}
local color = {
    --[[r = "\27[1;31m",
            g = "\27[1;32m",
            y = "\27[1;33m",
            b = "\27[1;34m",
            p = "\27[1;35m"]]
}

-- type to color
local ttc = {
    ['nil']      = 'r',
    ['boolean']  = 'y',
    ['number']   = 'g',
    ['string']   = 'b',
    ['function'] = 'p'
}

local cn = "\27[0m"

--- print the indent
local function pi(indent)
    return string.rep("  ", indent)
end

--- print next line
local function pl()
    return "\n"
end

--- print the variable
local function pv(var, c)
--[[    if c and color[c] then
        return color[c] .. tostring(var) .. cn
    else
        return tostring(var)
    end]]
    return tostring(var)
end

--- print the table
local function pt(var, indent)

    local ret = pv('{')..pl()

    for k, v in pairs(var) do
        ret = ret.. pi(indent + 1)..pv('[')..pv(k, ttc[type(k)])..pv(']  =')

        local t = type(v)
        if t == 'table' then
            ret = ret.. pt(v, indent + 1)
        else
            ret = ret.. pv(v, ttc[t])..pl()
        end
    end

    ret = ret.. pi(indent).. pv('}')..pl()
    return ret
end

function GamePrintTable(var)
	if var == nil then
		return
	end
    local t = type(var)

    if t == 'table' then
        GameWarnPrint(pt(var, 0))
    else
        GameWarnPrint(pv(var, ttc[t])..pl())
    end
end
--四舍五入
function GetRounding(number)
	local num = math.abs(number)
	local r1, r2 = math.modf(num, 1)
	r2 = r2 >= 0.5 and 1 or 0
	num = r1 + r2
	num = number > 0 and num * 1 or num * -1
	return num
end

--添加点击回调
function AddonClick(btn,fun,num)

	local uie = btn:GetComponent("UIEventListener")
	if uie == nil then
		uie = btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end 
	uie.onClick = fun
end

--添加点击回调
function AddonClickNew(id,btn,fun)
	local uieArrey = btn.gameObject:GetComponents(UIEventListener.GetClassType())

	local uie
	if uieArrey ~= nil and uieArrey.Length > id then
		uie = uieArrey[id]
	else
		uie = btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end
	uie.onClick = fun
end

--添加点击回调
function AddonPress(btn,fun)
	local uie = btn:GetComponent("UIEventListener")
	if uie == nil then
		uie = btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end 
	uie.onPress = fun
end

--[[--添加点击回调
function AddonClick(btn,fun)
	local uie = btn:GetComponent("UIEventListener")
	if uie == nil then
		uie = btn.gameObject:AddComponent(UIEventListener.GetClassType())
	end 
	uie.onClick = fun
end
]]

-- 设置相机参数
function SetCameraParam(paramId,mainCamera)
	local gameConfigTXT = TxtFactory:getTable(TxtFactory.GameConfigTXT)
	local cameraPostion = lua_string_split(gameConfigTXT:GetData(paramId,"CONFIG1"), ";")
	local cameraScale = lua_string_split(gameConfigTXT:GetData(paramId,"CONFIG3"), ";")
	local cameraRotation = lua_string_split(gameConfigTXT:GetData(paramId,"CONFIG2"), ";")
	local cameraFieldOfView = tonumber(gameConfigTXT:GetData(paramId,"CONFIG4"))
	--local cameraNear =  tonumber(self.gameConfigTXT:GetData(1005,"CONFIG5"))
	--local cameraFar  =  tonumber(self.gameConfigTXT:GetData(1005,"CONFIG6"))
	-- 设置新的值
	local mainCamera = find("Camera"):GetComponent(UnityEngine.Camera.GetClassType()) 
	mainCamera.fieldOfView =cameraFieldOfView
	
	mainCamera.transform.localPosition = UnityEngine.Vector3(tonumber(cameraPostion[1]),tonumber(cameraPostion[2]),tonumber(cameraPostion[3]))
    mainCamera.transform.localScale = UnityEngine.Vector3(tonumber(cameraScale[1]),tonumber(cameraScale[2]),tonumber(cameraScale[3]))
	mainCamera.transform.localRotation = Quaternion.Euler(tonumber(cameraRotation[1]),tonumber(cameraRotation[2]),tonumber(cameraRotation[3]))
end



