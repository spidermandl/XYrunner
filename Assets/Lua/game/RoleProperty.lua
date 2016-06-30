RoleProperty = {}
	
RoleProperty.index = 0
RoleProperty.level = 0							  	-- 角色等级
RoleProperty.maxHP = 0.0                           	-- 角色血量
RoleProperty.hp = 0.0							  	-- 角色当前血量
RoleProperty.jumpHeight = 0.0                    	-- 角色跳跃高度
RoleProperty.attack = 1                             -- 角色攻击力
RoleProperty.jumpAllow = 2                        	-- 角色最大跳跃次数
RoleProperty.jumpTime = 0                         	-- 角色当前跳跃次数
RoleProperty.leftDistance = 10                      -- 角色左侧距离怪的距离
RoleProperty.rightDistance = 20                     -- 角色右侧距离怪的距离
-----------------------------------角色动作配置参数-----------------------------------------------------------
RoleProperty.jumpACC = 54.0               		  	-- 角色跳跃加速度
RoleProperty.transionSpeed = 2.0                      --顶部动画切换速度
RoleProperty.moveSpeed = 8.0                        -- 角色水平移动速度
RoleProperty.flyAtkSpeed = 4.0                      --空中攻击速度
RoleProperty.airAtkMaxTime = 2 					 	--空中攻击最大次数
RoleProperty.jumpSpeed = 20.0                        --角色起跳初始速度
RoleProperty.doubleJumpSpeed = 15                  --多段跳起跳初始速度  RoleProperty.jumpSpeed/pow(2,0.5)
RoleProperty.dropACC = 50.0                         -- 角色下降加速度
RoleProperty.dropSpeed = 0.0						--角色掉落初始速度
RoleProperty.diveSpeed = 1.5                        --角色滑翔速度
RoleProperty.DropBreakDistance = 7                  --角色带刹车动画最小下降高度
RoleProperty.sprintSpeed = 15.0                     --冲击速度
RoleProperty.StaminaMax = 100                       --体力上限
RoleProperty.StaminaConsumedSpeed = 5.6  			--体力消耗速度
RoleProperty.StaminaConsumedSpeedMutation = 0.05  	--体力突变的判定范围
RoleProperty.hangingSpeed = 2                       --吸墙向下滑速度
RoleProperty.hangingRigidTime = 0.3                 --吸墙停顿时间
------------------------------------------------------------------------------------------------------------
RoleProperty.moveDir = nil                          -- 角色移动三维向量(速度向量)
RoleProperty.invTime = 0.0					   		-- 无敌时间
RoleProperty.mHeight = 0.0							-- 角色身高
RoleProperty.mBMR = 0.0				  		  	    -- 角色体力每秒消耗
RoleProperty.mBMRPow = 0.0						  	-- 角色体力每秒消耗倍率
RoleProperty.mMaxSP = 0.0						  	-- 角色蓝
RoleProperty.mSP = 0.0							  	-- 角色当前蓝
RoleProperty.mCurrentSkill = 0					 	-- 角色当前装备技能
RoleProperty.mWeaponBone = ''					    -- 角色握武器骨骼点
RoleProperty.mSpawnCount = 0 						-- 掉坑次数
RoleProperty.DamageTimes = 0                        -- 伤害次数

