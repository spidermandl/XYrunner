--[[
关卡配置表
author:Desmond
修改:sunkai
]]
ChapterTXT = class (TableTXT)

ChapterTXT.tag = "ChapterTXT"

ChapterTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."chapter_config.txt"                  --记录文件地址和名字

ChapterTXT.chapterNum = nil

function ChapterTXT:GetData(id,column)
    if column == TxtFactory.S_CHAPTER_TYPE then --关卡章节
    	return math.floor(tonumber(id)/1000)
    end

	return self.super.GetData(self,id,column)
end
-- 获取关卡的奖杯任务表
function ChapterTXT:GetLevelCupTask(id)
	local taskIdStr = self.GetData(self, id, "CupTaskID")
	return lua_string_split(taskIdStr, ";")
end

-- 获取关卡的奖励表
function ChapterTXT:GetLevelReward(id)
	local rewardStr = self.GetData(self, id, "StarsTaskID")
	local taskTxt = TxtFactory:getTable(TxtFactory.TaskTXT)
	local taskLinedata = taskTxt:GetLineByID(rewardStr)
	
	return taskLinedata
end


-- 获取关卡的坐标
function ChapterTXT:GetLevelPos(id)
	local posStr = self.GetData(self,id, "Coordinate")
	--print("posStr = " .. posStr)
	local posTable = string.split(posStr, ";")
	if #posTable < 3 then
		--warn("得不到关卡坐标:" .. id)
		return Vector3.zero
	end
	return UnityEngine.Vector3(tonumber(posTable[1]), tonumber(posTable[2]), tonumber(posTable[3]))
end
--获取关卡的旋转
function ChapterTXT:GetLevelRotation(id)
	local posStr = self.GetData(self,id, "Rotation")
	--print("posStr = " .. posStr)
	local posTable = string.split(posStr, ";")
	if #posTable < 3 then
		--warn("得不到关卡坐标:" .. id)
		return Quaternion.Euler(0,90,0)
	end
	return Quaternion.Euler(tonumber(posTable[1]), tonumber(posTable[2]), tonumber(posTable[3]))
end

--获取当前关卡的索引值
function ChapterTXT:GetCurrentLevelIndex(id)

	for i = 1,#self.TxtLines do
		--print ("self.TxtLines: "..self:GetData(i,"ID"))
		
		if tonumber(self:GetData(i,"ID")) == id then
			return i
		end
	end
	error ("no find id : "..id)
	return 0
end
-- 获取子关卡数 -- id = 101, 102...
function ChapterTXT:GetChildLevelNum(id)
	local num = 0
	for k, v in pairs(self.TxtArray) do
		if math.floor(tonumber(k)/1000) == id then
			num = num + 1
		end
	end
	if num == 0 then
		warn("没有找到子关卡:" .. id)
	end
	return num
end

-- 获取章节总数
function ChapterTXT:GetChapterNum()
	if self.chapterNum == nil then
		local num = 0
		for k, v in pairs(self.TxtArray) do
			if math.floor(tonumber(k)/1000) > 1 then
				num = num + 1
			end
		end
		self.chapterNum = num
	end
	return self.chapterNum
end

--返回是一个数字 没有找到返回0
function ChapterTXT:GetLevelIDByScenesId(ScenesId)
	local retLevelID = 0
	for i = 1,#self.TxtLines do
		if self:GetData(i,"ScenesId") == ScenesId then
			retLevelID = tonumber(self:GetData(i,"ID"))
		end
	end
	return retLevelID
end

