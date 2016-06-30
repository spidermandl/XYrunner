--[[
author:Desmond
网络配置
]]

--服务器地址 
NetDomain = --"http://120.26.3.29" --正式发布
            "http://121.41.95.94" --阿里云机器
            --"http://172.16.10.200" --局域网机器
-- passport入口
Passport = --"/passport_dev"   -- 外网
          "/passport"       -- 内网

NetConfig = {

    GUEST_REG_API = Passport.."/register/guest", --游客注册
    USER_REG_API = Passport.."/register", --普通用户注册
    USER_LOGIN_API = Passport.."/login", --普通用户登录
    USERXY_LOGIN_API = Passport.."/xy/login", --xy用户登录
    USER_SDK_LOGIN_API = Passport.."/login/sdk",--sdk 登陆
    ROLE_INFOGET_API="/login", --获得角色信息
    SER_LISTGET_API = Passport.."/serverlist", --获取服务器列表
    ROLE_CREAT_API ="/login",  --创建角色信息
    SUIT_SELECT ="/",   --套装选择 
    SUIT_LVUP="/",   --套装升级
    MOUNT_SELECT="/",   --坐骑选择
    MOUNT_LVUP="/",   --坐骑升级
    --[[装备]]
    EQUIPINFO = "", --获取装备列表信息，得到装备id
    EQUIP_LVL_UP = "", --装备升级协议，包括金币升级，钻石升级
    EQUIP_UNLOCK= "", --装备解锁 加装备格子
    EQUIP_EXCHANGE = "", --更换角色配置装备
    EQUIP_SLOT = "", --抽取装备
    EQUIP_MERGE = "",--装备熔炼，多个合成一个

    --[[城建]]
    BUILDINGINFO = "",   --城建信息
    BUILDING_LVUP = "",  --城建升级信息
    BUILDING_FETCH = "", --城建收获奖励

    --[[萌宠]]
    PETINFO = "", --拉取萌宠信息
    PET_UNLOCK = "", --增加萌宠格子
    PET_EXCHANGE = "", --萌宠上场 下场
    PET_UPGRADE = "",--萌宠升级
    PET_MERGE = "",--萌宠融合
    PET_VARIAT = "",--萌宠变异
    PET_SLOT = "", --萌宠抽取
    GIFT_PURCHASE = "",--萌宠合成购买道具
    PET_CALL = "", -- 萌宠召唤
    PET_JINENG = "", -- 萌宠技能
    PET_DUIZHANG = "", -- 萌宠队长

    --[[道具 无尽模式 跑酷道具]]
    ITEMINFO = "",--道具列表
    ITEM_PURCHASE = "",--购买道具
    ITEM_PETBUY = "", -- 宠物道具购买

    --[[商城]]
    STOREINFO = "",   --商城信息信息
    STORE_BUYITEM = "",  --商城购买道具

    --[[好友]]
    FRIENDLIST = "",   --好友列表
    FRIENDFIND = "",   --好友查找
    FRIENDADD = "",    --申请添加好友
    FRIENDACCEPT = "", --接受或者拒绝某申请
    RECOMMENDFRIEND = "", --推荐用户
    GIVESTRENGTH = "", --赠送体力
    FRIENDCHALLENGE = "", --挑战好友
    FRIENDREMOVE = "", --删除好友

    --[[关卡]]
    STORYINFO = "",--关卡信息 奖杯信息
    STORYUSEITEM = "",--关卡消耗道具

    --[[套装]]

    --[[炼金所]]
    MATERIAL_INFO = "",--获取玩家当前材料
    MATERIAL_MERGE = "",--材料合成

    --[[跑酷]]
    RUN_START = "", --跑酷开始
    RUN_RESULT = "", --跑酷结果
    RUN_MATERIAL_INFO = "", --跑酷收集材料 列表

    --[[默认]]
    DEFAULT = "",

    --[[任务]]
    TASK_INFO = "", -- 任务列表

    --[[新手引导]]
    GUIDE_PROGRESS = "", -- 新手引导进度

    --[[排行榜]]
    ENDLESS_RANK = "", -- 无尽排行榜
    
    --[[问卷调查]]--
    SURVEY = "",
    
    --[[ 天梯 ]]--
    LADDER_INFO = "", -- 天梯信息 


 }

