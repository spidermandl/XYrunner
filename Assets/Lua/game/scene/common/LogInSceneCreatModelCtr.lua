-- LogInSceneCreatModelCtr 注册登录场景里 创建人物 之 人物模型管理
-- 作者：胡秋翔
LogInSceneCreatModelCtr = class(BaseBehaviour)
LogInSceneCreatModelCtr.manModel = nil 
LogInSceneCreatModelCtr.womanModel = nil 
LogInSceneCreatModelCtr.manModelBody = nil 
LogInSceneCreatModelCtr.manModelHead = nil 
LogInSceneCreatModelCtr.womanModelBody = nil 
LogInSceneCreatModelCtr.womanModelHead = nil 

-----------创建3d模型-
function LogInSceneCreatModelCtr:creatModel()
    self.meshTab = {
        ["desmond"] = {},
        ["dgirl"] = {} ,
    }
    print("ModelTable ".. tostring(self.meshTab["desmond"])..table.getn(self.meshTab))
    self:creatManModel()
    self:creatWomanModel()
end

-----------显示男模型-
function LogInSceneCreatModelCtr:creatManModel()
    local characterName = "desmond"
    if self.manModel == nil then
        self.manModel = newobject(Util.LoadPrefab("Player/desmond"))
    end
    
    self.manModel.transform.position = Vector3.zero
    local Vx = 0
    local Vy = 0
    local Vz = -8.6
    self.manModel.transform:Translate(Vx,Vy,Vz,Space.World)
    -- self.manModel.transform.rotation = Quaternion.Euler(0,135,0)
    self.manModel.transform.localScale = Vector3(2, 2, 2)

    local playObj = self.manModel.gameObject.transform:FindChild("player_male@skin")
    self.manModelBody = playObj.gameObject.transform:FindChild("player_male_Body"):GetComponent("SkinnedMeshRenderer")
    self.manModelHead = playObj.gameObject.transform:FindChild("player_male_Head"):GetComponent("SkinnedMeshRenderer")

    self.manModelBody.material:SetColor("_RimColor",UnityEngine.Color.white)
    self.manModelHead.material:SetColor("_RimColor",UnityEngine.Color.white)
    self.manModelBody.material:SetFloat("_RimRanger",1.5)
    self.manModelHead.material:SetFloat("_RimRanger",1.5)

    local tab = {}
    tab[1] = self.manModelBody
    tab[2] = self.manModelHead

    self.meshTab[characterName] = tab  -- 把模型mesh放入tab
    -- self:setEntity(ModelTable[characterName],self.manModel) 
end

-----------显示女模型-
function LogInSceneCreatModelCtr:creatWomanModel()
    local characterName = "dgirl"
    if self.womanModel == nil then
        self.womanModel = newobject(Util.LoadPrefab("Player/dgirl"))
    end
	
    self.womanModel.transform.position = Vector3.zero
    local Vx = 0
    local Vy = 0
    local Vz = -8.6
    self.womanModel.transform:Translate(Vx,Vy,Vz,Space.World)
    -- self.womanModel.transform.rotation = Quaternion.Euler(0,135,0)
    self.womanModel.transform.localScale = Vector3(2, 2, 2)

    local playObj = self.womanModel.gameObject.transform:FindChild("player_girl@skin")
    self.womanModelBody = playObj.gameObject.transform:FindChild("player_girl_Body"):GetComponent("SkinnedMeshRenderer")
    self.womanModelHead = playObj.gameObject.transform:FindChild("player_girl_Head"):GetComponent("SkinnedMeshRenderer")

    self.womanModelBody.material:SetColor("_RimColor",UnityEngine.Color.white)
    self.womanModelHead.material:SetColor("_RimColor",UnityEngine.Color.white)
    self.womanModelBody.material:SetFloat("_RimRanger",1.5)
    self.womanModelHead.material:SetFloat("_RimRanger",1.5)

    local tab = {}
    tab[1] = self.womanModelBody
    tab[2] = self.womanModelHead
    self.meshTab[characterName] = tab  -- 把模型mesh放入tab

    -- self:setEntity(ModelTable[characterName],self.womanModel) 
end


LogInSceneCreatModelCtr.characterName = nil  -- 当前选中角色
LogInSceneCreatModelCtr.meshTab = nil -- 存放角色mesh的tab

