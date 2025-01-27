
--场景触摸委托 类

local SceneTouchDelegate = class("SceneTouchDelegate")

function SceneTouchDelegate:ctor(panel)
	self.panel = panel
	self:_init(panel.scene)
end

function SceneTouchDelegate:_init(scene)
	scene:setTouchEnabled(true)
	-- scene:setTouchMode(kCCTouchesAllAtOnce)
	scene:addTouchEventListener(handler(self,self._onTouchScene),false,-257,false)  --多点触摸
end

--鼠标事件，
function SceneTouchDelegate:_onTouchScene(event,x,y)
	local ret
	if event == "began" then
		ret = self:_onTouchBegan(event,x,y)
	elseif event == "moved" then
		self:_onTouchMoved(event,x,y)
	elseif event == "ended" then
		self:_onTouchEnded(event,x,y)
	elseif event == "canceled" then
		self:_onTouchEnded(event,x,y)
	end
	return ret
end

function SceneTouchDelegate:_onTouchBegan( e,x,y )
	if DEBUG == 2 then
	 	if FightDirector.status ~= FightCommon.pause and FightDirector.status ~= FightCommon.start then
	 		return false
	 	end
	elseif FightDirector.status ~= FightCommon.start then
		return false
	end
	if FightDirector:getSceneTouchEnable() then
		FightDirector:getCamera():setAuto(false)
		self._lastX,self._lastY = x,y
		self.mouseX,self.mouseY = x,y
		self.isMove = false

		if isShowTile then
			self._curTouchTileList = {}
		end
		return true
	else
		return false
	end
end

function SceneTouchDelegate:_onTouchMoved(e,x,y )

	if DEBUG == 2 then
	 	if FightDirector.status ~= FightCommon.pause and FightDirector.status ~= FightCommon.start then
	 		return false
	 	end
	elseif FightDirector.status ~= FightCommon.start then
		return false
	end
	if FightDirector:getSceneTouchEnable() == false then
		return
	end
	if not self.mouseX then
		return
	end
	local dx = x - self.mouseX
	local dy = y - self.mouseY
	self.mouseX = x
	self.mouseY = y

	if math.abs(self._lastX-x) + math.abs(self._lastY-y) > 1 then
		self.isMove = true
		--[[
		local map = FightDirector:getMap()
		if isShowTile and map:getParent() then
			x,y = Formula:globalToScenePos(x,y)

			local mx,my = map:toMapPos(x,y)
			local tile = map:getTile(mx,my)
			if tile and not self._curTouchTileList[tile] then
				self._curTouchTileList[tile] = true
				if map:getTileContent(mx, my) == FightMap.BLOCK then
					map:removeBlock(mx,my)
				else
					map:setTileContent(mx, my, FightMap.NONE)
					map:addBlock(mx,my)
				end
			end
			if tile then
				return
			end
		end
		--]]
	end

	local curX,curY = self.panel.scene:getPosition()
	local newX,newY = FightDirector:getCamera():moveScene(dx,dy)
	--local scale = self.panel.scene:getSceneScale()
end

