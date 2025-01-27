--[[--
	战斗计算 公式 相关
]]
local pairs = pairs
local ipairs = ipairs
local table = table

local Formula = class("Formula")

function Formula:ctor()
	-- body
	--self.atkCareer[]
	self.directionAngle = {}
	self.directionAngle[GameConst.UP] = math.pi/2
	self.directionAngle[GameConst.RIGHT_UP] = math.pi/4
	self.directionAngle[GameConst.RIGHT] = 0
	self.directionAngle[GameConst.RIGHT_DOWN] = -math.pi/4
	self.directionAngle[GameConst.DOWN] = -math.pi/2
	self.directionAngle[GameConst.LEFT_DOWN] = -math.pi*3/4
	self.directionAngle[GameConst.LEFT] = math.pi
	self.directionAngle[GameConst.LEFT_UP] = math.pi*3/4

	self.directionAngle[GameConst.RIGHT_UP_1] = math.pi*3/8
	self.directionAngle[GameConst.RIGHT_UP_2] = math.pi/8
	self.directionAngle[GameConst.RIGHT_DOWN_1] = -math.pi/8
	self.directionAngle[GameConst.RIGHT_DOWN_2] = -math.pi*3/8

	self.directionAngle[GameConst.LEFT_UP_1] = math.pi*5/8
	self.directionAngle[GameConst.LEFT_UP_2] = math.pi*7/8
	self.directionAngle[GameConst.LEFT_DOWN_1] = -math.pi*7/8
	self.directionAngle[GameConst.LEFT_DOWN_2] = -math.pi*5/8

	self.directionAngleEx = {}
	self.directionAngleEx[GameConst.UP] = math.pi/2
	self.directionAngleEx[GameConst.RIGHT_UP] = math.pi/4
	self.directionAngleEx[GameConst.RIGHT] = 0
	self.directionAngleEx[GameConst.RIGHT_DOWN] = -math.pi/4
	self.directionAngleEx[GameConst.DOWN] = -math.pi/2
	self.directionAngleEx[GameConst.LEFT_DOWN] = -math.pi/4
	self.directionAngleEx[GameConst.LEFT] = 0
	self.directionAngleEx[GameConst.LEFT_UP] = math.pi/4

	self.directionAngleEx[GameConst.RIGHT_UP_1] = math.pi*3/8
	self.directionAngleEx[GameConst.RIGHT_UP_2] = math.pi/8
	self.directionAngleEx[GameConst.RIGHT_DOWN_1] = -math.pi/8
	self.directionAngleEx[GameConst.RIGHT_DOWN_2] = -math.pi*3/8

	self.directionAngleEx[GameConst.LEFT_UP_1] = math.pi*3/8
	self.directionAngleEx[GameConst.LEFT_UP_2] = math.pi/8
	self.directionAngleEx[GameConst.LEFT_DOWN_1] = -math.pi/8
	self.directionAngleEx[GameConst.LEFT_DOWN_2] = -math.pi*3/8


	self.directionRound = {GameConst.UP,GameConst.RIGHT_UP
							,GameConst.RIGHT,GameConst.RIGHT_DOWN
							,GameConst.DOWN,GameConst.LEFT_DOWN
							,GameConst.LEFT,GameConst.LEFT_UP}

	self.directionRoundEx = {GameConst.UP,GameConst.RIGHT_UP_1,GameConst.RIGHT_UP,GameConst.RIGHT_UP_2
							,GameConst.RIGHT,GameConst.RIGHT_DOWN_1,GameConst.RIGHT_DOWN,GameConst.RIGHT_DOWN_2
							,GameConst.DOWN,GameConst.LEFT_DOWN_2,GameConst.LEFT_DOWN,GameConst.LEFT_DOWN_1
							,GameConst.LEFT,GameConst.LEFT_UP_2,GameConst.LEFT_UP,GameConst.LEFT_UP_1}


	-- self.defendTypeList = {}
end

--计算 敌人 权重
function Formula:getEnemyWeight(creature, target )

	if not creature.cInfo.priority then
		return 1
	end
	local p = -1
	for k,v in ipairs(creature.cInfo.priority) do
		local index = table.indexOf(v,target.cInfo.career)
		if index>0 then
			p = k
			break
		end
	end
	local w = 0
	if p == -1 then
		w = -1
	else
		w = 1000 - p
	end
	return  w
end

--计算 队友 权重
function Formula:getMateWeight(creature, target )
	return self:getEnemyWeight(creature,target)
end

function Formula:isBaseDirection(d)
	return d%10 <= 5
end

function Formula:getActionName(direction,aName)
	return aName.."_"..(direction%10)
end

function Formula:getAngleByDirection(d)
	return self.directionAngle[d]
end

