--[RollingAttribute控制类]]

RollingAttribute = class()

RollingAttribute.tag = "RollingAttribute"
RollingAttribute.roleName = "RollingAttribute"

RollingAttribute.LabelName="NNN"				--标签，用来分辨Label
RollingAttribute.LabelType="Random"				--滚动类型，是否随机滚动
RollingAttribute.TargetLabel=nil				--要改变的Label
RollingAttribute.From=0							--起始数据，随机滚动时，是TO的位数
RollingAttribute.To=0							--终止数据
RollingAttribute.TargetTime=0					--目标时间
RollingAttribute.AllTime=0						--总时间
RollingAttribute.AverageTime=0					--随机滚动时间隔时间
--初始化滚动属性数据
function RollingAttribute:SetRollingAttribute(labelName,labelType,targetLabel,from,to,allTime)
	self.LabelName=labelName
	self.TargetLabel=targetLabel:GetComponent("UILabel")
	self.LabelType=labelType
	self.From=from
	self.To=to
	self.TargetTime=UnityEngine.Time.time
	self.AllTime=allTime 
	if labelType=="Random"then
		self.From=0
		self:GetNumLength(to)
		if self.From ==0 then
			self.From=1
		end
		self.AverageTime=allTime/self.From
	end
end
--获取数字位数
function RollingAttribute:GetNumLength(num)
	if num>0 then
		num=UnityEngine.Mathf.Floor(num/10)
		self.From=self.From+1
		self:GetNumLength(num)
	end
end

-- --获取labelName
-- function RollingAttribute:GetLabelName()
-- 	-- print("LabelName:Stop:"..self.LabelName)
-- 	return self.LabelName
-- end