--
--
local pairs = pairs
local ipairs = ipairs
local table = table
local FightEngine = FightEngine
local MagicAutoTrigger = game_require("view.fight.common.MagicAutoTrigger")
--[[--
技能基类
]]
local Skill = class("Skill")

Skill.ATTACK_KEY_FRAME = 0
Skill.MAGIC_KEY_FRAME = 1
Skill.SELF_SKILL_KEY_FRAME = 2
Skill.TARGET_SKILL_KEY_FRAME = 3

Skill.END_KEY_FRAME = -100
local TEST_SKILL = 0
local TEST_MAGIC = 0
local TargetSearchDelegate = game_require("view.fight.common.TargetSearchDelegate")

function Skill:ctor(gId)
	self.gId = gId
	self.curTime = 0
	self._lastTime = 0
end

function Skill:init( creature,skillId,target,skillParams )
	if skillId == TEST_SKILL then
		print("SKILL--------",TEST_SKILL)
	end

	self.skillId = skillId
	self.level = skillParams.level
	self.skillParams = skillParams
	self.info = FightCfg:getSkillByLevel(skillId,self.level)
	self.creatureId = creature.id
	if target then
		self.targetId = target.id
	end
	if target then

		if creature.atkAv and self.info.fTime ~= 0 and not self._noRotation then
			local curR = 180*Formula:getAngleByDirection(creature:getAtkDirection())/math.pi

			local curX,curY = creature:getTruePosition()
			local targetX,targetY = target:getTruePosition()
			local nextR = 180*math.atan2( targetY - curY, targetX - curX)/math.pi

			local dr = (nextR - curR)
			if dr >= 180 then
				dr = 360 - dr
			elseif dr < -180 then
				dr = -360 - dr
			end
			if math.abs(dr) > 10 then
				dr = 10*(math.abs(dr)/dr)
			end
			self._atkRotation = -dr

			-- print("角度。。。",d,dr,curR,nextR,r,self.creature.cInfo.name,self.target.cInfo.name)
			creature.atkAv:setRotation(self._atkRotation)
		end
	end

	assert(self.info,"--技能配置没有！！"..skillId)


	self.action = self.info.action or Creature.ATTACK_ACTION


		local aInfo = creature:getAnimationInfo(self.action )  --动作信息

		if self.info.fTime then
			self.fTime = self.info.fTime
		elseif aInfo.frequency and aInfo.frequency > 0 then
			self.fTime = math.floor(1000/aInfo.frequency)
		else
			self.fTime = FightCommon.animationDefaultTime
		end

	--print("fTime",aInfo.frequency)
	local aFrame = aInfo:getFrameLength()
	self.animationTime = aFrame * self.fTime  -- 乘以每帧时间   可配置

	if self.info.totalFrame then
		self.totalTime = self.info.totalFrame * self.fTime  --持续时间
	else
		self.totalTime = self.animationTime  --持续时间
	end

	print("--开始技能。。。",self.skillId,creature.cInfo and creature.cInfo.name
					,target and target.cInfo.name,self.level)

	creature:addSkillCount()
	self._targetSearchDelegate = TargetSearchDelegate.new(creature.cInfo.career,creature.cInfo.team,creature.cInfo.atkScope)
end

function Skill:getCreature()
	return FightDirector:getScene():getCreature(self.creatureId)
end

function Skill:getTarget()
	if self.targetId then
		return FightDirector:getScene():getCreature(self.targetId)
	else
		return nil
	end
end

function Skill:breakLastSkill(  )
	if self.info.fTime == 0 then
		return false
	else
		return true
	end
end

function Skill:start()
	self.magicList = {}

	if self.info.keyframe and self.info.keyframe[1] == 0 then
		self:_checkKeyFrame(1)
	end
	self._lastTime = 1
	self.curTime = 1
end

function Skill:run(dt)
	self._isRunning = true

	self._lastTime = self.curTime

	self.curTime = self.curTime + dt

	self:_checkKeyFrame(dt) --检测关键帧处理

	self._isRunning = false

	if self._skillBreak then -- 技能被打断
		if TEST_SKILL == self.skillId then
			print("skill____magic______skillBreak",self.skillId)
		end
		self:_skillEnd()  --结束了
		return false
	end

	self:_showCurFrame()


	if self.curTime >= self.totalTime then   --循环次数 够了   结束技能
		if TEST_SKILL == self.skillId then
			print("skill____magic_____self.curTime >= self.totalTime",self.curTime,self.totalTime)
		end
		self:_skillEnd()  --结束了
		return false
	end
	return true
end

--全场冻结 只有这个在跑的时候
function Skill:runCongeal( dt )
	for i,mId in ipairs(self.magicList) do
		local magic = FightEngine:getMagicById(mId)
		if magic then
			magic:run(dt)
		end
	end
	self.congealTime = self.congealTime
	if self.congealTime <= 0 then
		FightEngine:removeCongeal(self)
	end
	self:run(dt)