function Formula:getDirectionBySpeed(dx,dy)
	local direction = 1
	local rateD = 0.3
	if dx >= 0 then
		if dy < 0 then
			dy = math.abs(dy)
			if dx/dy < rateD then
				direction = GameConst.DOWN
			elseif dy/dx < rateD then
				direction = GameConst.RIGHT
			else
				direction = GameConst.RIGHT_DOWN
			end
		else
			if dx/dy < rateD then
				direction = GameConst.UP
			elseif dy/dx < rateD  then
				direction = GameConst.RIGHT
			else
				direction = GameConst.RIGHT_UP
			end
		end
	else
		dx = math.abs(dx)
		if dy < 0 then
			dy = math.abs(dy)
			if dx/dy < rateD then
				direction = GameConst.DOWN
			elseif dy/dx < rateD then
				direction = GameConst.LEFT
			else
				direction = GameConst.LEFT_DOWN
			end
		else
			if dx/dy < rateD then
				direction = GameConst.UP
			elseif dy/dx < rateD then
				direction = GameConst.LEFT
			else
				direction = GameConst.LEFT_UP
			end
		end
	end
	return direction
end

function Formula:getDirectionBySpeedEx(dx,dy)
	local rotation = math.atan2(dy,dx)
	local min = math.pi/16
	local direction
	if rotation > -min then
		local arr,index
		if rotation < math.pi/2 + min then
			index = -1
			arr = {GameConst.RIGHT,GameConst.RIGHT_UP_2,GameConst.RIGHT_UP,GameConst.RIGHT_UP_1,GameConst.UP}
		else
			index = 4
			arr = {GameConst.LEFT_UP_1,GameConst.LEFT_UP,GameConst.LEFT_UP_2,GameConst.LEFT}
		end
		-- local a
		for i,d in ipairs(arr) do
			if rotation < (2*(index+i)+1)*min then
				direction = d
				break
			end
			-- a = i
		end
		-- if index == 4 then
		-- 	print("角度",rotation*180/math.pi,(2*(index+1)+1)*min*180/math.pi,index,a)
		-- end
	else
		local arr,index
		if rotation > -(math.pi/2 + min) then
			arr = {GameConst.RIGHT_DOWN_1,GameConst.RIGHT_DOWN,GameConst.RIGHT_DOWN_2,GameConst.DOWN}
			index = 0
		else
			index = 4
			arr = {GameConst.LEFT_DOWN_2,GameConst.LEFT_DOWN,GameConst.LEFT_DOWN_1,GameConst.LEFT}
		end
		-- local a
		for i,d in ipairs(arr) do
			if rotation > -(2*(i+index)+1)*min then
				direction = d
				break
			end
			-- a = i
		end
		-- if direction == nil then
		-- 	print("角度",rotation*180/math.pi,-(2*(1+index)+1)*min*180/math.pi,index,a)
		-- end
		-- print("角度",rotation*180/math.pi,direction)
	end

	return direction
end

function Formula:getAngleByDirectionEx(d)
	return self.directionAngleEx[d]
end

function Formula:turnDirection(start,to)
	return self:_trunDirection(start,to,self.directionRound)
end

function Formula:turnDirectionEx(start,to)
	return self:_trunDirection(start,to,self.directionRoundEx)
end

function Formula:_trunDirection(start,to,dList)
	if start == to then
		return to
	end
	local sIndex = table.indexOf(dList,start)
	local tIndex = table.indexOf(dList,to)
	local dr = tIndex - sIndex
	if dr > 0 and dr < #dList/2 then
		return dList[sIndex+1]
	elseif dr < 0 and dr < -#dList/2 then
		local d = sIndex + 1
		if d > #dList then
			d = 1
		end
		return dList[d]
	else
		local d = sIndex - 1
		if d < 1 then
			d = #dList
		end
		return dList[d]
	end
end

--从配置的速度  转换成 每毫秒移动的距离
function Formula:transformSpeed( speed )
	if speed == 0 then
		return 0
	end

	return math.sqrt(math.pow(FightMap.TILE_W,2)+math.pow(FightMap.TILE_H,2),2)/speed
end

function Formula:getOffsetPos(x,y,posLength)
	local offx,offy = self:getLengthXY(posLength)
	return x + offx,y + offy
end

function Formula:getLengthXY(posLength)
	local x = (posLength - 1) * FightMap.HALF_TILE_W
	local y = (posLength - 1) * FightMap.HALF_TILE_H
	return x,y --  x and y is the same
end

function Formula:toScenePosByLength(mx,my,posLength)
	local x,y = FightDirector:getMap():toScenePos(mx, my)
	return Formula:getOffsetPos(x,y,posLength)
end

function Formula:isInPosRange(mx,my,tx,ty,posLength)
	local dx,dy = tx-mx,ty-my
	if dx < 0 or posLength < dx then
		return false
	end
	if dy < 0 or posLength < dy then
		return false
	end
	return true
