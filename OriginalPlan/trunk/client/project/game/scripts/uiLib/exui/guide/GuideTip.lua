--
-- Author: wdx
-- Date: 2014-10-14 16:46:45
--
--新手提示文本
local GuideTip = class("GuideTip",function() return display.newNode() end)

function GuideTip:ctor(picType)
	ResMgr:loadPvr("ui/guide/guide.pvr.ccz")
	self:init(picType)
	self:retain()
end



function GuideTip:init(picType)
	local res = "#new_zhg"..(picType or "")..".png"
	local man = display.newXSprite(res)
	self:addChild(man,2)
	man:setPosition(40,10)
	man:setAnchorPoint(ccp(1,0))

	self.man = man


	local bg = display.newXSprite("#new_diban.png")
	self:addChild(bg)
	bg:setVisible(false)
	bg:setAnchorPoint(ccp(0,0))
	self:setContentSize(bg:getContentSize())
	self._tipText = RichText.new(250,120,22,nil)
	self._tipText:setPosition(35,30)
	bg:addChild(self._tipText)
	self.bg = bg
end

function GuideTip:setTarget(target,offsetX,offsetY,layerId)
	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local size = self:getContentSize()
	if not absolute then
		offsetX = -size.width + (offsetX)
		offsetY =  size.height/2 + (offsetY)
	end

	if layerId then  -- 把对话 添加到某一层上
		local pos = self.target:convertToWorldSpace(ccp(0,0))
		self:setPosition(pos.x + offsetX, pos.y + offsetY)
		local gLayer = ViewMgr:getGameLayer(layerId)
		gLayer:addChild(self)
	else
		local x,y = target:getPosition()
		self:setPosition(x + offsetX,y + offsetY)
		target:addChild(self)
	end
end

function GuideTip:setGuideText(id,step, callback)
	local info = GuideCfg:getGuide(id)
	if not info.dialog then
		return
	end
	local str = info.dialog[step or 1]
	if str then
		self:setText(str,callback,id)
	else
		print("--没对话。。",id,step)
	end
end

function GuideTip:_onMouseClick()
	NotifyCenter:removeEventListener(Notify.MOUSE_CLICK, {self,self._onMouseClick})
	if self._tipText then
		local str = self._tipText._text
		self._tipText:clearText()
		self._tipText:setText(str)
		self:_textShowEndCallback()
	end
end

function GuideTip:_textShowEndCallback()
	if self._textShowEnd then
		uihelper.call(self._textShowEnd)
		self._textShowEnd = nil
	end
end

function GuideTip:setText(str, callback,guideId)
	self._tipText:clearText()
	local call = function ()
		self.bg:setVisible(true)
		self.bg:setPositionY(-30)
		local showText = function()
			self._textShowEnd = callback
			self._tipText:setText1By1(str, nil, function() self:_textShowEndCallback() end)
			NotifyCenter:addEventListener(Notify.MOUSE_CLICK, {self,self._onMouseClick},-1)
		end

		local mov = CCMoveTo:create(0.2, ccp(0,10))
		local fade = CCFadeIn:create(0.2)
	--	local fadeSeq =
		--self._tipText = ui.newTTFLabel({text=str or "",size=22,align=ui.TEXT_ALIGN_LEFT,dimensions=CCSize(240,300),x=80,y=70})
		transition.execute(self.bg, mov, {easing="backOut"})
		transition.execute(self.bg, fade, {onComplete=showText})
	end

	self.man:setScale(1.0)
	--return transition.scaleTo(node, {time=0.25, scale=1, easing="backout", delay=delay, onComplete=onComplete})
	local sBegin = CCScaleTo:create(0.1, 1.05)
	local sEnd = CCScaleTo:create(0.05, 1)
	local seq = transition.sequence({sBegin, sEnd})
	transition.execute(self.man, seq, {onComplete=call})

	if guideId then
		local gInfo = GuideCfg:getGuide(guideId)
		if gInfo and gInfo.guideGold and gInfo.guideGold > 0 then
			self:_addGoldText(gInfo.guideGold)
			return
		end
	end
	self:_removeGoldText()
end

function GuideTip:_addGoldText(gold)
	if not self._goldText then
		self._goldText = RichText.new(400,30,22,nil,nil,nil,nil,nil,true)
		self.bg:addChild(self._goldText)
		local size = self.bg:getContentSize()
		self._goldText:setPosition(40,size.height-33)
	end
	self._goldText:setText(string.format("完成引导可获得%d<img src=#com_zs.png></img>奖励",gold)  )
end

function GuideTip:_removeGoldText()
	if self._goldText then
		self._goldText:dispose()
		self._goldText = nil
	end
end

function GuideTip:closeSelf()
	if self._tipText then
		local fadeOut = CCFadeOut:create(0.2)
		local call = CCCallFunc:create(function () self:dispose()end)
		transition.execute(self, transition.sequence(fadeOut, call))
	end
end

function GuideTip:dispose()
	NotifyCenter:removeEventListener(Notify.MOUSE_CLICK, {self,self._onMouseClick})
	self:removeFromParent()
	if self._tipText then
		self._tipText:dispose()
		self._tipText = nil
	end
	self:_removeGoldText()
	self:release()
	ResMgr:unload("ui/guide/guide.pvr.ccz")
end

return GuideTip
