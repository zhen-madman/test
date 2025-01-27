local MapUpdateInfoController = game_require('view.world.map.MapUpdateInfoController')
local HomogeneousMat3x3 = game_require('math.HomogeneousMat3x3')
local WorldElemController = game_require('view.world.map.WorldElemController')
local WorldMapEffectController = game_require('view.world.map.WorldMapEffectController')
local WMMarchController = game_require('view.world.map.mapElem.march.WMMarchController')
local WorldMap = class('WorldMap', function() return display.newNode() end)

local WMBaseInfoController = game_require('model.world.map.mapElemInfoControl.WMBaseInfoController')
function WorldMap:ctor( size, panel )
	self._size = size
	self._panel = panel
	self:setContentSize(self._size)

	self._elemController = WorldElemController.new(self)
	self._effectController = WorldMapEffectController.new(self)
	self._updateInfoController = MapUpdateInfoController.new(self)
	self._marchController = WMMarchController.new(self)
	self:addChild(self._marchController)
	self:_initBlockOrigin()
	self:_initTouch()
	NotifyCenter:addEventListener(Notify.WORLD_TO_BLOCK_POS,{self, self._toBlockPos})
	NotifyCenter:addEventListener(Notify.WORLD_UNSELECT,{self,self._onUnselect})
	self.astar = AStarPathFinding:new()
end

function WorldMap:initMapData()
	self._marchController:start();
end

function WorldMap:_initBlockOrigin()
	self._toBlockMat = HomogeneousMat3x3.new()
	local blockSize = self:getBlockSize()
	self._toBlockMat.mat[1][1] = blockSize.width/2
	self._toBlockMat.mat[2][1] = blockSize.height/2
	self._toBlockMat.mat[1][2] = -blockSize.width/2
	self._toBlockMat.mat[2][2] = blockSize.height/2
	self._mapRangeInBlock = {ccp(0,0), ccp(0,0)}
	self._blockOriginNode = display.newNode()
	self._blockOriginNode:setPosition(ccp(0,0))
	self:addChild(self._blockOriginNode)
	self:setMapScale(1)
end

function WorldMap:_initTouch()
	-- body
	self._touchLayer = TouchLayer.new(self._panel:getPriority(), false)
	self._touchLayer:setContentSize(self._size)
	self._touchLayer:setAnchorPoint(ccp(0,0))
	self._touchLayer:setPosition(ccp(0,0))
	self:addChild(self._touchLayer)

	self._touchLayer:setTouchMoveValidCheck(true)

	self._touchLayer:addEventListener(Event.MOUSE_CLICK, {self, self._onTouchClick})
	self._touchLayer:addEventListener(Event.MOUSE_DOWN, {self, self._onTouchDown})
	self._touchLayer:addEventListener(Event.MOUSE_MOVE, {self, self._onTouchMove})
	self._touchLayer:addEventListener(Event.MOUSE_END, {self, self._onTouchEnd})
end

function WorldMap:updateInfoControllerMoveEnd()
	local x, y = self._blockOriginNode:getPosition()
	self._blockOriginNode:setPosition(math.floor(x),math.floor(y))
	self._updateInfoController:moveEnd()
end

function WorldMap:_onTouchEnd()
	-- body
	if not self._touchInfo.hasClick and self:hasMarchSelected() then
		self:unSelectMarch()
	end
	self._touchInfo = nil
	self._updateInfoController:moveEnd()
	if self._moveTimer then
		self._moveTimer = scheduler.unscheduleGlobal(self._moveTimer)
		self._moveTimer = nil
	end
end

function WorldMap:_onTouchDown( event )
	-- body
	self._touchInfo = {}
	self._touchInfo._currPos = ccp(event.x, event.y)
	self._touchInfo._lastPos = self._touchInfo._currPos
	self._touchInfo._downPos = ccp(event.x, event.y)
	self._touchInfo.isMove = false
	self._touchInfo.hasClick = false
	if not self:hasMarchSelected() then
		if not self._moveTimer then
			self._showMineLvCount = 10
			self._moveTimer = scheduler.scheduleUpdateGlobal(function() self:_onMoveTimer() end)
		end
	end
end

function WorldMap:_onTouchMove( event )
	-- body
	if not self._touchInfo then
		self:_onTouchEnd()
		return
	end
	if not self._touchInfo.isMove then
		if math.abs(self._touchInfo._downPos.x - event.x) + math.abs(self._touchInfo._downPos.y - event.y) > 10 then
			self._touchInfo.isMove = true
			if true == self._elemController:hasSelect() then
				self._elemController:unselect()
			end
		end
	end

	self._touchInfo._currPos = ccp(event.x, event.y)
end

function WorldMap:moveBy(dx, dy)
	local blockOriginPosX, blockOriginPosY = self._blockOriginNode:getPosition()
	self._blockOriginNode:setPosition(blockOriginPosX + dx, blockOriginPosY + dy)
	local x,y = self._blockOriginNode:getPosition()
	self:_originUpdate(ccp(x-blockOriginPosX,y-blockOriginPosY))
	self._showMineLvCount = 0
	self._elemController:getChildElemController(WorldMapModel.MINE):setMineLvShow( false )
