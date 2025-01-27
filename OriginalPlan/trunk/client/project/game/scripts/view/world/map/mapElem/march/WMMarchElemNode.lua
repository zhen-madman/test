local WMMarchElemNode = class('WMMarchElemNode', function() return display.newNode(); end)
local WMMarchUnits = game_require('view.world.map.mapElem.march.WMMarchUnits')

function WMMarchElemNode:ctor(map, marchController)
	--! WorldMap
	self._map = map
	--! WMMarchController
	self._marchController = marchController
	self:setPosition(0,0)
	self._marchController:getMarchNode():addChild(self, 0)
	self:retain()
end

function WMMarchElemNode:createArrows(srcBlockPos, destBlockPos)
	self._srcBlockPos = srcBlockPos
	self._destBlockPos = destBlockPos

	local srcPos = self._map:getWorldPosFromBlockPos(srcBlockPos)
	local destPos = self._map:getWorldPosFromBlockPos(destBlockPos)

	local tempBlock = self._map:getBlockPosFromWorldPos(srcPos)
	assert(srcBlockPos.x == tempBlock.x and srcBlockPos.y == tempBlock.y)
	tempBlock = self._map:getBlockPosFromWorldPos(destPos)
	assert(destBlockPos.x == tempBlock.x and destBlockPos.y == tempBlock.y)

	self._srcPos = srcPos
	self._destPos = destPos
	self._orgDestPos = destPos

	local dx = destPos.x-srcPos.x
	local dy = destPos.y-srcPos.y
	local dist = math.sqrt(dx*dx+dy*dy)
	local interval = 40
	local px = destPos.x
	local py = destPos.y
	local pp = cc.pSub(destPos,srcPos):normalize()
	local pa = MathUtil:RadToAngle(pp:getAngle())
	local count = dist/interval
	local tempDestPos = self._destPos
	for k=1, count-1 do
		local pz = srcPos:lerp(destPos, (interval*k)/dist)
		tempDestPos = ccp(pz.x,pz.y);
	end
	self._destPos = tempDestPos

	self._units = WMMarchUnits.new(self._map, self, -pa, self._marchController:getBulletNode())
	self._units:init()
	self._lastSelected = false
end

function WMMarchElemNode:getSrcBlockPos()
	return self._srcBlockPos
end

function WMMarchElemNode:getDestBlockPos()
	return self._destBlockPos
end

function WMMarchElemNode:getOrgDestPos()
	return self._orgDestPos
end

function WMMarchElemNode:update(dt)
	self._units:update(dt)
	if self._hasSelected then
		local x,y = self._units:getPosition()
		local dx = x-self._unitsPos.x
		local dy = y-self._unitsPos.y
		local adx = math.abs(dx)
		local ady = math.abs(dy)
		self._unitsPos = ccp(x,y)
		self._map:moveBy(-dx,-dy)
		self._lastSelected = true;
	else
		if self._lastSelected == true then
			self._map:updateInfoControllerMoveEnd()
		end
		self._lastSelected = false
	end
end

function WMMarchElemNode:hasSelected()
	return self._units:hasSelected()
end
function WMMarchElemNode:unSelect()
	self._hasSelected = false
	self._units:unSelect()
end
function WMMarchElemNode:selectAt()
	self._units:selectAt()
	local x,y = self._units:getPosition()
	self._unitsPos = ccp(x,y)
	self._hasSelected = true
	self._lastSelected = false
end

function WMMarchElemNode:setUnselect()
	self._units:setUnselect()
end

function WMMarchElemNode:isSelected()
	return self._units:isSelected()
end

function WMMarchElemNode:isInBlockPos(blockPos)
	local poss = self._units:getUnitPoss();
	if poss == nil then
		return false
	end

--	for k,v in pairs(poss) do
--		local x1,y1 = v.pz.x, v.pz.y
--		local wpos = self._units:convertToWorldSpace(ccp(x1,y1))
--		local pos = self._units:getParent():convertToNodeSpace(wpos)
--		local x = pos.x
--		local y = pos.y
		local x,y = self._units:getPosition()
		local block = self._map:getBlockPosFromWorldPos(ccp(x,y))
		print("IsInBlockPos: ", block.x, block.y, blockPos.x, blockPos.y)
		if block.x == blockPos.x and block.y == blockPos.y then
			return true
		end
--	end

	return false
end

function WMMarchElemNode:accelerate()
	self._units:accelerate();
end

function WMMarchElemNode:isFinish()
	return self._units:isFinish()
end

function WMMarchElemNode:isBackToHome()
	return self._units:isBackToHome()
end

function WMMarchElemNode:backToHome()
	self._units:backToHome()
end

function WMMarchElemNode:getSrcPos()
	return self._srcPos
end

function WMMarchElemNode:getDestPos()
	return self._destPos
end

function WMMarchElemNode:dispose()
	self._units:dispose()
	self:release()
	self:removeFromParent()
end

return WMMarchElemNode