RoleProperty.mGoldPow = 0.0  						--增加金币得分
RoleProperty.mScorePow = 0.0 					 	--增加内裤得分
RoleProperty.addMaxHp = 0.0 						--开局体力增加
RoleProperty.physicalExertionReduce = 0.0   		--体力消耗减少%
RoleProperty.fallDamageReduce = 0.0 				--掉坑伤害减少%
RoleProperty.underAttackDamageReduce = 0.0			--被攻击伤害减少%
RoleProperty.avoidFallDamageTimes = 0 				--掉坑免伤次数
RoleProperty.avoidDamageTimes = 0 				    --免疫受伤害次数
RoleProperty.avoidDeathTimes = 0 	 				--免疫死亡次数
RoleProperty.revivalTimes = 0 						--复活次数
RoleProperty.hpLostByTime = 0.75                    --默认掉每秒掉体力数
RoleProperty.SprintCDTime = 3.0                     --丛刺cd时间
RoleProperty.SprintStateTime = 2                    --冲刺时间
RoleProperty.InvincibleTime = 3                     --真无敌时间
RoleProperty.AntiMagnetTime = 3 					--无法收集道具BUFF时间
RoleProperty.MagnetStateTime = 2.5                  --磁铁状态时间
RoleProperty.ChangeBigTime = 3                      --变大时间
RoleProperty.StaminaAdd = 25                        --恢复体力量
RoleProperty.EnlargeScale = 1.5                     --角色变大比率
RoleProperty.RhubarbDuchFlySpeed = 25               --大黄鸭X轴和Y轴飞行速度
RoleProperty.RhubarbDuckJumpSpeed = 60 				--大黄鸭Z轴飞行速度
RoleProperty.RhubarbDuckFlyTime = 4                 --大黄鸭飞行时间
RoleProperty.RhubardDuchDistance = 10 				--大黄鸭起飞距离
RoleProperty.MoveingCleanMonsterDistance = 10  		--寻路中清屏距离
RoleProperty.raycastLength = 0.1--RoleProperty.jumpACC/10                    --射线扫描地面距离
RoleProperty.holeStateSpeed = 12 					--神圣模式移动速度
RoleProperty.HolyDuringTime = 20 					--神圣模式时间
RoleProperty.ThroughoutMagentDistance = 1.5 			--全程磁铁范围
RoleProperty.StateBonusTime = 0 					--磁铁、变大、无敌，增益时间
RoleProperty.ATKCommboInterval = 1 --攻击连击时间间隔

RoleProperty.DefaultFlyPetId = 13001 --如果没有带飞行宠物 目前强制使用哈比作为飞行宠物

RoleProperty.unlimitedHP = false --无限体力
RoleProperty.test = true --开启场景测试
RoleProperty.buildingOpen = true --城建功能是否打开
RoleProperty.corePlayOnly = true --只跑核心玩法
RoleProperty.UseTestStroy = true --剧情结算使用快捷键j是否开启 
RoleProperty.isHolyOpen = true -- 神圣模式开启
RoleProperty.isNaviceOpen = false --是否开启新手引导
RoleProperty.isSDK = false --是否使用sdk
RoleProperty.isOutputLog = true -- 是否打印日志
RoleProperty.removeBgScene = false --不显示跑酷中远景
RoleProperty.isNewObjRecorded = false -- 记录核心玩法新建物体name

--[[
request result :{"code":16001,"data":"{\"charinfo\":{\"memberid\":136,\"username\":\"5bid5Zu955qE546y5YS/\",\"sex\":0,\"gold\":38850,\"diamond\":80,\"exp\":354,\"level\":1,\"cur_avator\":12001001,\"bin_avators\":[{\"id\":12003011,\"level\":0},{\"id\":12001001,\"level\":0}],\"cur_horse\":0,\"cur_pets\":[1,0,0],\"bin_pets\":[{\"id\":1,\"tid\":130010051,\"exp\":250,\"skills\":0,\"skill1\":101025,\"skill2\":101001,\"skill2_val\":10,\"skill1_lv\":1},{\"id\":2,\"tid\":130010011,\"exp\":0,\"skills\":0,\"skill1\":101025,\"skill2\":101001,\"skill2_val\":10,\"skill1_lv\":1}],\"strength\":20,\"icon\":101003,\"guide\":26,\"lott_gold\":0,\"lott_diamond\":0,\"status\":0,\"get_login_gift\":1,\"login_num\":0,\"alive_time\":0,\"alive_reward\":0,\"strength_time\":0},\"result\":1}","extra":"","memberid":0,"status":0}
request result :{"code":19015,"data":"{\"cur_horse\":0,\"cur_pets\":[1,0,0],\"bin_pets\":[{\"id\":1,\"tid\":130010051,\"exp\":250,\"skills\":0,\"skill1\":101025,\"skill2\":101001,\"skill2_val\":10,\"skill1_lv\":1},{\"id\":2,\"tid\":130010011,\"exp\":0,\"skills\":0,\"skill1\":101025,\"skill2\":101001,\"skill2_val\":10,\"skill1_lv\":1}],\"limit_num\":200,\"master_uid\":1,\"lottGoldTime\":0,\"lottDiamTime\":0}","extra":"","memberid":136,"status":0}
request result :{"code":20009,"data":"{\"bin_items\":[{\"tid\":15039000,\"num\":0,\"id\":1,\"add_num\":0}]}","extra":"","memberid":136,"status":0}
request result :{"code":20001,"data":"{\"maxnum\":100,\"unlocknum\":10,\"slotnum\":3,\"unlockslot\":1,\"buy_num\":0,\"lottGoldTime\":0,\"lottDiamTime\":0}","extra":"","memberid":136,"status":0}

]]
RoleProperty.defaultSuit = "12001001" --默认上场套装
RoleProperty.defaultPet = {130010011} --默认上场萌宠
RoleProperty.defaultMount = ""--"_mount_hb" --默认上场坐骑
RoleProperty.defaultSex = 1 --默认性别

