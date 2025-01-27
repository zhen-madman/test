
--[[--
Buff基类
]]
local Buff = class("Buff")

Buff.HIDE = 1 --隐身 buff
Buff.YUN = 99999 --眩晕 buff


function Buff:ctor(gId)
	self.gId = gId
	self.curTime = 0
	self._lastTime = 0
end

function Buff:init( creature,buffId,time,buffOwner,skillInfo,skillParams,target )
	self.creature = creature
	self.buffOwner = buffOwner   --buff的释放者

	self.buffId = buffId
	self.target = target

	self.skillInfo = skillInfo
	if skillInfo then
		self.skillId = skillInfo.id
	end

	self.skillParams = skillParams
	self.level = skillParams.level or 1
	self.totalTime = time  --持续时间

	-- print("buff....",time,buffId)

	self.info = FightCfg:getBuffByLevel(buffId,self.level)



	self.hurtTimes = self.info.hurtTimes  --受伤多少次 buff消失

	-- self.info.shield = 1

	-- self.info.shieldValue = 600

	if self.info.shield then
		self.shieldValue = self.info.shieldValue
	else
		self.shieldValue = -1
	end

	self.addAtk = 0
end


function Buff:getCreature()
	return self.creature
end

function Buff:getTextColor(index)
	local list = {display.COLOR_RED,display.COLOR_GREEN,display.COLOR_BLUE,display.COLOR_YELLOW,display.COLOR_WHITE}
	return list[index]
end

function Buff:start()

	self._attributeCount = 0
	self.effect = self.info.effect   --效果

	self.interval = self.info.interval or -1

	self.creature:addBuff(self)
	print("添加 buff 。",self.buffId)

	if self.info.avRes then  --变身
		self.creature:setAV(self.info.avRes)
	end

	if self.info.disorder  then  --混乱
		local ai = AIMgr:getAI(self.creature)
		self.creature.forbidMove = nil

		local buildtarget = FightDirector:getScene():getHQ(self.creature.cInfo.team)
		ai:setBuildTarget(buildtarget)
		ai:_setNewTarget(nil)
	end

	if self.info.hide then
		local cList = FightDirector:getScene():getEnemyList(self.creature)
		for i,c in ipairs(cList) do
			local ai = AIMgr:getAI(c)
			if ai.target == self.creature then
				ai:_setNewTarget(nil)
			end
		end
	end

	if self.info.monsterId then  --召唤物
		local heroInfo = HeroInfo.newBasic(self.info.monsterId[1], self.level, self.info.monsterId[3], self.info.monsterId[2])
		local cInfo = FightCfg:getFightHero(heroInfo,self.creature.cInfo.team)
		FightDirector:addTacticAttr(cInfo)  --添加英雄策略属性

		local skillObj = {}
		for i,skillId in ipairs(cInfo.skills) do  --获取技能 等级
			local obj = {}
			skillObj[skillId] = obj
	        obj.level = self.level - FightCfg:getSkillBaseLevel(i)
	        obj.hit = self.level
	    end
	    cInfo.skillObj = skillObj

		local posTarget = self.creature
		local posType = self.info.monsterId[4] or 2
		if posType == 1 and self.target then
			posTarget = self.target
		else
			posTarget = self.creature
		end
		-- if self.skillParams and self.skillParams.buffTarget then
		-- 	posTarget = self.skillParams.buffTarget
		-- end

		--self.totalTime = 9699999999999

		local tileList = FightDirector:getMap():getNearGapList(posTarget.mx,posTarget.my)
		local d = Formula:turnDirection(posTarget:getDirection())
		local mTile = nil
		for i,tile in ipairs(tileList) do
			local md = AIMgr:getDirection(posTarget,tile.x,tile.y)
			if md ~= d then
				mTile = tile
				break
			end
		end
		if not mTile then
			mTile = tileList[1]
		end
		cInfo.mx,cInfo.my = mTile.mx,mTile.my
		cInfo.isPet = true   --标记为宠物
		self.monster = FightDirector:getScene():initCreature(cInfo)
		if posTarget == self.target then
			self.monster:setPosition(self.target:getPosition())
		end

		-- self.monster:addEventListener(Creature.DIE_EVENT, {self,self._onMonsterDie})

		if self.skillId then
			FightCfg:setCallMonsterSkillId(self.skillId,self.buffId)
		end
	end


	local magicId = self.info.magic
	if magicId then
		FightEngine:removeCreatureMagicById(self.creature,magicId)
		local magicInfo = FightCfg:getMagic(magicId)
		-- print("buff 魔法。。。。",magicId)
		local totalFrame,parent,loop = magicInfo.totalFrame,magicInfo.parent,magicInfo.loop
		magicInfo.totalFrame = 99999
		magicInfo.parent = 2
		magicInfo.loop = 1000
		local magic = FightEngine:createMagic(self.buffOwner,magicId,self.creature,self.skillInfo,self.skillParams)
		if magic then
			self.mId = magic.gId
		end
		magicInfo.totalFrame,magicInfo.parent,magicInfo.loop = totalFrame,parent,loop
	end

	local stuntId = self.info.stunt
	if stuntId then
		self.stunt = FightEngine:createStunt(self.creature,stuntId,self.creature,self.totalTime)
	end

	local valueList = self:changeAttributes()  --这里扣血的话  可能会导致creature 死亡  死亡后会移除所有buff
