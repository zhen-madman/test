--[[
	class:		WMSelectController
	desc:
	author:		郑智敏
--]]
local WMChildElemControllerBase = game_require('view.world.map.mapElem.WMChildElemControllerBase')
local WorldBaseSelectMenuPanel = game_require('view.world.worldUI.WorldBaseSelectMenuPanel')
local WorldBaseSelectMeMenuPanel = game_require('view.world.worldUI.WorldBaseSelectMeMenuPanel')
local WMSelectController = class('WMSelectController',WMChildElemControllerBase)

function WMSelectController:ctor( map )
	--! WorldMap
	self._map = map
	self._menuUI = nil
	self._meMenuUI = WorldBaseSelectMeMenuPanel.new(self._map:getPriority(), self._map);
	self._meMenuUI:setScale(0.8)
	self._meMenuUI:retain()
	self._enemyMenuUI = WorldBaseSelectMenuPanel.new(self._map:getPriority(), self._map);
	self._enemyMenuUI:retain()
	self._enemyMenuUI:setScale(0.8)

	WMChildElemControllerBase.ctor(self,map)
	self._selectPic = display.newXSprite('#yw_bg_5.png')
	self._selectPic:setImageSize(self._map:getBlockSize())
	self._selectPic:retain()
	self._selectPic:setAnchorPoint(ccp(0.5,0.5))

	self._needRemoveList = {}
end

function WMSelectController:getAllElemInfoAt(blockPos)
	local allInfo = WorldMapModel:getAllElemInfoAt( blockPos )
	local march = self._map:getMarchInBlockPos(blockPos)
	if march ~= nil then
		allInfo.march = {name=march, hasElem = true}
	else
		allInfo.march = {name="", hasElem = false}
	end
	return allInfo;
end

function WMSelectController:getAllElemInfoSelect(blockPos)
	local allInfo = WorldMapModel:getAllElemInfoAt( blockPos )
	local march = self._map:getMarchHasSelected()
	if march ~= nil then
		allInfo.march = {name=march, hasElem = true}
	else
		allInfo.march = {name="", hasElem = false}
	end
	return allInfo;
end

function WMSelectController:selectAt( blockPos )
	local mapNodePos = self._map:getMapPosAtMidOfBlockRange(blockPos, blockPos)
	local allInfo = self:getAllElemInfoSelect(blockPos)
	if allInfo.march.hasElem then
		self._map:selectMarch(allInfo.march.name)
		self:_removePicsInList()
		if nil ~= self._selectPic:getParent() then
			self._selectPic:removeFromParent()
		end
	elseif allInfo.base.hasElem then
		if self._menuUI ~= nil then
			self._menuUI:removeFromParent()
			self._menuUI = nil
		end
		if allInfo.base.data.worldPlayerInfo.relationShip == 1 then
			self._menuUI = self._meMenuUI
		else
			self._menuUI = self._enemyMenuUI
		end
		if nil == self._menuUI:getParent() then
			self._map:addChild(self._menuUI, 3)
		end
		self._menuUI:showInfo(blockPos,mapNodePos)
		local originNodePosX,originNodePosY = self._map:getblockOriginNode():getPosition()
		self._selectPic:setPosition(ccp(mapNodePos.x - originNodePosX, mapNodePos.y - originNodePosY ))
		self._selectPic:setVisible(true)
		self:_removePicsInList()
		if nil == self._selectPic:getParent() then
			self._map:getblockOriginNode():addChild(self._selectPic,2)
		end
	else
		self:unselect()
		local originNodePosX,originNodePosY = self._map:getblockOriginNode():getPosition()
		self._selectPic:setPosition(ccp(mapNodePos.x - originNodePosX, mapNodePos.y - originNodePosY ))
		self._selectPic:setVisible(true)
		self:_removePicsInList()
		if nil == self._selectPic:getParent() then
			self._map:getblockOriginNode():addChild(self._selectPic,2)
		end
	end
end

function WMSelectController:_setEnemyArmyDefeat( enemyDefeatList, controllerType )
	-- body
	if 0 < #enemyDefeatList then
		self._selectPic:setVisible(false)
	end
	for _,emenyDefeatPos in ipairs(enemyDefeatList) do
		local defeatRangePosList = WorldMapProxy:getElemInfoController( controllerType ):getEnemyDefeatRangeListAt( emenyDefeatPos )
		for _,pos in ipairs(defeatRangePosList) do
			local defeatPic = display.newXSprite('#yw_bg_6.png')
			defeatPic:setImageSize(self._map:getBlockSize())
			defeatPic:setAnchorPoint(ccp(0.5,0.5))

			local mapNodePos = self._map:getMapPosAtMidOfBlockRange(pos, pos)
			local originNodePosX,originNodePosY = self._map:getblockOriginNode():getPosition()
			defeatPic:setPosition(ccp(mapNodePos.x - originNodePosX, mapNodePos.y - originNodePosY ))

			local fadeOut = CCFadeOut:create(0.5)
			local fadeIn = CCFadeIn:create(0.5)
			local fadeInAndOut = CCSequence:createWithTwoActions(fadeIn, fadeOut)
			local repeatAction = CCRepeat:create(fadeInAndOut, 3)
			defeatPic:runAction(repeatAction)

			self._map:getblockOriginNode():addChild(defeatPic,1)
			self._needRemoveList[#self._needRemoveList + 1] = defeatPic
		end
	end
end

function WMSelectController:_removePicsInList()
	for _,v in ipairs(self._needRemoveList) do
		v:removeFromParent()
	end
	self._needRemoveList = {}
end

function WMSelectController:unselect()
	self:_removePicsInList()
	if nil ~= self._selectPic:getParent() then
		self._selectPic:removeFromParent()
	end
	if self._menuUI ~= nil then
		if nil ~= self._menuUI:getParent() then
			self._menuUI:removeFromParent()
			self._menuUI:dispose()
			self._menuUI = nil
		end
	end
	self._map:unSelectMarch()
end

function WMSelectController:hasSelect()
	if self._map:hasMarchSelected() then
		return true;
	end

	return self._menuUI ~= nil
end

function WMSelectController:setElems( moveVector )
	if nil ~= self._menuUI and nil ~= self._menuUI:getParent() then
		local posX,posY = self._menuUI:getPosition()
		posX = posX + moveVector.x
		posY = posY + moveVector.y
		self._menuUI:updateInfo(ccp(posX, posY))
	end
end

function WMSelectController:dispose()

	self:_removePicsInList()
	self._menuUI = nil
	if self._meMenuUI:getParent() ~= nil then
		self._meMenuUI:removeFromParent()
	end
	self._meMenuUI:dispose()
	self._meMenuUI:release()
	if self._enemyMenuUI:getParent() ~= nil then
		self._enemyMenuUI:removeFromParent()
	end
	self._enemyMenuUI:dispose()
	self._enemyMenuUI:release()
	self._selectPic:removeFromParent()
	self._selectPic:release()
end

return WMSelectController
