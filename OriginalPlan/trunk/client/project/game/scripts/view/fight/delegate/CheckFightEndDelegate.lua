
local CheckFightEndDelegate = class("CheckFightEndDelegate")

local TIME_OUT = 1
local KILL_QH = 2
local KILL_PROTECT = 3
local KILL_ALL = 4
local SCORE = 10000

local FLAG_LIST = {TIME_OUT,KILL_QH,KILL_PROTECT,KILL_ALL}

function CheckFightEndDelegate:start(fightEndCfg)
	FightTrigger:addEventListener(FightTrigger.CREATURE_DIE,{self,self._onCreatureDie},-1)

	-- FightTrigger:addEventListener(FightTrigger.CHARM_CREATURE,{self,self._onCreatureCharm},-1)

	-- dump(fightEndCfg)
	-- print(debug.traceback())

	self.isOver = false
	self.isMateWin = false
	self.winNum = 0

	self.totalTime = FightDirector:getSysHandle():getFightTime()*1000

	self.winList = {}
	for i,flag in ipairs(fightEndCfg.winList or {}) do
		if flag > 10000 then
			self.winScore = flag - 10000
		else
			self.winList[flag] = true
		end
	end

	self.failList = {}
	for i,flag in ipairs(fightEndCfg.failList) do
		if flag > 10000 then
			self.failScore = flag - 10000
		else
			self.failList[flag] = true
		end
	end

	FightEngine:addFirstRun(self)
end

function CheckFightEndDelegate:run()
	if FightDirector.status == FightCommon.start then
		if FightEngine:getCurTime() >= self.totalTime then
			if self.winList[TIME_OUT] then   --time out win
				FightDirector:fightOver(true,false,true)
			elseif self.failList[TIME_OUT] then --time out fail
				FightDirector:fightOver(false,false,true)
			end
		end
	end
end


function CheckFightEndDelegate:_onCreatureDie(event)
	local creature = event.creature
	if FightDirector.status == FightCommon.start then
		self:checkFightOver(creature)
	end
end

function CheckFightEndDelegate:_onCreatureCharm(event)
	local creature = event.creature
	if FightDirector.status == FightCommon.start then
		self:checkFightOver(creature)
	end
end

function CheckFightEndDelegate:checkFightOver(creature)
	local team = creature._oldTeam or creature.cInfo.team
	if team == FightCommon.enemy then
		if self:check(creature,self.winList,self.winScore) then
			FightDirector:fightOver(true,true)
		end
	else
		if self:check(creature,self.failList,self.failScore) then
			FightDirector:fightOver(false,true)
		end
	end
end

function CheckFightEndDelegate:check(creature,list,score)
	if list[KILL_QH] and creature.isHQ then
		return true
	end

	local team = creature._oldTeam or creature.cInfo.team

	-- dump(self.winList)
	-- print("检测。。。。",list[KILL_PROTECT],creature.isProtectd,creature.cInfo.name)
	-- print(debug.traceback())
	if list[KILL_PROTECT] and creature.isProtectd then
		local cList = FightDirector:getScene():getTeamList(team)
		local hasProtectdNPC = false
		for i,c in ipairs(cList) do
			if c.isProtectd and not c:isDie() then
				hasProtectdNPC = true
				break
			end
		end
		if not hasProtectdNPC then
			return true
		end
	end

--	if score then
--		score = score - creature.cInfo.populace
--		if score <= 0 then
--			return true
--		end
--	end

	if list[KILL_ALL] then
		local cList = FightDirector:getScene():getTeamList(team)

		if team == FightCommon.enemy then
			local refreshMonster = FightDirector:getSysHandle():getRefreshMonsterDelegate()

			if refreshMonster and not refreshMonster:isRefreshEnd() then  --怪物还没刷完
				return false
			end
		end

		for i,ct in ipairs(cList) do
			if ct:isDie() or ct.isBeCharm or (ct.cInfo.heroType == 1 and not ct.cInfo.skillTurn and not ct.isHQ ) then

			else
				return false --还有会使用技能的单位
			end
		end
		if team == FightCommon.mate then --己方的
--			local panel = ViewMgr:getPanel(Panel.FIGHT)
--			if not panel.ui.fightBottom:getStockGrid() then  --英雄都用完了
--				if panel.ui.fightBottom:isSkillUsed() then  --大招也用完了
--					return true  --输了
--				else
--					--需要监听  使用大招
--					FightTrigger:addEventListener(FightTrigger.USE_PLAYER_SKILL, {self,self.checkSkillEnd})
--					return false
--				end
--			end
			return true
		else
			return true
		end
	end
end

function CheckFightEndDelegate:checkSkillEnd()
	self._checkSkillTimer = scheduler.performWithDelayGlobal(function()
			if FightDirector.status == FightCommon.start then
				local cList = FightDirector:getScene():getTeamList(FightCommon.mate)
				for i,ct in ipairs(cList) do
					if ct:isDie() or ct.isBeCharm or (ct.cInfo.heroType == 1 and not ct.cInfo.skillTurn and not ct.isHQ ) then

					else
						return false --还有会使用技能的单位
					end
				end
				FightDirector:fightOver(false,false)
			end
		end, 11)
end

function CheckFightEndDelegate:dispose()
	FightTrigger:removeEventListener(FightTrigger.CREATURE_DIE,{self,self._onCreatureDie})
	-- FightTrigger:removeEventListener(FightTrigger.CHARM_CREATURE,{self,self._onCreatureCharm})
end

return CheckFightEndDelegate
