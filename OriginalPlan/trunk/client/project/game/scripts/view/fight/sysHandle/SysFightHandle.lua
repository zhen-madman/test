local SysFightHandle = class("SysFightHandle")

function SysFightHandle:ctor(fightInfo)
	self.fightInfo = fightInfo
	self._equipList = {}

	self._technologyList = {}
	self._technologyList[FightCommon.mate] = {}
	self._technologyList[FightCommon.enemy] = {}
	-- self:_initMateEquipList()
end

function SysFightHandle:start()
end

function SysFightHandle:canUseSkill()
	return FightCfg:canUseSkill(self.fightInfo.fightType)
end

local Default_Tactic_Attr = {0,0,0,0,0,0,0,0}
--获取双方战略属性
function SysFightHandle:getTacticAttr(team)
	return Default_Tactic_Attr,Default_Tactic_Attr
end

function SysFightHandle:toTacticArray(info)
	return {info.tank_atk or 0,info.tank_def or 0,info.tank_life or 0
			,info.fly_atk or 0,info.fly_def or 0,info.fly_life or 0
			,info.soldier_atk or 0,info.soldier_def or 0,info.soldier_life or 0
			,info.panzer_atk or 0,info.panzer_def or 0,info.panzer_life or 0
			}
end

function SysFightHandle:_getEnemyTacticAttr()
	return Default_Tactic_Attr
end

function SysFightHandle:_initMateEquipList()
	local list = {}
	for arm=1,4 do
		local value = 0
		for pos = 1,6 do
			local equip = HeroModel:getEquip(arm, pos)
			if equip then
				value = value + equip.slev* (FightCfg.qualityList[equip.cfg.quality] or 0)
			end
		end
		list[arm] = value
	end
	self._equipList[FightCommon.mate] = list
end

function SysFightHandle:getEquipLevel(team)
	return self._equipList[team]
end

--获取军阶差
function SysFightHandle:getPowerVipSub()
	return 0
end

function SysFightHandle:getMaxPopulace()
	local populace = FightCfg:getMaxPopulation(self.fightInfo.fightType) or FightCommon.MAX_POPULACE
	local p2
	if self.monsterProduct then
		local autoCfg = DungeonCfg:getRefreshMonster(self.monsterProduct)
		p2 = autoCfg.populace
	else
		p2 = FightCommon.MAX_POPULACE
	end
	return populace,p2
end

function SysFightHandle:getGuildFightTechnology(team,key)
	local teamTechnology = self._technologyList[team]
	if not teamTechnology[key] then
		teamTechnology[key] = self:_getTechnology(team,key)
	end
	return teamTechnology[key]
end

function SysFightHandle:_getTechnology(team,key)
	if team == FightCommon.mate then
		return 100
	else
		return 0
	end
end

function SysFightHandle:getFightTime()
	return FightCfg:getFightTime(self.fightInfo.fightType)
end

function SysFightHandle:getSceneId()
	local autoCfg = DungeonCfg:getRefreshMonster(self.monsterProduct)
	return autoCfg.sceneId
end

function SysFightHandle:getPlayerSkill()
	local leader = nil
	if leader then
		return leader:getSkillInfo()
	else
		return nil
	end
	-- return SkillCfg.PLAYER_SKILL+1,BuildingModel:getBaseLevel()
end

function SysFightHandle:getFightHeroList()
	if not self._fightHeroList then
		self._fightHeroList,self._stockList = TacticModel:getFightHeroList(self.fightInfo.fightType)
		for i,hero in ipairs(self._fightHeroList) do
			hero:updateAttr(true)
		end
	end
	return self._fightHeroList,self._stockList
end

