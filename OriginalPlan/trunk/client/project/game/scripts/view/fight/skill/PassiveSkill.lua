
--
--被动技能类

local PassiveSkill = class("PassiveSkill")

PassiveSkill.HURT_TRIGGER = {"hurtSourceSkill","hurtTargetSkill","hurtSourceMagic","hurtTargetMagic"
								,"hurtSourceBuff","hurtTargetBuff"}

PassiveSkill.HALO_TIME = 1000  --1秒检测一次 光环的

function PassiveSkill:ctor(creature,skillId,skillObj)
	self.creature = creature
	self.skillId = skillId
	self.level = skillObj.level
	self.info = FightCfg:getSkillByLevel(skillId,self.level) --FightCfg:getSkill(skillId)
	self.skillParams = skillObj

	local rate = self.info.triggerRate
	if not rate or rate == 0 then
		rate = 10000
	end
	self.triggerRate = rate
end


--被动技能开始  战斗一开始就启动
function PassiveSkill:start()
	print("被动技能开始作用",self.skillId)
	local info = self.info

	if self.info.changeSkill then  --改变技能
		local skillList = self.creature.cInfo.skills
		local skillObj = self.creature.cInfo.skillObj
		for i,sId in ipairs(skillList) do
			if sId == self.info.changeSkill[1] then
				skillList[i] = self.info.changeSkill[2]  --直接改变英雄的某个技能
				local obj = {}
				obj.level = self.level --换了技能  等级也换成 被动技能的等级
				print("更换的技能等级 。。。",self.level)
				if skillObj[sId] then
					obj.hit = skillObj[sId].hit
				else
					obj.hit = 1
				end
				skillObj[skillList[i]] = obj
				break
			end
		end
	end

	for i,key in ipairs(PassiveSkill.HURT_TRIGGER) do  --需要添加受击后的 一些触发
		if self.info[key] then
			-- self.creature:addEventListener(Creature.BE_HURT, {self,self._beHurt},1)
			break
		end
	end

	if self.info.reborn or self.info.dieTriggerSkill then
		self.rebornTimes = self.info.reborn -- 复活次数
	end
	-- self.creature:addEventListener(Creature.DIE_EVENT, {self,self._onSelfDie},1)

	if info.reduceHpSkill or info.hpBuffList or info.hpSkillList then  --受到血量变化
		self:_checkHpBuff()
		self:_checkHpSkill()
		self.curReduceHp = 0
		-- self.creature:addEventListener(Creature.HP_CHANGE, {self,self._onHpChange},1)
	end



	if info.mateNumBuff or info.raceNumBuff then  --有队友在  有buff
		self:_ckeckMateNum()  --检测玩家数量  触发一些东西
	end

	if info.haloRange then
		self.range = Range.new(info.haloRange)
	end

	if info.magic then
		self.holeMagic = FightEngine:createMagic(self.creature, info.magic, self.creature, self.info,self.skillParams)
	end



	self.curTime = 0

	self.cdTime = 0
	self.haloTime = PassiveSkill.HALO_TIME

	-- FightTrigger:addEventListener(FightTrigger.CREATURE_DIE, {self,self._onCreatureDie})
	-- FightTrigger:addEventListener(FightTrigger.CREATURE_REBORN, {self,self._onCreatureReborn})
end

function PassiveSkill:run( dt )
	if self.cdTime > 0 then
		self.cdTime = self.cdTime - dt
	end

	self.haloTime = self.haloTime - dt
	if self.haloTime <= 0 then
		self.haloTime = PassiveSkill.HALO_TIME
		self:_checkHalo()  --检测光环作用
	end

end

function PassiveSkill:isInCD()
	if self.cdTime > 0 then
		return true
	else
		return false
	end
end

function PassiveSkill:resetCD()
	self.cdTime = self.info.skillCD or 0
end

--受击的时候
function PassiveSkill:_beHurt(event)
	if self:isInCD() then
		return
	end
	self:resetCD()

	if self.creature:isDie() then
		return
	end

	local target = event.atk
	local creature = self.creature
	local info = self.info

	if info.hurtSourceSkill and self:successTrigger() then
		FightEngine:createSkill(creature,info.hurtSourceSkill,target,self.skillParams)
	end

	if info.hurtTargetSkill and self:successTrigger() then
		if target:canBeHit(self.info) and target:canBeBreak() then  --目标能否被打断
			FightEngine:addNewSkill(target,info.hurtTargetSkill,creature,self.skillParams)
		end
	end

	if info.hurtSourceMagic and self:successTrigger() then
		FightEngine:createMagic(creature,info.hurtSourceMagic,target,info,self.skillParams)
	end

	if info.hurtTargetMagic and self:successTrigger() then
		FightEngine:createMagic(target,info.hurtTargetMagic,creature,info,self.skillParams)
	end

	if info.hurtSourceBuff and self:successTrigger() then
		local buffId = info.hurtSourceBuff[1]
		local time = info.hurtSourceBuff[2]
		FightEngine:createBuff( creature,buffId,time,creature,info,self.skillParams)
	end

	if info.hurtTargetBuff and self:successTrigger() then
		local buffId = info.hurtTargetBuff[1]
		local time = info.hurtTargetBuff[2]
		FightEngine:createBuff( target,buffId,time,creature,info,self.skillParams)
	end
