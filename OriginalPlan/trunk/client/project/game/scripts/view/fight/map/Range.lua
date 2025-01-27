
--
local pairs = pairs
local ipairs = ipairs
local table = table

--基于格子  的 不规则的范围

local Range = class("Range")

function Range:ctor( list )
	self:init(list)
	-- body
end

function Range:init(list)
	if not list then
		self.maxDis = -1
		return
	end
	if #list <= 2 then
		self.maxDis = list[1]
		self.minDis = list[2] or 0
	else
		self.w = list[1]
		self.h = list[2]
		self.maxIndex = self.h*self.w - 1
		self.sourceIndex = list[3]
		self.sourcePos = self:getPos(self.sourceIndex)


		-- self.exclude = {}
		self.excludeList = list

		self.excludeMap = {}
		for i=4,#list do
			self.excludeMap[list[i]] = true
		end
		-- for i = 4,#list do
		-- 	self.exclude[#self.exclude + 1] = self:getPos(list[i])   --排除的格子
		-- end
		if #self.excludeList == 3 then
			self.isWhole = true  --整个w * h 区域
		else
			self.isWhole = false
		end
		--self.isWhole = true
	end
end


--判定目标是否在 源对象 的这个范围内
function Range:isTargetIn(source,target,isPrecise,direction)
	if (source.posLength and source.posLength > 1 ) or (target.posLength and target.posLength > 1) then
		return self:_isTargetInPosList(source,target,isPrecise,direction)
	end

	local targetX,targetY
	-- if isPrecise then   --是否 需要获取精确的格子 坐标    --暂时全部不需要精确格子了
	-- 	targetX,targetY = FightDirector:getMap():getPreciseTilePos(target)
	-- else
		targetX,targetY = target.mx,target.my
	-- end

	if self.maxDis then
		return self:_isInDis(source.mx,source.my,targetX,targetY)
	end

	return false
--	direction = direction or source:getDirection()
--	local startPos,endPos = self:getBorderPos(source,direction)
--	return self:_isIn(source,startPos,endPos,targetX,targetY,direction)
end

function Range:_isTargetInPosList(source,target,isPrecise,direction)
	local cPosLength = source.posLength
	local tPosLength = target.posLength
	direction = direction or source:getDirection()

	local targetX,targetY

	-- if isPrecise and tPosLength == 1 then   --是否 需要获取精确的格子 坐标
	-- 	targetX,targetY = FightDirector:getMap():getPreciseTilePos(target)
	-- else
		targetX,targetY = target.mx,target.my
	-- end

	if self.maxDis then
		return self:_isPosInDisList(source.mx,source.my,targetX,targetY,cPosLength,tPosLength)
	end

	local startPos,endPos = self:getBorderPos(source,direction)
	if cPosLength > 1 then
		endPos.mx = endPos.mx + (cPosLength -1)
		endPos.my = endPos.my + (cPosLength -1)
		for i=0,cPosLength-1 do
			for j=0,cPosLength-1 do
				local s = {mx = source.mx + i ,my = source.my + j}
				if tPosLength > 1 then
					if self:_isInList(s,startPos,endPos,targetX,targetY,tPosLength,direction) then
						return true
					end
				else
					if self:_isIn(s,startPos,endPos,targetX,targetY,direction) then
						return true
					end
				end
			end
		end
		return false
	elseif tPosLength > 1 then
		if self:_isInList(source,startPos,endPos,targetX,targetY,tPosLength,direction) then
			return true
		end
		return false
	else
		return self:_isIn(source,startPos,endPos,targetX,targetY,direction)
	end
end

function Range:_isInDis(mx,my,tx,ty)
	local dis = Formula:getDistanceHalfHeight(mx,my,tx,ty)
	if dis >= self.minDis and dis <= self.maxDis then
		return true
	else
		return false
	end
end

function Range:_isPosInDisList(mx,my,tx,ty,cPosLength,tPosLength)
	local dis = Formula:getDisWithPosLength(mx,my,tx,ty,cPosLength,tPosLength)
	if dis >= self.minDis and dis <= self.maxDis then
		return true
	else
		return false
	end
end

function Range:_isInList(source,startPos,endPos,targetX,targetY,tPosLength,direction)
	for i=0,tPosLength-1 do
		local tx = targetX + i
		for j=0,tPosLength-1 do
			local ty = targetY + j
			if self:_isIn(source,startPos,endPos,tx,ty,direction) then
				return true
			end
		end
	end
	return false
end


function Range:_isIn(source,startPos,endPos,targetX,targetY,direction)
	if targetX >= startPos.mx and targetX <= endPos.mx and targetY >= startPos.my and targetY <= endPos.my then  --在范围内
		if self.isWhole then
			return true
		else
			return self:posInRange(targetX,targetY,source,direction)
		end
	end
	return false
end

function Range:posInRange( mx,my,source,direction )
	local index = self:scenePosToRangIndex(mx,my,source,direction)
	-- print("位置。。。range。。index",index,targetX,targetY)
	return self:indexInRange(index)
end

function Range:indexInRange( index )
	if index < 0 or index > self.maxIndex or self.excludeMap[index] then
		--print("点。。。。。",index,pos.mx,pos.my,self.w,self.h)
		return false
	else
		return true
	end
end

function Range:getPos(index)
	return {mx = index%(self.w ), my = math.floor( index/ (self.w))}
end

function Range:getIndex( x,y )
	return y*self.w + x
end

function Range:scenePosToRangIndex( mx,my,source,direction )
	local dx,dy = mx - source.mx, my - source.my
	local index
	if direction == Creature.RIGHT_DOWN or direction == Creature.RIGHT then
		index = self.w*dy + dx
	elseif direction == Creature.LEFT_DOWN or direction == Creature.DOWN then
		index = self.w*-dx + dy
	elseif direction == Creature.RIGHT_UP or direction == Creature.UP then
		index = self.w*dx - dy
	elseif direction == Creature.LEFT_UP or direction == Creature.LEFT then
		index = self.w*-dy - dx

	end

	index = index + self.sourceIndex
	return index
end

--返回开始点  和 结束点   就可得一个完整的矩形
function Range:getBorderPos(source,direction)
	local startPos,endPos = {},{}
	local sourcePos = self.sourcePos
	startPos.mx, startPos.my = -sourcePos.mx, -sourcePos.my
	if direction == Creature.RIGHT_DOWN or direction == Creature.RIGHT then
		endPos.mx, endPos.my = startPos.mx + self.w - 1, startPos.my + self.h - 1
		startPos.mx, startPos.my = -sourcePos.mx, -sourcePos.my
	elseif direction == Creature.LEFT_DOWN or direction == Creature.DOWN then
		endPos.mx, endPos.my = startPos.mx + self.w - 1, startPos.my
		startPos.mx, startPos.my = startPos.mx, startPos.my + self.h - 1
	elseif direction == Creature.RIGHT_UP or direction == Creature.UP then
		endPos.mx, endPos.my = startPos.mx, startPos.my + self.h - 1
		startPos.mx, startPos.my = startPos.mx + self.w - 1, startPos.my
	elseif direction == Creature.LEFT_UP or direction == Creature.LEFT then
		endPos.mx, endPos.my = -sourcePos.mx, -sourcePos.my
		startPos.mx, startPos.my = startPos.mx + self.w - 1, startPos.my + self.h - 1
	end
	--print("pos1",startPos.mx,startPos.my,endPos.mx,endPos.my)
	startPos = self:_getPosWitchSource(startPos,source,direction)
	endPos = self:_getPosWitchSource(endPos,source, direction)
	--print("pos2",startPos.mx,startPos.my,endPos.mx,endPos.my)
	return startPos,endPos
end

function Range:getScenePosByIndex( index,source,direction )
	local pos = self:getPos(index)
	pos.mx = pos.mx - self.sourcePos.mx
	pos.my = pos.my - self.sourcePos.my
	return self:_getPosWitchSource(pos,source,direction)
end

function Range:_getPosWitchSource( pos,source,direction )
	-- if source.info and source.info.effectType == 1 then
	-- 	print(source.mx,source.my,direction)
	-- end

	local newPos = self:_getPosWithDirection(pos,direction)
	--print("pos2",pos.mx,pos.my,newPos.mx,newPos.my)
	newPos.mx = newPos.mx + source.mx
	newPos.my = newPos.my + source.my
	return newPos
end

function Range:_getPosWithDirection(pos,direction)
	local newPos = {}
	-- print(direction)
	if direction == Creature.RIGHT_DOWN or direction == Creature.RIGHT then
		newPos.mx, newPos.my = pos.mx, pos.my
	elseif direction == Creature.LEFT_DOWN or direction == Creature.DOWN then
		newPos.mx, newPos.my = -pos.my, pos.mx
	elseif direction == Creature.RIGHT_UP or direction == Creature.UP then
		newPos.mx, newPos.my = pos.my, -pos.mx
	elseif direction == Creature.LEFT_UP or direction == Creature.LEFT then
		newPos.mx, newPos.my = -pos.mx, -pos.my
	end
	return newPos
end


function Range:removeCenter()
	local x,y = self.sourcePos.mx+1,self.sourcePos.my
	local index = self:getIndex(x,y)
	self.excludeMap[index] = true
	-- local removeList = {index}

	x,y = self.sourcePos.mx-1,self.sourcePos.my
	index = self:getIndex(x,y)
	self.excludeMap[index] = true
	-- removeList[#removeList+1] = index

	x,y = self.sourcePos.mx,self.sourcePos.my+1
	index = self:getIndex(x,y)
	self.excludeMap[index] = true
	-- removeList[#removeList+1] = index

	x,y = self.sourcePos.mx,self.sourcePos.my-1
	index = self:getIndex(x,y)
	self.excludeMap[index] = true
	-- removeList[#removeList+1] = index

	-- for i=#self.excludeList, 1,-1 do
	-- 	if self.excludeList[i] == index then
	-- 		table.remove(self.excludeList,i)
	-- 	end
	-- end
end


return Range