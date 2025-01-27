
local FlyCreature = class("FlyCreature",Creature)
local FLY_HIGHT = 200

function FlyCreature:ctor(info)
	Creature.ctor(self,info)
	self.flyHeight = self:getMaxHeight()
	self.avContainer:setPositionY(self.flyHeight)

	local y = self.cTitle:getPositionY()
	y =  y+ self.flyHeight
	self.cTitle:setY(y)

	if info.bombNum then
		--self:initBombNum()
	end

end

function FlyCreature:initBombNum()
	if self.cInfo.speciaAI ~= 16 then
		self.bombContainer = display.newNode()
		self.bombContainer:setAnchorPoint(ccp(0.5,0.5))
		self.bombContainer:setPositionY(self.flyHeight-25)
		self:addChild(self.bombContainer,2)
		for i=1,self.cInfo.bombNum[2] do
			local sp = display.newXSprite("#bombNumeEmpty.png")
			sp:setPositionX(i*6)
			self.bombContainer:addChild(sp)
		end
	end
	self:resetBombNum()
end

function FlyCreature:reduceBomb()
	if self.bombNum and self.bombNum > 0 then
		if self.bombContainer then
			self.bombContainer:removeChildByTag(self.bombNum)
		end
		self.bombNum = self.bombNum - 1
	end
end

function FlyCreature:setBomb(num)
	if self.cInfo.bombNum then
		self.bombNum = num
		if self.bombContainer then
			for i=1,self.cInfo.bombNum[2] do
				if i <= num then
					local node = self.bombContainer:getChildByTag(i)
					if not node then
						local sp = display.newXSprite("#bombNum.png")
						sp:setPositionX(i*6)
						sp:setTag(i)
						self.bombContainer:addChild(sp)
					end
				else
					self.bombContainer:removeChildByTag(i)
				end
			end
		end
	end
end

function FlyCreature:getBombNumType()
	return self.cInfo.bombNum and self.cInfo.bombNum[1]
end

function FlyCreature:resetBombNum()
	self.bombNum = self.cInfo.bombNum[2]
	if self.bombContainer then
		for i=1,self.bombNum do
			local sp = display.newXSprite("#bombNum.png")
			sp:setPositionX(i*6)
			sp:setTag(i)
			self.bombContainer:addChild(sp)
		end
		self.bombContainer:setContentSize(CCSize(8*self.bombNum,10))
	end
end

function FlyCreature:getBombNum()
	return self.bombNum or 999999
end

function FlyCreature:isFly()
	return true
end

function FlyCreature:getTruePosition()
	local x,y = self:getPosition()
	return x,y+self.flyHeight
end

function FlyCreature:isAtkFaceto(d)
	return Creature.isAtkFaceto(self,d)
end

function FlyCreature:setFlyHeight(height)
	local add = height - self.flyHeight
	self.flyHeight = height
	for i,magic in ipairs(self._magicList) do
		local y = magic:getPositionY()
		magic:setPositionY(y+add)
	end
	self.avContainer:setPositionY(self.flyHeight)

	local y = self.cTitle:getPositionY()
	y =  y + add
	self.cTitle:setY(y)
end

function FlyCreature:getFlyHeight()
	return self.flyHeight
end

function FlyCreature:getMaxHeight()
	return self.cInfo.flyHeight or FLY_HIGHT
end

function FlyCreature:setMagicDirection(direction)
	Creature.setMagicDirection(self,direction)
end

function FlyCreature:addMagic(magic,addIndex)
	Creature.addMagic(self,magic,addIndex)
	if addIndex < 2 then
		local y = magic:getPositionY()
		magic:setPositionY(y+self.flyHeight)
	end
end

function FlyCreature:getAtkPosition()
   local x,y = self:getPosition()
   return x,y+self.flyHeight
end


function FlyCreature:setDieEnd()
	Creature.setDieEnd(self)
	if self.bombContainer then
		self.bombContainer:removeFromParent()
		self.bombContainer = nil
	end
end

return FlyCreature

