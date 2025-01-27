--@ wdx
--抛物线类型的

local ArcMagic = class("ArcMagic",Magic)


function ArcMagic:start(root)
	self.speed = Formula:transformSpeed(self.info.speed or 300)--

	self.srcPos = {}
	self.srcPos.x,self.srcPos.y = self.creature:getTruePosition()
	self.targetPos = {}
	self.targetPos.x,self.targetPos.y = self.target:getTruePosition()


	local middleH = self.info.middleH or 300

	self.middle = {x=self.srcPos.x + (self.targetPos.x-self.srcPos.x)/2,y=self.srcPos.y + middleH}

	self.totalTime = (math.abs(self.targetPos.x-self.middle.x)+math.abs(self.targetPos.y-self.middle.y))/self.speed
					 +(math.abs(self.middle.x-self.srcPos.x)+math.abs(self.middle.y-self.srcPos.y))/self.speed

	if self.info.aType then
		self.middle2 = {x=self.srcPos.x + (self.targetPos.x-self.srcPos.x)*4/5,y=self.srcPos.y + middleH}
		self.totalTime = (math.abs(self.targetPos.x-self.middle2.x)+math.abs(self.targetPos.y-self.middle2.y))/self.speed
					 +(math.abs(self.middle2.x-self.srcPos.x)+math.abs(self.middle2.y-self.srcPos.y))/self.speed
	end
	self.curTime = 0

	self.speedA = 2

	local nextX,nextY = self:getPos(100/self.totalTime)
	local r = math.atan2( nextY- self.srcPos.y, nextX - self.srcPos.x)
	r = -180*r/math.pi
	self:setRotation(r)

	self.moveTime = self.totalTime
	-- if self.info.trailId then
	-- 	self.totalTime = self.totalTime + 1000
	-- end

	-- self._srcScale

	self.trailId = self.info.trailId

	Magic.start(self,root)
end

function ArcMagic:getDirection()
	return Creature.RIGHT
end

function ArcMagic:_getDirection(creature,target)
	return Creature.RIGHT
end


function ArcMagic:run(dt)
	-- print("run....",self.curTime,self.totalTime,self.curTime/self.totalTime)
	local lastTime = self.curTime
	if lastTime < self.moveTime then
		lastTime = lastTime + dt*self.speedA
		if lastTime > self.moveTime then
			lastTime = self.moveTime
		end
		local lastX,lastY = self:getPosition()

		local r = lastTime/self.moveTime
		self.speedA = 2 - r
		local x,y = self:getPos(r)

		self:setPosition(math.floor(x+0.5),math.floor(y+0.5))

		local r = math.atan2( y- lastY, x - lastX)
		r = -180*r/math.pi
		self:setRotation(r)
		-- print("run    r",self.gId,r)

		if not FightEngine:isSmooth() and self.trailId then
			self.trailId = nil
			if self.trail then
				self.trail:removeFromParent()
				self.trail:release()
				ParticleMgr:DestroyParticle(self.trail)
				self.trail = nil
			end
		end

		if self.trailId and not self.trail and lastTime > 150 then
			self.trail = ParticleMgr:CreateParticleSystem(self.trailId,true)
			self.trailId = nil
			self.trail:retain()
			self:addChild(self.trail)
		end
	end

	if not self._isCheckHit and self.curTime > self.moveTime then
		self._isCheckHit = true
		if self.particle and self.particle:getParent() then
			self.particle:removeFromParent()
		end
		self:_checkHitKeyFrame(self.target)
	end
	if Magic.run(self,dt) == false then
		--print("结束了？？")
		return
	end
end

function ArcMagic:_checkHitKeyFrame(target )
	local keyframeList = self.info["keyframe"]
	if keyframeList then
		local frameTypeList = self.info["keyType"]
		for i,frame in ipairs(keyframeList) do
			-- print("击中了。。。。",self.magicId,frame,frameTypeList[i],self.info["keyMagic"] and self.info["keyMagic"][i] )
			if frame == -1 then  --  -1表示在  打中人的时候
				local fType = frameTypeList[i]
				local frameType = frameTypeList[i]

				if frameType == Skill.MAGIC_KEY_FRAME then
					-- print("击中了。。。。",frame,frameType,self.info["keyMagic"] and self.info["keyMagic"][i] )
					self:_keyFrameHanlder(i,target,true) --播放一个魔法特效
				elseif frameType == Skill.ATTACK_KEY_FRAME then  --检测攻击到的
					self:_checkHitTarget(i)
				end
			end
		end
	end
end

function ArcMagic:getPos(r)
	local x,y
	if self.middle2 then
		x,y = self:bezier3(self.srcPos,self.middle,self.middle2,self.targetPos,r)
	else
		x,y = self:bezier(self.srcPos,self.middle,self.targetPos,r)
	end
	return x,y
end


function ArcMagic:bezier(a,b,c,t)
    -- /// t为0到1的小数。
    local n = 1-t
    local np2 = n*n
    local nt = n*t
    local tp2 = t*t
    local x = np2*a.x+2*nt*b.x+tp2*c.x
    local y = np2*a.y+2*nt*b.y+tp2*c.y
    return x,y
end

function ArcMagic:bazierAngle(a,b,c,t)
    -- /// 获得贝塞尔曲线上某点的弧度值
    local ax = b.x-a.x+(a.x+c.x-b.x*2)*t
    local ay = b.y-a.y+(a.y+c.y-b.y*2)*t
    return math.atan2(ay,ax)
end


function ArcMagic:bezier3(p1,p2,p3,p4,t)
	local n = 1-t
	local np2 = n*n*t
	local np3 = math.pow(n,3)
	local tp2 = t*t*n
	local tp3 = math.pow(t,3)
	local x = np3*p1.x + 3*p2.x*np2 + 3*p3.x*tp2 + p4.x *tp3
	local y = np3*p1.y + 3*p2.y*np2 + 3*p3.y*tp2 + p4.y *tp3
	return x,y
end

function ArcMagic:dispose()
	if self.trail then
		self.trail:removeFromParent()
		self.trail:release()
		ParticleMgr:DestroyParticle(self.trail)
		self.trail = nil
	end
	Magic.dispose(self)
end

function ArcMagic:reset()
	self._isCheckHit = false
	if self.particle then
		if not self.particle:getParent() then
			self:addChild(self.particle)
		end
		self.particle:ResetData()
		if self.particle2 then
			self.particle2:ResetData()
		end
	end
end

return ArcMagic