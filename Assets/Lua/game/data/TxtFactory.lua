--[[
txt表工厂类
author:Desmond
]]

TxtFactory = {}

TxtFactory.tableMap = {}
TxtFactory.hasTable = false --是否初始化

--[[静态数据表]]
TxtFactory.ChapterTXT = "ChapterTXT"
TxtFactory.UserTXT = "UserTXT"
TxtFactory.SuitTXT = "SuitTXT"
TxtFactory.MountTXT = "MountTXT" --宠物坐骑配置
TxtFactory.MountTypeTXT = "MountTypeTXT" --宠物坐骑种类
TxtFactory.LotteryDataTXT = "LotteryDataTXT"
TxtFactory.EndlessTXT = "EndlessTXT"
TxtFactory.LotteryPondTXT = "LotteryPondTXT" -- 奖池id
TxtFactory.CharIconTXT = "CharIconTXT" -- 玩家／系统icon表

TxtFactory.MaterialTXT = "MaterialTXT"
TxtFactory.EquipTXT = "EquipTXT"
TxtFactory.TaskTXT = "TaskTXT"
TxtFactory.TaskSonTXT = "TaskSonTXT"
TxtFactory.SurveyConfigTXT = "SurveyConfigTXT"
TxtFactory.SnatchConfigTXT = "SnatchConfigTXT"
TxtFactory.TextsConfigTXT = "TextsConfigTXT"
TxtFactory.StrongholdPostionConfigTXT = "StrongholdPostionConfigTXT"
TxtFactory.StoreConfigTXT = "StoreConfigTXT"
TxtFactory.GameConfigTXT = "GameConfigTXT"
TxtFactory.LadderConfigTXT = "LadderConfigTXT"
TxtFactory.LadderRewardConfigTXT = "LadderRewardConfigTXT"
TxtFactory.StoreGiftBagConfigTXT = "StoreGiftBagConfigTXT"
TxtFactory.SveneDayActivityConfigTXT = "SveneDayActivityConfigTXT"
TxtFactory.OnlineActivityConfigTXT = "OnlineActivityConfigTXT"

TxtFactory.SnatchIntegralConfigTXT = "SnatchIntegralConfigTXT"
TxtFactory.GameExplainConfigTXT = "GameExplainConfigTXT"

TxtFactory.PetSkillPassiveTXT = "PetSkillPassiveTXT"--宠物被动技能
TxtFactory.PetSkillMainTXT = "PetSkillMainTXT"--宠物主动技能
TxtFactory.PetMergeTXT = "PetMergeTXT"

TxtFactory.GudieRunningSceneTXT = "GudieRunningSceneTXT"
TxtFactory.GudieUISceneTXT = "GudieUISceneTXT"  
TxtFactory.GudieDialogTXT = "GudieDialogTXT"
TxtFactory.TipsTXT = "TipsTXT"
TxtFactory.VipFeatureConfigTXT = "VipFeatureConfigTXT"
TxtFactory.SystemNoticeConfigTXT = "SystemNoticeConfigTXT"

TxtFactory.SoundTXT = "SoundTXT"
TxtFactory.PlayerLevelUpTXT = "PlayerLevelUpTXT"
TxtFactory.MapConfigTXT = "MapConfigTXT"
TxtFactory.SceneThemeTXT = "SceneThemeTXT"
TxtFactory.CharNamesTXT = "CharNamesTXT"
TxtFactory.BuildingTXT = "BuildingTXT"	--城建
TxtFactory.StoryCupTXT = "StoryCupTXT"
TxtFactory.SuitSkillTXT = "SuitSkillTXT"
TxtFactory.ATKAnimTXT = "ATKAnimTXT"
TxtFactory.PetAnimTXT = "PetAnimTXT"
TxtFactory.FunctionOpenTXT = "FunctionOpenTXT" -- 功能开启
TxtFactory.JieSuoTiaoJianTXT = "JieSuoTiaoJianTXT" -- 功能解锁
--[[动态数据表]]
TxtFactory.MemDataCache = "MemDataCache" -- 内存数据表
TxtFactory.UserInfo = "UserInfo" --玩家信息表
TxtFactory.EquipInfo = "EquipInfo" -- 玩家装备表
TxtFactory.ChapterInfo = "ChapterInfo" -- 玩家关卡信息表
--玩家任务
TxtFactory.TaskManagement = "TaskManagement"
--scene切换管理
TxtFactory.UITransitionManager = "UITransitionManager"

