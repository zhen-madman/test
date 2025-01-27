
local RefreshMonsterDelegate = class("RefreshMonsterDelegate")

local NewHandle = game_require("view.fight.handle.NewHandle")

function RefreshMonsterDelegate:ctor()
	self.right_list = {}
	self.left_list = {}
end

function RefreshMonsterDelegate:start(refreshInfo,delay,timeRefresh)
	self.right_list = {}
	self.left_list = {}
	self:initBuild(refreshInfo.hq_1,refreshInfo.hq_2)

	if refreshInfo.initMonster then
		self:_initMonster(refreshInfo.initMonster,FightCommon.right,false,self.right_list)
	end

	if refreshInfo.initMate then
		self:_initMonster(refreshInfo.initMate,FightCommon.left,false,self.left_list)
	end

--	if refreshInfo.protectMonster then
--		self:_initMonster(refreshInfo.protectMonster,FightCommon.left,true,self.left_list)
--	end
--	if refreshInfo.protectEnemyMonster then
--		self:_initMonster(refreshInfo.protectEnemyMonster,FightCommon.right,true,self.right_list)
--	end

--	delay = delay or 0
--	self.curTime = -delay
--	-- self.maxNum = refreshInfo.populace or FightDirector:getMaxPopulace(FightCommon.enemy)
--	self.curIndex = 0
--	self.isLoop = refreshInfo.loop

--	if timeRefresh then
--		self.refreshMonster = refreshInfo.refreshMonster
--		self.refreshMateMonster = refreshInfo.refreshMateMonster
--		if self.refreshMonster then
--			self.curIndex = 1
--		end
--		self.curMateIndex = 1
--		self.curMateTime = -delay
--		self.isMateLoop = refreshInfo.mateLoop

--		if refreshInfo.posRefreshMonster then
--			self.posRefresh = refreshInfo.posRefreshMonster
--			self.posIndex = {}
--			self.posTime = {}
--			for i=1,#self.posRefresh do
--				self.posIndex[i]=1
--				self.posTime[i]=-delay
--			end
--		end

--		if refreshInfo.roundRefreshMonster then
--			self.roundRefresh = refreshInfo.roundRefreshMonster
--			self.curRound = 1
--		end

--		if not self._isRun then
--			self._isRun = true
--			FightEngine:addRunner(self)
--		end
--	end
end

--function RefreshMonsterDelegate:setDieList(dieList)
--	self._dieList = dieList
--end

--function RefreshMonsterDelegate:_checkDie(info,team)
--	if self._dieList then
--		if team == FightCommon.enemy then
--			if info.id and self._dieList[info.id] and self._dieList[info.id] > 0 then
--				self._dieList[info.id] = self._dieList[info.id] - 1
--				return true
--			end
--		end
--	end
--	return false
--end

--function RefreshMonsterDelegate:isRefreshEnd()
--	return self.curIndex == 0 or self.isLoop == 1
--end

--function RefreshMonsterDelegate:stopRefreshMonster()
--	FightEngine:removeRunner(self)
--end

function RefreshMonsterDelegate:initBuild(hq_1,hq_2)
	if hq_1 then
		local buildInfo = FightCfg:getFightMonster(hq_1[1])
		buildInfo.mx,buildInfo.my = hq_1[2],hq_1[3]
		buildInfo.team = FightCommon.left
		buildInfo.buildBlood = true
		local creature = self:initCreature(buildInfo)
		if creature then
			FightDirector:getScene():setHQ(creature)
			table.insert(self.left_list,creature)
		end
	end

	if hq_2 then
		local buildInfo = FightCfg:getFightMonster(hq_2[1])
		buildInfo.mx,buildInfo.my = hq_2[2],hq_2[3]
		buildInfo.team = FightCommon.right
		buildInfo.buildBlood = true
		local creature = self:initCreature(buildInfo)
		if creature then
			FightDirector:getScene():setHQ(creature)
			table.insert(self.right_list,creature)
		end
	end
end

function RefreshMonsterDelegate:_initMonster(mList,team,isProtectd,list)
	for i,info in ipairs(mList) do
		local hero = FightCfg:getFightMonster(info[1],team)
		hero.mx = info[2]
		hero.my = info[3]
		dump(info)
		hero.team = team


		print( "怪物 :",hero.name,hero.team,hero.id)

		-- if hero.name ~= "美国大兵" then

		-- else

--		if info[4] then
--			hero.cfgGlobalId = info[4]
--		end
		local remainder = 0
		if info[4] then
			hero.echelonType = info[4]
			remainder = hero.echelonType%10
			if remainder == 0 then
				hero.hideBlood = true
			end
		end
		hero.cityWallBoss = false
		if info[5] and  info[5] == 1 then
		   hero.cityWallBoss = true
			hero.hideBlood = false
		end

		if team == FightCommon.mate then
			hero.populace = 0
		end

		local creature = self:initCreature(hero)
		if creature then
				creature.isProtectd = isProtectd
				if (remainder ~= 0) and hero.scope ~= 1 then
					creature.beIgnored = true
				end
			table.insert(list,creature)
		end
	end
end

--function RefreshMonsterDelegate:run(dt)
--	if FightDirector.status ~= FightCommon.start then
--		return
--	end

--	self:_refreshMonster(dt)
--	self:_refreshPosMonster(dt)
--	self:_refreshRoundMonster()
--end


