
local MultiAvatar = class("MultiAvatar",function() return AvatarEx:create() end)
local TURN_TIME  = 100

local MIDDLE_D = (180/math.pi)*3/8

function MultiAvatar:ctor(pre,dFunc)
	self.resPre = pre or ""
	self._dFunc = dFunc
	self.colorAv = nil
	self.topAv = nil
	self._curTime = 0
	self._turnD = GameConst.UP
end

function MultiAvatar:setResPre(pre)
	self.resPre = pre
end

function MultiAvatar:addTurnListener(tFunc)
	self._tFunc = tFunc
	self.turnRun = self.turnRunEx
end

function MultiAvatar:turnRun(dt)
	if self.direction ~= self._targetD then
		self._curTime = self._curTime - dt
		if self._curTime <= 0 then
			self:setRotation(0)
			self._curTime = TURN_TIME
			if self.hasTurnAction then
				self._turnD = Formula:turnDirectionEx(self._turnD,self._targetD)
			else
				self._turnD = Formula:turnDirection(self._turnD,self._targetD)
			end
			self:_showFrame(0,GameConst.STAND_ACTION,self._turnD)
			local s = Formula:getDirectionScaleX(self._turnD)
			self:setScaleX(s)

			if Formula:isBaseDirection(self._turnD) and self.direction ~= self._turnD then
				self:_updateDirection(self._turnD)
			end
			if self.shadow then
				self.shadow:setDirection(self.direction,self._turnD,0)
			end
		elseif self._curTime <= TURN_TIME then
			-- do
			--  return
			-- end
			local r = Formula:getAngleByDirectionEx(self._turnD)
			local nextD
			if self.hasTurnAction then
				nextD = Formula:turnDirectionEx(self._turnD,self._targetD)
			else
				nextD = Formula:turnDirection(self._turnD,self._targetD)
			end

			local nextR = Formula:getAngleByDirectionEx(nextD)
			local dr = (nextR - r)

			local s = Formula:getDirectionScaleX(nextD)
			if s == 1 then
				s = Formula:getDirectionScaleX(self._turnD)
			end
			dr = s*dr*MIDDLE_D
			self:setRotation(dr)
			self:_showFrame(0,GameConst.STAND_ACTION,nextD)
			self:setScaleX(s)

			if self.shadow then
				self.shadow:setDirection(self.direction,nextD,dr)
			end
		end
	end
end

function MultiAvatar:turnRunEx(dt)
	if self.direction ~= self._targetD then
		self._curTime = self._curTime - dt*1.5
		if self._curTime <= 0 then
			self:setRotation(0)
			self._curTime = TURN_TIME
			if self.hasTurnAction then
				self._turnD = Formula:turnDirectionEx(self._turnD,self._targetD)
			else
				self._turnD = Formula:turnDirection(self._turnD,self._targetD)
			end
			self:_showFrame(0,GameConst.STAND_ACTION,self._turnD)
			local s = Formula:getDirectionScaleX(self._turnD)
			self:setScaleX(s)

			if Formula:isBaseDirection(self._turnD) and self.direction ~= self._turnD then
				self:_updateDirection(self._turnD)
			else
				self:updateTurn(self._turnD)
			end

			if self.shadow then
				self.shadow:setDirection(self.direction,self._turnD,0)
			end
		end
	end
end

function MultiAvatar:clear()
	AvatarEx.initWithResName(self,"")
	if self.colorAv then
		self.colorAv:initWithResName("")
	end
	if self.topAv then
		self.topAv:initWithResName("")
	end
	self.isClear = true
end

function MultiAvatar:initWithResName(res)
	self.isClear = false
	AvatarEx.initWithResName(self,res)
	if AnimationMgr:getActionInfo(res,GameConst.STAND_ACTION.."_6") then
		self.hasTurnAction = true
	else
		self.hasTurnAction = false
		if not AnimationMgr:getActionInfo(res,GameConst.STAND_ACTION.."_1") then
			local SingleDirectionAvatarExtend = game_require("view.fight.creature.SingleDirectionAvatarExtend")
			SingleDirectionAvatarExtend.extend(self)
		end
	end
