--SceneModelShowControl
--[[
  author: huqiuxiang
  萌宠 套装 拖拽3d模型 旋转
]]
SceneModelShowControl = class(BaseBehaviour)
SceneModelShowControl.Model3D = nil
SceneModelShowControl.rotationNum = 0
SceneModelShowControl.isRotating = false
SceneModelShowControl.StartTriggetPosition= Vector3(0,0,0) 					-----------3D触发器开始的位置
--------------------3D旋转操作----------------------------------------------------------------
-----------加载3d模型
function SceneModelShowControl:Load3DModel(targetName,url)
	self:Clear3DModel()
	local go = newobject(Util.LoadPrefab(url..targetName))
	-- go.name=name
    go.transform.parent=self.Model3D.transform
    go.transform.localPosition = Vector3.zero
    go.transform.localScale = UnityEngine.Vector3(1,1,1)
    go.transform.rotation=UnityEngine.Vector3(0,0,0)
end

-----------清除3D模型
function SceneModelShowControl:Clear3DModel()
	if self.Model3D.childCount==0 then
		return
	end
	GameObject.Destroy(self.Model3D:GetChild(0).gameObject) 
	self.rotationNum=0
	self.Model3D.localRotation=UnityEngine.Quaternion.Euler(0,0,0)
end

-----------启动旋转
function SceneModelShowControl:StartRotating( ... )
	self.isRotating=true
	self.StartTriggetPosition=UnityEngine.Input.mousePosition -- 以后改触屏
end

---------------结束旋转
function SceneModelShowControl:EndRotating( ... )
	self.isRotating=false
end

--------Update中调用
function SceneModelShowControl:Rotating3DModel()
	if self.isRotating then
		local dePositionx=UnityEngine.Input.mousePosition.x-self.StartTriggetPosition.x
		self.rotationNum=self.rotationNum-dePositionx*0.5
		self.Model3D.localRotation=UnityEngine.Quaternion.Euler(0,self.rotationNum,0)
		self.StartTriggetPosition=UnityEngine.Input.mousePosition
	end
end