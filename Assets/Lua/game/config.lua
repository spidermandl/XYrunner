--[[
  author:Desmond,huqiuxiang
  游戏lua脚本载入关联
]]
require "game/LuaShell"

require "game/RoleProperty"

require "game/PetStaticTable" -------秦仕超添加 宠物坐骑套装 静态变量表

require "game/gameObject/BaseBehaviour"
require "game/gameObject/GameCamera"
--require "game/gameObject/loader/ObjectGroup"

----------------------------
require "game/gameObject/loader/LoaderConfig"
require "game/gameObject/role/player/Desmond"
require "game/gameObject/role/player/HangingColliderItem"
require "game/gameObject/role/pet/PetConfig"
require "game/gameObject/item/ItemConfig"
require "game/gameObject/role/enemy/EnemyConfig"
require "game/gameObject/surface/SurfaceConfig"


require "game/gameObject/role/mount/BaseMount"
require "game/gameObject/role/mount/RainbowCatMount"
require "game/gameObject/role/mount/RhubarbDuckMount"
require "game/gameObject/role/mount/SadaharuMount"

require "game/scene/common/LogInSceneCreatModelCtr"
require "game/gameObject/surface/RunngingOverItem"
require "game/gameObject/surface/HolyOverItem"
require "game/scene/UIEquipSceneItem/resetEquipItem"
require "game/gameObject/surface/CameraZMoveItem"


require "game/roleState/StateConfig"


require "game/scene/SceneConfig"
require "game/data/DataConfig"
require "game/net/NetConfig"
require "game/UI/UIConfig"

require "game/export/ExportConfig"

require "game/platform/PlatformAction" -- hanli_xiong
