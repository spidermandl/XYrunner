--SpringEnemySpringState


SpringEnemySpringState = class (BaseEnemyState)

SpringEnemySpringState._name = "SpringEnemySpringState"
SpringEnemySpringState.springACC = 45
SpringEnemySpringState.effectManager = nil --特效管理类
SpringEnemySpringState.effect = nil --特效

function SpringEnemySpringState:Enter(role)
    self.super.Enter(self,role)
    self.effectManager = PoolFunc:pickSingleton("EffectGroup")
    self.effect = PoolFunc:pickObjByPrefabName("Effects/Common/ef_monster_guike")
    self.effectManager:addObject(self.effect)
    self.effect.gameObject.transform.position = role.gameObject.transform.position
    role.dropSpeed = ConfigParam.dropSpeed
    role.movetoLeftSpeed = ConfigParam.springtoLeftSpeed
    --print("role.dropSpeed "..role.dropSpeed)
end

function SpringEnemySpringState:Excute(role,dTime)
      self:Dropbase(role,dTime)
end


function SpringEnemySpringState:Dropbase(role,dTime) --上升

    local dHeight = (role.dropSpeed  - dTime * self.springACC) * dTime

    local flag = false
    if dHeight < 0 then
        flag = true
    else
        flag = false  
    end

	--上升过程:
	--一直上升
	if flag == false then
        role.dropSpeed = role.dropSpeed - dTime * self.springACC
        role.gameObject.transform:Translate(0,dHeight,0)
        role.gameObject.transform:Translate(0,0,UnityEngine.Time.deltaTime * role.movetoLeftSpeed)
        role.IsSpring = 2
	-- 到顶点:
	else
        role.IsSpring = 0
        role.stateMachine:changeState(SpringEnemyDropState.new())
        --GameObject.Destroy(role.effect)
        --self.effectManager.removeObject(self.effect)
        --self.effect = nil
	end

end