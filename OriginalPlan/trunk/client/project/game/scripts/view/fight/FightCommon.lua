--
--

--静态常量
local FightCommon = {}

FightCommon.intervalTime = 30 -- engine run 间隔速度  毫秒

FightCommon.animationDefaultTime = math.floor(1000/12)   --动画播放帧  时间 毫秒

FightCommon.MAX_POPULACE = 30

FightCommon.mate = FightCfg.left   --同队的
FightCommon.enemy = FightCfg.right   --敌人
FightCommon.all = 2   --全部

FightCommon.left = 1
FightCommon.right = 2


FightCommon.red = FightCommon.enemy
FightCommon.blue = FightCommon.mate


FightCommon.win = 1
FightCommon.fail = 2


FightCommon.prepare = 1  --战斗准备
FightCommon.enter = 2
FightCommon.start = 3 --战斗开始
FightCommon.pause = 4 --暂停
FightCommon.over = 5--战斗出结果
FightCommon.stop = 6 --战斗完结 清除战斗信息


FightCommon.TOTAL_TIME = 90000   --战斗总时间90秒


FightCommon.FIGHT_MODE = 0  --战斗
FightCommon.FILM_MODE = 1  --电影


FightCommon.dodge = "dodge"  --闪避
FightCommon.hit = "hit"  --命中
FightCommon.critical = "critical" --暴击
FightCommon.breakOff = "breakOff" --打断
FightCommon.parry = "parry"  --格挡
FightCommon.rebound = "rebound"  --反弹


----------------战斗内部一些消息事件--通过FightTrigger发出--------------------------
FightCommon.CREATURE_DIE = "c_d" --有玩家死亡
FightCommon.RUN_END = "run_end"  --run 结束了

return FightCommon