-------------------------秦仕超添加用作宠物坐骑套装----------------------------------------------------

RoleProperty.PetSuitName="desmond" --"desmond" --"FortuneCatSuitState" --"FortuneCatSuitState"--"CatSuit"--		ChopperSuit			--套装名字
RoleProperty.PetSuitSustain=20 									--套装技能持续时间
RoleProperty.PetMountName="UFOMount"--"UFOMount"--"RhubarbDuckMount"--"RainbowCatMount"--	"GMHorseMount"--		--坐骑名字
RoleProperty.PetMountCd=6 										--坐骑技能cd时间
RoleProperty.PetFlightName = "habi" --"habi"--"xiaoke"	--"chobe"----	--飞行宠物名字
RoleProperty.PetFlightCd=8 										--飞行宠物技能cd时间
RoleProperty.PetName1=nil--"meows"--"Ali"--"Chinchillas"--			--宠物1名字
RoleProperty.Pet1Cd=5 										--宠物1技能cd时间
RoleProperty.PetName2=nil--"Chinchillas"--"Ali"--"ChinchillasColor"--"Elizabeth"	--宠物2名字
RoleProperty.Pet2Cd=5 										--宠物2技能cd时间
RoleProperty.AttackTimesMax=10 						--攻击该次数后龙猫下落
--RoleProperty.AttackTimes=10 							--攻击次数用作龙猫下落判断

RoleProperty.PetTabel = {"meows","Elizabeth","ali","psyduck","hamtaro","chipDale","habi",}                  -- 主角萌宠携带保存Tabel 胡秋翔添加  "Elizabeth","meows","Ali"

RoleProperty.ChinchillasColorPosition = nil 			--变色龙猫落地的位置，用于判断冲击波攻击范围
RoleProperty.ChinchillasSummonedByAtkTimes = 2      --连续N次攻击龙猫被召唤
RoleProperty.ChinchillasDropSpeed = 50              --龙猫掉落速度
RoleProperty.ChinchillasBlastSpeed = 30            --龙猫冲击波扩张速度
RoleProperty.ChinchillasBlastBoundary = 30          --龙猫冲击波最大距离半径
RoleProperty.PetFlightAppearCD = 8                  --飞行宠物出现cd时间

