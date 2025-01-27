
--

local FloatStunt = class("FloatStunt",Stunt)

function FloatStunt:ctor( gId )
	Stunt.ctor(self,gId)
end

function FloatStunt:init(creature,stuntId,target,time)
	Stunt.init(self,creature,stuntId,target,time)
	if self.info.sType < 100 then
		self.stuntElem = creature.avContainer
	else
		self.stuntElem = target.avContainer
	end
end

function FloatStunt:start()
	self.lastY = 0
	self.curScale = 0
	self.info.range = 50
	self.info.dis = 100


	Stunt.start(self)
	local t = math.sqrt(self.info.range)
	self.rateA = math.pow(0.5*self.totalTime/t,2)
end

function FloatStunt:run( dt )
	local curY = self:_getY(self.curTime)

	local y = self.stuntElem:getPositionY()
	local addY = (curY - self.lastY)
	y = y + addY
	self.lastY = curY
	self.stuntElem:setPositionY(y)

	local addS = addY/200
	local newScale = self.curScale + addS

	local scale = self.stuntElem:getScale()
	scale = scale + addS
	self.stuntElem:setScale(scale)
	self.curScale = newScale


	Stunt.run(self,dt)
end

function FloatStunt:_getY( t )
	return -math.pow(t- self.totalTime/2,2)/self.rateA + self.info.range
end

function FloatStunt:dispose()
	if self.lastY ~= 0 then
		local y = self.stuntElem:getPositionY()
		y = y  - self.lastY
		self.stuntElem:setPositionY(y)
	end
	if self.curScale ~= 0 then
		local scale = self.stuntElem:getScale()
		scale = scale - self.curScale
		self.stuntElem:setScale(scale)
	end
	Stunt.dispose(self)
end

return FloatStunt