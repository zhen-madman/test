--
--
local PosExtend = {}
function PosExtend.extend(obj)

	 function obj:setPos(mx,my)
	 	self.mx = mx
		self.my = my
		self.x=(self.mx-self.my)*(FightMap.TILE_W/2) + FightMap.HALF_TILE_W + FightMap.OFFSET_X
		self.y=(self.my+self.mx)*(FightMap.TILE_H/2)+ FightMap.HALF_TILE_H + FightMap.OFFSET_Y
		self:setPosition(self.x,self.y)
	 end
end

return PosExtend