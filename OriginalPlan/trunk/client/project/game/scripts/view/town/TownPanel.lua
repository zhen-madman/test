﻿--
-- Author: lyc
-- Date: 2016-05-23 13:56:00
-- 主城界面

local TownScene = game_require("view.town.TownScene")
local Builder = game_require("view.town.building.Builder")
local BuildingInfo = game_require("model.town.BuildingInfo")
local TownPanel = class("TownPanel", PanelProtocol)
local TownTouchLayer = class("TownTouchLayer", TouchLayer)

function TownTouchLayer:ctor(priority,swallowTouches)
	TouchLayer.ctor(self, priority, swallowTouches)

	self._touchOutFlag = false
	self:setScrollViewCheck(true)
end

function TownTouchLayer:dispose()
	self:removeEventListener(Event.MOUSE_MOVE_OUT, {self, self._onMoveOut})

	TouchLayer.dispose(self)
end

function TownTouchLayer:setMaskLayer(panel)
	self._maskPanel = panel

	self:addEventListener(Event.MOUSE_MOVE_OUT, {self, self._onMoveOut})
end

function TownTouchLayer:_onMoveOut()
	self._touchOutFlag = true;
end

function TownTouchLayer:_onTouch(event, x, y)
	if event == "began" then
		self._touchOutFlag = false
	end

	if event == "ended" then
		if self._touchOutFlag == false then
			self._maskPanel:onMouseClick(event, x, y)
		end

		self._touchOutFlag = false
	end

	TouchLayer._onTouch(self, event, x, y)

	return true
end

TownPanel.UIResPath = "ui/town/town.pvr.ccz"

function TownPanel:ctor(panelName)
	self._nodeList = nil
	--! BuildingNode
	self._buildingList = nil

	PanelProtocol.ctor(self, panelName)
end

function TownPanel:init()

end

-------------------------------------------------------
-- @class
-- @name
-- @description
-- @return TownScene:
-- @usage
function TownPanel:getMapScene()
	return self.scene;
end

function TownPanel:initUI()
	self.sceneContainer = display.newNode()
	self:addChild(self.sceneContainer)

	self.scene = TownScene.new(self:getPriority(), self)
	self.sceneContainer:addChild(self.scene)
	self.sceneContainer:setContentSize(CCSize(display.width,display.height))
	self.sceneContainer:setScale(0.5)
	self.scene:initScene(1)
	self.scene:setPosition(-2267, -1858)

	self._touchLayer = TownTouchLayer.new(self:getPriority()-2, true)
	self._touchLayer:setMaskLayer(self)
	self._touchLayer:setAnchorPoint(ccp(0,0))
	self._touchLayer:setContentSize(ccsize(display.width, display.height))
	self._touchLayer:addEventListener(Event.MOUSE_DOWN, {self, self._onTouchBegin})
	self._touchLayer:addEventListener(Event.MOUSE_MOVE, {self, self._onTouchMove})
	self._touchLayer:addEventListener(Event.MOUSE_END, {self, self._onTouchEnd})
	self:addChild(self._touchLayer)

	NotifyCenter:addEventListener(Notify.BUILDING_DELETE, {self,self._onBuildDelete})
	NotifyCenter:addEventListener(Notify.BUILDING_CREATE, {self,self._onBuildCreate})
	NotifyCenter:addEventListener(Notify.BUILDING_FAST_FINISH, {self,self._onBuildFastFinish})
	NotifyCenter:addEventListener(Notify.BUILDING_LEVELUP, {self,self._onBuildLevelUp})
	NotifyCenter:addEventListener(Notify.BUILDING_ACCELERATE, {self,self._onBuildAccelerate})
	NotifyCenter:addEventListener(Notify.PANEL_CLOSE, {self,self._onPanelClsoe})
end

function TownPanel:onMouseClick(event, x, y)
	if self.scene:hasSelect() then
		self.scene:unSelect()
		return
	end

	for k,v in pairs(self._buildingList) do
		if v.contain and v:contain(x,y) and v:getEnable() == true then
			v:onMouseClick(x,y)
			return true
		end
	end

	return false
end

function TownPanel:_onTouchBegin(event)
	self.scene:_onTouchScene("began",event.x,event.y)
end

function TownPanel:_onTouchMove(event)
	self.scene:_onTouchScene("moved",event.x,event.y)
end

function TownPanel:_onTouchEnd(event)
	self.scene:_onTouchScene("ended",event.x,event.y)
end

function TownPanel:_buildNodes()
	local townMapLayout = UINode.new(self:getPriority())
 	townMapLayout:setUI('town_building_map')

	self._nodeList = {}
	self._buildingList = {}

	local builder = game_require('view.town.building.Builder')
	builder.buildNode(self, townMapLayout)

	townMapLayout:dispose()
 	townMapLayout = nil
end

function TownPanel:getSceneScale()
	return self.scene:getSceneScale()
end

function TownPanel:onOpened(params)
	if not self._loadedRes[TownPanel.UIResPath] then
		self:loadRes(TownPanel.UIResPath)
	end

	self:initUI()

	self:_buildNodes()
end

