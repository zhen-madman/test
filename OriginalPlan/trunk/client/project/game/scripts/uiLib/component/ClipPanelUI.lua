--region ClipPanelUI.lua
--Author : Administrator
--Date   : 2014/7/25
--此文件由[BabeLua]插件自动生成

local ClipPanelUI = class("ClipPanelUI", TouchBase)
function ClipPanelUI:ctor(bottomImageUrl, topImageUrl,size, priority,swallowTouches,clipImageUrl, imageDownFlag)
	local frameZOrder = 1
	local imageZOrder = 2
	if true == imageDownFlag then
		frameZOrder = 2
		imageZOrder = 1
	end
	TouchBase.ctor(self,priority,swallowTouches)

    self.owner = display.newXSprite(bottomImageUrl )
    self:addChild(self.owner,frameZOrder)

    size = size or self.owner:getContentSize()

    self.clipNode = display.newXClipSprite()
    self.clipNode:setSpriteImage( topImageUrl,clipImageUrl or "#com_mark_1.png",true);
    self:addChild(self.clipNode,imageZOrder)
    self.clipNode:setPosition(ccp( size.width/2,size.height /2))
    self.owner:setPosition(ccp(size.width/2,size.height/2))
    local ownerSize = self.owner:getContentSize()
    self:setContentSize(size)
    self.ScaleX = size.width/ownerSize.width
    self.ScaleY = size.height/ownerSize.height
    self:setScaleX(self.ScaleX)
    self:setScaleY(self.ScaleY)

    -- ClipPanelUI.num = 1 + ClipPanelUI.num
    -- print("ClipPanelUI num ",ClipPanelUI.num)
end

-- ClipPanelUI.num = 0

function ClipPanelUI:dispose()
    TouchBase.dispose(self)
    -- ClipPanelUI.num = ClipPanelUI.num -1
    -- print("ClipPanelUI num ",ClipPanelUI.num)
end

return ClipPanelUI
--endregion