end

function WorldMap:_onMoveTimer()
	if self._touchInfo and self._touchInfo._currPos then
		local dx = self._touchInfo._currPos.x - self._touchInfo._lastPos.x
		local dy = self._touchInfo._currPos.y - self._touchInfo._lastPos.y

		if math.abs(dx) + math.abs(dy) > 5 then
			self._touchInfo._lastPos = self._touchInfo._currPos
			self:moveBy(dx,dy)
		else
			self._showMineLvCount = self._showMineLvCount + 1
			if self._showMineLvCount == 15 then
				self._elemController:getChildElemController(WorldMapModel.MINE):setMineLvShow( true )
			end
		end
	end
end

function WorldMap:_onTouchClick(event)
	-- body
	if not self._touchInfo then
		return
	end
	if self._touchInfo.isMove or self._showMineLvCount > 15 then
		return
	end
	self._touchInfo.hasClick = true
	if true == self._elemController:hasSelect() then
		self._elemController:unselect()
		self._elemController:getChildElemController(WorldMapModel.MINE):setMineLvShow( false )
	else
		local mapNodePos = ccp(event.x, event.y)
		local blockPos = self:getBlockPosFromMapNodePos(mapNodePos,true)
		local mapSize = WorldMapCfg:getMapSize()
		if blockPos.x < 0 or blockPos.x >= mapSize.width or blockPos.y < 0 or blockPos.y >= mapSize.height then
			return
		end
		self._elemController:selectAt(blockPos)
		self._elemController:getChildElemController(WorldMapModel.MINE):setMineLvShow( true )
	end
end

function WorldMap:_onUnselect(event)
	self._elemController:unselect(blockPos)
end

function WorldMap:hasMarchSelected()
	return self._marchController:hasMarchSelected()
end

function WorldMap:unSelectMarch()
	self._marchController:unSelectMarch()
end

function WorldMap:selectMarch(name)
	self._marchController:selectMarch(name)
end

function WorldMap:getMarchHasSelected()
	return self._marchController:getMarchHasSelected()
end
function WorldMap:getMarchInBlockPos(blockPos)
	return self._marchController:getMarchInBlockPos(blockPos)
end

function WorldMap:getElemByPos(elemName, blockPos)
	return self._elemController:getElemByPos(elemName, blockPos)
end

function WorldMap:getPriority()
	-- body
	return self._panel:getPriority()
end

local BLOCK_SIZE = ccsize(256, 128)
function WorldMap:getBlockSize()
	-- body
	return BLOCK_SIZE
end

--手动缩放后的大小
function WorldMap:setMapScale( scale )
	self._sceneScale = scale
end

--获取缩放后的大小
function WorldMap:getMapScale()
	return self._sceneScale
end

function WorldMap:getMapNodeRange()
	-- body
	local scale = self:getMapScale()
	return ccp(0,0) , ccp(self._size.width*scale, self._size.height*scale)
end

function WorldMap:getWorldPosFromBlockPos( blockPos )
	local orgX, orgY = self:getblockOriginNode():getPosition()
	local midPos = self:getMapPosAtMidOfBlockRange(blockPos, blockPos)
	return ccp(midPos.x - orgX, midPos.y - orgY)
end

function WorldMap:getBlockPosFromWorldPos( worldPos )
	local orgX, orgY = self:getblockOriginNode():getPosition()
	local midPos = ccp(worldPos.x+orgX,worldPos.y+orgY)
	return self:getBlockPosFromMapNodePos(midPos, true);
end

function WorldMap:getMapNodePosFromBlockPos( blockPos )
	-- body
	return self._toBlockMat:transformPos(blockPos)
end

function WorldMap:getBlockPosFromMapNodePos( mapNodePos , integerFlag )
	-- body
	local resultPos = self._toBlockMat:getInverse():transformPos(mapNodePos)
	if true == integerFlag then
		resultPos.x = math.floor(resultPos.x)
		resultPos.y = math.floor(resultPos.y)
	end
	return resultPos
end

function WorldMap:checkIsOutOfMapNode(leftDownBlockPos, rightUpBlockPos)
	if self._mapRangeInBlock[1].x >= (rightUpBlockPos.x + 1) or self._mapRangeInBlock[2].x <= leftDownBlockPos.x
		or self._mapRangeInBlock[1].y >= (rightUpBlockPos.y + 1) or self._mapRangeInBlock[2].y <= leftDownBlockPos.y then

		return true
	else
		return false
	end
end

function WorldMap:getblockOriginNode(  )
	-- body
	return self._blockOriginNode
end

function WorldMap:getBlockMapRange( )
	return ccp(math.floor(self._mapRangeInBlock[1].x), math.floor(self._mapRangeInBlock[1].y) ),
		ccp(math.floor(self._mapRangeInBlock[2].x), math.floor(self._mapRangeInBlock[2].y) )
