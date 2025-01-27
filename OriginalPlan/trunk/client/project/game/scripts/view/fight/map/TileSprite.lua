--

local TileSprite = class("TileSprite",function() return display.newXSprite() end)

function TileSprite:ctor(mx,my,content,color)
	self:setPos(mx,my)
	self.content = content

	self.color = color
	if color == "red" then
		-- self:setSpriteImage("#tile_red.png")
		self.mg = SimpleMagic.new(39)
		self:addChild(self.mg)
	elseif color == "bule" then
		--self:setSpriteImage("#tile_bule.png")

		self.mg = SimpleMagic.new(41)
		self:addChild(self.mg)
	elseif color == "gray" then
		self:setSpriteImage("#skill_dizi.png")
	elseif color == "red_1" then
		self:setSpriteImage("#skill_dizi.png")
	elseif color == "gray_1" then
		self:setSpriteImage("#skill_dizi.png")
	end
	self:setPosition(self.x,self.y)
end

function TileSprite:setPos( mx,my )
	self.mx = mx
	self.my = my
	self.x=(self.mx-self.my)*(FightMap.TILE_W/2) + FightMap.HALF_TILE_W + FightMap.OFFSET_X
	self.y=(self.my+self.mx)*(FightMap.TILE_H/2)+ FightMap.HALF_TILE_H + FightMap.OFFSET_Y
	self:setPosition(self.x,self.y)
end

function TileSprite:addToMap()
	FightDirector:getMap():addChild(self)
end

function TileSprite:dispose()
	if self.mg then
		self.mg:dispose()
		self.mg = nil
	end
end

return TileSprite