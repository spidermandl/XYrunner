--[[
author:huqiuxiang
任务数据
]]

TaskTXT = class(TableTXT)

TaskTXT.tag = "TaskTXT"

TaskTXT.TxtName=Util.DataPath..AppConst.luaRootPath.."game/export/".."task_config.txt"                  --记录文件地址和名字


function TaskTXT:GetSplitArray(id,str)
	local taskIdStr = self.GetData(self, id, str)
	return string.split(taskIdStr, ";")
end

