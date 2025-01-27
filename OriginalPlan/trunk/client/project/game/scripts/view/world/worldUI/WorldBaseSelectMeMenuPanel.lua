local WorldBaseSelectMeMenuPanel = class("WorldBaseSelectMeMenuPanel", function() return display.newNode() end)

function WorldBaseSelectMeMenuPanel:ctor(priority, map)
	self._map = map
    self.uiNode = UINode.new(priority - 1, true)
    self.uiNode:setUI("world_base_select_me_menu")
    self:addChild(self.uiNode)
	self._priority = priority-1
	self:setAnchorPoint(ccp(0,0))
	self.name = self.uiNode:getNodeByName("name")
	self.pos = self.uiNode:getNodeByName("pos")
	self.btnEnter = self.uiNode:getNodeByName("enter_btn")
	self.btnEnter:addEventListener(Event.MOUSE_CLICK, {self, self.clickEnter})
    self:retain()
end

function WorldBaseSelectMeMenuPanel:clickEnter(event)
	NotifyCenter:dispatchEvent({name=Notify.ENTER_TOWN})
end

function WorldBaseSelectMeMenuPanel:showInfo( blockPos, mapNodePos )
    -- body
    self.blockPos = blockPos
    self._posX = blockPos.x
    self._posY = blockPos.y
    self:setPosition(mapNodePos)
    self.data = WorldMapModel:getAllElemInfoAt( blockPos )
	dump(self.data)
	self.name:setText('我的城堡')
	local pos = self.data.base.data.worldPos
	self.pos:setText(string.format("x:%.0f,y:%.0f",pos.x,pos.y))
end

function WorldBaseSelectMeMenuPanel:dispose()
	self.btnEnter:removeEventListener(Event.MOUSE_CLICK,{self,self.clickEnter})
    self.uiNode:dispose()
    self:release()
end

function WorldBaseSelectMeMenuPanel:updateInfo( mapNodePos )
    -- body
    self:setPosition(mapNodePos)
end

function WorldBaseSelectMeMenuPanel:dispose()
end

return WorldBaseSelectMeMenuPanel