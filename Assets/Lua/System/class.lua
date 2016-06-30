
function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for key, value in pairs(object) do
            new_table[_copy(key)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

--Create an class.
-- function class(classname, super)
--     local superType = type(super)
--     local cls

--     if superType ~= "function" and superType ~= "table" then
--         superType = nil
--         super = nil
--     end

--     if superType == "function" or (super and super.__ctype == 1) then
--         -- inherited from native C++ Object
--         cls = {}

--         if superType == "table" then
--             -- copy fields from super
--             for k,v in pairs(super) do cls[k] = v end
--             cls.__create = super.__create
--             cls.super    = super
--         else
--             cls.__create = super
--         end

--         cls.ctor    = function() end
--         cls.__cname = classname
--         cls.__ctype = 1

--         function cls.New(...)
--             local instance = cls.__create(...)
--             -- copy fields from class to native object
--             for k,v in pairs(cls) do instance[k] = v end
--             instance.class = cls
--             instance:ctor(...)
--             return instance
--         end

--     else
--         -- inherited from Lua Object
--         if super then
--             cls = clone(super)
--             cls.super = super
--         else
--             cls = {ctor = function() end}
--         end

--         cls.__cname = classname
--         cls.__ctype = 2 -- lua
--         cls.__index = cls

--         function cls.New(...)
--             local instance = setmetatable({}, cls)
--             instance.class = cls
--             instance:ctor(...)
--             return instance
--         end
--     end

--     return cls
-- end

--云风（吴云洋)
local _class={}
function class(super)
    local class_type={}
    class_type.ctor     = false
    class_type.super    = super
    class_type.new      = 
        function(...)
            local obj={}
            do
                local create
                create = function(c,...)
                    if c.super then
                        create(c.super,...)
                    end
                    if c.ctor then
                        c.ctor(obj,...)
                    end
                end

                create(class_type,...)
            end
            setmetatable(obj,{ __index = _class[class_type] })
            return obj
        end
    local vtbl={}
    _class[class_type]=vtbl
    vtbl.super = _class[super] --Desmond

    setmetatable(class_type,{__newindex=
        function(t,k,v)
            vtbl[k]=v
        end
    })
    
    if super then
        setmetatable(vtbl,{__index=
            function(t,k)
                local ret=_class[super][k]
                vtbl[k]=ret
                return ret
            end
        })
    end

    return class_type
end

