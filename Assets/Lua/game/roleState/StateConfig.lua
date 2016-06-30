require "game/roleState/IState"
require "game/roleState/playerState/BasePlayerState"
require "game/roleState/playerState/JumpState"
require "game/roleState/playerState/RunState"
require "game/roleState/playerState/StateMachine"
require "game/roleState/playerState/RoleStateMachine"
require "game/roleState/playerState/DropState"
require "game/roleState/playerState/DoubleJumpState"
require "game/roleState/playerState/DoubleDropState"
require "game/roleState/playerState/AttackState"
require "game/roleState/playerState/GroundAttackState"
require "game/roleState/playerState/AirAttackState"
require "game/roleState/playerState/DefendState"
require "game/roleState/playerState/DiveState"
require "game/roleState/playerState/FallOverState"
require "game/roleState/playerState/BlockState"
require "game/roleState/playerState/HangingBlockState"
require "game/roleState/playerState/BouncingState"
require "game/roleState/playerState/JumpTopState"
require "game/roleState/playerState/DeadState"
require "game/roleState/playerState/SprintState"
require "game/roleState/playerState/UnstopableState"  --无敌状态 公共状态
require "game/roleState/playerState/FailedState"
require "game/roleState/playerState/WallClimbState"
require "game/roleState/playerState/IdleState"
require "game/roleState/playerState/VictoryState"
require "game/roleState/playerState/ChobeFollowState"
require "game/roleState/playerState/CNMMountState"
require "game/roleState/playerState/UFOMountState"
require "game/roleState/playerState/ElectricBallState"   -- 电力球状态 公共状态
require "game/roleState/playerState/InvincibleState"   -- 真无敌状态 公共状态
require "game/roleState/playerState/CantAttackState"   -- 无法攻击 公共状态
require "game/roleState/playerState/CantDiveState"   -- 无法滑翔 公共状态
require "game/roleState/playerState/CantJumpState"   -- 无法跳跃 公共状态
require "game/roleState/playerState/CantSkillState"   -- 无法放技能 公共状态
require "game/roleState/playerState/ConfusionState"   -- 混乱状态 跳跃攻击反向 公共状态
require "game/roleState/playerState/ChangeBigState"  --变大状态 公共状态
require "game/roleState/playerState/StealthState"  --潜行状态 公共状态
require "game/roleState/playerState/MagnetState"  --磁铁状态 公共状态
require "game/roleState/playerState/ThroughoutMagentState"  --全程磁铁状态 公共状态
require "game/roleState/playerState/AntiMagnetState"  --无法收集道具 公共状态
require "game/roleState/playerState/CureState"  --恢复体力 公共状态
require "game/roleState/playerState/CoinWaveState"  --金币冲击波 公共状态
require "game/roleState/playerState/CoinChangeFromPetState"  --(宠物效果改变金币  奎特，独眼怪，索尼克等) 公共状态
require "game/roleState/playerState/ChobeThrowingThingsForRoleState"  --丘比抛洒物品 人调用 公共状态
require "game/roleState/playerState/TurnAroundState" --转身 公共状态
require "game/roleState/playerState/OnRhubarbDuckSprintState" --大黄鸭冲刺单独状态
require "game/roleState/playerState/FinalSpurtState" --大黄鸭结算状态
require "game/roleState/playerState/StopState"
require "game/roleState/playerState/EndlessRunningOutState"
require "game/roleState/playerState/HolyState"
require "game/roleState/playerState/FlyATKBlockState"
require "game/roleState/playerState/SkillCDState"
require "game/roleState/playerState/AtkCDState"
require "game/roleState/playerState/SuitState"
require "game/roleState/playerState/PlayerHideState" --隐藏主角非共享状态
require "game/roleState/playerState/PathFindingState" --自动寻路共享状态
require "game/roleState/playerState/CleanMonsterState" --清屏共享状态
require "game/roleState/playerState/HolyDropState" --神圣模式掉落状态
require "game/roleState/playerState/BouncingDropState" --弹簧掉落状态
require "game/roleState/playerState/PlayingSkillState" --释放技能中共享状态
require "game/roleState/playerState/CheckBattleItemState" --检查战斗使用道具共享状态
require "game/roleState/playerState/DisposableInvincibleState" --一次性护盾状态
require "game/roleState/playerState/DeathSprintState" --死亡冲刺
require "game/roleState/playerState/MidasTouchState" --跳跃产生金币
require "game/roleState/playerState/MonsterIntoCoinState" --怪物变成金币组
require "game/roleState/playerState/ItemChangeCloverState" --道具变成四叶草
require "game/roleState/playerState/JumpReduceSkillCd" --跳跃减少技能CD

