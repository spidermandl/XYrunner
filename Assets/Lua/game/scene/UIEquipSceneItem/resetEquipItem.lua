-- resetEquipItem icon移动逻辑 （单个）
-- 作者：胡秋翔

resetEquipItem = class (BaseBehaviour)
resetEquipItem.UICamera = nil 
resetEquipItem.mainCamera = nil 
function resetEquipItem:Awake()
	print("resetEquipItem:Awake ")
	local camera = find("CameraUI")
	self.UICamera = camera.gameObject.transform:GetComponent('UICamera')
	local mianCamera = find("Main Camera")
	self.mainCamera = mianCamera:GetComponent(UnityEngine.Camera.GetClassType())

end

function resetEquipItem:Update()
    -- self.gameObject.transform.localPosition = Input.mousePosition
    

    self:followMove()
    self:checkEquip()
    -- local nowPos = self.mainCamera:WorldToScreenPoint(self.gameObject.transform.position)
    -- local mousePos = Input.mousePosition
    -- local newSPos = Vector3(mousePos.x,mousePos.y,mousePos.z)
    -- local newWPos = self.mainCamera:ScreenToWorldPoint (newSPos)
    -- self.gameObject.transform.position = newWPos


end

function resetEquipItem:OnTriggerEnter( gameObj )
	print("gameObj " .. gameObj.name)
end

-- 跟随移动
function resetEquipItem:followMove()
	self.gameObject.transform.localPosition = Input.mousePosition
end

-- 判断左下角装备孔
function resetEquipItem:checkEquip()
	-- 判断指针上得icon类型
    if self.UICamera.hoveredObject.name == "EquipUI_leftBtn1" then
        
         destroy(self.gameObject)
    elseif self.UICamera.hoveredObject.name == "EquipUI_leftBtn2" then

         destroy(self.gameObject)
    elseif self.UICamera.hoveredObject.name == "EquipUI_leftBtn3" then

    	 destroy(self.gameObject)
    end
end