--[[
author:Desmond
跑酷动态场景配置导出工具  
]]

require 'cjson'
luaTable = {}
--设置布局等参数
function addConfig( path, parentName,luaName,left_x,position,rotation,scale,param)
    local item = {}
    --item['path'] = path
    item['parentName'] = parentName
    item['luaName'] = luaName
    item['left_x'] = left_x
	item['position'] = position
	item['rotation'] = rotation
	item['scale'] = scale
    if param ~= nil then
		item['param'] = lua_string_split(param,';')
    else
        item['param'] = ''
    end
    table.insert(luaTable,item)
end

--保存文件
function file_save(filename, data)
    local file
    if filename == nil then
        file = io.stdout
    else
        local err
        file, err = io.open(filename, 'wb')
        if file == nil then
        end
    end
    file:write(data)
    if filename ~= nil then
        file:close()
    end
end

--字符串分割
function lua_string_split(str, split_char)
    local sub_str_tab = {};
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end

--保存文件
function save(name)
	file_save(name, cjson.encode(luaTable))
end

--保存无尽模式随机地块
function save_endless_part(name)
	local path = 'Assets/Lua/game/export/endless_set.json'
	local file, err = io.open(path, 'rb')
    if file == nil then --空文件
    	local str = cjson.encode({tostring(name) = luaTable})
    	print(tostring(str))
    	file_save(path,str)
    	return
    end
    
    local obj = cjson.decode(file_load(path))
    obj[tostring(name)] = luaTable
    file_save(path,cjson.encode(obj))
end

--读文件
function file_load(filename)
    local file
    if filename == nil then
        file = io.stdin
    else
        local err
        file, err = io.open(filename, 'rb')
        if file == nil then

        end
    end
    local data = file:read('*a')

    if filename ~= nil then
        file:close()
    end

    if data == nil then
        error('Failed to read'  .. filename)
    end

    return data
end