function SysFightHandle:getHeroResList()
	local resList = {}
	local team = {}
	local hList = self:getFightHeroList()
	for i,info in ipairs(hList) do
		if i > 6 then
			break
		end
		resList[i] = hList[i]
		team[i] = FightCommon.mate
	end

	local mList = self:_getMonsterResList(self.monsterProduct)
	for i,mInfo in ipairs(mList) do
		if i > 6 then
			break
		end
		resList[#resList+1] = mInfo
		team[#team+1] = FightCommon.enemy
	end
	return resList,team
end

function SysFightHandle:_getMonsterResList(monsterProduct)
	if monsterProduct then
		local monsterMap = {}
		local function mergeResList(monsterList)
			if monsterList then
				for i,mInfo in ipairs(monsterList) do
					monsterMap[mInfo[1]] = true
				end
			end
		end
		local resList = {}
		local autoCfg = DungeonCfg:getRefreshMonster(monsterProduct)
		mergeResList(autoCfg.initMate)
		mergeResList(autoCfg.initMonster)

		local resList = {}
		for mId,_ in pairs(monsterMap) do
			local mInfo = MonsterCfg:getMonster(mId)
			resList[#resList+1] = mInfo
		end
		return resList
	else
		return {}
	end
end

function SysFightHandle:startCheckFightEndDelegate(checkCfg)
	local CheckFightEndDelegate = game_require("view.fight.delegate.CheckFightEndDelegate")
	local checkFightEnd = CheckFightEndDelegate.new()
	checkFightEnd:start(checkCfg)
end

function SysFightHandle:startRefreshMonsterDelegate(monsterProduct,dieList)
	local cfg = DungeonCfg:getRefreshMonster(monsterProduct)
	local RefreshMonsterDelegate = game_require("view.fight.delegate.RefreshMonsterDelegate")
	self.refreshMonster = RefreshMonsterDelegate.new()
	--self.refreshMonster:setDieList(dieList)
	self.refreshMonster:start(cfg,1500,not FightDirector:isNetFight())
end

function SysFightHandle:getRefreshMonsterDelegate()
	return self.refreshMonster
end

function SysFightHandle:starCheckStarDelegate(starRequest)
	if starRequest then
		local CheckStarDelegate = game_require("view.fight.delegate.CheckStarDelegate")
		self.starCheck = CheckStarDelegate.new()
		self.starCheck:start(starRequest)
	end
end

function SysFightHandle:getStar()
	if self.starCheck then
		return self.starCheck:getStar()
	else
		return {1,1,1}
	end
end

function SysFightHandle:reqFightBegin(callback)
	self.callback = callback
	NotifyCenter:addEventListener(Notify.NET_FIGHT_BEGIN,{self,self._resFightBegin})
end

function SysFightHandle:_resFightBegin(event)
	if event.fightType == self.fightInfo.fightType or event.fightType == self._fightType then
		NotifyCenter:removeEventListener(Notify.NET_FIGHT_BEGIN,{self,self._resFightBegin})
		if event.msg.result == 0 then
			self:fightBeginNetMsgHandle(event)
			self.callback()
		else
			self:fightBeginNetErrorHandle(event.msg.result)
		end
	end
end

function SysFightHandle:fightBeginNetMsgHandle(event)
end

function SysFightHandle:fightBeginNetErrorHandle(result)
	ViewMgr:close(Panel.FIGHT)
end

--主动退出战斗
function SysFightHandle:exitFight()

end

function SysFightHandle:fightEnd(isWin)
	self._loadingTimer = scheduler.performWithDelayGlobal(function()
			self._loadingTimer = nil
			LoadingControl:show("fightEndMsg",true)
			LoadingControl:setText("获取战斗结果")
		end, 3)
	NotifyCenter:addEventListener(Notify.NET_FIGHT_END, {self,self._resFightEnd})
end

function SysFightHandle:_resFightEnd(event)
	self:_removeLoading()
	if not self.fightInfo or (event.fightType ~= self.fightInfo.fightType and event.fightType ~= self._fightType ) then
		return
	end
	NotifyCenter:removeEventListener(Notify.NET_FIGHT_END, {self,self._resFightEnd})
	if event.msg.result == 0 then  --结果正常  没作弊
		if event.win then
			FightModel:setWin()
		else
			FightModel:setFail()
		end
		self:fightEndNetMsgHandle(event)
	else
		if ViewMgr:isOpen(Panel.FIGHT) then
			local btnInfos = {{text="确定", obj=self, callfun=self._onError, param=nil}}
			openTipPanel("战斗结果异常！"..event.msg.result,btnInfos)
		end
	end
end

function SysFightHandle:fightEndNetMsgHandle(event)
	self:_openResultPanel(event.win,event)
end

function SysFightHandle:_openResultPanel(isWinPanel,params)
	FightEngine:pause()
	params.fightData = HurtHandler:getHurtData()
	params.enemyLeader = self.enemyLeader
	params.enemyLeaderCfg = self.enemyLeaderCfg  --敌人将领
	params.enemyScore = self.enemyScore  --敌人评分
	params.enemyRole = self.enemyRole
	params.isWin = isWinPanel
	ViewMgr:open(Panel.FIGHT_RESULT,params)
	scheduler.performWithDelayGlobal( function() FightDirector:stop() end, 1)
	scheduler.performWithDelayGlobal(function()
		ParticleMgr:AllReRegisterParticle()
		end, 3)

	scheduler.performWithDelayGlobal(function()
		FightCache:releaseAllAnima()
		end, 5)
end

function SysFightHandle:_onError()
	ViewMgr:close(Panel.FIGHT)
end

function SysFightHandle:_removeLoading()
	if self._loadingTimer then
		scheduler.unscheduleGlobal(self._loadingTimer)
		self._loadingTimer = nil
	end
	LoadingControl:stopShow("fightEndMsg")
end

function SysFightHandle:dispose()
	self:_removeLoading()
	self.fightInfo = nil
	NotifyCenter:removeEventListener(Notify.NET_FIGHT_END, {self,self._resFightEnd})
	NotifyCenter:removeEventListener(Notify.NET_FIGHT_BEGIN,{self,self._resFightBegin})
end

return SysFightHandle