end

function Buff:changeAttributes()
	if self.info.attrTypes then
		local valueList = {}
		self._attributeCount = self._attributeCount + 1
		for i,type in ipairs(self.info.attrTypes ) do
			if self:isHurtBuff(type) and self.skillInfo and not self.creature:canBeHit(self.skillInfo) then  --加血 减血
				--不能受伤
			elseif self.info then
				local value = (self.info.values and self.info.values[i]) or 0
				local rate = (self.info.rates and self.info.rates[i]/10000) or 0
				local type,value = self:_setAttribute(type,value,rate,self.buffOwner,self.skillInfo)
				valueList[i] = value
			else
				return nil
			end
		end
		return valueList
	end
	return nil
end

function Buff:isHurtBuff(type)
	return type == 1
end

function Buff:resetAttribute()
	if self.info.attrTypes then
		local valueList = {}
		for i,type in ipairs(self.info.attrTypes ) do
			if not self:isHurtBuff(type) then  --1 是当前血量的  不恢复了
				local value = (self.info.values and self.info.values[i]) or 0
				local rate = (self.info.rates and self.info.rates[i]/10000) or 0  --百分比的
				value = -value*self._attributeCount
				-- if HeroConst.Attribute[type] == Formula:getAtkType(self.creature) and self.addAtk > 0 then
				-- 	value = value - self.addAtk
				-- end
				rate = -rate*self._attributeCount
				local type,value = self:_setAttribute(type,value,rate,self.buffOwner,self.skillInfo)
				valueList[i] = value
			end
		end
		return valueList
	end
	return nil
end

function Buff:_setAttribute(type,value,rate,skill )
	value = value or 0
	if rate ~= 0 then  --百分比的
		--print("加。。。bug",type,HeroConst.Attribute[type],self.buffId)
		local key = HeroConst.Attribute[type]
		local oValue
		-- if type == 1 then
		-- 	key = HeroConst.Attribute[2]  --按最大生命值去取
		-- end
		oValue = self.creature:getOriginalValue(key)
		oValue = oValue or 0
		value = value + oValue*rate
	end
	if self:isHurtBuff(type) then  --扣血的
		-- print("--扣血。。。buff",self.buffId,value,rate,self.creature.cInfo.name)
		HurtHandler:hurtTarget(self.creature,value,skill,self.buffOwner)
	else
		-- if type == 3 then
		-- 	print(" change speed buff。。。。。。。。。。。。。。。。。。。。。。",value,rate,type,self.buffId,self.creature.cInfo.mSpeed)
		-- end
		self.creature:changeValue(HeroConst.Attribute[type], value,skill)

		-- print(" --结果：",self.creature.cInfo.mSpeed)-*/
	end
	return type,value
end


function Buff:run(dt)
	self._isRunning = true

	self._lastTime = self.curTime
	self.curTime = self.curTime + dt

	local skillId = self.info.skill
	if skillId and not self.skill then
		--FightEngine:addNewSkill(self.creature,skillId,nil)
		self.skill = FightEngine:createSkill(self.creature,skillId,nil,self.skillParams)
	end
	if self.totalTime >= 0 then
		if self.interval > 0 then
			self.interval = self.interval - dt
			if self.interval <= 0 then
				self.interval = self.info.interval
				self:changeAttributes()
			end
		end

		--print("buff时间",self._lastTime,self.totalTime)
		if self._lastTime >= self.totalTime or self.shieldValue == 0 then
			self._isRunning = false
			self:_endBuff()
		end
	end
	self._isRunning = false
	-- print("buff。。。。",self.totalTime)