end

function Formula:isIntersect(mx,my,mPosLength,tx,ty,tPosLength)
	local dx,dy = tx-mx,ty-my
	if dx < 0 then
		if tPosLength < math.abs(dx) then
			return false
		end
	else
		if mPosLength < dx then
			return false
		end
	end

	if dy < 0 then
		if tPosLength < math.abs(dy) then
			return false
		end
	else
		if mPosLength < dy then
			return false
		end
	end
	return true
end

--根据当前点 目标点  速度    计算出 时间间隔 所能到达的点
function Formula:getNextPos(curX,curY,targetX,targetY,speed,dt)
	local r = math.atan2(targetY-curY,targetX-curX)
	local speedX = speed * math.cos(r)
	local speedY = speed * math.sin(r)

	local dx = speedX*dt
	local dy = speedY*dt

	local nextX,nextY
	if math.abs(targetX - curX) <= math.abs(dx) then
		nextX = targetX
	else
		nextX = curX + dx
	end
	if math.abs(targetY - curY) <= math.abs(dy) then
		nextY = targetY
	else
		nextY = curY + dy
	end
	return nextX,nextY,r
end


--获取免伤
function Formula:getAtkRate( atkRateList,tInfo  )
	if tInfo.defType and atkRateList and atkRateList[tInfo.defType] and atkRateList[tInfo.defType] > 0 then
		return self:getRateValue(atkRateList[tInfo.defType])
	end
	return 1
end

function Formula:getSkillStatus(cInfo,tInfo)
	if tInfo.heroType ~= 1 or tInfo.isHQ then
		-- local cEquip = FightDirector:getTeamEquipLevel(cInfo.team,cInfo.arm)
		-- local tEquip = FightDirector:getTeamEquipLevel(tInfo.team,tInfo.arm)
		local hit = cInfo.level*5 + (cInfo.hit or 0)
		local dodge = tInfo.level*5 + (tInfo.dodge or 0)
		local rate = 100 + ( hit  - dodge)
		if rate < 100 then
			rate = math.max(rate,20)
			if math.random(1,100) > rate then
				return FightCommon.dodge  --闪避了
			end
		end
	end
	if cInfo.crit then
		local crit = cInfo.crit - (tInfo.anti_crit or 0)
		if crit > 0 and math.random(1,10000) <= crit then
			return FightCommon.critical,(1.5+ self:getRateValue(cInfo.crit_factor) )
		end
	end
	return FightCommon.hit
end

function Formula:getDefendRate(level,def)
	local cDef = Formula:getLevelValue(level,"def_factor")
	local defRate =  1 - def/(def + cDef)
	if defRate < 0.1 then
		defRate = 0.1
	end
	return defRate
end

--玩家的全局技能
function Formula:getPlayerSkillValue( player,info,target,level )
	local atkRate = self:getAtkRate(info.atkRate,target.cInfo)
	local defRate =  Formula:getDefendRate(target.cInfo.level,target.cInfo.def)
	local value = -info.eNum*atkRate*defRate
	if info.hurtRate then
		local maxHp = target.cInfo.maxHp
		value = value - math.floor(maxHp*info.hurtRate/100)
	end
	return FightCommon.hit,value,0
end


-- *A治疗B
-- 	B受到治疗量 = A_法术攻击 *治疗技能百份比/10000+治疗技能固定值
--获取技能作用数值
function Formula:getSkillValue( creature,info,target, params )
	local value = 0
	if params.weapon == FightCfg.MAIN_ATTACK then
		value = -creature.cInfo.main_atk
	elseif params.weapon == FightCfg.MINOR_ATTACK then
		value = -creature.cInfo.minor_atk
	end
	return FightCommon.hit,value,0
end

function Formula:getRateValue( value )
	value = value or 0
	return value/10000
end

function Formula:isHurtMagic( info )
	return true
end

function Formula:isScopeContain(scope1,scope2)
	return scope1 == scope2 or scope1 == FightCfg.LAND_FLY or scope2 == FightCfg.LAND_FLY
end

function Formula:getCreatureDistance( creature,target )
	return self:getDistance(creature.mx,creature.my,target.mx,target.my)
end

function Formula:getDistance(mx,my,tx,ty)
	return math.abs(mx - tx) + math.abs(my - ty)
end

Formula.Y_RATE = 0.5
function Formula:getDistanceHalfHeight(mx,my,tx,ty)
	return math.abs(mx - tx) + math.abs(my - ty)*Formula.Y_RATE
end