TxtFactory.SuitInfo = "SuitInfo"  --玩家套装表
TxtFactory.PetInfo = "PetInfo" -- 萌宠信息表
TxtFactory.MountInfo = "MountInfo" -- 坐骑信息表
TxtFactory.BagItemsInfo = "BagItemsInfo" -- 背包数据信息表
TxtFactory.EndlessRankInfo = "EndlessRankInfo" -- 无尽排行数据表
TxtFactory.TaskInfo = "TaskInfo" -- 任务数据表
TxtFactory.AccountInfo = "AccountInfo" -- 账户数据表
TxtFactory.EmailInfo = "EmailInfo" -- 玩家邮件列表
TxtFactory.BuildingInfo = "BuildingInfo" --城建信息数据
TxtFactory.SnatchInfo = "SnatchInfo"  -- 据点信息数据
TxtFactory.StoreInfo = "StoreInfo"  -- 商城信息
TxtFactory.FriendInfo = "FriendInfo" --好友信息
TxtFactory.LadderInfo = "LadderInfo" -- 天梯信息
TxtFactory.ChallengeInfo = "ChallengeInfo" --挑战信息
TxtFactory.ReplyChallengeInfo = "ReplyChallengeInfo" --应战信息
TxtFactory.SoundManagement = "SoundManagement" --声音管理表
TxtFactory.BattleUseItemInfo = "BattleUseItemInfo" -- 战斗需要消耗的物品信息
TxtFactory.BattleUseSkillInfo = "BattleUseSkillInfo" -- 战斗需要使用的技能信息
TxtFactory.FunctionOpenInfo = "FunctionOpenInfo" --  功能开启表
TxtFactory.BigFun = "BigFun" --  大功能开启表
TxtFactory.SmallFun = "SmallFun" --  小功能开启表
TxtFactory.AsyncPvpInfo = "AsyncPvpInfo" -- 异步pvp需要存储的信息
--[[==========================================================================================================]]
--[[数据表列名]]
--静态套装表
TxtFactory.S_SUIT_NAME="NAME" --套装名字
TxtFactory.S_SUIT_DESCRIBE="DRESSDESC" --套装说明
TxtFactory.S_SUIT_GOLD="GOLD" --升级所需金币
TxtFactory.S_SUIT_DIAMONDS="DIAMONDS" --升级所需钻石
TxtFactory.S_SUIT_MATERIAL="MATERIAL" --升级所需素材
TxtFactory.S_SUIT_BASE_HP="BASE_HP" --基础hp
TxtFactory.S_SUIT_ADD_KILLSCORE="ADD_KILLSCORE" --击杀额外得分
TxtFactory.S_SUIT_COLLECTIONS_SCORE="COLLECTIONS_SCORE" --收集物额外得分
TxtFactory.S_SUIT_SCORE_PEN="SCORE_PEN" --得分加成
TxtFactory.S_SUIT_ICON_ATLAS="ICON_SPRITE" --套装图
TxtFactory.S_SUIT_LVL ="lvl" --套装等级
TxtFactory.S_SUIT_MAX = "maxLv" --套装最大等级
TxtFactory.S_SUIT_INIT = "init_id" --套装第一个id
TxtFactory.S_SUIT_TYPE = "type" --套装种类
TxtFactory.S_SUIT_FIRST_SKILL = "SKILL1" --技能索引
TxtFactory.S_SUIT_MALE_MODEL = "MALE_MODEL" --男模型
TxtFactory.S_SUIT_FEMALE_MODEL = "FEMALE_MODEL" --女模型
TxtFactory.S_SUIT_OPEN_CLOSE = "OPEN_CLOSE" --是否开启
TxtFactory.S_SUIT_DEFAULT_SUIT = 12001 --默认套装类型id
TxtFactory.S_SUIT_FORTUNE_CAT_SUIT = 12003 --招财猫套装类型 id
TxtFactory.S_SUIT_CHOPPER_SUIT = 12003 --乔巴套装类型 id
TxtFactory.S_SUIT_LION_EAR_SUIT = 12004 --狮子耳套装类型 id
TxtFactory.S_SUIT_FORTUNE_COLOR_SUIT = 12005 --招财猫变色套装类型 id
TxtFactory.S_SUIT_TEEMO_SUIT = 12006 --提莫套装类型 id

--静态套装技能表
TxtFactory.S_SUIT_SKILL_CD_TIME = "CD_TIME" --技能冷却时间
TxtFactory.S_SUIT_SKILL_ATK_CD = "ATK_CD" --攻击次数
TxtFactory.S_SUIT_SKILL_KILL_CD = "KILL_CD" --击杀多少怪物CD
TxtFactory.S_SUIT_SKILL_JUMP_CD = "JUMP_CD" --跳跃CD
TxtFactory.S_SUIT_SKILL_SUSTAINED_TIME = "SUSTAINED_TIME" --持续时间
TxtFactory.S_SUIT_SKILL_NEW_COLLECTIONS_P = "NEW_COLLECTIONS_P" --生成物品比例  收集物1ID=8;收集物2ID=7  解释：每秒生成8个收集物1，和7个收集物2
TxtFactory.S_SUIT_SKILL_TYPE = "TYPE" --套装种类
TxtFactory.S_SUIT_SKILL_LUA_CLASS = "LUA_CLASS"  --对应lua实现类

