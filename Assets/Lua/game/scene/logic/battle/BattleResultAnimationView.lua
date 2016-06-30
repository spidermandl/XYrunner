--[[
author:sunkai
跑酷胜利动画界面
]]

BattleResultAnimationView = class()

BattleResultAnimationView.scene = nil --场景scene
BattleResultAnimationView.name = "BattleResultAnimationView" --类名
function BattleResultAnimationView:Awake()
    self.ui_zhanghaoshengjiAni1 = newobject(Util.LoadPrefab("UI/Chapter/ui_zhanghaoshengjiAni1"))
    self.ui_zhanghaoshengjiAni2 = newobject(Util.LoadPrefab("UI/Chapter/ui_zhanghaoshengjiAni2"))
    self.ui_zhanghaoshengjiAni3 = newobject(Util.LoadPrefab("UI/Chapter/ui_zhanghaoshengjiAni3"))
    self.Parent = find("sceneUI")
    self.ui_zhanghaoshengjiAni1.transform.parent = self.Parent.gameObject.transform
    self.ui_zhanghaoshengjiAni2.transform.parent = self.Parent.gameObject.transform
    self.ui_zhanghaoshengjiAni3.transform.parent = self.Parent.gameObject.transform


end