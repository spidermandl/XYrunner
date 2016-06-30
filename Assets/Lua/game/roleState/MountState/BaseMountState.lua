--[[
author :Desmond
坐骑基类
]]
BaseMountState = class(IState)

BaseMountState._name = nil

BaseMountState.effect=nil --特效实例

BaseMountState.animator = nil --主角动画
BaseMountState.mount = nil --坐骑模型
BaseMountState.mountAnimator = nil --坐骑动画

function BaseMountState:Enter(role)
	-- self.super.Enter(self,role)
end

function BaseMountState:Excute(role,dTime)
	-- self.super.Excute(self,role,dTime)
end

function BaseMountState:Exit(role)
	-- self.super.Exit(self,role)
end

--获取坐骑动画
function BaseMountState:getMountAnimator()
	return self.mountAnimator
end

function BaseMountState:playMountAnimation( name )
	--print ("---------------------->>>>>>>>  function CNMMountState:playMountAnimation( name ) "..name)
    self.mountAnimator:Play(name)
end

function BaseMountState:AddEffect(role,effectName)
	self.effect =newobject(Util.LoadPrefab("Effects/Common/"..effectName))
	-- newobject(Util.LoadPrefab("Effects/Common/ef_pleyer_male_chongci"))
    self.effect.transform.parent=role.gameObject.transform
    self.effect.transform.position = role.gameObject.transform.position
    self.effect.transform.localScale = role.gameObject.transform.localScale
end