end

function PassiveSkill:successTrigger()
	if self.triggerRate >= 10000 then
		return true
	end
	local r = math.random(1,10000)
	if r <= self.triggerRate then
		return true
	else
		return false
	end
end

function PassiveSkill:isBodyExplode()
	return false
	-- if self.info.dieTriggerSkill then
	-- 	return true
	-- else
	-- 	return false
	-- end
end

--死亡了  可能会爆炸  可能会复活
function PassiveSkill:_onSelfDie(event)
	local creature = self.creature

	if self.info.dieTriggerSkill then  --死亡发出技能
		FightEngine:createSkill(creature,self.info.dieTriggerSkill,nil,self.skillParams)
	end

	if self.holeMagic then
		FightEngine:removeMagic(self.holeMagic)
		self.holeMagic = nil
	end
	self.haloTime = 9999999  --不检测光环
	self:_removeHoleBuff()  --移除光环作用
end

--血量变化
function PassiveSkill:_onHpChange(event)
	if self.creature:isDie() then
		return
	end
	local value = event.value

	self:_checkReduceHpSkill(value)
	self._checkHpBuff()
	self._checkHpSkill()
end


--每受到多少百分比的伤害  就会触发一个技能
function PassiveSkill:_checkReduceHpSkill(value)
	if self.info.reduceHpSkill then
		if value < 0 then --扣血
			self.curReduceHp = self.curReduceHp - value
		end
		local rate = Formula:getRateValue(self.info.reduceHpSkill[1])
		if rate < self.curReduceHp/self.creature.cInfo.maxHp then   --每受到多少百分比的伤害  就会触发一个技能
			self.curReduceHp = 0
			FightEngine:createSkill(self.creature,self.info.reduceHpSkill[2],nil,self.skillParams)
		end
	end
end

--在不同的血量区间段会有不同的buff
function PassiveSkill:_checkHpBuff()
	if self.info.hpBuffList then
		local hpRate = self.creature:getHpRate()
		if self.hpBuff then
			if self.hpBuff.minHpRate < hpRate and self.hpBuff.maxHpRate >= hpRate then
				return
			end
			FightEngine:removeBuff(self.hpBuff)
			self.hpBuff = nil
		end
		for i,bInfo in ipairs(self.info.hpBuffList) do
			if bInfo[1] < hpRate and bInfo[2] >= hpRate then
				self.hpBuff = FightEngine:createBuff(self.creature, bInfo[3], 9999999,self.creature, self.info,self.skillParams)
				self.hpBuff.minHpRate = bInfo[1]
				self.hpBuff.maxHprate = bInfo[2]
				return
			end
		end
	end
end

--在不同血量段会有不同的技能
function PassiveSkill:_checkHpSkill()
	if self.info.hpSkillList then
		if self:isInCD() then
			return
		end
		if self.creature:canBeBreak() then
			local hpRate = self.creature:getHpRate()
			for i,sInfo in ipairs(self.info.hpBuffList) do
				if sInfo[1] < hpRate and sInfo[2] >= hpRate then
					FightEngine:addNewSkill(self.creature,sInfo[3],self.creature,self.skillParams)
					self:resetCD()
					return
				end
			end
		end

	end
end

--检测光环作用
function PassiveSkill:_checkHalo()
	if self.range then
		if self.info.haloMateBuff then   --队友进入光环范围
			local buffId = self.info.haloMateBuff
			local mateList = FightDirector:getScene():getMateList(self.creature)
			local cList = AIMgr:getTargetInRange(self.creature,mateList,self.range)
			for i,c in ipairs(mateList) do
				if table.indexOf(cList,c) > 0 and not c:isDie() then
					if not c:getBuffById(buffId) then
						FightEngine:createBuff(c, buffId, 99999999, self.creature,self.info,self.skillParams)
					end
				else
				 	local buff = c:getBuffById(buffId)
				 	if buff then
				 		FightEngine:removeBuff(buff)
				 	end
				end
			end
		end
		if self.info.haloEnemyBuff then   --检测敌人进入光环范围
			local buffId = self.info.haloEnemyBuff
			local enemyList = FightDirector:getScene():getEnemyList(self.creature)
			local cList = AIMgr:getTargetInRange(self.creature,enemyList,self.range)
			for i,c in ipairs(enemyList) do
				if table.indexOf(cList,c) > 0 and not c:isDie() then
					if not c:getBuffById(buffId) then
						FightEngine:createBuff(c, buffId, 99999999, self.creature, self.info, self.skillParams)
					end
				else
					local buff = c:getBuffById(buffId)
					if buff then
						FightEngine:removeBuff(buff)
					end
				end
			end
		end
	end