--function RefreshMonsterDelegate:_refreshMonster(dt)
--	if self.refreshMonster and self.curIndex > 0 then
--		self.curTime,self.curIndex = self:_refreshCreature(self.refreshMonster,self.curIndex
--							,self.curTime + dt,FightCommon.right)
--		if self.curIndex > #self.refreshMonster then
--			if self.isLoop == 1 then
--				self.curIndex = 1
--			else
--				self.curIndex = 0
--			end
--		end
--	end
--	if self.refreshMateMonster and self.curMateIndex > 0 then
--		self.curMateTime,self.curMateIndex = self:_refreshCreature(self.refreshMateMonster,self.curMateIndex
--							,self.curMateTime + dt,FightCommon.left)
--		if self.curMateIndex > #self.refreshMateMonster then
--			if self.isMateLoop == 1 then
--				self.curMateIndex = 1
--			else
--				self.curMateIndex = 0
--			end
--		end
--	end
--end

--function RefreshMonsterDelegate:_refreshCreature(refreshList,index,curTime,team)
--	local curRefresh = refreshList[index]
--	if curTime >= curRefresh[1]*1000 then
--		local num = curRefresh[3] or 1
--		if self:_canAddMonster(curRefresh[2],num,team) then
--			curTime = 0
--			index = index + 1
--			local mInfo = MonsterCfg:getMonster(curRefresh[2])
--			local mx,my = FightDirector:getMap():getRandomBorn(team, mInfo.scope)
--			num = (mInfo.heroNum or 1)*num
--			-- print("  这里？》？？",mInfo.heroNum,num,team)
--			for i=1,num do
--				self:addCreature(mInfo,mx,my,team)
--			end
--		end
--	end
--	return curTime,index
--end

--function RefreshMonsterDelegate:_refreshPosMonster(dt)
--	if self.posRefresh and FightDirector.status == FightCommon.start then
--		for i,reInfo in ipairs(self.posRefresh) do
--			local curIndex = self.posIndex[i]
--			if curIndex > 0 then
--				local cfgGlobalId = reInfo[1]
--				local isLoop = reInfo[2]
--				local mx,my = reInfo[3],reInfo[4]
--				local refreshList = reInfo[5]

--				local buildAlive = true
--				if cfgGlobalId > 0 then
--					local build = self:_getCreatureByCfgId(cfgGlobalId)
--					if not build or build:isDie() then
--						buildAlive = false
--						self.posIndex[i] = 0
--					end
--				end
--				if buildAlive then
--					self.posTime[i] = self.posTime[i] + dt

--					local curRefresh = refreshList[curIndex]
--					if self.posTime[i] >= curRefresh[1]*1000 then
--						local num = curRefresh[3] or 1
--						if self:_canAddMonster(curRefresh[2],num,FightCommon.right) then
--							self.posTime[i] = 0
--							curIndex = curIndex + 1
--							if curIndex > #refreshList then
--								if isLoop == 1 then
--									curIndex = 1
--								else
--									curIndex = 0
--								end
--							end
--							self.posIndex[i] = curIndex
--							local mInfo = MonsterCfg:getMonster(curRefresh[2])
--							num = (mInfo.heroNum or 1)*num
--							for i=1,num do
--								self:addCreature(mInfo,mx,my,FightCommon.right)
--							end
--						end
--					end
--				end
--			end
--		end
--	end
--end

--function RefreshMonsterDelegate:_refreshRoundMonster()
--	if self.roundRefresh then
--		if self._roundAddList and #self._roundAddList > 0 then
--			local curRefresh = self._roundAddList[1]
--			local num = curRefresh[2] or 1
--			if self:_canAddMonster(curRefresh[1],num,FightCommon.right) then
--				table.remove(self._roundAddList,1)
--				local mInfo = MonsterCfg:getMonster(curRefresh[1])
--				local mx,my = FightDirector:getMap():getRandomBorn(FightCommon.right, mInfo.scope)
--				num = (mInfo.heroNum or 1)*num
--				for i=1,num do
--					local c = self:addCreature(mInfo,mx,my,FightCommon.right)
--					if c then
--						c._isRoundRefresh = true
--					end
--				end
--			end
--		else
--			local enemyList = FightDirector:getScene():getTeamList(FightCommon.right)
--			for i,e in ipairs(enemyList) do
--				if e._isRoundRefresh then
--					return
--				end
--			end
--			local monsterList = self.roundRefresh[self.curRound]
--			if monsterList then
--				self._roundAddList = {}
--				table.merge(self._roundAddList,monsterList)
--				self.curRound = self.curRound + 1
--			else
--				self.roundRefresh = nil
--			end
--		end
--	end
--end

--function RefreshMonsterDelegate:_getCreatureByCfgId(id)
--	local cList = FightDirector:getScene():getCreatureList()
--	for i,c in pairs(cList) do
--		if c.cInfo.cfgGlobalId == id then
--			return c
--		end
--	end
--	return nil
--end

--function RefreshMonsterDelegate:_canAddMonster(mId,num,team)
--	local mInfo = MonsterCfg:getMonster(mId)
--	if mInfo.populace*num > FightDirector:getRemainPopulace(team) then
--		return false
--	end
--	return true
--end

--function RefreshMonsterDelegate:addCreature(cHero,mx,my,team)
--	-- local populace
--	-- if team == FightCommon.mate then
--	-- 	populace = 0
--	-- end
--	if self:_checkDie(cHero,team) then
--		return nil
--	else
--		return NewHandle:createMonster(cHero,mx,my,team,populace)
--	end
--end

function RefreshMonsterDelegate:initCreature(cInfo)
--	if self:_checkDie(cInfo,cInfo.team) then
--		return nil
--	else
		return FightDirector:getScene():initCreature(cInfo)
--	end
end

function RefreshMonsterDelegate:dispose()

end

return RefreshMonsterDelegate