--消息协议号码
MsgCode = 
{
    GuestMsg = 10 , 
    RegisterMsg = 11 , --注册角色 回复
    LoginMsg = 12 , --角色登录 回复
    ServerListMsg = 13 , 
    XYLoginMsg = 14,
    SDKLoginMsg = 15, --sdk 登录
    RegisterRequest = 51 , --创建角色 请求
    RegisterResponse = 52 , --创建角色 回复
    GetCharInfoRequest = 16000 , --角色基本信息 请求
    GetCharInfoResponse = 16001,  --角色基本信息 回复
    GetGiftRequest = 16002, -- 兑换码领取礼包 请求
    GetGiftResponse = 16003, -- 兑换码领取礼包 回复
    GetMailListRequest = 16004, -- 获取邮件列表 请求
    GetMailListResponse = 16005, -- 获取邮件列表 回复
    GetMailItemRequest = 16006, -- 获得邮件物品 请求
    GetMailItemResponse = 16007, -- 获得邮件物品 回复
    GetBattleListRequest = 17000, -- 获取邮件列表 请求
    GetBattleListResponse = 17001, --获取关卡进度信息 回复
    TaskListRequest = 21000, -- 获取任务列表信息 请求
    TaskListResponse = 21001, -- 获取任务列表信息 回复
    TaskCommitRequest = 21002, -- 提交任务 请求
    TaskCommitResponse = 21003, -- 提交任务 回复
    UpdateGuideRequest = 16008, -- 新手引导提交进度 请求
    UpdateGuideResponse = 16009, -- 新手引导提交进度 回复
    StartBattleRequest = 17002, --开始进入某一关卡 请求
    StartBattleResponse = 17003, --开始进入某一关卡 回复
    EndBattleRequest = 17004, --关卡结束 汇报关卡成绩 请求
    EndBattleResponse = 17005, --关卡结束 汇报关卡成绩 回复
    EndBattleStartRequest = 17006, --无尽开始协议 请求
    EndBattleStartResponse = 17007, --无尽开始协议 回复
    EndBattleEndRequest = 17008, --无尽结束协议 请求
    EndBattleEndResponse = 17009, --无尽结束协议 回复
    SelectAvatorRequest = 18000 , --套装选择 请求
    SelectAvatorResponse = 18001, --套装选择 回复
    UpgradeAvatorRequest = 18002 ,
    UpgradeAvatorResponse = 18003,
    EquipsListRequest = 20000 , --获取装备列表 有最大格子数多少 已解锁多少格子 请求
    EquipsListResponse = 20001, --获取装备列表 有最大格子数多少 已解锁多少格子 回复
    UnlockSlotRequest = 20002 , --解锁背包格子和解锁装备位 请求
    UnlockSlotResponse = 20003 , --解锁背包格子和解锁装备位 回复
    EquipItemRequest = 20004 , --装备物品 请求
    EquipItemResponse = 20005 , --装备物品 回复
    UnEquipRequest = 20006 ,--卸载装备 请求
    UnEquipReponse = 20007 ,--卸载装备 回复
    ItemListRequest = 20008, --获取材料列表 id-num 请求
    ItemListResponse = 20009, --获取材料列表 id-num 回复
    EquipUpgradeRequest = 20010 ,--升级装备 请求
    EquipUpgradeResponse = 20011 ,--升级装备 回复
    EquipMergeRequest = 20012,-- 装备融合 请求
    EquipMergeReponse = 20013, -- 装备融合 回复
    EquipLotteryRequest = 20014,-- 装备抽取 请求
    EquipLotteryResponse = 20015, -- 装备抽取 回复
    SelPetRequest = 19016, -- 萌宠上场 请求
    SelPetResponse = 19017, -- 萌宠上场 回复
    UpgradePetRequest = 19002, -- 萌宠升级 请求
    UpgradePetResponse = 19003, -- 萌宠升级 回复
    SelectHorseRequest = 19004,--坐骑选择 请求
    SelectHorseResponse = 19005,--坐骑选择 回复
    PetMergeRequest = 19006, -- 萌宠融合 请求
    PetMergeReponse = 19007, -- 萌宠融合 回复
    PetLotteryRequest = 19008, -- 萌宠抽取 请求
    PetLotteryResponse = 19009, -- 萌宠抽取 回复
    PetCallingRequest = 19010, -- 萌宠召唤 请求
    PetCallingResponse = 19011, -- 萌宠召唤 回复
    RankListRequest = 22000, -- 排行数据 请求
    RankListResponse = 22001, -- 排行数据 回复
    RankRecentRequest = 22002, -- 角色当前排行 请求
    RankRecentResponse = 22003, -- 角色当前排行 回复
    PetVariationRequest = 19012, -- 萌宠变异 请求
    PetVariationResponse = 19013, -- 萌宠变异 回复
    BuyItemRequest = 20016, -- 无尽购买 请求
    BuyItemResponse = 20017, -- 无尽购买 回复
    QuestAnswerRequest = 16010, -- 问卷调查请求
    QuestAnswerResponse = 16011, -- 问卷调查 回复
    BuildListRequest = 23000,  --城建信息请求
    BuildListResponse = 23001, --城建信息回复
    BuildUpgradeRequest = 23002, --城建建筑升级
    BuildUpgradeResponse = 23003, --城建建筑升级回复
    BuildGainRequest = 23004, --城建收获金币
    BuildGainResponse = 23005, --城建收货金币回复
    ExplorerListRequest = 24000, --获取当前分配给玩家的探险点  请求
    ExplorerListResponse = 24001, --获取当前分配给玩家的探险点 回复
    ExplorerStartRequest = 24002, -- 探险开始  请求
    ExplorerStartResponse = 24003, -- 探险开始  回复
    ExplorerEndRequest = 24004, -- 探险结束汇报  请求
    ExplorerEndResponse = 24005, -- 探险结束汇报  回复
    ExplorerInfoRequest = 24006, -- 请求自己占领地 请求
    ExplorerInfoResponse = 24007, -- 请求自己占领地 回复
    ExplorerOccupyRequest = 24008, -- 占领据点 请求
    ExplorerOccupyResponse = 24009, -- 占领据点 回复
    CupGetResponse = 17011,--奖杯获取奖励
    CupGetRequest = 17010,--领取奖杯中心奖励
    ShopListRequest = 20022, -- 商城信息 请求
    ShopListResponse = 20023, -- 商城信息 回复
    ExplorerDenfenseRequest = 24010,--设置守卫 请求
    ExplorerDenfenseResponse = 24011,--设置守卫 回复
    ExplorerGainRequest = 24012, -- 收获自己据点的金币 请求
    ExplorerGainResponse = 24013, -- 收获自己据点的金币 回复
    FriendListRequest = 25006, --好友列表 请求
    FriendListResponse = 25007, --好友列表 回复
    FriendFindRequest = 25000, --好友查找 请求
    FriendFindResponse = 25001, --好友查找 回复
    FriendAddRequest = 25002, --好友申请 请求
    FriendAddResponse = 25003, --好友申请 回复
    FriendAcceptRequest = 25004, --接受或者拒绝某申请 请求
    FriendAcceptResponse = 25005, --接受或者拒绝某申请 回复
    RecommendFriendRequest = 25008, --推荐好友 请求
    RecommendFriendResponse = 25009, --推荐好友 回复
    GiveStrengthRequest = 27000, -- 赠送体力 请求
    GiveStrengthResponse = 27001, --赠送体力 回复
    FriendChallengeRequest = 27002, --向其他好友发起挑战 请求
    FriendChallengeResponse = 27003, --向其他好友发起挑战 回复
    FriendAckChallengeRequest = 27004, --回应好友的挑战 请求
    FriendAckChallengeResponse = 27005, --回应好友的挑战 回复
    FriendRemoveRequest = 25010, --删除好友 请求
    FriendRemoveResponse = 25011, --删除好友 回复
    LadderInfoRequest = 28000 , -- 获得玩家天梯信息 请求
    LadderInfoResponse = 28001 , -- 获得玩家天梯信息  回复
    LadderRaceBeginRequest = 28002,  -- 定级赛开始 请求
    LadderRaceBeginResponse = 28003, --  定级赛开始 回复
    LadderRaceEndRequest = 28004,  -- 定级赛结束 请求
    LadderRaceEndResponse = 28005, --  定级赛结束 回复
    LadderLevelConfirmRequest = 28006,  -- 确定段位 请求
    LadderLevelConfirmResponse = 28007, --  确定段位 回复
    LadderListRequest = 28009,  -- 天梯排行列表 请求
    LadderListResponse = 28010, --  天梯排行列表 回复
    LadderUpgradeStartRequest = 28011,  -- 晋级挑战开始 请求
    LadderUpgradeStartResponse = 28012, --  晋级挑战开始 回复
    LadderUpgradeEndRequest = 28013,  -- 晋级挑战汇报 请求
    LadderUpgradeEndResponse = 28014, --  晋级挑战汇报 回复
    LadderChallengeRequest = 28015,  -- 向其他玩家发起晋级挑战 请求
    LadderChallengeResponse = 28016, --  向其他玩家发起晋级挑战 回复
    ExplorerDataRequest = 24016,   --  自己夺宝的额外信息 请求
    ExplorerDataResponse = 24017,   --  自己夺宝的额外信息 回复
    ExplorerReferRequest = 24018,  --  刷新一批  请求
    ExplorerReferResponse = 24019,  --  刷新一批  回复
    PetUpgradeSkillRequest = 19018,  --  宠物技能升级  请求
    PetUpgradeSkillResponse = 19019,  --  宠物技能升级  回复
    PetSetHeroRequest = 19020,  --  设置队长  请求
    PetSetHeroResponse = 19021,  --  设置队长  回复
    PetListRequest = 19014,  --获得萌宠列表
    PetListResponse = 19015,  --获得萌宠列表 返回
    SevenLoginRequest = 16014,  --请求获取7天登录奖励
    SevenLoginResponse = 16015,  --请求获取7天登录奖励 返回
    UseItemRequest = 20024,     --关卡消耗道具
    UseItemResponse = 20025,     --关卡消耗道具
    GameEndNotify = 16016, --游戏结束时通知一下
    RankMatchRequest = 22004, --匹配玩家 请求
    RankMatchResponse = 22005, --匹配玩家 回复
    RankChallengeRequest = 22006, --向匹配的玩家发起挑战 请求
    RankChallengeResponse = 22007, --向匹配的玩家发起挑战 回复
}