---------- 选中男的
function LogInSceneCreatModelCtr:manDo()
    if self.characterName == "desmond" then
        local animatorMan = self.manModel.transform:GetComponent("Animator"):Play("idle")
        self.manModel.transform.rotation = Quaternion.Euler(0,90,0)
        return
    end
    self.manModel:SetActive(true)
    self.womanModel:SetActive(false)
    self.characterName = "desmond"
    -- 男的变化
    local animatorMan = self.manModel.transform:GetComponent("Animator"):Play("Victory")
    self.manModel.transform.rotation = Quaternion.Euler(0,0,0)

    self.manModelBody.material:SetFloat("_Outline",0.0006)
    self.manModelHead.material:SetFloat("_Outline",0.0006)

    self.manModelBody.material:SetColor("_OutlineColor",UnityEngine.Color.white)
    self.manModelHead.material:SetColor("_OutlineColor",UnityEngine.Color.white)

    -- 女的变化
    -- local animatorWoman = self.womanModel.transform:GetComponent("Animator"):Play("idle")
    -- self.womanModel.transform.rotation = Quaternion.Euler(0,0,0)

    -- self.womanModelBody.material:SetFloat("_Outline",0.001)
    -- self.womanModelHead.material:SetFloat("_Outline",0.001)

    -- self.womanModelBody.material:SetColor("_OutlineColor",UnityEngine.Color.black)
    -- self.womanModelHead.material:SetColor("_OutlineColor",UnityEngine.Color.black)
  
end

---------- 选中女的
function LogInSceneCreatModelCtr:womanDo()
    if self.characterName == "dgirl" then
        local animatorWoman = self.womanModel.transform:GetComponent("Animator"):Play("idle")
        self.womanModel.transform.rotation = Quaternion.Euler(0,90,0)
        return
    end
    self.manModel:SetActive(false)
    self.womanModel:SetActive(true)
    self.characterName = "dgirl"
    -- 男的变化
    -- local animatorMan = self.manModel.transform:GetComponent("Animator"):Play("idle")
    -- self.manModel.transform.rotation = Quaternion.Euler(0,0,0)

    -- self.manModelBody.material:SetFloat("_Outline",0.001)
    -- self.manModelHead.material:SetFloat("_Outline",0.001)

    -- self.manModelBody.material:SetColor("_OutlineColor",UnityEngine.Color.black)
    -- self.manModelHead.material:SetColor("_OutlineColor",UnityEngine.Color.black)

    -- 女的变化
    local animatorWoman = self.womanModel.transform:GetComponent("Animator"):Play("Victory")
    self.womanModel.transform.rotation = Quaternion.Euler(0,0,0)

    self.womanModelBody.material:SetFloat("_Outline",0.0006)
    self.womanModelHead.material:SetFloat("_Outline",0.0006)

    self.womanModelBody.material:SetColor("_OutlineColor",UnityEngine.Color.white)
    self.womanModelHead.material:SetColor("_OutlineColor",UnityEngine.Color.white)

end

---------  没有选中的角（预留 以后人物可能多)
function LogInSceneCreatModelCtr:istroleSelect()
	    	print(tostring(#self.meshTab))
    for i , v in ipairs(self.meshTab) do
    	print(tostring(i))
         if i ~= self.characterName then
              for u = 1 , #v do
                   v[u].material:SetFloat("_Outline",0.001)
                   v[u].material:SetColor("_OutlineColor",UnityEngine.Color.black)
              end
         end
    end
end

-----------设置人物组件-
function LogInSceneCreatModelCtr:setEntity(modelCfg,role)--avatarPath,controllerPath.avatarName,controllerName

    local animator = role.gameObject:GetComponent(UnityEngine.Animator.GetClassType())

    -- local animator = role.gameObject:AddComponent(UnityEngine.Animator.GetClassType())
    -- local controller = Util.LoadAnimatorController(modelCfg.controllerPath,modelCfg.controllerName) -- 取出动画animator
    -- local player_male = Util.LoadPrefabByPath(modelCfg.avatarPath,modelCfg.avatarName) -- 取出模型
    -- local animatorT = player_male.gameObject:GetComponent(UnityEngine.Animator.GetClassType()) -- 取出模型里的animator
    -- if animatorT ~= nil then
    --     animator.runtimeAnimatorController = controller
    --     animator.avatar = animatorT.avatar
    --     animator.applyRootMotion = animatorT.applyRootMotion
    --     animator.cullingMode = animatorT.cullingMode
    --     animator.updateMode = animatorT.updateMode
    -- end
end