-----------------------------装备附加属性------------------------------------------------
RoleProperty.ADDHP = 0 --额外HP
RoleProperty.ADDITEMR = 0 --血瓶增益
RoleProperty.SLOWHP = 0 --延缓体力
RoleProperty.ELFSOCRE = 0 --收集额外得分
RoleProperty.ADDATKSC = 0 --击杀额外得分
RoleProperty.ADDSC = 0 --结算得分加成万分比
RoleProperty.ADDEXP = 0 --结算经验加成
RoleProperty.ADDGOLD = 0 --结算金钱加成
RoleProperty.TWOJUMPSOCRE = 0 --二段跳额外得分
RoleProperty.MOREJUMPSOCRE = 0 --多段跳额外得分
RoleProperty.SUBATKDMG = 0 --受击减伤
RoleProperty.SUBDROPDMG = 0 --掉坑免伤
RoleProperty.MISATKDMG = 0 --免疫攻击，无敌次数
RoleProperty.ADDSUCKHP = 0 --吸血每击杀以下个数怪物获得2点体力
RoleProperty.ADDSUCKTIME = 0 --磁铁时间延长
RoleProperty.ADDGODTIME = 0 --无敌延长
RoleProperty.LIGHT_PE = 0 --几率产生心
RoleProperty.TASK_PE = 0 --有几率产生额外的每日任务，几率=任务ID
RoleProperty.ENERGY = 0 --击杀怪物额外能量
RoleProperty.ENERGYJUMP = 0 --跳跃产生极限碎片
RoleProperty.DIAMOND_PE = 0 --几率钻石：几率=钻石数量
RoleProperty.ADDJUMP = 0 --跳跃次数增加
RoleProperty.MATERIAL = 0 --产出材料
RoleProperty.ATK = 0 --额外增加攻击
RoleProperty.CDDOWM = 0 --减少CD时间
RoleProperty.SPEED = 0 --增加速度
RoleProperty.NOTE = 0 --音符得分
RoleProperty.SPTINT = 0 --冲刺延长
RoleProperty.VOLPLANE = 0 --滑翔得分
RoleProperty.NEVER = 0 --负面道具
RoleProperty.JUMPTIME = 0 --CD跳跃
RoleProperty.SKILLBUFF = 0 --技能BUFFID


ConfigParam = {}