--萌宠坐骑配置
TxtFactory.S_MOUNT_ADDSC = "ADDSC" --得分加成
TxtFactory.S_MOUNT_COLLECTIONS_SCORE = "COLLECTIONS_SCORE" --收集物得分
TxtFactory.S_MOUNT_ADDATKSC = "ADDATKSC" --击杀额外得分
TxtFactory.S_MOUNT_ADDHP = "ADDHP" --额外增加体力
TxtFactory.S_MOUNT_LVL = "lvl" --萌宠坐骑等级
TxtFactory.S_MOUNT_MAX = "maxLv" --萌宠坐骑最大等级
TxtFactory.S_MOUNT_STAR = "star" --萌宠坐骑星级
TxtFactory.S_MOUNT_INIT_ID = "init_id" --萌宠坐骑第一个等级id
TxtFactory.S_MOUNT_TYPE = "type_id" --萌宠坐骑种类id
TxtFactory.S_MOUNT_EXP = "exp_min" --萌宠所需最小总经验值
TxtFactory.S_MOUNT_ACTIVE_SKILLS = "ACTIVE_SKILLS" --主动技能
TxtFactory.S_MOUNT_SKILL_CONTINUED_LEN = "SKILL_CONTINUED_LEN" --主动技能时间
TxtFactory.S_MOUNT_SKILL_SKILL_CD = "SKILL_CD" --技能CD时间
TxtFactory.S_MOUNT_SKILL_SUCCESS_RATE = "SKILL_SUCCESS_RATE" --技能触发概率
--萌宠主动技能表
TxtFactory.S_MAIN_SKILL_ADD_SCORE_PEN = "ADD_SCORE_PEN" --结算得分加成
TxtFactory.S_MAIN_SKILL_ADD_COLLECTIONS_SCORE = "ADD_COLLECTIONS_SCORE" --收集物得分
TxtFactory.S_MAIN_SKILL_ADD_KILL_SCORE = "ADD_KILL_SCORE"  --击杀额外得分
TxtFactory.S_MAIN_SKILL_ADD_HP = "ADD_HP" ----额外增加体力
TxtFactory.S_MAIN_SKILL_ACTION_ID = "ACTION_ID" --攻击动作
TxtFactory.S_MAIN_SKILL_TARGET_SHAPE_PARA = "TARGET_SHAPE_PARA" --作用范围
TxtFactory.S_MAIN_SKILL_D_F_DISTANCE = "D_F_DISTANCE" --角色与摄像机距离
TxtFactory.S_MAIN_SKILL_GAIN_VALUE = "SKILL_GAIN_VALUE" --技能增益
--萌宠被动技能表
--静态装备表
TxtFactory.S_EQUIP_ELFSOCRE = "ELFSOCRE" --收集额外得分
TxtFactory.S_EQUIP_ADDATKSC = "ADDATKSC" --击杀得分
TxtFactory.S_EQUIP_ADDHP = "ADDHP" --额外增加体力
TxtFactory.S_EQUIP_ADDSC = "ADDSC"  -- 结算得分加成
TxtFactory.S_EQUIP_ADDEXP = "ADDEXP"  -- 结算经验加成
TxtFactory.S_EQUIP_ADDGOLD = "ADDGOLD"  -- 结算金币加成
TxtFactory.S_EQUIP_ADDITEMR = "ADDITEMR" --血瓶增益 吃到血瓶才加血
TxtFactory.S_EQUIP_SLOWHP = "SLOWHP" --延缓体力 跑酷体力减少减缓
TxtFactory.S_EQUIP_TWOJUMPSOCRE = "TWOJUMPSOCRE" --二段跳额外得分
TxtFactory.S_EQUIP_MOREJUMPSOCRE = "MOREJUMPSOCRE"--多段跳额外得分
TxtFactory.S_EQUIP_SUBATKDMG = "SUBATKDMG" --受击减伤
TxtFactory.S_EQUIP_SUBDROPDMG = "SUBDROPDMG"--掉坑免伤
TxtFactory.S_EQUIP_MISATKDMG = "MISATKDMG" --免疫攻击，不掉血次数(暂时不做)
TxtFactory.S_EQUIP_ADDSUCKHP = "ADDSUCKHP" --吸血每击杀以下个数怪物获得2点体力
TxtFactory.S_EQUIP_ADDSUCKTIME = "ADDSUCKTIME"  --磁铁时间延长
TxtFactory.S_EQUIP_ADDGODTIME = "ADDGODTIME" --无敌延长
TxtFactory.S_EQUIP_ENERGY = "ENERGY"--击杀怪物额外能量 神圣模式能量
TxtFactory.S_EQUIP_ENERGYJUMP = "ENERGYJUMP"--跳跃产生极限碎片 弹跳加神圣模式能量
TxtFactory.S_EQUIP_ADDJUMP = "ADDJUMP"--跳跃次数增加
TxtFactory.S_EQUIP_CDDOWM = "CDDOWM"--减少CD时间 套装cd时间
TxtFactory.S_EQUIP_SPEED ="SPEED" --增加速度 跑酷速度
TxtFactory.S_EQUIP_VOLPLANE ="VOLPLANE"--滑翔得分
TxtFactory.S_EQUIP_SPRINT = "SPTINT"--大黄鸭冲刺时间
TxtFactory.S_EQUIP_LVL ="lvl" --装备等级
TxtFactory.S_EQUIP_MAX = "maxLv" --装备最大等级
TxtFactory.S_EQUIP_INIT = "init_id" --装备第一个id
TxtFactory.S_EQUIP_TYPE = "type" --装备种类
--静态材料表
TxtFactory.S_MATERIAL_NAME = "NAME" --材料名字
TxtFactory.S_MATERIAL_MODEL = "MATERIAL_MODEL" --材料3d模型
TxtFactory.S_MATERIAL_BASICSCORE = "BASICSCORE" --材料基本得分
TxtFactory.S_MATERIAL_TYPE = "MATERIAL_TYPE" --材料种类
TxtFactory.S_MATERIAL_GOLD_VALUE = "GOLD_VALUE" --金币分数
TxtFactory.S_MATERIAL_CLASS = "CLASSNAME" --材料lua类名
TxtFactory.S_MATERIAL_MATERIAL_ICON = "MATERIAL_ICON" --材料icon名字
TxtFactory.S_MATERIAL_EFFECT = "EFFECT" --材料特效
TxtFactory.S_MATERIAL_SKILL_ID = "SKILL_ID" --触发技能ID
TxtFactory.S_MATERIAL_HOLYSCORE = "holy"	--神圣点数