function Formula:getDisWithPosLength(mx,my,tx,ty,cPosLength,tPosLength)
	cPosLength = cPosLength or 1
	tPosLength = tPosLength or 1
	local dx,dy = tx-mx,ty-my
	if dx > 0 then
		dx = math.max( dx - (cPosLength - 1), 0)
	elseif dx < 0 then
		dx = math.max( -dx -(tPosLength -1), 0)
	end
	if dy > 0 then
		dy = math.max( dy - (cPosLength - 1), 0)
	elseif dy < 0 then
		dy = math.max( -dy -(tPosLength -1), 0)
	end
	return dx + dy*Formula.Y_RATE
end

function Formula:getPreciseDistance(creature,target)
	local mx,my = FightDirector:getMap():getPreciseTilePos(creature)
	local tx,ty = FightDirector:getMap():getPreciseTilePos(target)
	return  self:getDistance(mx,my,tx,ty)
end

function Formula:getDistanceEx(creature, target)
	local curX,curY = creature:getPosition()
	local targetX,targetY = target:getPosition()
	return math.abs(targetX-curX) + math.abs(targetY-curY)
end

function Formula:getDistanceExact( creature,target )
	local curX,curY = creature:getPosition()
	local targetX,targetY = target:getPosition()
	return math.sqrt(math.pow(curX-targetX,2) + math.pow(curY-targetY,2))
end

function Formula:getDistanceByPos( curX,curY,targetX,targetY )
	return math.sqrt(math.pow(curX-targetX,2) + math.pow(curY-targetY,2))
end

--全局坐标到场景坐标
function Formula:globalToScenePos( x,y )
	print("Formula:globalToScenePos",x,y)
	local scene = FightDirector:getScene()
	local sceneScale = scene:getSceneScale()
	local sx,sy = scene:getPosition()
	x,y = x/sceneScale-sx,y/sceneScale-sy
	return x,y
end

--场景坐标到全局坐标
function Formula:sceneToGlobalPos(x,y )
	local scene = FightDirector:getScene()
	local sceneScale = scene:getSceneScale()
	local sx,sy = scene:getPosition()
	x,y = (x+sx)*sceneScale,(y+sy)*sceneScale
	return x,y
end

--把场景坐标 转换到地图坐标
function Formula:toMapPos( x,y )
	return FightDirector:getMap():toMapPos(x, y)
end

--把地图坐标转换成场景坐标
function Formula:toScenePos( mx,my )
	return FightDirector:getMap():toScenePos(mx, my)
end


--数组随机排序
function Formula:randomArray( array,index )
	local list = {}
	count = #array
	index = index or 1
	for i = index,#array do
		local j = math.random(index,count)
		list[#list+1] = array[j]
		array[count],array[j] = array[j],array[count]
		count = count -1
	end

	return list
end


function Formula:getDirectionScaleX(direction)
	if direction >= 20 then
		return -1
	else
		return 1
	end
end

function Formula:getEnemyTeam(team)
	return (team == FightCommon.mate and FightCommon.enemy) or FightCommon.mate
end

--和英雄等级相关的值  魔法抗性 物理抗性等
function Formula:getLevelValue( level,params )
	level = level or 1
	local cfg = HeroCfg:getHeroLevelCfg(level)
	return cfg[params] or 1
end

--职业可站立位置
function Formula:getCreatureStandRange(w,h,margin)
	local heroPos = {}

	local matePos = {}
	local enemyPos = {}
	heroPos[FightCommon.mate] = matePos
	heroPos[FightCommon.enemy] = enemyPos

	for i=1,10 do
		local posInfo = {}
		posInfo.beginPos = {x=0,y=0}
		posInfo.endPos = {x=w,y=h}
		matePos[i] = posInfo

		posInfo = {}
		posInfo.beginPos = {x=0,y=0}
		posInfo.endPos = {x=w,y=h}
		enemyPos[i] = posInfo
	end
	return heroPos
end

function Formula:playHitAudio(skillInfo,target)
	if target.cInfo.material and skillInfo and skillInfo.hitAudio then
		local audioId = ""..target.cInfo.material .."_"..skillInfo.hitAudio

		if AudioMgr:playEffect(audioId) then
			FightCache:retainAudio(audioId)
		end
	end
end

function Formula:calAckRange(magicCfg,creature,target)
	local srcMX = 0
	local srcMY = 0
	if magicCfg.hitAreaType == 0 then --全场
		return Range.new(1000)
	elseif magicCfg.hitAreaType == 1 then --以自身为中心
		srcMX = creature.mx
		srcMY = creature.my
	elseif magicCfg.hitAreaType == 2 then --自身
		return nil
	elseif magicCfg.hitAreaType == 3 then --当前目标
		return nil
	elseif magicCfg.hitAreaType == 4 then --当前目标为中心
		srcMX = target.mx
		srcMY = target.my
	elseif magicCfg.hitAreaType == 5 then --目标所在方向

	elseif magicCfg.hitAreaType == 6 then --自己的坐标便宜

	elseif magicCfg.hitAreaType == 7 then --目标的坐标便宜

	end

end

return Formula.new()