function SceneTouchDelegate:_onTouchEnded( e,x,y )

	local isDelay = true
	if DEBUG == 2 then
	 	if FightDirector.status ~= FightCommon.pause and FightDirector.status ~= FightCommon.start then
	 		self.mouseX = nil
			return false
	 	end
	elseif FightDirector.status ~= FightCommon.start then
		isDelay = false
	end
	--FightDirector:getCamera():setAuto(true,isDelay)

	if not self.isMove then
		FightTrigger:dispatchEvent({name=FightTrigger.CLICK_SCENE,x=x,y=y})
		local map = FightDirector:getMap()
		if isShowTile and map:getParent() then
			x,y = Formula:globalToScenePos(x,y)
			local mx,my = map:toMapPos(x,y)
			print("SceneTouchDelegate:_onTouchEnded",x,y,mx,my)
			if map:getTile(mx,my) then
				FightTrigger:dispatchEvent({name = FightTrigger.SELECT_TILE,tile = map:getTile(mx,my)})
			end
		end
	end

	-- local m
	-- local mList = FightDirector:getScene():getTeamList(FightCommon.mate)
	-- for i,c in ipairs(mList) do
	-- 	if c.cInfo.atkRes then --and c.cInfo.scope == 1 then
	-- 		m = c
	-- 		break
	-- 	end
	-- end
	-- if m then
		-- local ai = AIMgr:getAI(m)
		-- x,y = Formula:globalToScenePos(x,y)
		-- local offx,offy = Formula:getLengthXY(m.cInfo.posLength)
		-- x,y = x-offx,y-offy
		-- ai.moveAI:setMoveToTargetPos({x=x,y=y})
	-- end



	-- local x,y = touchs[1],touchs[2]
	-- if self._lastPos then
	-- 	x,y = Formula:globalToScenePos(x,y)
	-- 	local map = FightDirector:getMap()
	-- 	local mx,my = map:toMapPos(x,y)

	-- 	local tile = map:getTile(mx,my)
	-- 	tile:setTileColor(2)

	-- 	tile.posLength = 3

	-- 	-- local dx,dy = self:getPathTargetXY(self._lastPos,{mx=mx,my=my},1)

	-- 	local lastTile = map:getTile(self._lastPos.mx,self._lastPos.my)
	-- 	lastTile.posLength = 2
	-- 	local dx,dy = FightDirector:getMap():getCreatureRoundGap(lastTile,tile)
	-- 	if dx then
	-- 		local tile = map:getTile(dx,dy)
	-- 		tile:setTileColor(2)
	-- 	end

	-- 	-- print("开始寻路：",self._lastPos.x, self._lastPos.y,mx,my)
	-- 	-- local path = map:getPath(self._lastPos.mx, self._lastPos.my,mx,my,2)
	-- 	-- if path and #path > 1 then
	-- 	-- 	for i=1,#path,1 do
	-- 	-- 		local index = 2*(i)-1
	-- 	-- 		local x = path[index]
	-- 	-- 		local y = path[index+1]
	-- 	-- 		if not x then
	-- 	-- 			break
	-- 	-- 		end
	-- 	-- 		print(x,y)
	-- 	-- 		local tile = map:getTile(x,y)
	-- 	-- 		tile:setTileColor(2)
	-- 	-- 	end
	-- 	-- else
	-- 	-- 	print("no path")
	-- 	-- end

	-- 	self._lastPos = nil
	-- else
	-- 	self._lastPos = {}
	-- 	x,y = Formula:globalToScenePos(x,y)
	-- 	local map = FightDirector:getMap()
	-- 	local mx,my = map:toMapPos(x,y)
	-- 	self._lastPos.mx = mx
	-- 	self._lastPos.my = my

	-- 	local tile = map:getTile(mx,my)
	-- 	tile:setTileColor(2)
	-- 	print(x,y,mx,my)
	-- end
	self.mouseX = nil
end

function SceneTouchDelegate:getPathTargetXY(creature,target,maxDis)
	creature.posLength = 2
	local mx,my,tx,ty = creature.mx,creature.my,target.mx,target.my
	local dx,dy = tx - mx,ty-my
	local curDis = math.abs(dx) + math.abs(dy)
	local rate = maxDis/curDis
	dx,dy = math.floor(dx*rate),math.floor(dy*rate)

	local startX,startY = tx - dx, ty -dy

	local r = -math.atan2(dy,dx)
	local cos,sin = math.cos(r),math.sin(r)

	local toGlobal = function(x,y)
		return math.floor(startX + cos*x + sin*y + 0.5), math.floor(startY + cos*y + sin*x+0.5)
	end

 	for x=0,2*maxDis do
 		for y=0,x do
 			local gx,gy = toGlobal(x,y)
 			-- print("几个。。",startX,startY,x,y,gx,gy,maxDis,curDis,Formula:getDistance(gx,gy,tx,ty))
 			if Formula:getDistance(gx,gy,tx,ty) <= maxDis then
 				if FightDirector:getMap():canStandCreature(gx,gy,creature) then
 					return gx,gy
 				end
 			end
 		end
 	end
end


return SceneTouchDelegate