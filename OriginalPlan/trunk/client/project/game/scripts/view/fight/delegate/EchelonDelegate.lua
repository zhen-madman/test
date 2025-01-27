
local EchelonDelegate = class("EchelonDelegate")

function EchelonDelegate:ctor()
	FightTrigger:addEventListener(FightTrigger.CREATURE_DIE, {self,self._onCityWallBossDie})
	FightTrigger:addEventListener(FightTrigger.CREATURE_CHANGE_HP,{self,self._onCityWallBossChangeHP},-2)
end

function EchelonDelegate:run(dt)
end

function EchelonDelegate:_onCityWallBossDie(e)
	if e.creature.cInfo.cityWallBoss then
		local creature = e.creature
		local doorsill = math.floor(creature.cInfo.echelonType/10)
		self:setCityWallDie(doorsill,list)
		self:cancleIgnored(doorsill,list)
		FightDirector:setFightArea( FightCfg:getNextFightArea(doorsill*10))
	end
end

function EchelonDelegate:_onCityWallBossChangeHP( e )
	if e.creature.cInfo.cityWallBoss then
		local creature = e.creature
		local doorsill = math.floor(creature.cInfo.echelonType/10)
		local rate = creature.cInfo.hp/creature.cInfo.maxHp
		self:_updateCityWallHp(doorsill,rate)
	end
end

function EchelonDelegate:_updateCityWallHp(doorsill,rate )
	local list = role_list or FightEngine:getAllCreture()
	for k,v in pairs(list) do
		if v.cInfo.echelonType and not v:isDie() and not v:isCityWallBoss(doorsill) then
			if v.cInfo.echelonType == doorsill*10 then
				local tempHp = math.floor(v.cInfo.maxHp*rate)+1
				v:setHp(tempHp)
			end
		end
	end
end

function EchelonDelegate:setCityWallDie(doorsill,role_list)
	local DieHandle = game_require("view.fight.handle.DieHandle")
	--local list = FightEngine:getAllCreture()
	local list = role_list or FightEngine:getAllCreture()
	for k,v in pairs(list) do
		if v.cInfo.echelonType then
			if v.cInfo.echelonType == doorsill*10 then
				v:setHp(0)
				local handle = DieHandle.new(v)
				handle:start()
			end
		end
	end
end

function EchelonDelegate:start()
--	self.wallBoass = {}
--	for k,v in ipairs(FightCfg.ECHELON_AREA) do
--		local cityWallboss = FightEngine:getCityWallBoss( v )
--		self.wallBoass[v] = cityWallboss
--		if cityWallboss then
--			local totalHP = FightCfg.CITY_WALL_TOTAL_HP[v] or 1000
--			cityWallboss:setMaxHp( totalHP )
--			cityWallboss:setHp(totalHP)
--		end
--	end
end

function EchelonDelegate:dispose()
	FightTrigger:removeEventListener(FightTrigger.CREATURE_DIE, {self,self._onCityWallBossDie})
	FightTrigger:removeEventListener(FightTrigger.CREATURE_CHANGE_HP,{self._onCityWallBossChangeHP})
end

function EchelonDelegate:cancleIgnored(doorsill,role_list)
	local list = role_list or FightEngine:getAllCreture()
	for k,v in pairs(list) do
		if v.cInfo.echelonType and v.cInfo.echelonType == (doorsill+1)*10+1
			or v.cInfo.echelonType == (doorsill+1)*10+2 or v.cInfo.echelonType == (doorsill+1)*10+3 then
			v.beIgnored = nil
		end
	end
end

return EchelonDelegate