end

--显示某一帧
function Skill:_showCurFrame()
	local newFrame
	if self.info.framePlay then
		local ft = 0
		local index = 1
		for i = 1, #self.info.framePlay, 3 do
			local dTime = self.info.framePlay[i] * self.fTime
			ft = ft + dTime
			if self._lastTime < ft then
				ft = ft - dTime
				index = i
				break
			end
		end
		local dTime = self.info.framePlay[index] * self.fTime
		local sFrame = self.info.framePlay[index + 1]
		local eFrame = self.info.framePlay[index + 2]
		local passFrame = (eFrame - sFrame)*(self._lastTime - ft)/dTime
		newFrame = sFrame + math.floor(passFrame+0.5)
	else
		local time = self._lastTime%self.animationTime
		newFrame = math.floor(time/self.fTime)

	end
	local creature = self:getCreature()
	if creature then
		creature:showAnimateFrame(newFrame,self.action)
	end
end

--检测关键帧处理
function Skill:_checkKeyFrame( dt )
	local keyframeList = self.info["keyframe"]
	local frameMagicList = self.info["keyMagic"]
	local creature = self:getCreature()
	if keyframeList then
		for i,frame in ipairs(keyframeList) do   --处理关键帧 的 触发东西
			local time = self.fTime * frame
			if self.skillId == TEST_SKILL then
				print("SKILL--------keyFrame",TEST_SKILL,time,self._lastTime,self._lastTime + dt)
			end

			if time >= self._lastTime and time < self._lastTime + dt then
				if TEST_MAGIC == frameMagicList[index] then
					print("skill____magic_____frame",TEST_MAGIC)
				end
				self:_keyFrameHanlder(i,true)
			end
		end
	end
end

function Skill:_createFrameMagic(creature,magicId,target,hookObj)
	local magicCfg = FightCfg:getMagic(magicId)
	if not magicCfg then
		return
	end
	local magic = FightEngine:createMagic(creature,magicId,target,self.info,self.skillParams,self.gId,hookObj) --播放一个魔法特效
	if magic then
		self.magicList[#self.magicList + 1] = magic.gId
		if target and target.posLength > 1 and FightCfg:getMagic(magicId).parent == 2 then
			local x,y = magic:getPosition()
			x = x + math.random(-FightMap.HALF_TILE_W*(target.posLength*0.5),FightMap.HALF_TILE_W*(target.posLength*0.5))
			y = y + math.random(-FightMap.HALF_TILE_H*(target.posLength*0.5),FightMap.HALF_TILE_H*(target.posLength*0.5))
			magic:setPosition(x,y)
		end
		if magic.info.direction == 1 then
			-- print("设置方向啊。。。。")
			if self._atkRotation then
				magic:setRotation(self._atkRotation)
			end

			if creature.getCurAtkOffsetPos then
				local off = creature:getCurAtkOffsetPos()
				if off then
					local x,y = magic:getPosition()
					magic:setPosition(x+off[1],y+off[2])
				end
			end
		end
	end
	return magic
end

function Skill:_keyFrameHanlder(index,selfEffect)
	local creature = self:getCreature()
	if not creature or not self:getTarget() then
		return
	end
	local frameMagicList = self.info["keyMagic"]
	if frameMagicList and frameMagicList[index] and frameMagicList[index] > 0 then
		local magicCfg = FightCfg:getMagic(frameMagicList[index])
		if (magicCfg.parent  == 1 or  magicCfg.parent  == 3)  then
			self:_createFrameMagic(creature,frameMagicList[index],self:getTarget(),creature)
		else
			local targetList = self._targetSearchDelegate:getHitTarget(magicId,self:getCreature(),self:getTarget())
			if (not targetList) or #targetList==0 then
				return
			end
			for k,v in pairs(targetList) do
				self:_createFrameMagic(creature,frameMagicList[index],v,v)
			end
		end

	end
end

function Skill:_skillEnd()
	FightEngine:removeSkill(self)
end

function Skill:getHitRange( magicInfo )
	if not magicInfo then
		return nil
	end
	local creature = self:getCreature()
	local target = self:getTarget()
	return Formula:calAckRange(magicInfo,creature,target)
end

function Skill:dispose()
	if self._isRunning then  --当前正在跑   延迟销毁
		FightEngine:delayDisposeElem(self)
		return
	end

	-- print(debug.traceback())

	print("--技能 结束",self.skillId)
	if self.congealTime and self.congealTime > 0 then
		FightEngine:removeCongeal(self)
		--FightDirector:getCamera():removeCongeal(self.creature)
	end

	self.info = nil
	local creature = self:getCreature()
	if creature then
		creature:removeSkillCount()
	end
end

return Skill

