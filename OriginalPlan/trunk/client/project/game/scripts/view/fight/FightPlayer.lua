--
--

local FightPlayer = class("FightPlayer")

function FightPlayer:ctor( team )

	self.team = team
	self.isPlayer = true
	self:init()
end

function FightPlayer:init()
end

function FightPlayer:start()
end

function FightPlayer:getBuffEffectValue( value )
	return value
end

function FightPlayer:getDirection(  )
	return Creature.RIGHT_UP
end

function FightPlayer:getMagicTarget(magicInfo,targetType)
	if self.team == FightCommon.enemy then
		local team = Formula:getEnemyTeam(self.team)
		return FightDirector:getScene():getTeamList(team)
	end
	targetType = targetType or 3
	-- print(debug.traceback())
	-- print("--获取敌人。。。。",targetType,self.team)
	if targetType == 3 then  --敌人
		local team = Formula:getEnemyTeam(self.team)
		return FightDirector:getScene():getTeamList(team)
	elseif targetType == 2 then   --队友
		return FightDirector:getScene():getTeamList(self.team)
	elseif targetType == 4 then
		return FightDirector:getScene():getCreatureList()
	else
		print("targetType",targetType)
		assert(false,"player skill cfg targetType error")
	end
end

function FightPlayer:retain()
end

function FightPlayer:release()
end

function FightPlayer:dispose(  )

end

return FightPlayer