--[[
	author:huqiuxiang	
	新手引导 ui提示 （出箭头）
]]
GuideUIShow = class ()


function GuideUIShow:init(path,btn,photoId,position)


	-- local btnClone = newobject(btn)
	-- btnClone.gameObject.transform.parent = btn.gameObject.transform

	local effect = newobject(Util.LoadPrefab(path))
    effect.gameObject.transform.parent = btn.gameObject.transform
    effect.gameObject.transform.localPosition = position == nil and Vector3(0,0,0) or position
    effect.gameObject.transform.localScale =Vector3.one
    effect.name = "jiantou"
    local btnClone = effect.gameObject.transform:FindChild("icon")
    btnClone.gameObject.transform.position = btn.gameObject.transform.position
    btnClone.gameObject.transform.parent = effect.gameObject.transform
	btnClone.gameObject.transform.localScale = Vector3.one
	local btnsprtie = btnClone.gameObject.transform:GetComponent("UISprite")
	btnsprtie.spriteName = btn.gameObject.transform:GetComponent("UISprite").spriteName
	-- print(btnsprtie.spriteName)

    local ps = effect.gameObject.transform:FindChild("photo")
    ps.gameObject.transform.position = Vector3.zero
    ps.gameObject:SetActive(false)

    if photoId ~= nil then
		ps.gameObject:SetActive(true)
		--ps.gameObject.transform:GetComponent("UISprite").spriteName = photoId
		local Icon = ps:GetComponent("UITexture")
		Icon.mainTexture = Util.LoadPrefabByPath("GuidePic/",photoId)
    end
	-- btnClone.gameObject.transform.position = btn.gameObject.transform.position

	local btnCollider = btnClone.gameObject.transform:GetComponent(UnityEngine.BoxCollider.GetClassType())
	--btnsprtie:MakePixelPerfect()
	--btnsprtie.spriteName = ""
	btnClone.gameObject:SetActive(false)
	destroy(btnCollider)
    return effect
end