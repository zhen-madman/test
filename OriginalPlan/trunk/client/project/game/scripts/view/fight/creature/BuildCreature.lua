
local BuildCreature = class("BuildCreature",Creature)

function BuildCreature:ctor(info)
	self.isBuild = true
	Creature.ctor(self,info)
	-- local buff = FightEngine:createBuff(self,FightCfg.BATI_BUFF,100000000,self)

	-- self.avContainer:setScale(3)
	self._curAction = Creature.STAND_ACTION
end

function BuildCreature:isAtkFaceto(d)
	return true
end

function BuildCreature:setAV( res )
	-- FightCache:retainAnima(res)  --缓存资源
	Creature.setAV(self,res)
	local action = AnimationMgr:getActionInfo(res,Creature.HURT_ACTION.."_3")
	if action then
		self._hasHurtAction = true
	end
end

--boss 不可移动
function BuildCreature:canMove()
	return false
end

--直接显示某一动作的某一帧
function BuildCreature:showAnimateFrame( frame,action,direction)
	--frame = 0
	if direction then
		self:setDirection(direction)
	end
	if not self._curAvRes or self._curAvRes == "" then
		return false
	end
	self.av:showAnimateFrame(frame,self._curAction)
	return true
end

function BuildCreature:turnDirection()

end

--设置朝向
function BuildCreature:setDirection( direction)
	if not direction then
		return
	end
	direction = Creature.RIGHT

	Creature.setDirection(self,direction)
end

function BuildCreature:updateTitlePos(res)
	if self.cInfo then
		res = res or self.cInfo.res
		local aInfo = AnimationMgr:getAnimaInfo(res)
		local action = AnimationMgr:getActionInfo(res,Creature.STAND_ACTION.."_3")
		local size = aInfo:getFrameSize(action.startFrame)
		-- local action1 = AnimationMgr:getActionInfo(res,Creature.STAND_ACTION.."_3")
		-- local size1 = aInfo:getFrameSize(action1.startFrame)
		local height = size.height

		-- print("高度。。。",size.height,action.startFrame)
		local offY = FightCfg:getTitleY(res)
		height = height + offY
		self.cTitle:setY(height*0.8)
		-- self.bottom:setScale(avScale)
	end
end

function BuildCreature:getAnimationInfo( action )
	return AnimationMgr:getActionInfo(self.cInfo.res,action .."_3")
end

function BuildCreature:_checkAddHurtMagic()
	Creature._checkAddHurtMagic(self)
	if self._hasHurtAction then
		local rate = self:getHpRate()
		local mId
		if rate < 0.5 then
			self._curAction = Creature.HURT_ACTION
			self._hasHurtAction = false
		end
	end
end

return BuildCreature