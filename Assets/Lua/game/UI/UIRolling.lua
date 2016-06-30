--[UIAction控制类]]

UIRolling = class()

UIRolling.tag = "UIRolling"
UIRolling.roleName = "UIRolling"
UIRolling.RollingList={}						--存放滚动数字的列表

--添加指定label的滚动
function UIRolling:AddRolling(labelName,labelType,targetLabel,from,to,allTime)
	local Rol=RollingAttribute.new()
	Rol:SetRollingAttribute(labelName,labelType,targetLabel,from,to,allTime,self.FinishFun)
	table.insert(self.RollingList,Rol)
end

--通过labelName查询RollingList指针的方法
function UIRolling:FindRolling(labelName)
	if table.getn(self.RollingList)>0 then
		for i=1,table.getn(self.RollingList)do
			if self.RollingList[i].LabelName==labelName then
				return i
			end
		end
	end
end

--通过rollingAttributes查询RollingList指针的方法
function UIRolling:FindRolling(rollingAttributes)
	if table.getn(self.RollingList)>0 then
		for i=1,table.getn(self.RollingList)do
			if self.RollingList[i]==rollingAttributes then
				return i
			end
		end
	end
end

--用来处理滚动的方法
function UIRolling:Rolling(rollingAttributes)
	if rollingAttributes==nil then
		return 0
	end
	if rollingAttributes.LabelType=="Line" then
		self:RollingLine(rollingAttributes)
	elseif rollingAttributes.LabelType=="Random" then
		self:RollingRandom(rollingAttributes)
	end
	
end

--线性变化滚动
function UIRolling:RollingLine(rollingAttributes)
	local tarTime=(UnityEngine.Time.time-rollingAttributes.TargetTime)/rollingAttributes.AllTime
		rollingAttributes.TargetLabel.text=tostring(UnityEngine.Mathf.Floor(UnityEngine.Mathf
			.Lerp(rollingAttributes.From,rollingAttributes.To,tarTime)))
	if tarTime>1 then
		table.remove(self.RollingList,self:FindRolling(rollingAttributes))
	end
end

--随机变化滚动
function UIRolling:RollingRandom(rollingAttributes)
	local teStr=0
	
	if rollingAttributes.From>0 then
		if UnityEngine.Time.time-rollingAttributes.TargetTime>rollingAttributes.AverageTime then
			rollingAttributes.TargetTime=UnityEngine.Time.time
			rollingAttributes.From=rollingAttributes.From-1
		end
		teStr=UnityEngine.Mathf.Floor(rollingAttributes.To/(UnityEngine.Mathf.Pow(10,rollingAttributes.From)))
	else
		table.remove(self.RollingList,self:FindRolling(rollingAttributes))
		return 0
	end
	for i=rollingAttributes.From-1,0,-1 do
		local num=UnityEngine.Random.Range(0,10)
		teStr=teStr*10+num
	end
	rollingAttributes.TargetLabel.text=tostring(teStr)
end

--Update中执行的循环方法
function UIRolling:DoRolling()
		if table.getn(self.RollingList)>0 then
			--print("数量："..table.getn(self.RollingList))
			for i=1,table.getn(self.RollingList)do
				self:Rolling(self.RollingList[i])
			end
		end
end

--停止指定labelName滚动
function UIRolling:StopRolling(labelName)
	table.remove(self.RollingList,self:FindRolling(labelName))
end

--停止所有滚动
function UIRolling:StopRollingAll()
	self.RollingList={}
end

