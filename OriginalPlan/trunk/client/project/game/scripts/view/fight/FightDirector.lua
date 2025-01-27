--
--
local FightDirector = class("FightDirector")

FightCommon =  game_require("view.fight.FightCommon")  --一些产量

game_require("view.fight.FightEngine")  --单例

AIMgr = game_require("view.fight.ai.AIMgr") --单例
FightTrigger = game_require("view.fight.FightTrigger")  --触发器
FightCache = game_require("view.fight.FightCache")
--Formula = game_require("view.fight.formula.Formula")
FightNet = game_require("view.fight.net.FightNet")
HurtHandler = game_require("view.fight.formula.HurtHandler")
FightPlayer = game_require("view.fight.FightPlayer")
FightAudio = game_require("view.fight.FightAudio")

local camera = game_require("view.fight.FightCamera")  --单例
local NewHandle = game_require("view.fight.handle.NewHandle")

-- local CraterHandle = game_require("view.fight.handle.CraterHandle")

local SysHandleCreate = game_require("view.fight.sysHandle.SysHandleCreate")

function FightDirector:ctor()
	--self:init(info)
	self.status = FightCommon.stop

	self.sceneTouchEnable = false
	self.creatureTouchEnable = true

	self.maxPopulace = {}
	self._isShowMagic = true
	-- CraterHandle:init()
	self.curFightArea =-1

end

function FightDirector:setFightArea( area )
	self.curFightArea = area
end

function FightDirector:getFightArea()
	return self.curFightArea
end

function FightDirector:setMode(fMode)
	self.fightMode = fMode
end

function FightDirector:init( scene,fightInfo )
	self.sceneTouchEnable = false
	self.creatureTouchEnable = true

	self.fightInfo = fightInfo

	self.fightMode = FightCommon.FIGHT_MODE

	self.playerList = {}
	self.playerList[FightCommon.mate] = FightPlayer.new(FightCommon.mate)
	self.playerList[FightCommon.enemy] = FightPlayer.new(FightCommon.enemy)

	self.populaceList = {0,0,0}

	FightAudio:init()

	NewHandle:init()

	self.fightType = fightInfo.fightType

	if self.sysHandle then
		self.sysHandle:dispose()
	end

	self.sysHandle = SysHandleCreate:createSysHandle(fightInfo)
	self.sysHandle:start()
	fightInfo.sceneId = self.sysHandle:getSceneId()

	self.maxPopulace = {}
	local maxP1,maxP2 = self.sysHandle:getMaxPopulace()
	self.maxPopulace[FightCommon.mate] = maxP1
	self.maxPopulace[FightCommon.enemy] = maxP2

	self.scene = scene
	--self:setShowMagic(false)
end

function FightDirector:setStatus(status)
	self.status = status
end

--战斗准备
function FightDirector:prepare(scene,fightType)
	--self.performer = FightPerformer.new()
	--self.performer:init()
	self.status = FightCommon.prepare  --战斗准备

	camera:start(self.scene)
	FightEngine:addCamera(camera)
	FightEngine:addScene(self.scene)
	FightEngine:start()
	AIMgr:start()
end

--英雄进场
function FightDirector:enterScene()
	self.status = FightCommon.enter  --战斗准备
end

function FightDirector:start(info)
	self.creatureTouchEnable = true
	self.status = FightCommon.start  --战斗开始
	-- AIMgr:sortAI()
	FightEngine:resetCurTime()
	self.scene:start()

	self.playerList[FightCommon.mate]:start()
	self.playerList[FightCommon.enemy]:start()

	HurtHandler:init()
	self.curFightArea =FightCfg.ECHELON_AREA_1
	FightTrigger:dispatchEvent({name=FightTrigger.FIGHT_START})
end

function FightDirector:pause()  --暂停
	self.status = FightCommon.pause
	FightEngine:pause()
end

function FightDirector:resume() --继续
	self.status = FightCommon.start
	FightEngine:resume()
end

function FightDirector:setShowMagic(show)
	self._isShowMagic = show
end

function FightDirector:isShowMagic()
	return self._isShowMagic
end

function FightDirector:isNetFight()
	return self.fightInfo.isNet
end

function FightDirector:touchEnabled(flag)
	self.sceneTouchEnable = flag
	self.creatureTouchEnable = flag
end

--设置场景能否触摸
function FightDirector:setSceneTouchEnable(flag)
	self.sceneTouchEnable = flag
end

--场景是否能触摸
function FightDirector:getSceneTouchEnable()
	return self.sceneTouchEnable
end

function FightDirector:setCreatureTouchEnable(flag)
	self.creatureTouchEnable = flag
end

function FightDirector:getCreatureTouchEnable()
	return self.creatureTouchEnable
end

