--[[
author:Desmond
特效管理器
]]
EffectGroup = class (ObjectGroup)
EffectGroup.name = "EffectGroup"
EffectGroup.timeTable = nil --特效播放时间记录
EffectGroup.loopTable = nil --需要循环播放的特效

--[[增加 object]]
--loop 动画是否循环,根据时间控制的传入时间,否则传入true
function EffectGroup:addObject(obj ,loop)
	self.super.addObject(self,obj)
    
    if self.timeTable == nil then
    	self.timeTable = {}
    end
    self.timeTable[obj] = UnityEngine.Time.time

    if self.loopTable == nil then
    	self.loopTable = {}
    end
    if loop ~= nil then
    	self.loopTable[obj] = loop
	end

    local pArray = obj.transform:GetComponentsInChildren(UnityEngine.ParticleSystem.GetClassType())
    local length = pArray.Length-1 
    for i=0,length do
    	System.Array.GetValue(pArray,i):Stop()
    	System.Array.GetValue(pArray,i):Play()
	end
end

--删除特效
function EffectGroup:removeObject(obj)
	self.super.removeObject(self,obj)
end
--移除循环特效
function EffectGroup:removeLoop(obj)
	if self.loopTable ~= nil then
		self.loopTable[obj] = nil
	end
end

function EffectGroup:Update()
	--self.super.Update(self)
	local currentTime = UnityEngine.Time.time
    for k,v in pairs(self.objGroup) do --遍历group 执行c＃绑定lua update
    	if v ~= nil then
		    local pArray = v.transform:GetComponentsInChildren(UnityEngine.ParticleSystem.GetClassType())
			local length = pArray.Length - 1
			local isFinished = true
			for i=0,length do
				if System.Array.GetValue(pArray,i).isPlaying == true then
					isFinished = false
				end
			end
            
			if self.loopTable[v] then --需要循环播放的特效
				--如果传入的是时间根据时间控制特效播放
				if self.timeTable[v] ~= nil and type(self.loopTable[v]) == "number" and currentTime - self.timeTable[v] > self.loopTable[v]-0.4 then --提前一帧结束特效
					self:removeObject(v)
					self:removeLoop(v)
					self.timeTable[v] = nil
				end
			else
				if isFinished == true then --特效放完 inactive
					self:removeObject(v)
					self.timeTable[v] = nil
					return
				end
				if self.timeTable[v] ~= nil and currentTime - self.timeTable[v] > 5 then --特效超时 inactive
					self:removeObject(v)
					self.timeTable[v] = nil
				end
			end
     	end
    end
end

function EffectGroup:FixedUpdate()
end

function EffectGroup:LateUpdate()    
end