end

function MultiAvatar:addColorAv(res)
	local action = AnimationMgr:getActionInfo(res,"y"..GameConst.STAND_ACTION.."_3")
	if action then
		if not self.colorAv then
			self.colorAv = AvatarEx:create()
			self.colorAv:initWithResName(res)
			self:addChild(self.colorAv)
		else
			self.colorAv:initWithResName(res)
		end
	end
end

function MultiAvatar:removeColorAv()
	if self.colorAv then
		self.colorAv:removeFromParent()
		self.colorAv = nil
	end
end

function MultiAvatar:hasColor()
	return self.colorAv ~= nil
end

function MultiAvatar:addTopAv(res)
	local action = AnimationMgr:getActionInfo(res,"z"..GameConst.STAND_ACTION.."_3")
	if action then
		self.topAv = AvatarEx:create()
		self.topAv:initWithResName(res)
		self:addChild(self.topAv)
	end
end

function MultiAvatar:setShadow(shadow)
	self.shadow = shadow
end

function MultiAvatar:updateTurn(d)
	if self._tFunc then
		self._tFunc(d)
	end
end

function MultiAvatar:_updateDirection(d)
	self.direction = d
	if self._dFunc then
		self._dFunc(d)
	end
	-- if self.resPre == "" then
	-- 	print(debug.traceback())
	-- 	print("设置方向啊啊啊啊",d)
	-- end
end


function MultiAvatar:setDirection(d)
	self._turnD = d
	self._targetD = d
	if self.direction ~= d then
		local s = Formula:getDirectionScaleX(d)
		self:setScaleX(s)
		self:_updateDirection(d)
		if self.shadow then
			self.shadow:setDirection(self.direction,self._turnD,0)
		end
	end
end

function MultiAvatar:isTurnIng()
	return self._targetD ~= self.direction
end

function MultiAvatar:getDirection()
	return self.direction
end

function MultiAvatar:getTurnDirection()
	return self._turnD
end

function MultiAvatar:getTargetDirection()
	return self._targetD
end

function MultiAvatar:turnDirection(d,delyTime)
	-- if self.resPre == "x" then
	-- 	print(debug.traceback())
	-- end

	if self._targetD ~= d then
		self._targetD = d
		-- if self.resPre == "x" then
		-- 	print("转向。。。。。。",self.direction,d)
		-- end
		self._turnD = self.direction
		self._curTime = (delyTime or 0 ) + TURN_TIME
		-- print('self._turnD ..' .. self._turnD)
		self:_showFrame(0,GameConst.STAND_ACTION,self._turnD)

		self:updateTurn(self._turnD)
	end
end

function MultiAvatar:showAnimateFrame(index,action,d)
	if self.direction ~= self._targetD then
		return
	end
	if d then
		self:setDirection(d)
	end
	self:_showFrame(index,action,self.direction)
end

function MultiAvatar:_showFrame(index, action,d)
	if self.isClear then
		return
	end
	-- index = 0
	local actionName = self.resPre .. Formula:getActionName(d,action)
	AvatarEx.showAnimateFrame(self,index,actionName)
	if self.colorAv then
		self.colorAv:showAnimateFrame(index,"y"..actionName)
	end
	if self.topAv then
		self.topAv:showAnimateFrame(index,"z"..actionName)
	end
end

function MultiAvatar:isExistFrame(index, action,d)
	local actionName = self.resPre .. Formula:getActionName(d,action)
	local info = AvatarEx.getAnimateFrame(self, index,actionName)
	return info ~= nil
end
function MultiAvatar:setColor(color)
	CCNode.setColor(self,color)
	if self.colorAv then
		self.colorAv:setColor(color)
	end
	if self.topAv then
		self.topAv:setColor(color)
	end
end

return MultiAvatar