TxtFactory.S_MATERIAL_COIN_ID = "15001000" --金币
TxtFactory.S_MATERIAL_BIG_COIN_ID = "15002000" --大金币
TxtFactory.S_MATERIAL_SMALL_COIN_ID = "15142000" --小金币
TxtFactory.S_MATERIAL_DIAMOND_FRAG_ID = "15003000" --钻石碎片
TxtFactory.S_MATERIAL_DIAMOND_ID = "15004000" --钻石
TxtFactory.S_MATERIAL_STONE_ID = "15005000" --小石子
TxtFactory.S_MATERIAL_BLOCK_ID = "15006000" --大石块
TxtFactory.S_MATERIAL_C_JEWEL_ID = "15007000" --金刚石
TxtFactory.S_MATERIAL_TREE_BRANCH_ID = "15008000" --小树枝
TxtFactory.S_MATERIAL_WOOD_ID = "15009000" --木片
TxtFactory.S_MATERIAL_GOD_TREE_ID = "15010000" --神木树枝
TxtFactory.S_MATERIAL_IRON_FRAG_ID = "15011000" --铁屑
TxtFactory.S_MATERIAL_IRON_BOARD_ID = "15012000" --铁板
TxtFactory.S_MATERIAL_IRON_STONE_ID = "15013000" --陨铁石
TxtFactory.S_MATERIAL_HALF_SHAPED_DIAMOND_ID = "15014000" --半月宝石
TxtFactory.S_MATERIAL_FULL_SHAPED_DIAMOND_ID = "15015000" --圆月宝石
TxtFactory.S_MATERIAL_GOD_SHAPED_DIAMOND_ID = "15016000" --月神宝石
TxtFactory.S_MATERIAL_POINT_TOOTH_ID = "15017000" --小尖牙
TxtFactory.S_MATERIAL_SHARP_TOOTH_ID = "15018000" --锐利的牙
TxtFactory.S_MATERIAL_BEAST_TOOTH_ID = "15019000" --神兽的牙

--商城表列名
TxtFactory.S_STORECONFIGTXT_ID = "ID" --道具id
TxtFactory.S_STORECONFIGTXT_SHOP_TYPE = "SHOP_TYPE" --商城类型 1=跑酷前商城 2=夺宝奇兵商城   4-10=游戏商城
TxtFactory.S_STORECONFIGTXT_PROMOTIONS = "PROMOTIONS" --促销类型 0=不做判断 1=限时 2=特惠 
TxtFactory.S_STORECONFIGTXT_PRICE_OFF = "PRICE_OFF" --折扣
TxtFactory.S_STORECONFIGTXT_TYPE = "TYPE" --货币种类 1=PRICE_GOLD（金币）   2=PRICE_DIAMOND（钻石）  3=TERRITORY_GOLD（夺宝货币） 4=RMB
TxtFactory.S_STORECONFIGTXT_PRICE_COUNT = "PRICE_COUNT" --价格
TxtFactory.S_STORECONFIGTXT_MATERIAL_ID = "MATERIAL_ID" --材料ID
TxtFactory.S_STORECONFIGTXT_GOODS_ICON = "GOODS_ICON" --商品ICON
TxtFactory.S_STORECONFIGTXT_SHOP_GOODS_NAME = "SHOP_GOODS_NAME" --商城物品名称
TxtFactory.S_STORECONFIGTXT_GOODS_DESC = "GOODS_DESC" --物品描述

--静态场景表
TxtFactory.S_SCENE_MID = "MIDSHOT" --中景
TxtFactory.S_SCENE_FAR = "FARSHOT" --远景

--剧情关卡静态表
TxtFactory.S_CHAPTER_TYPE = "TYPE" --关卡大章
TxtFactory.S_CHAPTER_BASE = "BASE" --剧情背景
--无尽关卡表
TxtFactory.S_ENDLESS_NAME = "NAME" --Resources下prefab名字
TxtFactory.S_ENDLESS_BASE = "BASE" --base 类型
TxtFactory.S_ENDLESS_SPEED = "SPEED" --速度
TxtFactory.S_ENDLESS_TYPE = "TYPE" --随机组 组号
TxtFactory.S_ENDLESS_BASE_NUM = "BASE_NUM" --base数量
TxtFactory.S_ENDLESS_MAX_SPEED = "MAX_SPEED" --最大速度
TxtFactory.S_ENDLESS_HP_USE = "HP_USE" --每秒消耗的体力
TxtFactory.S_ENDLESS_ROLL = "ROLL" --速度 类型对 的随机次数
TxtFactory.S_ENDLESS_SEASON = "SEASON" --对应 base的段数
TxtFactory.S_ENDLESS_PREFABNAME = "PREFAB" --关卡json名字
	
