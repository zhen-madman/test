--
--

local YShakeStunt = class("YShakeStunt",Stunt)




function YShakeStunt:ctor(gId)
	Stunt.ctor(self,gId)
end

function YShakeStunt:init(creature,stuntId,target,time)
	Stunt.init(self,creature,stuntId,target,time)
	if self.info.sType == 0 then  --震屏  获取到场景
		self.stuntElem = FightDirector:getScene()
	elseif self.info.sType < 100 then
		self.stuntElem = creature.avContainer
	else
		self.stuntElem = target.avContainer
	end
end


function YShakeStunt:start()
	Stunt.start(self)

	self.speed = math.pi/(self.totalTime/self.info.per)
	self.curR = math.pi
	self.dy = 0

	self.range = self.info.range
	--self.scaleRate = (self.info.scale or 0)/1000
	--self.addScale = 0

	FightEngine:removeCreatureStunt(self.creature,self.info.sType)
end

function YShakeStunt:run( dt )

	-- local newR = self.curTime*self.speed
	-- if newR - self.curR > 90 then
	-- 	newR = self.curR - self.curR%90 + 90
	-- end
	self.curR = self.curR + 30* self.speed

	-- local curScale = self.stuntElem:getScale()
	-- curScale = curScale - self.addScale
	-- local newScale = self.scaleRate*(self.curR%math.pi)/math.pi
	-- self.addScale = newScale
	-- curScale = curScale + newScale
	-- self.stuntElem:setScale(curScale)

	local posX,posY = self.stuntElem:getPosition()
	posY = posY - self.dy

	self.dy = math.floor(math.cos(self.curR) * self.range + 0.5)

	self.stuntElem:setPositionY(posY+self.dy)


	Stunt.run(self,dt)
end

function YShakeStunt:dispose()
	-- local curScale = self.stuntElem:getScale()
	-- curScale = curScale - self.addScale
	-- self.stuntElem:setScale(curScale)

	local posX,posY = self.stuntElem:getPosition()
	posY = posY - self.dy
	self.stuntElem:setPositionY(posY)
	Stunt.dispose(self)

end

return YShakeStunt