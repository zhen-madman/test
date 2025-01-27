--
-- Author: wdx
-- Date: 2014-12-10 10:40:10
-- 中间是  tile 平铺的  头尾各有一个不平铺的

local  MiddleTile = class("MiddleTile",function() return display.newNode() end)

function MiddleTile:ctor(size,headImage,tileImage,endImage)
	local isEndScaleX = false
	if not endImage or endImage == headImage then
		isEndScaleX = true
		endImage = headImage
	end

	self:setContentSize(size)

	local head = display.newXSprite(headImage)
	head:setAnchorPoint(ccp(0,0))
	self:addChild(head)

	local endSp = display.newXSprite(endImage)
	endSp:setAnchorPoint(ccp(0,0))

	local headSize = head:getContentSize()
	local endSize = endSp:getContentSize()

	self:addChild(endSp)
	if isEndScaleX then
		endSp:setScaleX(-1)
		endSp:setPositionX(size.width)
	else
		endSp:setPositionX(size.width-endSize.width)
	end
	local middleSize = CCSize(size.width-headSize.width-endSize.width+2,size.height)
	local middle = display.newXTileSprite(tileImage,middleSize)
	middle:setAnchorPoint(ccp(0,0))
	middle:setPositionX(headSize.width-1)
	self:addChild(middle)
end


return MiddleTile