--静态萌宠坐骑种类表
TxtFactory.S_ROLE_TYPE = "TYPE" --萌宠类型
TxtFactory.S_ROLE_MODEL = "MODEL" --prefab 3d模型名字
TxtFactory.S_ROLE_LUACLASS = "LUA_CLASS" --萌宠 lua class
TxtFactory.S_ROLE_CHINCHILLAS_ID = 13005 --龙猫种类id
--城建配置表
TxtFactory.S_BUILD_MODEL = "MODEL" --城建模型
TxtFactory.S_BUILDING_TYPE = "OPERATION_TYPE" --建筑操作类型
TxtFactory.S_BUILDING_TYPENAME = "OPERATION_TYPENAME" --建筑操作类型
TxtFactory.S_BUILDING_FIRST_LVL = "FIRST_LVL" --该建筑种类第一个等级id
TxtFactory.S_BUILDING_MAX_LVL = "MAX_LVL" --该建筑种类第一个等级id
TxtFactory.S_BUILDING_OPEN_TYPE = "OPEN_TYPE" --建筑开启
TxtFactory.S_BUILDING_METERIAL = "METERIAL" --建筑升级材料
TxtFactory.S_BUILDING_UPDIAMONDS = "UPDIAMONDS" --建筑升级钻石
TxtFactory.S_BUILDING_UPGOLD = "UPGOLD" --建筑升级金币
TxtFactory.S_BUILDING_NAME = "NAME" --城建名字
TxtFactory.S_BUILDING_DESC = "BUILDING_DESC" --城建描述
TxtFactory.S_BUILDING_SPEED = "SPEED" --生产速度
TxtFactory.S_BUILDING_MAXGOLD = "MAXGOLD" --生产上限
TxtFactory.S_BUILDING_CAPACITY = "CAPACITY" --容量
TxtFactory.S_BUILDING_PEN = "ADDSC_PEN"	--结算得分加成
TxtFactory.S_BUILDING_POSITION = "POSITION" --模型位置
TxtFactory.S_BUILDING_ROTATION = "ROTATION" --模型旋转
TxtFactory.S_BUILDING_NAME_POSITION = "BUILDING_NAME_POSITION" --城建名字位置

--攻击动作表
TxtFactory.S_ATK_ANIM_SUIT = "DRESS_ID" --套装
TxtFactory.S_ATK_ANIM_SEX = "SEX" --性别
TxtFactory.S_ATK_ANIM_ORDER = "ORDER" --动作顺序
TxtFactory.S_ATK_ANIM_ACTION = "ACTION" --人物动画
TxtFactory.S_ATK_ANIM_EFFECT = "EFFECT" --特效
TxtFactory.S_ATK_ANIM_MIN_TIME = "ACT_TIME" --至少播放时间
TxtFactory.S_ATK_ANIM_DAMAGE_START = "DAMAGE_START" --伤害开始时间
TxtFactory.S_ATK_ANIM_DAMAGE_END = "DAMAGE_OVER" --伤害结束时间
TxtFactory.S_ATK_ANIM_COMBO_TIME = "COMBO_TIME" --连击有效时间
TxtFactory.S_ATK_ANIM_DAMAGE_SCALE = "DAMAGE_SCALE" --伤害范围
TxtFactory.S_ATK_ANIM_JUMP_ATK = "JUMP_ATK" --是否为攻击动画
TxtFactory.S_ATK_ANIM_ATK_DISTANCE = "ATK_DISTANCE" --动作内需要移动的距离

--萌宠动作表
TxtFactory.S_PET_ANIM_ARISE_ACTION = "ARISE_ACTION" --出现动作
TxtFactory.S_PET_ANIM_ARISE_SPEED = "ARISE_SPEED" --宠物出现速度
TxtFactory.S_PET_ANIM_CONTINUED_ACTION = "CONTINUED_ACTION" --持续动作
TxtFactory.S_PET_ANIM_CONTINUED_SPEED = "CONTINUED_SPEED" --宠物持续速度
TxtFactory.S_PET_ANIM_END_ACTION = "END_ACTION" --结束动作
TxtFactory.S_PET_ANIM_ARISE_EFFECT = "ARISE_EFFECT" --出现特效
TxtFactory.S_PET_ANIM_LINK_EFFECT = "LINK_EFFECT" --衔接特效
TxtFactory.S_PET_ANIM_CONTINUED_EFFECT = "CONTINUED_EFFECT" --持续特效
TxtFactory.S_PET_ANIM_END_EFFECT = "END_EFFECT" --结束特效
TxtFactory.S_PET_ANIM_ARISE_POSITION = "ARISE_POSITION" --出现位置
TxtFactory.S_PET_ANIM_CONTINUED_POSITION = "CONTINUED_POSITION" --停留位置
-- 据点信息表(动态)
TxtFactory.SNATCH_STRONGHOLDID = "STRONGHOLDID"		-- 当前攻打的据点ID
TxtFactory.SNATCH_BATTLERESULT = "BATTLERESULT" -- 夺宝奇兵战斗结算数据
TxtFactory.SNATCH_DEFENGPETS = "DEFENGPETS"   -- 驻守萌宠信息(客户端用于临时存储)
TxtFactory.SNATCH_STRONGHOLDINFO = "STRONGHOLDINFO" -- 我自己的据点信息
TxtFactory.SNATCH_SCORE = "SNATCH_SCORE" -- 夺宝积分
TxtFactory.SNATCH_GOLD = "SNATCH_GOLD" -- 夺宝币
TxtFactory.SNATCH_NUM = "SNATCH_NUM" -- 今天已经玩的次数
TxtFactory.SNATCH_REFER_NUM = "SNATCH_REFER_NUM" -- 换一批的次数
TxtFactory.SNATCH_REFER_MAXNUM = "SNATCH_REFER_MAXNUM" -- 可攻打的最大次数
TxtFactory.SNATCH_BUY_NUM  = "SNATCH_BUY_NUM"    -- 已购买的次数

