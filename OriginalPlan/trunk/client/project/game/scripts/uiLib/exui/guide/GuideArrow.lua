--[[--
class:GuideArrow
新手指引的 箭头
wdx
]]
local GuideArrow = class("GuideArrow",function()
	return display.newNode()
end)

function GuideArrow:ctor()
	ResMgr:loadPvr("ui/guide/guide.pvr.ccz")
	self:retain()
	self._swallow = false


	self._hand = display.newNode()
	local handIcon = display.newXSprite("#new_jiantou1.png")
	self._hand:addChild(handIcon)
	self._hand.handIcon = handIcon
	self._hand:retain()

	self.magic = SimpleMagic.new(54)
	self:addChild(self.magic)

	self._touchSize = CCSize(90,90)

end

--设置按下时候的回调
function GuideArrow:setDownCallBack(fun)
	self.downCallBack = fun
end

function GuideArrow:setTouchSize(size)
	self._touchSize = size
	if self._touch then
		self._touch:setContentSize(self._touchSize)
	end
end

--[[--
--是否 吞掉 这个新手点击区域之外的事件  默认是flase
]]
function GuideArrow:swallowTouches(flag,priority)
	if self._swallow == flag then
		return
	end
	self._swallow = flag
	if flag then
		if self._touch then
			self._touch:removeFromParent()
			self._touch = nil
		end
		local p = priority or GameLayer.priority[Panel.PanelLayer.MASK_LAYER]
		if self._touch == nil then
			self._touch = TouchBase.new(p,true,true)
			self._touch:setAnchorPoint(ccp(0.5,0.5))
			self._touch:setContentSize(self._touchSize)
			self:addChild(self._touch)
			self._touch.touchContains = function(touch, x,y )
				local tOk = TouchBase.touchContains(self._touch,x, y) and self._hand:isVisible()
				if not tOk and self._hand:isVisible() then
					if not self._moveMagic then
						self._moveMagic = display.newXSprite("#new_jiantou1.png")
						self._moveMagic:retain()
					end
					self._moveMagic:setScaleX(self._hand.handIcon:getScaleX())
					if not self._moveMagic:getParent() then
						local gLayer = ViewMgr:getGameLayer(Panel.PanelLayer.MASK_LAYER)
						gLayer:addChild(self._moveMagic)
						self._moveMagic:setPosition(x,y)
						local pos = self:convertToWorldSpace(ccp(50,-50))
						UIAction.setMoveTo(self._moveMagic,pos.x,pos.y,0.5,function() self._moveMagic:removeFromParent() end)
					end
				end
				if tOk and self.downCallBack then
					self.downCallBack()
				end
				return not tOk
			end
		else
			self._touch:touchPriority(p)
			if not self._touch:getParent() then
				self:addChild(self._touch)
			end
		end
	else
		if self._touch and self._touch:getParent() then
			self:removeChild(self._touch)
		end
	end
end

--设置成遮罩状态
function GuideArrow:addMask()
	local size = self.target:getContentSize()

	local pos = self.target:convertToWorldSpace(ccp(0,0))
	pos.x = pos.x + size.width/2 + (offsetX or 0)
	pos.y = pos.y + size.height/2 + (offsetY or 0)
	self:setPosition(pos.x,pos.y)

	self:_newMask()

	local gLayer = ViewMgr:getGameLayer(Panel.PanelLayer.MASK_LAYER)
	local p = self:getParent()
	if p and p ~= gLayer then
		self:removeFromParent()
	end
	if p ~= gLayer then
		gLayer:addChild(self)
	end
end

--移除mask
function GuideArrow:removeMask()
	if self.maskNode then
		self.maskNode:removeFromParent()
		self.maskNode:release()
		self.maskNode = nil
	end
end


--[[--
	--设置指向 目标   一般都是按钮  里面会自动添加进去
]]
function GuideArrow:setTarget(target,offsetX,offsetY,layerId)
	self.target = target

	offsetX = offsetX or 0
	offsetY = offsetY or 0
	local size = target:getContentSize()

		local p = self:getParent()
		if p and p ~= target then
			self:removeFromParent()
		end
		if p ~= target then
			target:addChild(self,20)
			-- self:_starHandAction()
		end
		self:setPosition(size.width/2 + offsetX,size.height/2 + offsetY)


	local pos = self:convertToWorldSpace(ccp(0,0))

	self._hand:removeFromParent()
	if layerId then
		local gLayer = ViewMgr:getGameLayer(layerId)
		gLayer:addChild(self._hand)
		if pos.x > display.width - 100 then
			self._hand:setPosition(pos.x -60 + offsetX,pos.y-40 + offsetY)
			self._hand.handIcon:setScaleX(-1)
		else
			self._hand.handIcon:setScaleX(1)
			self._hand:setPosition(pos.x + 60 + offsetX,pos.y -40 + offsetY)
		end
		self._hand._handParent = gLayer
	else
		self:addChild(self._hand)
		if pos.x > display.width - 100 then
			self._hand.handIcon:setScaleX(-1)
			self._hand:setPosition(-60,-40)
		else
			self._hand.handIcon:setScaleX(1)
			self._hand:setPosition(60,-40)
		end
		self._hand._handParent = self
	end
	UIAction.shrinkRecoverForever(self._hand)

	if size.width > self._touchSize.width/2 then
		self._touchSize.width = size.width
	end
	if size.height > self._touchSize.height/2 then
		self._touchSize.height = size.height
	end
	-- self._touchSize = size
	if self._touch then
		self._touch:setContentSize(self._touchSize)
	end
	self:showHand()