function TownPanel:onCloseed(params)
	for k,v in pairs(self._nodeList) do
		v:dispose()
	end
	self._nodeList = {}
	self._buildingList = {}

	self.scene:dispose()
	self.scene:removeFromParent();
	self.sceneContainer:removeFromParent()
	NotifyCenter:removeEventListener(Notify.BUILDING_DELETE, {self,self._onBuildDelete})
	NotifyCenter:removeEventListener(Notify.BUILDING_CREATE, {self,self._onBuildCreate})
	NotifyCenter:removeEventListener(Notify.BUILDING_FAST_FINISH, {self,self._onBuildFastFinish})
	NotifyCenter:removeEventListener(Notify.BUILDING_LEVELUP, {self,self._onBuildLevelUp})
	NotifyCenter:removeEventListener(Notify.BUILDING_ACCELERATE, {self,self._onBuildAccelerate})
	NotifyCenter:removeEventListener(Notify.PANEL_CLOSE, {self,self._onPanelClsoe})
--	if params.dontUnload then
--		if self._loadedRes[TownPanel.UIResPath] then
--			self:unloadRes(TownPanel.UIResPath)
--		end
--	end
end

function TownPanel:_onPanelClsoe(event)
	if event.panelName == Panel.BUILDING_CREATE then
		self.scene:getBuildingController():unSelect()
	end
end

function TownPanel:_onBuildDelete(event)
	self.scene:getBuildingController():unSelect()
	self:removeBuildingNode(event.pos)
end

function TownPanel:_onBuildCreate(event)
	self.scene:getBuildingController():unSelect()
	self:createBuildingNode(event.buildId, event.nodePos, event.pos)
end

function TownPanel:_onBuildFastFinish(event)
	self:fastFinish(event.dataId)
end

function TownPanel:_onBuildLevelUp(event)
	self:buildingLevelUp(event.dataId)
end

function TownPanel:_onBuildAccelerate(event)
	self:accelerate(event.dataId, event.decTime)
end

----------对外接口---------------------------------------
function TownPanel:fastFinish(dataId)
	self.scene:getBuildingController():unSelect()
	TownModel:getBuildModel():fastFinish(dataId)
end
function TownPanel:buildingLevelUp(dataId)
	self.scene:getBuildingController():unSelect()
	local buildingNode = self:getBuildingNode(dataId);
	if nil ~= buildingNode then
		buildingNode:levelUp()
	end
end
function TownPanel:accelerate(dataId, decTime)
	self.scene:getBuildingController():unSelect()
	TownModel:getBuildModel():accelerate(dataId, decTime)
end
function TownPanel:setCreateNodeVisible(pos, flag)
	for k,v in pairs(self._buildingList) do
		if v:getPos() == pos and v:getBuildType() == "Create" then
			v:setEnable(flag)
		end
	end
end
function TownPanel:createBuildingNode(buildId, buildingNodePos, pos)
	local conf = BuildingCfg:getBuildingInfo(buildId)
	local buildName = Builder.getBuildNodeInfo(buildId).name
	local buildingNode = Builder.createNode(buildName, "#"..conf.icon..".png", pos,
		nil, ccp(buildingNodePos.x+conf.offset_x, buildingNodePos.y+conf.offset_y),
		self, TownModel:getBuildModel())
	self:addBuildingNode(buildingNode)

	local levelUpConf = BuildingCfg:getLevelUp()
	TownModel:getBuildModel():setBuildingStatus(buildingNode:getDataId(), BuildingInfo.Status.CREATE, levelUpConf[1].need_time)
	buildingNode:updateUI()
	buildingNode:startTimer()
end

function TownPanel:getBuildingNode(dataId)
	for k,v in ipairs(self._buildingList) do
		if dataId == v:getDataId() then
			return v
		end
	end

	return nil
end

function TownPanel:addBuildingNode(node)
	self:addNode(node)
	self._buildingList[#self._buildingList+1] = node
end

function TownPanel:removeBuildingNode(pos)
	--! BuildingNode
	local obj = nil
	local lists = {}
	for k,v in ipairs(self._buildingList) do
		if v:getPos() ~= pos or not v:isBaseBuilding() then
			table.insert(lists, v)
		elseif v:isBaseBuilding() then
			obj = v;
		end
	end

	self:setCreateNodeVisible(pos, true)
	if obj ~= nil then
		obj:stopTimer();
		TownModel:getBuildModel():delBuilding(obj:getDataId())
		self:removeNode(obj)
	end
	self._buildingList = lists;
end

function TownPanel:getBuildingByGroupId(groupId)
	local buildings = {}
	for k,v in ipairs(self._buildingList) do
		if groupId == v:getGroupId() then
			table.insert(buildings, v)
		end
	end

	return buildings;
end

function TownPanel:addNode(node)
	self._nodeList[#self._nodeList + 1] = node
	self.scene:addChild(node)
end

function TownPanel:removeNode(obj)
	local findFlag = false
	local lists = {}
	for _,v in pairs(self._nodeList) do
		if v ~= obj then
			table.insert(lists, v)
		else
			findFlag = true
		end
	end

	if not findFlag then
		assert(false)
	else
		obj:dispose()
		self.scene:removeChild(obj)
	end

	self._nodeList = lists;
end

function TownPanel:getNodeCount()
	return #self._nodeList
end

function TownPanel:getGroundNode()
	return self._groundNode
end

function TownPanel:isShowMark()
    return false
end

return TownPanel
