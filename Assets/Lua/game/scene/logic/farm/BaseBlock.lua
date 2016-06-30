--[[
author : Desmond
城建地块
]]

BaseBlock = class()

BaseBlock.state = nil --地块状态
BaseBlock.index = 0 --地块索引

BaseBlock.empty = 0 --空闲地块
BaseBlock.occupied = 1 --有建筑物地块

BaseBlock.building = nil --地块上建筑物