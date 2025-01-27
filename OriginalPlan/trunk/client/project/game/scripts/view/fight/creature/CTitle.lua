
--[[--
玩家上的  血量 名字 什么的  信息   暂时  todo
]]

local CTitle = class("CTitle",function()
								return display.newNode()
								end)

function CTitle:ctor()
end

function CTitle:init(info)

	self.curHp = info.hp

	local x,y = 0,2

	-- print("CTitle",info.heroId,info.id,info.name)

	if not info.hideBlood then
		if info.buildBlood then  --build
			local barBg = "#fight_blood_frame_2.png"
			local bar = "#fight_blood_2a.png"
			if info.team == FightCommon.right then
				bar = "#fight_blood_2c.png"
			end
			self.blood = UIProgressBar.new(bar,barBg)
			self.blood:setRotation(-30)
			self.blood:setClipMode(true)
		elseif info.campBlood then
			self.blood = UIProgressEx.new("#yw_img_3.png",nil,CCSize(288,18))
			self.blood:setPosition(-140,-80)
		else

			local barBg = "#fight_blood_frame_1.png"
			local bar = "#fight_blood_1a.png"
			if info.team == FightCommon.right then
				bar = "#fight_blood_1c.png"
			end
			self.blood = UIProgressBar.new(bar,barBg)
			self.blood:setClipMode(true)
		end
		self.blood:setAnchorPoint(ccp(0.5,0.5))
		self.blood:retain()
		self:addChild(self.blood)
		self:setBlood(info.hp,info.maxHp)
	end

	self:retain()
end

function CTitle:setY(y)
	self:setPositionY(y)
end

function CTitle:setBloodVisible(flag)
	if self.blood then
		self.blood:setVisible(flag)
	end
end

function CTitle:setBlood( cur,max,noTween,speed )
	if not self.blood then
		return
	end
	self.blood:setMaxProgress(max)
	if cur > max then
		cur = max
	end
	local rate = self.curHp/max
	if noTween or not  self.blood.startProgressTo then
		self.blood:setProgress(cur)
	else
		self.blood:startProgressTo(self.curHp,cur,(cur-self.curHp)/(speed or 8) )
	end
	self.curHp = cur
end

function CTitle:dispose()
	-- if self._skillNameTimer then
	-- 	scheduler.unscheduleGlobal(self._skillNameTimer)
	-- end
	-- self.skillName:release()
	if self.blood then
		self.blood:dispose()
		self.blood:release()
		self.blood = nil
	end

	self:release()
end

return CTitle