-- 异步pvp信息表(动态)
TxtFactory.ASYNCPVPVINFO_MEMBERID = "ASYNCPVPVINFO_MEMBERID" -- 挑战的对手id
TxtFactory.ASYNCPVPVINFO_NICKNAME = "ASYNCPVPVINFO_NICKNAME" -- 挑战的对手名称
TxtFactory.ASYNCPVPVINFO_ICON = "ASYNCPVPVINFO_ICON" 		 -- 挑战的对手名称ICON
TxtFactory.ASYNCPVPVINFO_ACATOR = "ASYNCPVPVINFO_ACATOR" 	 -- 挑战的对手套装ID
TxtFactory.ASYNCPVPVINFO_ACATORS = "ASYNCPVPVINFO_ACATORS" -- 挑战的对手名称套装列表
TxtFactory.ASYNCPVPVINFO_CURPETS = "ASYNCPVPVINFO_CURPETS" -- 挑战的对手的宠物上阵列表
TxtFactory.ASYNCPVPVINFO_BINPETS = "ASYNCPVPVINFO_BINPETS" -- 挑战的对手宠物列表

-- 天梯信息表(动态)
TxtFactory.LADDER_BASEINFO = "LADDER_BASEINFO"  -- 天梯基础信息
TxtFactory.LADDER_RANKLIST = "LADDER_RANKLIST"  -- 天梯排行列表
TxtFactory.LADDER_RIVAL_MEMBERID = "LADDER_RIVAL_MEMBERID"  -- 挑战赛要挑战的人id
TxtFactory.LADDER_UPGRADE_RESULT = "LADDER_UPGRADE_RESULT"  -- 天梯晋级赛结果保存
TxtFactory.LADDER_CHALLENGE_RESULT = "LADDER_CHALLENGE_RESULT" -- 天梯挑战结果

--好友信息表列名(动态)
TxtFactory.FRIEND_NOWPAGE = "NOWPAGE" --现在的页数
TxtFactory.FRIEND_ALLPAGE = "ALLPAGE" --总页数
TxtFactory.FRIEND_REQNUM = "REQNUM" --申请数
TxtFactory.FRIEND_FRIENDNUM = "FRIENDNUM" --现在的好友数

--城建信息表列名(动态)
TxtFactory.BUILDING_IDTABLE = "IDTABLE" --根据实例ID存放的城建服务器table
TxtFactory.BUILDING_OBJTABLE = "OBJTABLE" --存储城建对象的table
TxtFactory.BUILDING_HASDATA = "HASDATA" --是否有服务器数据
TxtFactory.BUILDING_FETCHID = "FETCHID" --有产出的城建实例id

--玩家挑战信息列名（动态）
TxtFactory.CHALLENGE_FRIENDID = "FRIENDID" --好友id
TxtFactory.CHALLENGE_FRIENDINFO = "FRIENDINFO" --好友信息

--玩家应战信息列名（动态）
TxtFactory.REPLYCHALLENGE_FRIENDID = "FRIENDID" --好友id
TxtFactory.REPLYCHALLENGE_MAILID = "MAILID" --邮件id
TxtFactory.REPLYCHALLENGE_FRIENDNAME = "FRIENDNAME" --好友名字
TxtFactory.REPLYCHALLENGE_FRIENDSCORE = "FRIENDSCORE" --好友分数

--玩家信息表
TxtFactory.USER_MEMBERID = 'memberid'--玩家id
TxtFactory.USER_NAME = 'username'  --玩家姓名
TxtFactory.USER_SEX = 'sex'  ---玩家性别
TxtFactory.USER_GOLD = 'gold'  --玩家金币
TxtFactory.USER_DIAMOND = 'diamond' --玩家钻石
TxtFactory.USER_EXP = 'exp' --玩家经验
TxtFactory.USER_EXP_MAX = 'exp_max'--玩家升级经验
TxtFactory.USER_LEVEL = 'level'  --玩家等级
TxtFactory.USER_STRENGTH = 'strength' --体力值
TxtFactory.USER_ICON = 'icon' --头像索引
TxtFactory.USER_GUIDE = 'guide' --新手引导进度
TxtFactory.USER_LOTT_GOLD = "lott_gold" -- 免费金币抽剩余时间
TxtFactory.USER_LOTT_DIAMOND = "lott_diamond" -- 免费钻石抽剩余时间
TxtFactory.USER_STATUS = "status"-- 调查问卷是否完成
TxtFactory.USER_GET_LOGIN_GIFT = "get_login_gift" --能否获得登录奖励 1能够 0 不能
TxtFactory.USER_LOGIN_NUM = "login_num" --获取登录奖励的次数 初始化为0
TxtFactory.USER_ALIVE_TIME = "alive_time" --累计在线时间 领取该次奖励时清零
TxtFactory.USER_STRENGTH_TIME = "strength_time" --距离下一次领取时间还剩多久
TxtFactory.USER_GAME_STAR_TIME = "game_star_time" --游戏开始时间
TxtFactory.USER_ALIVE_REWARD = "alive_reward" --在线奖励次数 累加
TxtFactory.USER_STORY = "story"  --当前选中关卡
TxtFactory.USER_MOVE_SPEED = 'move_speed' --玩家移动速度
TxtFactory.USER_BATTLE_TYPE = 'battle_type' --玩家核心战斗类型
TxtFactory.USER_BLOOD_BOTTLE_EXTRA = "bloodBottleExtra"--血瓶增益 吃到血瓶才加血
TxtFactory.USER_HP_RATE = "hp_rate" --体力 消耗速率
TxtFactory.USER_HP_SLOWDOWN = "hpSlowDown"--延缓体力 跑酷体力减少减缓
TxtFactory.USER_SECOND_JUMP_SCORE = "secondJumpScore"--二段跳额外得分
TxtFactory.USER_MULTI_JUMP_SCORE = "multiJumpScore"--多段跳额外得分
TxtFactory.USER_MINUS_DAMAGE = "minusDamage"--受击减伤
TxtFactory.USER_INMUNE_FALLDOWN = "inmuneFalldown"--掉坑免伤
TxtFactory.USER_INMUNE_ATK_COUNT = "inmuneAktCount"--免疫攻击，不掉血次数(暂时不做)
TxtFactory.USER_HP_KILL_SUCK = "hpKillSuck"--吸血每击杀以下个数怪物获得2点体力
TxtFactory.USER_MAGNET_TIME = "magnetTimeExtra"  --磁铁时间延长
TxtFactory.USER_INVINCIBLE_TIME ="invincibleTimeExtra" --无敌延长
TxtFactory.USER_HOLY_KILL_SUCK = "holyKillSuck"--击杀怪物额外能量 神圣模式能量
-- TxtFactory.S_EQUIP_ENERGYJUMP = "ENERGYJUMP"--跳跃产生极限碎片 弹跳加神圣模式能量
TxtFactory.USER_JUMP_CAP = "jumpCap" --跳跃次数增加
TxtFactory.USER_SUIT_SKILL_CD = "suitSkillCD" --减少CD时间 套装cd时间
TxtFactory.USER_SPEED_EXTRA	= "speedExtra" --增加速度 跑酷速度
TxtFactory.USER_DIVE_SCORE = "diveScore"  --滑翔得分
TxtFactory.USER_ON_DUCK_FLY_TIME = "onDuckFlyTime" --在大黄鸭上飞行时间
TxtFactory.USER_IS_RESTART= "userIsRestart" -- 是否重来关