end

function WorldMap:setMidMapBlockPos(midBlockPos)
	self._updateInfoController:setMidPos( midBlockPos )
	--计算中间块与原点块的距离(在菱形坐标表示下)
	local originToMidBlockVector = ccp(midBlockPos.x + 0.5, midBlockPos.y + 0.5)
	--将该距离转换为mapNode的坐标系下的表示
	originToMidBlockVector = self._toBlockMat:transformPos(originToMidBlockVector)
	local preOriginX,preOriginY = self._blockOriginNode:getPosition()
	originToMidBlockVector.x = originToMidBlockVector.x - preOriginX
	originToMidBlockVector.y = originToMidBlockVector.y - preOriginY

	--计算菱形坐标的原点距离mapNode坐标系的距离(在mapNode坐标系的表示下)
	mapNodeOriginToBlockOriginVector = ccp( -originToMidBlockVector.x + self._size.width/2,
	 		-originToMidBlockVector.y + self._size.height/2 )
	print("WorldMap:setMidMapBlockPos",mapNodeOriginToBlockOriginVector.x, mapNodeOriginToBlockOriginVector.y)
	self._blockOriginNode:setPosition(ccp(mapNodeOriginToBlockOriginVector.x, mapNodeOriginToBlockOriginVector.y))

	self:_originUpdate(ccp(mapNodeOriginToBlockOriginVector.x - preOriginX, mapNodeOriginToBlockOriginVector.y - preOriginY))
end

function WorldMap:_originUpdate( moveVector )
	local blockOriginPosX, blockOriginPosY = self._blockOriginNode:getPosition()
	self._toBlockMat.mat[1][3] = blockOriginPosX
	self._toBlockMat.mat[2][3] = blockOriginPosY
	print("WorldMap:_originUpdate",blockOriginPosX, blockOriginPosY)
	local bSize = self:getBlockSize()
	local bw,bh = bSize.width,bSize.height

	local leftDownMapNodeInBlockPos = self:getBlockPosFromMapNodePos(ccp(-bw,-bh), false)
	local leftUpMapNodeInBlockPos = self:getBlockPosFromMapNodePos(ccp(-bw, self._size.height + bh), false)
	local rightDownMapNodeInBlockPos = self:getBlockPosFromMapNodePos(ccp(self._size.width + bw,-bh), false)
	local rightUpMapNodeInBlockPos = self:getBlockPosFromMapNodePos(ccp(self._size.width + bw, self._size.height+ bh), false)

	self._mapRangeInBlock = {ccp(leftDownMapNodeInBlockPos.x,rightDownMapNodeInBlockPos.y),ccp(rightUpMapNodeInBlockPos.x, leftUpMapNodeInBlockPos.y),}
	self:_setElems(moveVector)
	self._updateInfoController:move(moveVector)
end

function WorldMap:getMapPosAtMidOfBlockRange(leftDownBlockPos, rightUpBlockPos)
	local leftDownBlockInMapPos = self:getMapNodePosFromBlockPos(ccp(leftDownBlockPos.x, leftDownBlockPos.y))
	local leftUpBlockInMapPos = self:getMapNodePosFromBlockPos(ccp(leftDownBlockPos.x, rightUpBlockPos.y + 1))
	local rightDownBlockInMapPos = self:getMapNodePosFromBlockPos(ccp(rightUpBlockPos.x + 1, leftDownBlockPos.y))
	local rightUpBlockInMapPos = self:getMapNodePosFromBlockPos(ccp(rightUpBlockPos.x + 1, rightUpBlockPos.y + 1))

	return ccp((leftDownBlockInMapPos.x + rightUpBlockInMapPos.x)/2, (leftUpBlockInMapPos.y + rightDownBlockInMapPos.y)/2)
end

function WorldMap:getBlockPosAtMidOfMapNode(  )
	-- body
	return self._updateInfoController:getMidPos()
end

function WorldMap:_setElems( moveVector )
	print("WorldMap:_setElems",moveVector.x,moveVector.y)
	-- body
	self._elemController:setElems( moveVector )
end

function WorldMap:_toBlockPos( event )
	self:setMidMapBlockPos(ccp(event.x, event.y))
	if true == event.setSelectFlag then
		self._elemController:selectAt(ccp(event.x, event.y))
	end
end

function WorldMap:dispose()
	-- body
	if self._moveTimer then
		self._moveTimer = scheduler.unscheduleGlobal(self._moveTimer)
		self._moveTimer = nil
	end
	self._touchLayer:dispose()
	self._elemController:dispose()
	self._blockOriginNode:removeFromParent()
	self._updateInfoController:dispose()
	self._effectController:dispose()
	self._marchController:dispose()
	NotifyCenter:removeEventListener(Notify.WORLD_TO_BLOCK_POS,{self, self._toBlockPos})
	NotifyCenter:removeEventListener(Notify.WORLD_UNSELECT,{self,self._onUnselect})
	WorldMapModel:clearMapInfo()
end

return WorldMap