--
-- 伤害计算相关

local FightNum = game_require("view.fight.runner.FightNum")

local HurtHandler = {}

function HurtHandler:ctor()
	self.dataList = {}
end

HurtHandler:ctor()

function HurtHandler:init()
	self.dataList = {}
	self._maxDps = 1
	self._maxDef = 1
end

function HurtHandler:setHurtData(team1,team2)
end

function HurtHandler:getMaxDataValue(type)
	if type == "dps" then
		return self._maxDps
	else
		return self._maxDef
	end
end

function HurtHandler:getTotalHurt()
	return self._maxDps,self._maxDef
end

function HurtHandler:getDataList()
	return self.dataList
end

function HurtHandler:_addHurtDate(creature,target,value,isKill)
	value = math.abs(value)
	local team = nil
	if creature then
		local cInfo = creature.cInfo
		team = creature._oldTeam or cInfo.team
		if creature._oldTeam == FightCommon.enemy and creature._charmSrcId then --被我方心灵控制
			local c = FightDirector:getScene():getCreature(creature._charmSrcId)
			if c and c.cInfo.team == FightCommon.mate then
				cInfo = c.cInfo
				team = FightCommon.mate
			end
		end
		if team == FightCommon.mate and cInfo.heroId then
			local data = self.dataList[cInfo.heroId]
			if not data then
				data = {heroId = cInfo.heroId,dps=0,def=0,killList={}}
				self.dataList[cInfo.heroId] = data
			end
			data.dps = data.dps + value
			self._maxDps = self._maxDps + value
			if isKill and target.cInfo.head then
				local tInfo = target.cInfo
				local killInfo = data.killList[tInfo.id]
				if not killInfo then
					killInfo = {id = tInfo.id,num = 0}
					data.killList[tInfo.id] = killInfo
				end
				killInfo.num = killInfo.num + 1
			end
		end
	end

	local tInfo = target.cInfo
	team = target._oldTeam or target.cInfo.team
	if team == FightCommon.mate and tInfo.heroId then
		local data = self.dataList[tInfo.heroId]
		if not data then
			data = {heroId = tInfo.heroId,dps=0,def=0,killList={}}
			self.dataList[tInfo.heroId] = data
		end
		data.def = data.def + value
		self._maxDef = self._maxDef + value
	end
end

--战后 数据统计
function HurtHandler:getHurtData(  )
	local dList = {}
	for heroId,data in pairs(self.dataList) do
		local info = {heroId = heroId}
		info.powerValue = data.dps
		info.harmValue = data.def
		info.power = math.floor(100*data.dps/self._maxDps + 0.5)
		info.harm = math.floor(100*data.def/self._maxDef + 0.5)
		info.eliminateList = {}
		for i,kill in pairs(data.killList) do
			info.eliminateList[#info.eliminateList+1] = kill
		end
		dList[#dList+1] = info
	end
	table.sort(dList,function(a,b)
		local av,bv = a.powerValue + a.harmValue + #a.eliminateList*10000,b.powerValue + b.harmValue + #b.eliminateList*10000
		if av > bv then
			return true
		elseif av == bv then
			return a.heroId > b.heroId
		end
		return false
	end)
	if #dList > 0 then
		dList[1].isMvp = true
	end
	return dList
end

--作用技能作用 的伤害  包括加血的  刚体的改变d
function HurtHandler:skillHurt( creature,skill,hitTarget,params )

	--计算技能伤害
	if hitTarget:isDie() or FightDirector:isNetFight() then
		return FightCommon.hit,0,0
	end
	--[[--]]
	-- if hitTarget.cInfo.team == FightCommon.mate then
	-- 	return FightCommon.hit,0,0
	-- end

	if not skill.skillLevel then
		if not skill.id then
			-- local str = "not skill id: "..(skill.skillLevel or "") .." creature: "
			-- if creature then
			-- 	if creature.cInfo then
			-- 		str = str .. "   name : "..creature.cInfo.name
			-- 	end
			-- end
			-- StatSender:sendBug(str )
			return FightCommon.hit,0,0
		end
		skill = FightCfg:getSkillByLevel(skill.id, params.level)
	end

	params.weapon = FightCfg.MINOR_ATTACK
	if table.indexOf(creature.cInfo.skills,skill.id) >0 then
		params.weapon = FightCfg.MAIN_ATTACK
	end
	local status,hurtValue,gangValue = Formula:getSkillValue( creature,skill,hitTarget,params,hurtRate )

	local hurtParams = {}
	hurtParams.status = status
	hurtValue = self:hurtTarget(hitTarget,hurtValue,skill,creature,hurtParams)
	--print("--伤害。。。",status,hurtValue,creature.cInfo.name)
	return status,hurtValue,gangValue  --闪避  暴击 命中等
end

function HurtHandler:playerSkillHurt( creature,skill,target,params )
	if FightDirector:isNetFight() then
		return FightCommon.hit,0,0
	end
	local status,value,gangValue = Formula:getPlayerSkillValue( creature,skill,target,params.level )



	value = target:getBuffFilterValue(value,skill.effect)  --计算一下buff 的加成  或者免伤之类的

	local realHurt = self:changeHP(target,value,skill,nil,status)

	if creature and creature.team == FightCommon.mate then
		self._maxDps = self._maxDps - realHurt
	end

	return status,realHurt,gangValue  --闪避  暴击 命中等
end

--目标受伤   或者加血  需要计算一些buff 的免疫等
function HurtHandler:hurtTarget(target,value,skill,creature,hurtParams)
--	local effect
--	if skill then
--		effect = skill.effect
--	elseif value > 0 then
--		effect = FightCfg.ASSIST --法术治疗
--	end

--	if creature then
--		value = creature:getBuffEffectValue(value,effect)
--	end
--	value = target:getBuffFilterValue(value,effect)  --计算一下buff 的加成  或者免伤之类的

	local realHurt = self:changeHP(target,value,skill,creature,hurtParams)

	return realHurt
end

--直接改变血量
function HurtHandler:changeHP(target,value,skill,creature,hurtParams,force)
	target = FightEngine:cityWallRelocation(target)
	if not target then
		return
	end
	hurtParams = hurtParams or {}
	local isHurt
	if (not skill or Formula:isHurtMagic()) and value <= 0 then  --被打到了
		isHurt = true
	else
		isHurt = false
	end
	value = math.floor(value)
	value = target:checkDie(value)  ---看看是不是有 不死的技能
	value = target:changeHP(value,hurtParams,skill,force,creature)

	if isHurt then
		target:beHurt(value,creature)
	end

	local kill = false
	if target.cInfo.hp <= 0 then  --死了
		target:dieHandle(creature)
		kill = true
	else
		-- if creature and isHurt then
		-- 	target:dispatchEvent({name=Creature.BE_HURT,atk=creature})
		-- end
	end

	self:_addHurtDate(creature,target,value,kill)

	return value
end


return HurtHandler