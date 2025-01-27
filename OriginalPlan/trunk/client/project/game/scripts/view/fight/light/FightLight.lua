--
--
local FightLight = class("FightLight",function() return display.newLightSprite() end)

function FightLight:ctor(res)
	self:setSpriteImage(res)
	self:retain()
	-- self:setOpacity(80)
	-- self:setScaleX(5)
	-- self:setScaleY(3)
end

function FightLight:init(target,x,y,color)
	self.target = target
	self.offsetX = x or 0
	self.offsetY = y or 0
	if color then
		self:setColor(color)
	end
end

function FightLight:start()
	if self.target then
		self.lastTargetX,self.lastTargetY = self.target:getPosition()
		-- local pos = self.target:convertToWorldSpace(ccp(0,0))

		-- self:setPosition(self.lastTargetX + self.offsetX, self.lastTargetY + self.offsetY)
		self:setPosition(self.offsetX,self.offsetY)
	else
		self:setPosition(self.offsetX,self.offsetY)
	end
	-- FightDirector:getScene():addElem(self,1,100)
	self.target:addChild(self,-1)
end

function FightLight:run(dt)
	-- self:updatePos()
end

function FightLight:updatePos()
	if self.target then
		local x,y = self.target:getPosition()
		if x ~= self.lastTargetX or y ~= self.lastTargetY then
			-- local dx,dy = x - self.lastTargetX, y - self.lastTargetY
			-- local curX,curY = self:getPosition()
			-- self.lastTargetX = x
			-- self.lastTargetY = y
			-- self:setPosition(x,y)
		end
	end
end

function FightLight:toEnd()
	FightEngine:removeRunner(self)
end

function FightLight:dispose()
	self:removeFromParent()
	self:release()
end

return FightLight
