UIBagLua = class(BaseBehaviour)

UIBagLua.items = nil --物品信息Table
UIBagLua.itemParent = nil --父节点
UIBagLua.itemPre = nil --物品
UIBagLua.grid = nil --grid

function UIBagLua:Awake()
end

function UIBagLua:Start()
end

function UIBagLua:OnEnable()
end

function UIBagLua:OnDisable()
end

function UIBagLua:Init()
	if self.itemParent == nil then
		self.itemParent = find("grid")
		self.grid = self.itemParent:GetComponent(UIGrid.GetClassType())
	end

	if self.itemPre == nil then
		self.itemPre = find("itemPre")
		self.itemPre.gameObject:SetActive(false)
	end

	self.items = {}--接受服务器物品信息列表
	self:DisplayItems()
end

function UIBagLua:CloseBag()
	for i = 0 ,self.itemParent.transform.childCount -1 do
		GameObject.Destroy(self.itemParent.transform:GetChild(i).gameObject)
	end
end

function UIBagLua:DisplayItems()--陈列物品
	local goItem = nil
	local object = nil
	for i = 1, 50 do 
		goItem = self:CreatItem()
		goItem.gameObject.name = tostring(i-1)
		self:SetItemInfo(goItem)
	end
	self.grid:Reposition()
end

function UIBagLua:SetItemInfo(goItem)--设置物品信息
	local icon = goItem.gameObject.transform:FindChild('icon')
	local count = goItem.gameObject.transform:FindChild('count')
	local sprite = icon:GetComponent(UISprite.GetClassType())
	local label = count:GetComponent(UILabel.GetClassType())
	sprite.spriteName = "no.1"
	label.text = "X88"
end

function UIBagLua:CreatItem()--创建物品
	local goItem = newobject(self.itemPre.gameObject)
	goItem.gameObject.transform.parent = self.itemParent.gameObject.transform
	goItem.gameObject:SetActive(false)
	goItem.gameObject.transform.localPosition = Vector3.zero
	goItem.gameObject.transform.localScale = Vector3.one
	goItem.gameObject:SetActive(true)
	return goItem
end




