----

--缩放的
local ScaleStunt = class("ScaleStunt",Stunt)

function ScaleStunt:ctor(gId)
	Stunt.ctor(self,gId)
end

function ScaleStunt:init(creature,stuntId,target,time)
	Stunt.init(self,creature,stuntId,target,time)
	if self.info.sType < 100 then
		self.stuntElem = creature.avContainer
	else
		self.stuntElem = target.avContainer
	end
end


function ScaleStunt:start()
	Stunt.start(self)
	self.curScale = 0
	self.targetScale = (self.info.scale or 0)/1000
	self.scaleSpeed = self.targetScale/200   --/(self.totalTime/4)
	self.bigestTime = self.totalTime
	self.totalTime = self.totalTime + 500
	self.toback = false
end

function ScaleStunt:run( dt )
		if (self.scaleSpeed > 0 and self.curScale < self.targetScale) or (self.scaleSpeed < 0 and self.curScale > self.targetScale) then
			local addS = self.scaleSpeed * dt
			local newScale = self.curScale + addS
			if math.abs(addS) >= math.abs(self.targetScale-self.curScale) then
				newScale = self.targetScale
				addS = self.targetScale - self.curScale
			end

			local scale = self.stuntElem:getScale()
			scale = scale + addS
			self.stuntElem:setScale(scale)
			self.curScale = newScale
			if self.curScale == self.targetScale then
				if self.info.sType < 100 then
					if self.creature.updateTitlePos then
						self.creature:updateTitlePos()
					end
				else
					if self.target.updateTitlePos then
						self.target:updateTitlePos()
					end
				end
			end
		elseif self.curTime >= self.bigestTime and self.toback == false then
			self.toback = true
			self.scaleSpeed = -self.curScale/800
			self.targetScale = 0
		end
		Stunt.run(self,dt)
end

function ScaleStunt:dispose()
	if self.curScale ~= 0 and self.stuntElem then
		local scale = self.stuntElem:getScale()
		scale = scale - self.curScale
		self.stuntElem:setScale(scale)
	end
	self.stuntElem = nil
	if self.info.sType < 100 then
		self.creature:updateTitlePos()
	else
		self.target:updateTitlePos()
	end
	Stunt.dispose(self)
end

return ScaleStunt