require "game/roleState/enemyState/BaseEnemyState"
require "game/roleState/enemyState/EnemyAtkState"
require "game/roleState/enemyState/EnemyDefState"
require "game/roleState/enemyState/EnemyIdleState"
require "game/roleState/enemyState/FlightEnemyAtkState"
require "game/roleState/enemyState/FlightEnemyIdleState"
require "game/roleState/enemyState/FlightEnemyFlyState"
require "game/roleState/enemyState/FlightEnemyDefState"
require "game/roleState/enemyState/SpringEnemyDropState"
require "game/roleState/enemyState/SpringEnemySpringState"
require "game/roleState/enemyState/SpringEnemyDefState"
require "game/roleState/enemyState/SumoFrogEnemyIdleState"
require "game/roleState/enemyState/SumoFrogEnemyAtkState"
require "game/roleState/enemyState/SumoFrogEnemyDefState"
require "game/roleState/enemyState/BowserEnemyIdleState"
require "game/roleState/enemyState/BowserEnemyAtkState"
require "game/roleState/enemyState/BowserEnemyDefState"
require "game/roleState/enemyState/LittleDropEnemyIdleState"
require "game/roleState/enemyState/LittleDropEnemyAtkState"
require "game/roleState/enemyState/LittleDropEnemyDefState"
require "game/roleState/enemyState/MadRabbitEnemyIdleState"
require "game/roleState/enemyState/MadRabbitEnemyAtkState"
require "game/roleState/enemyState/MadRabbitEnemyDefState"
require "game/roleState/enemyState/DrunkRatEnemyIdleState"
require "game/roleState/enemyState/DrunkRatEnemyAtkState"
require "game/roleState/enemyState/DrunkRatEnemyDefState"
require "game/roleState/enemyState/KoffingEnemyIdleState"
require "game/roleState/enemyState/KoffingEnemyAtkState"
require "game/roleState/enemyState/KoffingEnemyDefState"
require "game/roleState/enemyState/SpiritPaEnemyIdleState"
require "game/roleState/enemyState/SpiritPaEnemyAtkState"
require "game/roleState/enemyState/SpiritPaEnemyDefState"
require "game/roleState/enemyState/LickFlowerEnemyIdleState"
require "game/roleState/enemyState/LickFlowerEnemyAtkState"
require "game/roleState/enemyState/LickFlowerVariationEnemyAtkState"
require "game/roleState/enemyState/LickFlowerEnemyDefState"
require "game/roleState/enemyState/SlideMoleEnemyIdleState"
require "game/roleState/enemyState/SlideMoleEnemyAtkState"
require "game/roleState/enemyState/SlideMoleEnemyDefState"
require "game/roleState/enemyState/SlideMoleEnemyStandState"
require "game/roleState/enemyState/ChasedBirdEnemyIdleState"
require "game/roleState/enemyState/ChasedBirdEnemyAtkState"
require "game/roleState/enemyState/ChasedBirdEnemyDefState"
require "game/roleState/enemyState/NinjaPigEnemyIdleState"
require "game/roleState/enemyState/NinjaPigEnemyAtkState"
require "game/roleState/enemyState/NinjaPigEnemyDefState"
require "game/roleState/enemyState/NinjaBeautyEnemyIdleState"
require "game/roleState/enemyState/NinjaBeautyEnemyAtkState"
require "game/roleState/enemyState/NormalBirdEnemyIdleState"
require "game/roleState/enemyState/NormalBirdEnemyAtkState"
require "game/roleState/enemyState/NormalBirdEnemyDefState"


require "game/roleState/petState/BasePetState"
require "game/roleState/petState/PetIdleState"
require "game/roleState/petState/PetRescueState"
require "game/roleState/petState/PetEscortState"
require "game/roleState/petState/ChobeRescueState"
require "game/roleState/petState/XiaokeRescueState"
require "game/roleState/petState/NemoRescueState"