end

--设置遮罩
function GuideArrow:_newMask()
	if not self.maskNode then
		self.maskNode = CCClippingNode:create()
		self.maskNode:retain()
		local pColor = CCLayerColor:create(ccc4(0,0,0,150))
		pColor:setContentSize(CCSize(display.width,display.height))
		self.maskNode:addChild(pColor)
	end
	local x,y = self:getPosition()
	local size = self.target:getContentSize()
	local w,h = size.width,size.height
	x = x - w/2
	y = y - h/2

	local points = CCPointArray:create(4)
	local lb = ccp(0,0)
	local lt = ccp(0,h)
	local rt = ccp(w,h)
	local rb = ccp(w,0)
	points:add(lb)
	points:add(lt)
	points:add(rt)
	points:add(rb)

	local fillColor = ccc4f(1,1,1,1)
	local borderColor = ccc4f(1,1,1,1)
	local borderWidth = 0
	local drawNode = CCDrawNode:create()
	drawNode:drawPolygon(points:fetchPoints(),points:count(),fillColor,borderWidth,borderColor)
	drawNode:setPosition(x,y)

	self.maskNode:setStencil(drawNode)
	self.maskNode:setInverted(true)

	if self.maskNode:getParent() == nil then
		local gLayer = ViewMgr:getGameLayer(Panel.PanelLayer.MASK_LAYER)
		gLayer:addChild(self.maskNode,-1)
	end

end

function GuideArrow:hideHand()
	self._hand:setVisible(false)
	self.magic:setVisible(false)
end

function GuideArrow:showHand()
	self.magic:setVisible(true)
	self._hand:setVisible(true)

	self._hand.handIcon:stopAllActions()
	local pos = self:convertToWorldSpace(ccp(0,0))
	local x,y
	if pos.x < display.cx then
		x = 100
	else
		x = -100
	end
	if pos.y < display.cy then
		y = 100
	else
		y = -100
	end
	UIAction.flyAction(self._hand.handIcon, ccp(x,y),{x=0,y=0} , 0.5)
end

function GuideArrow:setTipTextPos(x,y)
	if self.guideTip then
		self.guideTip:setPosition(x,y)
	end
end

function GuideArrow:showTipText(str,offsetX,offsetY,layerId,guideId,step)
	if self.guideTip == nil then
		self.guideTip = GuideTip.new()
	else
		self.guideTip:removeFromParent()
	end
	local size = self.guideTip:getContentSize()
	offsetX = -size.width + (offsetX or 0)
	offsetY =  size.height/2 + (offsetY or 0)
	if layerId then  -- 把对话 添加到某一层上
		local pos = self:convertToWorldSpace(ccp(0,0))
		self.guideTip:setPosition(pos.x + offsetX, pos.y + offsetY)
		local gLayer = ViewMgr:getGameLayer(layerId)
		gLayer:addChild(self.guideTip)
	else
		self.guideTip:setPosition(offsetX,offsetY)
		self:addChild(self.guideTip)
	end

	self:hideHand()

	self.guideTip:setText(str,function() self:showHand() end,guideId)
	-- print("function GuideArrow:showTipText(str,offsetX,offsetY,layerId,absolute)", layerId)
end

function GuideArrow:hideTipText()
	self:showHand()
	if self.guideTip then
		self.guideTip:dispose()
		self.guideTip = nil
	end
end

function GuideArrow:hasTipText()
	return self.guideTip ~= nil
end

function GuideArrow:showGuideText(id,step,offsetX,offsetY,layerId,replace)
	local info = GuideCfg:getGuide(id)
	if not info.dialog then
		return
	end
	local str = info.dialog[step or 1]
	-- print("function GuideArrow:showGuideText(id,step,offsetX,offsetY,layerId,replace,absolute)", str)
	if str then
		if replace then
			str = util.strFormat(str, replace)
		end
		self:showTipText(str,offsetX,offsetY,layerId,id)
	else
		print("--没对话。。",id,step)
	end
end

--析构
function GuideArrow:dispose()
	self.downCallBack = nil
	self:removeMask()
	if self._moveMagic then
		self._moveMagic:removeFromParent()
		self._moveMagic:release()
		self._moveMagic = nil
	end
	if self._touch then
		self._touch:removeFromParent()
		self._touch:dispose()
		self._touch = nil
	end
	self.target = nil
	self:hideTipText()
	self._hand:removeFromParent()
	self._hand:release()
	self._hand = nil
	self:removeFromParent()
	self:release()
	ResMgr:unload("ui/guide/guide.pvr.ccz")
end

return GuideArrow