--玩家装备表
TxtFactory.EQUIPMAIN_SELECTED = "equipmain_selected" -- 主界面选中序号 名字
TxtFactory.UPGRADE_SELECTED = "upgrade_selected" --升级选中序号 名字
TxtFactory.MERGE_SELECTED = "merge_selected" --融合选中序号 名字
TxtFactory.HANDBOOK_INFOTAB = "handbook_infotab" -- 配置表全图鉴id
TxtFactory.MERGE_EQUIPEDNFO = "merge_equipedinfo" -- 融合已装备的物品
--玩家关卡表
TxtFactory.CUR_BATTLE_ID = "cur_battle_id" -- 当前解锁的关卡ID

TxtFactory.BIN_BATTLES = "bin_battles" -- 关卡战绩
TxtFactory.SELECTED_BATTLE_ID = "selected_battle_id" --当前前端选中关卡id
TxtFactory.SELECTED_CHAPTER_ID = "selected_chapter_id"
TxtFactory.CHAPTER_INFO = "chapter_info" -- 关卡解锁信息
TxtFactory.CHAPTER_STAR = "chapter_star"--玩家关卡星级 
TxtFactory.CUPS_REWARD = "CupRewardList"-- 奖杯已经领取物品的链表
--玩家套装表
TxtFactory.SUIT_LEFT_INDEX="suit_left_index" --滑动最左边序号
TxtFactory.SUIT_SELECTED_INDEX="suit_selected_index" --选中序号
TxtFactory.CUR_SUITS = "cur_suits" --套装数组
TxtFactory.SUIT_ID = "suit_id" --套装id
TxtFactory.SUIT_CONFIG_ID = "suit_config_id" --套装静态表id
TxtFactory.SUIT_LVL = "suit_lvl"  --套装等级
--玩家萌宠表
TxtFactory.BIN_PETS = "bin_pets" -- 萌宠信息tab
TxtFactory.AID_PETS = "aid_pets" -- 支援宠tab
TxtFactory.FLY_PETS = "fly_pets" -- 飞行宠tab
TxtFactory.CUR_PETS = "cur_pets" -- 携带萌宠tab
TxtFactory.PETMAIN_SELECTED = "petmain_selected" -- 主界面选中序号 名字
TxtFactory.EXPITEM_SELECTED = "expitem_selected" -- 主界面 选中的经验物品
TxtFactory.MERGE_PETSSLOTTAB = "merge_petsslottab" -- 融合界面 选中萌宠tab
TxtFactory.PIECE_PETS = "piece_pets" -- 图鉴界面 拥有碎片萌宠tab
TxtFactory.DUI_ZHANG = "dui_zhang" -- 宠物队长
TxtFactory.Limit_NUM = "limit_num" -- 宠物背包数量上限

--玩家坐骑表
TxtFactory.BIN_MOUNT = "bin_mount"
TxtFactory.CUR_MOUNT = "cur_mount"

--背包数据 
TxtFactory.ITEMS_INFOTAB = "items_infotab" -- 背包数据tab
TxtFactory.ITEMS_BATTLEINFOTAB = "items_battleinfotab" -- 冲关前道具
TxtFactory.ITEMS_BATTLEINFODATATAB = "items_battleinfodatatab" -- 冲关前道具
TxtFactory.ITEMS_PETPIECE = "items_petpiece" -- 萌宠抽取碎片

--无尽数据表
TxtFactory.ENDLESSRANK_INFOTAB = "endlessrank_infotab" -- 无尽排行数据

--玩家任务列表
TxtFactory.TASK_DIALYINFOTAB = "task_dialyinfotab" -- 每日任务数据
TxtFactory.TASK_GUIDEINFOTAB = "task_guideinfotab" -- 新手任务数据