require "game/net/MsgFactory"
require "game/net/BaseMsg"
require "game/net/GuestMsg"
require "game/net/RegisterMsg"
require "game/net/LoginMsg"
require "game/net/RoleInfoMsg"
require "game/net/ServerListMsg"
require "game/net/RoleCreatMsg"
require "game/net/RoleInfoGetMsg"
require "game/net/SuitSelectMsg"
require "game/net/SuitLevelUp"
require "game/net/MountSelectMsg"
require "game/net/EquipInfoGetMsg"
require "game/net/EquipSlotAddMsg"
require "game/net/EquipItemMsg"
require "game/net/UnEquipMsg"
require "game/net/EquipLevelUpMsg"
require "game/net/EquipMergeMsg"
require "game/net/EquipExtractMsg"
require "game/net/ChapterInfoMsg"
require "game/net/PetLevelUpMsg"
require "game/net/MaterialInfoMsg"
require "game/net/PetJoinMsg"
require "game/net/StartRunningMsg"
require "game/net/PetMergeMsg"
require "game/net/PetLotteryMsg"
require "game/net/GiftExchageMsg"
require "game/net/BattleBuyItemsMsg"
require "game/net/EmailListMsg"
require "game/net/EmailRewardMsg"
require "game/net/TaskListMsg"
require "game/net/TaskCommitMsg"
require "game/net/UpdateGuideMsg"
require "game/net/RankListMsg"
require "game/net/PetCallingMsg"
require "game/net/PetVariationMsg"
require "game/net/EndStartRunningMsg"
require "game/net/EndBattleEndMsg"
require "game/net/EndBattleMsg"
require "game/net/BuyItemMsg"
require "game/net/QuestAnswerMsg"
require "game/net/BuildingInfoMsg"
require "game/net/BuildingUpLvMsg"
require "game/net/BuildingFetchMsg"
require "game/net/ExplorerListMsg"
require "game/net/ExplorerStartMsg"
require "game/net/ExplorerEndMsg"
require "game/net/ExplorerOccupyMsg"
require "game/net/ExplorerInfoMsg"
require "game/net/CupGetMsg"
require "game/net/StoreInfoMsg"
require "game/net/StoreBuyItemMsg"
require "game/net/ExplorerDenfenseMsg"
require "game/net/ExplorerGainMsg"
require "game/net/RecommendFriendMsg"
require "game/net/FriendAddMsg"
require "game/net/FriendFindMsg"
require "game/net/FriendListMsg"
require "game/net/FriendAcceptMsg"
require "game/net/GiveStrengthMsg"
require "game/net/FriendChallengeMsg"
require "game/net/FriendReplyChallengeMsg"
require "game/net/FriendRemoveMsg"
require "game/net/LadderInfoMsg" 
require "game/net/LadderRaceEndMsg"
require "game/net/LadderRaceBeginMsg"
require "game/net/LadderLevelConfirmMsg"
require "game/net/LadderListMsg"
require "game/net/LadderUpgradeStartMsg"
require "game/net/LadderUpgradeEndMsg"
require "game/net/LadderChallengeMsg"	
require "game/net/ExplorerDataMsg"
require "game/net/ExplorerReferMsg"
require "game/net/SevenLoginMsg"
require "game/net/PetListMsg"
require "game/net/UseItemMsg"
require "game/net/RankMatchMsg"
require "game/net/RankChallengeMsg"
