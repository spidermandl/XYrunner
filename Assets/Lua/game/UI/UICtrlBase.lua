--[[
author: hanli_xiong
UI加载类(用于加载UIPrefab,对UI做统一处理)
]]


UICtrlBase = class(BaseBehaviour)

UICtrlBase.uiroot = nil
UICtrlBase.guideManagement = nil --

function UICtrlBase:Awake()
	self.uiroot = find("UI Root")
	if self.uiroot == nil then
		error("找不到'UI Root'，请先创建一个'UI Root'")
	end
end

function UICtrlBase:Start()
end

function UICtrlBase:Update()
end

function UICtrlBase:LoadUIPrefab(prefabs)
	if prefabs == nil then
		warn("UICtrlBase.LoadUIPrefab:" .. "prefabs为空")
		return
	end

	if type(prefabs) == "table" then
		local objTable = {}
		for k, v in ipairs(prefabs) do
			objTable[k] = newobject(Util.LoadPrefab(v))
			objTable[k].transform.parent = self.uiroot.transform
			objTable[k].transform.localPosition = Vector3.zero
			objTable[k].transform.localScale = Vector3.one
		end
		return objTable
	else
		local obj = nil
		obj = newobject(Util.LoadPrefab(prefabs))
		obj.transform.parent = self.uiroot.transform
		obj.transform.localPosition = Vector3.zero
		obj.transform.localScale = Vector3.one
		return obj
	end
end

-- 判断新手引导
function UICtrlBase:UIPanelControl(action)
	local flag = true

	-- 是的话 根据服务器的步骤操作
	local step = 0
	if action ~= "Building_Task" then
		flag = false 
		step = step + 1 
	end

	return flag
end