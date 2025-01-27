local TargetSearchDelegate = class("TargetSearchDelegate")
local CircleRange = game_require("view.fight.common.CircleRange")
local RectRange = game_require("view.fight.common.RectRange")
function TargetSearchDelegate:ctor( career,team,atkScope)
	self.career = career
	self.team = team
	self.atkScope = atkScope
end

function TargetSearchDelegate:getRelativeCoordinate( mx,my, pos_list,flag,dir,srcX,srcY)
	local new_pos_list = {}
	local angle = 0

	if dir then
		angle = Formula:getAngleByDirection(dir)*180/math.pi
	else
		angle = self:getAngle(srcX,srcY,mx,my)
	end

	angle = angle - 45
	for k,v in pairs(pos_list) do
		local x1=math.cos(angle)*v[1]-math.sin(angle)*v[2]+mx
		local y1=math.cos(angle)*v[2]+math.sin(angle)*v[1]+my
		table.insert(new_pos_list,{mx =math.floor(x1),my =math.floor(y1)})
	end
	return new_pos_list
end

function TargetSearchDelegate:getAbsoluteCoordinate( mx,my, pos_list)
	local newPos_list = {}
	local count = #pos_list
	if triggerTime then
		count = math.floor(#pos_list/triggerTime)
	end
	for k,v in ipairs( pos_list ) do
		local x,y = mx+v[1],my+v[2]
		table.insert(newPos_list,{mx = x,my = y})
	end
	return newPos_list
end

--flag 1:相对  2：绝对
function TargetSearchDelegate:getDiscretePosTargetList( mx,my, pos_list,flag,dir,srcX,srcY )
	local new_pos_list = {}
	if flag == 1 then
		new_pos_list = self:getRelativeCoordinate(mx,my, pos_list,flag,dir,srcX,srcY)
	elseif flag == 2 then
		new_pos_list = self:getAbsoluteCoordinate(mx,my, pos_list)
	end
--	local target_list = {}
--	local isInPos = function( list,pos )
--			for k,v in pairs(list) do
--				if Formula:isInPosRange(v.mx,v.my,pos.mx,pos.my,v.posLength or 1) then
--					return true
--				end
--			end
--			return false
--		end

--	local memlist = self:targetList()
--	for k,v in pairs(memlist) do
--		if isInPos(new_pos_list,v) then
--			table.insert(target_list,v)
--		end
--	end
--	return target_list
	return new_pos_list
end

function TargetSearchDelegate:getHitTarget(magicId,creature,target)
	if not creature then
		return {}
	end

	local info = FightCfg:getMagic(magicId)
	if info == nil then
		return {}
	end
	local x,y = creature:getTruePosition()
	local mx,my = FightDirector:getMap():toMapPos(x,y)
	local targetList = nil
	local targetNum = (info.targetNum or 1)*info.triggerTimes
	local ackRange = nil
		if info.hitAreaType == 0 then --全场
			local x,y = creature:getTruePosition()
			local mx,my = FightDirector:getMap():toMapPos(x,y)
			ackRange = CircleRange.new({mx,my,10000})
		elseif info.hitAreaType == 1 then --以自身为中心

			if info.rangeType ==  0 then
				ackRange = CircleRange.new({mx,my,info.hitGridRange})
			elseif info.rangeType ==  1 then
				local leftDown = { mx = 0,my =0}
				local rightTop = { mx = 0,my =0}
				local centerPos = {mx = mx,my = my}
				leftDown.mx = centerPos.mx -info.hitGridRange[1]/2
				leftDown.my = centerPos.my -info.hitGridRange[2]/2
				rightTop.mx = centerPos.mx +info.hitGridRange[1]/2
				rightTop.my = centerPos.my +info.hitGridRange[2]/2
				ackRange = RectRange.new({leftDown.mx,leftDown.my,rightTop.mx,rightTop.my})
			end
		elseif info.hitAreaType == 2 then --自身
			return {creature}
		elseif info.hitAreaType == 3 then --当前目标
			return {target}
		elseif info.hitAreaType == 4 then --当前目标为中心
			if info.rangeType ==  1 then
				local leftDown = { mx = 0,my =0}
				local rightTop = { mx = 0,my =0}
				local x1,y1 = target:getTruePosition()
				local mx1,my1 = FightDirector:getMap():toMapPos(x1,y1)
				local centerPos = {mx = mx1,my = my1}
				leftDown.mx = centerPos.mx -info.hitGridRange[1]/2
				leftDown.my = centerPos.my -info.hitGridRange[2]/2
				rightTop.mx = centerPos.mx +info.hitGridRange[1]/2
				rightTop.my = centerPos.my +info.hitGridRange[2]/2
				ackRange = RectRange.new({leftDown.mx,leftDown.my,rightTop.mx,rightTop.my})
			end
		elseif info.hitAreaType == 5 then --目标所在方向
			local x1,y1 = target:getTruePosition()
			local mx1,my1 = FightDirector:getMap():toMapPos(x1,y1)
			if info.rangeType ==  1 then
				targetList =  TargetSearchDelegate:getDirTargets( mx,my,
													mx1,my1,info.hitGridRange[1],info.hitGridRange[2])
			end
		elseif info.hitAreaType == 6 then --自己的坐标偏移
			if info.relativeOffPos then
				targetList = self:getDiscretePosTargetList( mx,my, info.relativeOffPos,1,creature:getAtkDirection())
			elseif info.absoluteOffPos then
				targetList = self:getDiscretePosTargetList( mx,my, info.absoluteOffPos,1)
			end
			return targetList
		elseif info.hitAreaType == 7 then --目标的坐标偏移
			local x1,y1 = target:getTruePosition()
			local mx1,my1 = FightDirector:getMap():toMapPos(x1,y1)
			if info.relativeOffPos then
				targetList = self:getDiscretePosTargetList( mx1,my1, info.relativeOffPos,2,nil,mx,my)
			elseif info.absoluteOffPos then
				targetList = self:getDiscretePosTargetList( mx1,my1, info.absoluteOffPos,2)
			end
			return targetList
		end

	if ackRange then  --检测攻击范围内的目标
		targetList = self:getMagicTargetInRange( creature,info,atkRange)
	end

	return self:targetsfiltrAndSort(targetList,info,target,creature)
end

function TargetSearchDelegate:getHitTargetEx(info,creature,target,srcPos)
	if not creature then
		return {}
	end

	if info == nil then
		return {}
	end

	local localpos = {}
	if creature then
		local x,y = creature:getTruePosition()
		local mx,my = FightDirector:getMap():toMapPos(x,y)
		localpos = {mx,my = mx,my}
	end
	if srcPos then
		localpos.mx = srcPos.mx
		localpos.my = srcPos.my
	end

	local targetList = nil
	local targetNum = info.targetNum or 1
	local ackRange = nil
		if info.hitAreaType == 0 then --全场
			ackRange = CircleRange.new({localpos.mx,localpos.my,10000})
		elseif info.hitAreaType == 1 then --以自身为中心
			if info.rangeType ==  0 then
				ackRange = CircleRange.new({localpos.mx,localpos.my,info.hitGridRange})
			elseif info.rangeType ==  1 then
				local leftDown = { mx = 0,my =0}
				local rightTop = { mx = 0,my =0}
				local centerPos = {mx = localpos.mx,my = localpos.my}
				leftDown.mx = centerPos.mx -info.hitGridRange[1]/2
				leftDown.my = centerPos.my -info.hitGridRange[2]/2
				rightTop.mx = centerPos.mx +info.hitGridRange[1]/2
				rightTop.my = centerPos.my +info.hitGridRange[2]/2
				ackRange = RectRange.new({leftDown.mx,leftDown.my,rightTop.mx,rightTop.my})
			end
		elseif info.hitAreaType == 2 then --自身
			return {srcPos}
		elseif info.hitAreaType == 3 then --当前目标
			return {target}
		elseif info.hitAreaType == 4 then --当前目标为中心
			if info.rangeType ==  1 then
				local leftDown = { mx = 0,my =0}
				local rightTop = { mx = 0,my =0}
				local x,y = target:getTruePosition()
				local mx,my = FightDirector:getMap():toMapPos(x,y)
				local centerPos = {mx,my = mx,my}
				leftDown.mx = centerPos.mx -info.hitGridRange[1]/2
				leftDown.my = centerPos.my -info.hitGridRange[2]/2
				rightTop.mx = centerPos.mx +info.hitGridRange[1]/2
				rightTop.my = centerPos.my +info.hitGridRange[2]/2
				ackRange = RectRange.new({leftDown.mx,leftDown.my,rightTop.mx,rightTop.my})
			end
		elseif info.hitAreaType == 5 then --目标所在方向
			if info.rangeType ==  1 then
				local x,y = target:getTruePosition()
				local mx,my = FightDirector:getMap():toMapPos(x,y)
				targetList =  TargetSearchDelegate:getDirTargets( localpos.mx,localpos.my,
													mx,my,info.hitGridRange[1],info.hitGridRange[2])
			end
		elseif info.hitAreaType == 6 then --自己的坐标偏移
			if info.relativeOffPos then
				targetList = self:getDiscretePosTargetList( localpos.mx,localpos.my, info.relativeOffPos,1,creature:getAtkDirection())
			elseif info.absoluteOffPos then
				targetList = self:getDiscretePosTargetList( localpos.mx,localpos.my, info.absoluteOffPos,2)
			end
			return targetList
		elseif info.hitAreaType == 7 then --目标的坐标偏移
			local x,y = target:getTruePosition()
			local mx,my = FightDirector:getMap():toMapPos(x,y)
			if info.relativeOffPos then
				targetList = self:getDiscretePosTargetList( mx,my, info.relativeOffPos,1,nil,localpos.mx,localpos.my)
			elseif info.absoluteOffPos then
				targetList = self:getDiscretePosTargetList( mx,my, info.absoluteOffPos,2)
			end
			return targetList
		end

	if ackRange then  --检测攻击范围内的目标
		targetList = self:getMagicTargetInRange( creature,info,ackRange)
	end
	return self:targetsfiltrAndSort(targetList,info,target,creature)
end

function TargetSearchDelegate:getMagicTargetInRange( creature,magicInfo,range)
	--print("POPOPOPOPOPOPOPO444444444444444",magicInfo.targetType,self.team,FightCommon.mate,FightCommon.enemy,dump(range))
	local targetList = {}

	if magicInfo.targetType == 3 then --敌人
		if self.team == FightCommon.mate then
			targetList = FightDirector:getScene():getTeamList(FightCommon.enemy)
		else
			targetList = FightDirector:getScene():getTeamList(FightCommon.mate)
		end
	elseif magicInfo.targetType == 2 then --队友
		targetList = FightDirector:getScene():getTeamList(self.team)
	elseif magicInfo.targetType == 4 then --全部
		targetList = FightScene:getCreatureList()
	elseif magicInfo.targetType == 1 then --自己
		targetList = {creature}
	end

	if TEST_MAGIC == magicInfo.id then
		print("magic_____getMagicTargetInRange__targets:",#targetList)
	end

	return self:_getTargetInRangeByScope(targetList,range,magicInfo.effect,magicId)
end

function TargetSearchDelegate:_getTargetInRangeByScope(list,range,scope,magicId)
	local targetList = {}
	for i,target in pairs(list) do
		if self:_canSkillSearch(target,scope) and range:isTargetIn(target) then
			targetList[#targetList + 1 ] = target
		end
	end
	if TEST_MAGIC == magicId then
		print("magic______getTargetInRangeByScope__targets:",#targetList,dump(range))
	end
	return targetList
end

function TargetSearchDelegate:_canSkillSearch(target,atkScope)
	if target:isDie() then
		return false
	end
	if not Formula:isScopeContain(atkScope,target.cInfo.scope)  then
		return false
	end
	return true
end

function TargetSearchDelegate:getDirTargets(srcMx,srcMy,destMx,destMy,dx,dy)
	local targets = {}
	local allPos = self:getDirPos(srcMx,srcMy,destMx,destMy,dx,dy)
	local isHasPos = function( pos ,allPos )
			for k,v in ipairs(allPos) do
				if pos.mx == v.mx and pos.my == v.my then
					return true
				end
			end
			return false
		end
	local list = self:targetList()
	for k,target in pairs(list) do
		if not target:isDie() and isHasPos(target,allPos) then
			table.insert(targets,target)
		end
	end
	return targets
end

function TargetSearchDelegate:targetList()
	local team = FightCommon.enemy
	if self.team == FightCommon.left then
		team = FightCommon.right
	else
		team = FightCommon.left
	end
	if self.career == 5 then
		team = self.team
	end
	return FightDirector:getScene():getTeamList( team )
end

function TargetSearchDelegate:getDirPos(srcMx,srcMy,destMx,destMy,dx,dy,isTargetPos)
	local angle = self:getAngle(srcMx,srcMy,destMx,destMy)
	local leftDownMx = destMx
	local leftDownMy = destMy-dy/2
	if not isTargetPos then
		leftDownMx = srcMx
		leftDownMy = srcMy-dy/2
	end
	local posS = {}
	for x =leftDownMx,leftDownMx+dx do
		for y = leftDownMy,leftDownMy+dy do
			local x1=math.cos(angle)*x-math.sin(angle)*y
			local y1=math.cos(angle)*y+math.sin(angle)*x
			table.insert(posS,{mx = math.floor(x1+0.5),my = math.floor(y1+0.5)})
		end
	end
	return posS
end

function TargetSearchDelegate:getAngle(px1, py1, px2, py2)
    --两点的x、y值
    x = px2-px1
    y = py2-py1
    hypotenuse = math.sqrt(Math.pow(x, 2)+math.pow(y, 2));
    --斜边长度
    cos = x/hypotenuse
    radian = Math.acos(cos)
    --求出弧度
    angle = 180/(Math.PI/radian)
    --用弧度算出角度
    if  y<0  then
            angle = -angle
    elseif ((y == 0) and (x<0)) then
            angle = 180
    end
    return angle
end


--flag  nil:最近目标,1:最近的英雄,2：最近的受伤单位
function TargetSearchDelegate:getRecentlyTarget( list,existList,srcMx,srcMy,flag)
	local target_list = {}
	local disTable = {}
	local items = {}
	for k,v in pairs(list) do
		if table.indexOf(existList,v) == -1  then
			if (not flag) or(flag == 1 and table.indexOf(HeroCfg.heroCareers,v.cInfo.career) ~= -1) or (flag == 2 and v.cInfo.hp< v.cInfo.maxHp)then
				local dis = MathUtil.Distance(srcMx,srcMy,v.mx,v.my)
				table.insert(disTable,dis)
				items[dis] = v
			end
		end
	end

	table.sort(disTable)
	local retTargets = {}
	for k,v in pairs(disTable) do
		table.insert(retTargets,items[v])
	end
	return retTargets
end

function TargetSearchDelegate:targetsfiltrAndSort( targetList, info,target,creature )
	local targets = {}
	if targetList then
		for i = #targetList,1,-1 do
			local hitTarget = targetList[i]
			if hitTarget:isDie() or not hitTarget:canBeHit() or not FightCfg:isHasCareer( info,hitTarget.cInfo.career ) then
				table.remove(targetList,i)
			end
		end

		local addTarget = function( list,target,flag )
				if flag and #list>=info.targetNum then
					return list
				end
				table.insert(list,target)
				return list
			end

		local getIndex = function(indexs,maxNum)
				math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
				index = math.random(1,maxNum)
				while( table.indexOf(indexs,index)>0)
				do
				   index = math.random(1,maxNum)
				end
				return index
			end

		local randomTargets = function( list,num )
				local targets = {}
				local indexs = {}
				if num > #list then
					num = #list
				end
				for k = 1,num do
					local index = getIndex(indexs,#list)
					table.insert(targets,list[index])
					table.insert(indexs,index)
					if #targets>=num then
						return targets
					end
				end
				return targets
			end

		--按照职业优先级排序
		local isHasTarget = function( target,list)
			return table.indexOf(list,target) >0
		end

		local getCenterPos = function( hitAreaType,src,dest )
					local srcMx = 0
					local srcMy = 0
					if info.hitAreaType == 1 or info.hitAreaType == 5 then
						srcMx = src.mx
						srcMy = src.my
					elseif info.hitAreaType == 4 then
						srcMx = dest.mx
						srcMy = dest.my
					end
				return srcMx,srcMy
			end
		if info.filtrTypes then
			for k,v in ipairs(info.filtrTypes) do
				if v == 0 then --无需过滤（补齐攻击对象的数量）
					for k1,tempTarget in ipairs(targetList) do
						if table.indexOf(targets,tempTarget) == -1 then
							targets = addTarget(targets,tempTarget,true)
						end
					end
				elseif v == 1 then -- 受伤的目标
					for k1,tempTarget in ipairs(targetList) do
						if table.indexOf(targets,tempTarget) == -1 and tempTarget.cInfo.hp< tempTarget.cInfo.maxHp then
							targets = addTarget(targets,tempTarget,true)
						end
					end
				elseif v == 2 then --最近的目标
					local srcMx,srcMy = getCenterPos(hitAreaType,creature,target)
					if info.hitAreaType == 1 or info.hitAreaType == 4 or info.hitAreaType == 5 then
						local templist = self:getRecentlyTarget( targetList,targets,srcMx,srcMy)
						for k,v in ipairs(templist) do
							targets = addTarget(targets,v,true)
						end
					end

				elseif v == 3 then --最近英雄
					local srcMx,srcMy = getCenterPos(hitAreaType,creature,target)
					if info.hitAreaType == 1 or info.hitAreaType == 4 or info.hitAreaType == 5 then
						local templist = self:getRecentlyTarget( targetList,targets,srcMx,srcMy,1)
						for k,v in ipairs(templist) do
							targets = addTarget(targets,v,true)
						end
					end
				elseif v == 4 then --随机英雄
					for k1,tempTarget in ipairs(targetList) do
						if table.indexOf(targets,tempTarget) == -1 and table.indexOf(HeroCfg.heroCareers,cInfo.career) ~= -1 then
							targets = addTarget(targets,tempTarget)
						end
					end
					targets = randomTargets(targets,info.targetNum)

				elseif v == 5 then --随机单位
					for k1,tempTarget in ipairs(targetList) do
						if table.indexOf(targets,tempTarget) == -1 then
							targets = addTarget(targets,tempTarget)
						end
					end
					targets = randomTargets(targets,info.targetNum)
				elseif v == 6 then --最近受伤
					local srcMx,srcMy = getCenterPos(hitAreaType,creature,target)
					if info.hitAreaType == 1 or info.hitAreaType == 4 or info.hitAreaType == 5 then
						local templist = self:getRecentlyTarget( targetList,targets,srcMx,srcMy,2)
						for k,v in ipairs(templist) do
							targets = addTarget(targets,v,true)
						end
					end
				elseif v == 7 then --职业
					for k1,career in ipairs(info.filtrParams) do
						for k1,tempTarget in ipairs(targetList) do
							if tempTarget.cInfo.career == career then
								targets = addTarget(targets,tempTarget,true)
							end
						end
					end
				end

			end
		end
	end

	return targets
end

return TargetSearchDelegate