--[[
monoBehaviour lua基类
author:Desmond
]]

BaseBehaviour = class()

BaseBehaviour.gameObject = nil --场景object
BaseBehaviour.bundleParams = nil --c#传入参数

function BaseBehaviour:setParent( gameObj,params)
	--print("-----------------BaseBehaviour setParent--->>>"..tostring(params))
	self.gameObject=gameObj
	self.bundleParams = params
end

function BaseBehaviour:Awake()
	--print("-----------------BaseBehaviour Awake--->>>-----------------")
end

--初始化参数配置
function BaseBehaviour:initParam()
	-- body
end
--启动事件--
function BaseBehaviour:Start()
    --print("-----------------BaseBehaviour Start--->>>-----------------")
end

function BaseBehaviour:Update()
    --print("-----------------Desmond Update-->>>-----------------")
end

function BaseBehaviour:FixedUpdate()
	-- body
end

function BaseBehaviour:LateUpdate()
	-- body
end

function BaseBehaviour:OnGUI()
	-- body
end

function BaseBehaviour:OnEnable()

end

function BaseBehaviour:OnDisable()

end

function BaseBehaviour:DoAction(action)

end
--销毁--
function BaseBehaviour:OnDestroy()
	--GamePrint("-----------------BaseBehaviour:OnDestroy-->>>-----------------")
	self.gameObject = nil
	self.bundleParams = nil
end

function BaseBehaviour:OnTriggerEnter( gameObj )
    --print("-----------------BaseBehaviour:OnTriggerEnter-->>>-----------------")
end

function BaseBehaviour:OnTriggerStay( gameObj )
    --print("-----------------BaseBehaviour:OnTriggerStay-->>>-----------------")
end

function BaseBehaviour:OnTriggerExit( gameObj )
    --print("-----------------BaseBehaviour:OnTriggerExit-->>>-----------------")
end

function BaseBehaviour:OnCollisionEnter( collision )
    
end

function BaseBehaviour:OnCollisionStay( collision )
    
end

function BaseBehaviour:OnCollisionExit( collision )
    
end

function BaseBehaviour:OnAnimatorIK()
	-- body
end