end

--能否移动
function Buff:canMove( )
	return not self.info.noMove
end

--能否攻击
function Buff:canUseSkill()
	return not self.info.noaAttack
end

function Buff:canBeHurt()
	return not self.info.noBeHurt
end

--能否被打断
function Buff:canBeBreak(  )
	if self.info.noBeBreak == 1 then
		return false
	end
	return true
end

--能否被搜索到
function Buff:canBeSearch( sType )
	if not self.info.hide then
		return true
	elseif self.info.hide == 3 then
		return false
	elseif self.info.hide == sType then
		return false
	end
	return true
end

--受击次数
function Buff:reduceHurtTimes(num)
	if self.hurtTimes then
		self.hurtTimes = self.hurtTimes - num
		if self.hurtTimes <= 0 then
			self:_endBuff()
		end
		return true
	end
	return false
end


--过滤buff  免疫
function Buff:immuneBuff( buffId )
	if self.info.immuneBuffs then
		for i,bId in ipairs(self.info.immuneBuffs) do
			if bId == buffId then
				return true
			end
		end
	end
	return false
end

--伤害别人的 效果加成
function Buff:addHurt(value)
	if self.info.atkRate then
		return self.info.atkRate*value/10000
	end
	return 0
end

--受伤 效果增加
function Buff:filterHurt( value )
	if self.info.hurtRate then
		return self.info.hurtRate*value/10000
	end
	return 0
end

--盾承受伤害
function Buff:shieldHurt( value,hType )
	if value < 0 and self.shieldValue > 0 then
		local shieldType = self.info.shield
		if shieldType == 3 or shieldType == hType then
			if -value >= self.shieldValue then
				value = value + self.shieldValue
				self.shieldValue = 0
			else
				self.shieldValue = self.shieldValue + value
				value = 0
			end
		end
	end
	return value
end

--召唤物死了  buff也结束了
function Buff:_onMonsterDie( event )
	self:_endBuff()
end

function Buff:_endBuff()
	if self.info.endSkill then
		local sId = self.info.endSkill[1]
		local target
		local creature
		if self.info.endSkill[2] == 2 then
			creature = self.buffOwner
			target = self.creature
		else
			creature = self.creature
			target = self.buffOwner
		end
		-- self.skillParams.buffTarget = target
		--print("创建 buff  结束技能。。",self.buffId,self.info.endSkill[1],self.info.endSkill[2])
		FightEngine:createSkill(creature,sId,target,self.skillParams)
	end
	FightEngine:removeBuff(self)
end

function Buff:_onCreatureDie(event)
	local target = event.creature
	if event.killer == self.creature then
		if self.info and self.info.killSourceBuff then
			local buffId = self.info.killSourceBuff[1]
			local time = self.info.killSourceBuff[2]
			FightEngine:createBuff( self.creature,buffId,time,self.creature,self.skillInfo,self.skillParams)
		end
	end
end


function Buff:dispose()
	print("--移除buff",self.buffId)
	if self.mId then
		FightEngine:removeMagicById(self.mId)
		self.mId = nil
	end
	if self.skill then
		FightEngine:removeSkill(self.skill)
		self.skill = nil
	end
	if self.stunt then
		FightEngine:removeStunt(self.stunt)
		self.stunt = nil
	end

	if self._isRunning then  --当前正在跑   延迟销毁
		FightEngine:delayDisposeElem(self)
		return
	end

	local valueList = self:resetAttribute()

	if self.info.avRes then
		self.creature:setAV(self.creature.cInfo.res)
	end

	self.creature:removeBuff(self)

	if self.info.disorder  then  --混乱
		local ai = AIMgr:getAI(self.creature)
		if ai then
			ai:updateBuildTarget()
			ai:_setNewTarget(nil)
		end
	end
	if self.monster then  --有召唤物
		-- self.monster:removeEventListener(Creature.DIE_EVENT, {self,self._onMonsterDie})
		self.monster:die()
		self.monster = nil
	end
	self.creature = nil
	self.info = nil
end

return Buff