require "game/roleState/petState/AliThrowingBottlesState"
require "game/roleState/petState/ChinchillasDropState"
require "game/roleState/petState/ChinchillasDownState"
require "game/roleState/petState/ChinchillasBlastState"
require "game/roleState/petState/ChobeThrowingThingsState"
require "game/roleState/petState/ElizabethRaisingState"
require "game/roleState/petState/LittleBearGivingState"
require "game/roleState/petState/MeowsThrowingCoinsState"
require "game/roleState/petState/PsyduckThrowingItemState"
require "game/roleState/petState/HamtaroThrowingItemsState"  -- 哈姆太郎扔东西
require "game/roleState/petState/ChipDaleThrowingItemState"  -- 松鼠扔东西
require "game/roleState/petState/PikachuGiveBuffState"  -- 皮卡丘给电力球
require "game/roleState/petState/PikachuCaptainState" --皮卡丘队长技能
require "game/roleState/petState/HabiCaptainState"	--哈比队长技能
require "game/roleState/petState/XiaokeCaptainState"	--小可队长技能
require "game/roleState/petState/PsyduckCaptainState"	--可达鸭队长技能
require "game/roleState/petState/LhgCaptainState"	--魉皇鬼队长技能
require "game/roleState/petState/CatTeacherCaptainState"	--猫老师队长技能
require "game/roleState/petState/SuperChinchillasCaptainState"	--超级村长队长技能

require "game/roleState/SuitState/ChopperSuitState"
require "game/roleState/SuitState/LionEarSuitState"
require "game/roleState/SuitState/TeemoSuitState"
require "game/roleState/SuitState/FortuneCatSuitState"

require "game/roleState/MountState/BaseMountState"
require "game/roleState/MountState/GMHorseMountState"
require "game/roleState/MountState/GMHorseMountColorState"
require "game/roleState/MountState/RainbowCatMountState"
require "game/roleState/MountState/RhubarbDuckMountState"
require "game/roleState/MountState/SadaharuMountState"

require "game/roleState/itemState/StaminaBottleState"
require "game/roleState/itemState/UnsolvedTreasureBoxExplodeState"
require "game/roleState/itemState/BoxExplodeState"
require "game/roleState/itemState/CoinTailState"
require "game/roleState/itemState/ChangeBigBottleState"
require "game/roleState/itemState/CrackWallIsDestroyState"
require "game/roleState/itemState/CrackWallIstDestroyState"
require "game/roleState/itemState/BigAppleItemIsDestroyState"
require "game/roleState/itemState/BigAppleItemIstDestroyState"
require "game/roleState/itemState/PokeballItemState"
require "game/roleState/itemState/CantJumpItemState"
require "game/roleState/itemState/CantAttackItemState"
require "game/roleState/itemState/CantSkillItemState"
require "game/roleState/itemState/ConfusionItemState"
require "game/roleState/itemState/CoinWaveItemState"
require "game/roleState/itemState/guide/JumpGuideItemState"
require "game/roleState/itemState/guide/petSkillGuideitemState"
require "game/roleState/itemState/guide/AttackGuideItemState"
require "game/roleState/itemState/guide/JumpDoubleGuideItemState"
require "game/roleState/itemState/guide/DiveGuideItemState"
require "game/roleState/itemState/guide/GetStaminaGuideItemState"
require "game/roleState/itemState/guide/HangingGuideItemState"
require "game/roleState/itemState/guide/HangingGuideEndItemState"
require "game/roleState/itemState/guide/StaminaGuideItemState"
require "game/roleState/itemState/guide/StaminaGuideItemEndState"
require "game/roleState/itemState/ItemFlowState"
require "game/roleState/itemState/ItemTrowState"
require "game/roleState/itemState/CoinRainState"

require "game/roleState/CameraState/CameraStateMachine"
require "game/roleState/CameraState/BaseCameraState"
require "game/roleState/CameraState/CameraNormalState"
require "game/roleState/CameraState/CameraWallClimbState"
require "game/roleState/CameraState/CameraCheckState"
require "game/roleState/CameraState/CameraAutoFixState"
require "game/roleState/CameraState/CameraFollowState"
require "game/roleState/CameraState/CameraYFixState"
require "game/roleState/CameraState/CameraStayState"
require "game/roleState/CameraState/CameraYResetState"
require "game/roleState/CameraState/CameraZResetState"
require "game/roleState/CameraState/CameraFixState"
require "game/roleState/CameraState/CameraZDropState"
require "game/roleState/CameraState/CameraZBackState"
require "game/roleState/CameraState/CameraZForwardState"

require "game/roleState/hangingState/HangingStateMachine"
require "game/roleState/hangingState/HangingNormalState"
require "game/roleState/hangingState/HangingCheckState"
require "game/roleState/hangingState/HangingOnProgressState"
require "game/roleState/hangingState/HangingOnGroundState"
require "game/roleState/hangingState/HangingVoidState"
require "game/roleState/hangingState/HangingLeaveState"









