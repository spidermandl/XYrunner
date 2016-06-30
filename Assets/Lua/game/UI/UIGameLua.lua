--[[UIGame控制类]]

UIGameLua = class(BaseBehaviour)

--Desmond.gameObject =nil --场景object
UIGameLua.tag = "UIGameLua"
UIGameLua.roleName = "UIGameLua"

function UIGameLua:Awake()
end

function UIGameLua:Start()
end

function UIGameLua:Update()
end

function UIGameLua:FixedUpdate()
end

function UIGameLua:OnGUI()
	-- body
end

function UIGameLua:DoAction(action)
	LuaShell.getRole(LuaShell.DesmondID):DoAction(action)
end


--销毁--
function UIGameLua:OnDestroy()
end

function UIGameLua:itweenCallback()
end