end

--移除光环作用
function PassiveSkill:_removeHoleBuff()
	if self.info.haloMateBuff then   --队友进入光环范围
		local buffId = self.info.haloMateBuff
		local mateList = FightDirector:getScene():getMateList(self.creature)
		for i,mate in ipairs(mateList) do
			local buff = mate:getBuffById(buffId)
			if buff then
				FightEngine:removeBuff(buff)
			end
		end
	elseif self.info.haloEnemyBuff then   --检测敌人进入光环范围
		local buffId = self.info.haloEnemyBuff
		local enemyList = FightDirector:getScene():getEnemyList(self.creature)
		for i,enemy in ipairs(enemyList) do
			local buff = enemy:getBuffById(buffId)
			if buff then
				FightEngine:removeBuff(buff)
			end
		end

	end
end

--检测玩家数量  触发一些东西
function PassiveSkill:_ckeckMateNum()
	if self.creature:isDie() then
		return
	end
	local info = self.info
	if info.mateNumBuff then  --有队友在  有buff
		local mateList = FightDirector:getScene():getMateList(self.creature)
		local num = #mateList-1
		local buffId = info.mateNumBuff[num]
		if buffId then
			FightEngine:createBuff(self.creature, buffId, 99999999, self.creature, self.info, self.skillParams)
		else
			buffId = info.mateNumBuff[1]
			local buff = FightCfg:getBuff(buffId)
			if buff then
				FightEngine:removeBuffByType( self.creature,buff.bType,1 )
			end
		end
	end
	if info.raceNumBuff then  --同种族队友在
		local mateList = FightDirector:getScene():getMateList(self.creature)
		local num = #mateList-1
		local buffId = info.raceNumBuff[num]
		if buffId then
			FightEngine:createBuff(self.creature, buffId, 99999999, self.creature, self.info, self.skillParams)
		else
			buffId = info.raceNumBuff[1]
			local buff = FightCfg:getBuff(buffId)
			if buff then
				FightEngine:removeBuffByType( self.creature,buff.bType,1 )
			end
		end
	end
end

function PassiveSkill:_onCreatureDie(event)
	local target = event.creature
	print("event...... die........",target.cInfo,self.creature.cInfo)
	if not AIMgr:isEnemy(self.creature, target) then  --同队的
		self:_ckeckMateNum()
	end
	if event.killer == self.creature then
		if self.info.killSourceBuff and self:successTrigger() then
			local buffId = self.info.killSourceBuff[1]
			local time = self.info.killSourceBuff[2]
			FightEngine:createBuff( self.creature,buffId,time,self.creature,self.info,self.skillParams)
		end
		if self.info.killReleaseBuff and self:successTrigger() then
			for i,buffId in ipairs(self.info.killReleaseBuff) do
				FightEngine:removeCreatureBuffByBuffId(self.creature,buffId)
			end
		end
	end
end

--有队友复活了
function PassiveSkill:_onCreatureReborn(event)
	local target = event.creature
	if not AIMgr:isEnemy(self.creature, target) then  --同队的
		self:_ckeckMateNum()
	end
end

--免死的被动技能
function PassiveSkill:checkDie(value)
	if self.info.noDieBuff and not self.noDieTimes then
		self.noDieTimes = 1
		FightEngine:createBuff(self.creature, self.info.noDieBuff[1], self.info.noDieBuff[2], self.creature, self.info, self.skillParams)
		return -self.creature.cInfo.hp + 1   --剩余1点血
	else
		return value
	end
end


--过滤伤害
function PassiveSkill:filterHurt(value,hType)
	if self.info.noHurtType and (self.info.noHurtType == hType or self.info.noHurtType == 3) then  --不受伤害
		local p = Formula:getRateValue(self.info.noHurtProb)
		if math.random(1,10000) <= p then  --免疫本次伤害
			return 0
		end
	end
	return value
end

function PassiveSkill:dispose()
	FightTrigger:removeEventListener(FightTrigger.CREATURE_DIE, {self,self._onCreatureDie})
	FightTrigger:removeEventListener(FightTrigger.CREATURE_REBORN, {self,self._onCreatureReborn})
	self.holeMagic = nil
	self.creature = nil
end



return PassiveSkill