function FightDirector:addPopulace(team,cInfo)
	local populace = 0
	if cInfo.heroNum then
		populace = (cInfo.populace/cInfo.heroNum)
	else
		populace = cInfo.populace
	end
	self.populaceList[team] = self.populaceList[team] + populace
	FightTrigger:dispatchEvent({name=FightTrigger.POPULACE_CHANGE,team = team,populace = populace})
end

function FightDirector:reducePopulace(team,cInfo)
	local populace = 0
	if cInfo.heroNum then
		populace = (cInfo.populace/cInfo.heroNum)
	else
		populace = cInfo.populace
	end
	self.populaceList[team] = self.populaceList[team] - populace
	self.populaceList[team] = math.max(0,self.populaceList[team])
	FightTrigger:dispatchEvent({name=FightTrigger.POPULACE_CHANGE,team = team , populace = -populace})
end

function FightDirector:resetPopulace()
	self.populaceList = {0,0,0}
	FightTrigger:dispatchEvent({name=FightTrigger.POPULACE_CHANGE,team = FightCommon.mate})
end

function FightDirector:getPopulace(team)
	return self.populaceList[team]
end

function FightDirector:getRemainPopulace(team)
	return self:getMaxPopulace(team) - self.populaceList[team]
end

function FightDirector:getMaxPopulace(team)
	return 5000;--self.maxPopulace[team]
end

function FightDirector:setMaxPopulace(team,populace)
	self.maxPopulace[team] = populace
end

function FightDirector:getSysHandle()
	return self.sysHandle
end

function FightDirector:getScene()
	return self.scene
end

function FightDirector:getMap()
	return self.scene.map
end

function FightDirector:getAir()
	return self.scene.air
end

function FightDirector:getCamera()
	return camera
end

function FightDirector:getPlayer( team )
	return self.playerList[team]
end

function FightDirector:getPlayerByCreature( creature )
	return self.playerList[creature.cInfo.team]
end

function FightDirector:stop()
	self.sysHandle:dispose()
	self.sysHandle = nil

	self.status = FightCommon.stop
	for i,player in ipairs(self.playerList) do
		player:dispose()
	end
	self.playerList = {}

	FightEngine:stop()
	self.scene:clear()
	AIMgr:clear()
	self.scene = nil
	camera:stop()
	FightCache:releaseAll()

	-- CraterHandle:clear()

	FightAudio:clear()

	self.fightInfo = nil
end

function FightDirector:setIntervalRate(rate)
	FightEngine:setIntervalRate(rate)
end

function FightDirector:fightOver(isMateWin,isSlowRate,isTimeOut)
	self.status = FightCommon.over
	self.curFightArea =-1
	FightEngine:fightOver()
	local reward = {}
	-- if reward and reward.coin and isMateWin then
	-- 	ViewMgr:getPanel(Panel.FIGHT).ui.title:setCoin(reward.coin)
	-- end

	FightTrigger:dispatchEvent({name = FightTrigger.RESULT,isWin = isMateWin,isTimeOut = isTimeOut, isSlowRate = isSlowRate})
end

--添加策略属性
function FightDirector:addTacticAttr(info)
	-- local mateAttr,enemyAttr = self.sysHandle:getTacticAttr()
	-- local attrList = (info.team == FightCommon.mate and mateAttr) or enemyAttr
	-- local startIndex = (info.arm-1)*2
	-- local attrNameList = {{HeroConst.MAINY_ATK,HeroConst.MINOR_ATK},{HeroConst.HP,HeroConst.MAXHP}}
	-- for i=1,2 do
	-- 	local value = attrList[i+startIndex]
	-- 	local attrName = attrNameList[i]
	-- 	for _,name in ipairs(attrName) do
	-- 		if info[name] then
	-- 			-- print("--加属性啊。。。。",name,value)
	-- 			info[name] = info[name] + value
	-- 		end
	-- 	end
	-- end

	local sub = self.sysHandle:getPowerVipSub()  --获取军阶 差
	if sub ~= 0 then
		local arrList = {HeroConst.MAINY_ATK,HeroConst.MINOR_ATK}
		if sub > 0 and info.team == FightCommon.mate then
			for _,name in ipairs(arrList) do
				if info[name] then
					info[name] = info[name] + info[name]*0.05
				end
			end
		elseif sub < 0 and info.team == FightCommon.enemy then
			for _,name in ipairs(arrList) do
				if info[name] then
					info[name] = info[name] + info[name]*0.05
				end
			end
		end
	end
end

function FightDirector:getTeamEquipLevel(team,arm)
	-- local equipList = self.sysHandle:getEquipLevel(team)
	-- if equipList then
	-- 	return equipList[arm] or 0
	-- else
		return 0
	-- end
end

return FightDirector:new()