--账户数据表
TxtFactory.ACCOUNT_GUIDE = "account_guide" -- 新手进度


--注册所有静态表
function TxtFactory:RegisterAll()
    --静态表
	self:RegisterTable(_G[self.UserTXT].new())
	self:RegisterTable(_G[self.ChapterTXT].new())
	self:RegisterTable(_G[self.SuitTXT].new())
	self:RegisterTable(_G[self.MountTXT].new())
	self:RegisterTable(_G[self.MountTypeTXT].new())
	self:RegisterTable(_G[self.LotteryDataTXT].new())
	self:RegisterTable(_G[self.MaterialTXT].new())
	self:RegisterTable(_G[self.CharIconTXT].new())
	self:RegisterTable(_G[self.EquipTXT].new())
    self:RegisterTable(_G[self.EndlessTXT].new())
    self:RegisterTable(_G[self.TaskTXT].new())
	self:RegisterTable(_G[self.TaskSonTXT].new())
    self:RegisterTable(_G[self.GudieRunningSceneTXT].new())
    self:RegisterTable(_G[self.GudieDialogTXT].new())
    self:RegisterTable(_G[self.GudieUISceneTXT].new())
    self:RegisterTable(_G[self.PetSkillPassiveTXT].new())
    self:RegisterTable(_G[self.PetSkillMainTXT].new())
    self:RegisterTable(_G[self.PetMergeTXT].new())
    self:RegisterTable(_G[self.TipsTXT].new())
	self:RegisterTable(_G[self.VipFeatureConfigTXT].new())
	self:RegisterTable(_G[self.SystemNoticeConfigTXT].new())
	self:RegisterTable(_G[self.SoundTXT].new())
	self:RegisterTable(_G[self.MapConfigTXT].new())
	self:RegisterTable(_G[self.SceneThemeTXT].new())
	self:RegisterTable(_G[self.PlayerLevelUpTXT].new())
	self:RegisterTable(_G[self.LotteryPondTXT].new())
	self:RegisterTable(_G[self.CharNamesTXT].new())
	self:RegisterTable(_G[self.SurveyConfigTXT].new())
	self:RegisterTable(_G[self.BuildingTXT].new())
    self:RegisterTable(_G[self.StoryCupTXT].new())
    self:RegisterTable(_G[self.SuitSkillTXT].new())
	self:RegisterTable(_G[self.SnatchConfigTXT].new())
	self:RegisterTable(_G[self.TextsConfigTXT].new())
	self:RegisterTable(_G[self.StrongholdPostionConfigTXT].new())
	self:RegisterTable(_G[self.StoreConfigTXT].new())
	self:RegisterTable(_G[self.LadderConfigTXT].new())
	self:RegisterTable(_G[self.StoreGiftBagConfigTXT].new())
	self:RegisterTable(_G[self.SveneDayActivityConfigTXT].new())
	self:RegisterTable(_G[self.OnlineActivityConfigTXT].new())
	
	self:RegisterTable(_G[self.SnatchIntegralConfigTXT].new())
	self:RegisterTable(_G[self.GameExplainConfigTXT].new())
	self:RegisterTable(_G[self.GameConfigTXT].new())
	self:RegisterTable(_G[self.LadderRewardConfigTXT].new())
	self:RegisterTable(_G[self.ATKAnimTXT].new())
	self:RegisterTable(_G[self.PetAnimTXT].new())
	self:RegisterTable(_G[self.FunctionOpenTXT].new())
	self:RegisterTable(_G[self.JieSuoTiaoJianTXT].new())
	--动态表
	self:RegisterTable(_G[self.MemDataCache].new())
	self:RegisterTable(_G[self.TaskManagement].new())
	self:RegisterTable(_G[self.UITransitionManager].new())
	self:RegisterTable(_G[self.SoundManagement].new())

    self.hasTable = true
end

--注册并初始化表
function TxtFactory:RegisterTable(txt)
	self.tableMap[txt.tag] = txt
	txt:Init()
end
--获取静态表
function TxtFactory:getTable( name )
	return self.tableMap[name]
end
--返回本地表是否已初始化
function TxtFactory:isInit()
	return self.hasTable
end
-- 获取动态表
function TxtFactory:getMemDataCacheTable( name )
	local t =  self.tableMap[TxtFactory.MemDataCache]:getTable(name)
	if t == nil then
		t={}
		self:setMemDataCacheTable(name,t)
	end

	return t
end

-- 插入动态表
function TxtFactory:setMemDataCacheTable( name,t)
	return self.tableMap[TxtFactory.MemDataCache]:setTable(name,t)
end

-- 写入数值
-- name 表名
--column 列名
--value 写入值
function TxtFactory:setValue( name,column,value )
	local t = self.tableMap[TxtFactory.MemDataCache]:getTable(name)
	if t ~= nil then
		t[column] = value
	else
		error("TxtFactory:setValue"..name.."该表为空")
		t = {}
		self.tableMap[TxtFactory.MemDataCache]:setTable(name,t)
		t[column] = value
	end
end

--读出数据
function TxtFactory:getValue( name,column)
	local t = self.tableMap[TxtFactory.MemDataCache]:getTable(name)
	if t ~= nil then
		return t[column]
	else
		error("TxtFactory:getValue"..name.."该表为空")
		t = {}
		self.tableMap[TxtFactory.MemDataCache]:setTable(name,t)
		return t
	end
end