ConfigParam.FilterColliderMash = true                --去碰撞物mash
ConfigParam.CoinExplodeRadius = 4.0                   --金币爆破距离半径
ConfigParam.CoinExplodeVelocity = 8.0                 --金币吸向主角速率
ConfigParam.CameraDisVector = UnityEngine.Vector3(3.4,4.0,-11.4)   --default摄像头距离角色x \ y坐标距离
ConfigParam.CameraMoveToYSpeed = 8.0                  --摄像头y方向移动速度
ConfigParam.CameraTailingTriggerY = 6.0               --摄像头开始跟随的Y方向距离差
ConfigParam.CameraForceFixValue = 30 				  --摄像机距离玩家过远，强制修复距离
ConfigParam.EnemyDefBackwardsDis = 5.0               --敌人死亡时后退距离
ConfigParam.EnemyDieBackwardsDis = 2.5 				 --敌人受击时后退距离
ConfigParam.EnemyDefBackwardsVel = 32.0               --敌人受击后退速度
ConfigParam.UnstopableTime = 1.5                      --无敌时间(受伤后)
ConfigParam.UnstopableSwitchFrame = 3                 --无敌帧数切换
ConfigParam.StealthStateTime = 1.5                    --隐身时间
ConfigParam.isCanCollect = 0                          --能否收集物品
ConfigParam.CantCollectTime = 3                       --不能收集物品时间
ConfigParam.CantAttackTime = 3                        --无法攻击时间
ConfigParam.CantJumpTime = 3                          --无法跳跃时间
ConfigParam.CantSkillTime = 3                         --无法放技能时间
ConfigParam.ConfusionTime = 3                         --混乱 跳跃 攻击反向状态时间
ConfigParam.CoinDistance = 10                          --磁铁道具金币吸向主角距离 
ConfigParam.CoinRainTime = 8                          --金币雨持续时间
ConfigParam.CoinRainCount = 20                        --金币雨密度 （越少越多）
ConfigParam.FlightSpeed = 5                           --怪物飞行速度        
ConfigParam.dropSpeed = 20                            --弹射怪弹起最高点  
ConfigParam.springtoLeftSpeed = 12                    --弹射怪往左移动速度 
ConfigParam.isSceneObjLoadDynamic = false             --场景物体是否动态加载
ConfigParam.objectLoadByCameraDis = 30                --场景开始动态加载物体 距摄像机的距离
ConfigParam.objectDestroyByCameraDis = -30            --场景动态销毁物体 距摄像机的距离
ConfigParam.xiaoHeiAttackDistance = 4 				  --小黑攻击判定距离
ConfigParam.DrunkRatAttackInterval = 2    			  --醉酒鼠攻击间隔 (秒)
ConfigParam.DrunkRatAttackDistance = 14               --醉酒鼠攻击判定距离
ConfigParam.fireSpeed = 7                            --醉酒鼠火球飞行速度(秒)
ConfigParam.carrotSpeed = 7                           --疯兔胡萝卜飞行速度(秒)
ConfigParam.MadRabbitAttackDistance = 14              --疯兔攻击判定距离
ConfigParam.MadRabbitAttackInterval = 2  			  --疯兔攻击间隔
ConfigParam.MoleAttackDistance = 7                    --潜行鼠攻击探测范围
ConfigParam.BirdAttackDistance = 8                    --城管鸟攻击探测距离
ConfigParam.NormalBirdAttackDistance = 1   		  	  --普通城管鸟攻击探测距离
ConfigParam.NinJaChangeTime = 2                       --忍者变身时间
ConfigParam.UIbuiildingMinFov = 20                    --城建最近视距
ConfigParam.UIbuiildingMaxFov = 50                    --城建最远视距
ConfigParam.CameraZoomSpeed = 2 					  --触屏缩放摄像头速度
ConfigParam.UIbuiildingSensitivity = 6                --城建摄像头拉伸速度
ConfigParam.UIbuiildingMovSpeed = 2                   --城建拖拽速度
ConfigParam.UIbuiildingMovSize = 100                  --城建拖拽尺度 Vector(x = value ~ -value, y , z = value ~ -value)
ConfigParam.SceneOjbName = "sceneUI"                  --场景scene 
ConfigParam.ShowBuildNameTime = 1 					  --拖拽地图后多少面显示城建名字
ConfigParam.SelectChapterMinFov = 17					--剧情章节最近视距              
ConfigParam.SelectChapterMaxFov = 27				  	--剧情章节最远视距
ConfigParam.SelectLevelMinFov = 20						--剧情选关最近视距    
ConfigParam.SelectLevelMaxFov = 40						--剧情选关最近视距    
ConfigParam.HolyMapPosition = Vector3(0,80,0) 			--神圣模式地图出现位置
ConfigParam.HolyStateRolePos = Vector3(2,8,0) 			--角色出现在神圣模式地图的位置差
ConfigParam.NextEndlessRoadDistance = 60 			  --载入无尽关卡条件（下一路面与摄像机的距离）
ConfigParam.FindRevivePointDistance = Vector3(100,10,0) 		--找不到复活点时角色前进距离
ConfigParam.RebornCleanDistance = 10  					--复活、神圣结束清屏距离
----------------------------- 萌宠影响 --------
ConfigParam.XiaoKeStaminaAdd = 2        -- 小柯提人回复体力
ConfigParam.UFOMagnetDistance = 5         -- ufo磁铁效果范围
ConfigParam.probabilityOfSonic = 100 -- 索尼克的概率
ConfigParam.probabilityOfMike = 10 -- 独眼怪的概率
ConfigParam.probabilityOfKuite = 5 --  奎特的概率
ConfigParam.CoinChangeFromPetDuringTime = 4 -- (宠物效果改变金币  奎特，独眼怪，索尼克等) 持续时间
ConfigParam.ChobeThrowingThingDuringTime = 3 -- 丘比扔收集物 间隔时间
ConfigParam.LittleBearGivingTab = {"coin","diamond","iron01"} -- 结算面板小熊给的收集物（从中随机）


ConfigParam.UnsolvedTreasureReHP = 0.6                  --问号宝箱回复血量