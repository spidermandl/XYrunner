--[[
author:Desmond
手指触屏事件
]]
TouchEvent = class ()

TouchEvent.MOVE_GAP = 2 --判断移动最短距离
TouchEvent.PRESS_GAP = 2 --判断长按最短时间

TouchEvent.MOUSE_NONE = 0
TouchEvent.MOUSE_DOWN = 1
TouchEvent.MOUSE_MOVE = 2
TouchEvent.MOUSE_UP = 3
TouchEvent.mouseType = 0 --事件类型

TouchEvent.pressTime = nil --按下时间
TouchEvent.pressPosition = nil --按下坐标

TouchEvent.listener = nil --回调对象

function TouchEvent:reInit()
	self.mouseType = self.MOUSE_NONE
	self.pressTime = nil 
	self.pressPosition = nil
end

function TouchEvent:Update()
	--print ("-------------------------function TouchEvent:Update() "..tostring(Input.touchCount))
	-- if Input.touchCount > 0 then
	-- 	print ("-------------------------function TouchEvent:Update() 2")
	-- 	local touch = Input.GetTouch(0)

	-- 	if touch.phase == UnityEngine.TouchPhase.Began then
	--     	self.pressPosition = Input.mousePosition --点击位置
	--     	self.pressTime = UnityEngine.Time.time --点击时间
	-- 		if self.listener ~= nil then
	-- 			self.listener:press()
	-- 		end
	-- 	elseif touch.phase == UnityEngine.TouchPhase.Moved then
	-- 		self.mouseType = self.MOUSE_MOVE
	-- 		if self.listener ~= nil then
	-- 			self.listener:move()
	-- 		end
	-- 	elseif touch.phase == UnityEngine.TouchPhase.Ended then
	--     	if self.mouseType == self.MOUSE_MOVE then --移动
	--     		return
	--     	end

	--     	if UnityEngine.Time.time - self.pressTime >= self.PRESS_GAP then --长按回调
	--     		if self.listener ~= nil then
	--     			self.listener:longClick()
	--     		end

	--     		return
	--     	end

	-- 		if self.listener ~= nil then --单击回调
	-- 			self.listener:click()
	-- 		end
	-- 	end
	-- end

    if Input.GetMouseButtonDown(0) then
    	self.mouseType = self.MOUSE_DOWN
    	self.pressPosition = Input.mousePosition --点击位置
    	self.pressTime = UnityEngine.Time.time --点击时间
		if self.listener ~= nil then
			self.listener:press()
		end
    end
    
    if Input.GetMouseButton(0) then
        local dis = UnityEngine.Vector3.Distance(self.pressPosition,Input.mousePosition)
    	if dis > self.MOVE_GAP then --移动
    		self.mouseType = self.MOUSE_MOVE
    		if self.listener ~= nil then
    			self.listener:move()
    		end
    		return
    	end

        return
    end

    if Input.GetMouseButtonUp(0) then
    	if self.mouseType == self.MOUSE_MOVE then --移动
    		self:reInit()
    		return
    	end

    	if UnityEngine.Time.time - self.pressTime >= self.PRESS_GAP then --长按回调
    		if self.listener ~= nil then
    			self.listener:longClick()
    		end
			self:reInit()
    		return
    	end

		if self.listener ~= nil then --单击回调
			self.listener:click()
			self:reInit()
		end

    end
end

--设置监听回调
function TouchEvent:setListener(l)
	self.listener = l
end

function TouchEvent:press()
	-- body
end

function TouchEvent:click()
	-- body
end

function TouchEvent:move()
	-- body
end

function TouchEvent:longClick()
	-- body
end