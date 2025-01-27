
--开场的 一些 动画 动作 等  的委托

local FightBeginDelegateEx = class("FightBeginDelegateEx")


function FightBeginDelegateEx:ctor(panel)
	self.panel = panel
end

function FightBeginDelegateEx:start(fightInfo,callback)
	self.callback = callback
	self.fightInfo = fightInfo
	-- self.STEP_SCALE = {0.6,1,0.6,1,0.6}


	self.dialogs = (fightInfo.info and fightInfo.info.dialogs) or nil


	self:changeScene(self.fightInfo.sceneId)

	FightDirector:enterScene()
	FightTrigger:dispatchEvent({name=FightTrigger.FIGHT_ENTER})

	FightDirector:touchEnabled(false)

	FightDirector:getSysHandle():fightBegin()

	if FightDirector:isNetFight() then
		FightNet:init()
	end

	if false  then
		local x,y = FightDirector:getMap():toScenePos(55,77)
		FightDirector:getCamera():setSceneScale(1,x,y,false)
		--FightDirector:getCamera():moveCenterPosByMap(84,70,20)
		FightDirector:getCamera():setCenterPosByMap(20,36)
		--FightDirector:getCamera():setSceneCenter()
		self:_moveSceneEnd()
	else
		self:_startMove()
	end

end

function FightBeginDelegateEx:changeScene(sceneId)
	local sceneCfg = FightCfg:getSceneCfg(sceneId)

	if sceneCfg.globalMagic then
		local mInfo = FightCfg:getMagic(sceneCfg.globalMagic)
		mInfo.parent = 5
		local mgaic = FightEngine:createMagic(nil, sceneCfg.globalMagic, nil, nil,{x=self.panel.scene.width/2,y=self.panel.scene.height/2})
		mgaic.totalTime = 999999999
	end
	local localMagic = sceneCfg.localMagic
	if localMagic then
		local bgX,bgY = self.panel.scene:getBgOriginPos()
		for i,mCfg in ipairs(localMagic) do
			local mId,x,y = mCfg[1],mCfg[2],mCfg[3]
			local mInfo = FightCfg:getMagic(mId)
			mInfo.parent = 5
			x,y = FightDirector:getMap():toScenePos(x,y)
			local mgaic = FightEngine:createMagic(nil, mId, nil, nil,{x=bgX+x,y=bgY+y})
			mgaic.totalTime = 999999999
		end
	end
end

function FightBeginDelegateEx:_getTeamPos(team)

	local map = FightDirector:getMap()
	if team == FightCommon.left then
		local x,y = map:toScenePos(20,46)
		return x,y
	else
		local x,y = map:toScenePos(48,41)
		return x,y
	end
end

function FightBeginDelegateEx:_startMove()

	--local x,y = self:_getTeamPos(FightCommon.mate)
	--FightDirector:getCamera():setScenePos(x,y)
	local moveX,MoveY = self:_getTeamPos(FightCommon.enemy)
	FightDirector:getCamera():setSceneCenterPos(moveX,MoveY)

--	local x,y = self:_getTeamPos(FightCommon.enemy)
--	local curX,curY = FightDirector:getScene():getPosition()
--	local dx,dy = x-curX,y-curY
--	FightDirector:getCamera():moveSceneTo(moveX,MoveY,500)

--	local FogRunner = game_require("view.fight.runner.FogRunner")
--	self.fog = FogRunner.new()
--	self.fog:init()

	-- local hq = FightDirector:getScene():getHQ(FightCommon.enemy)
	-- if hq then
	-- 	hq:removeFromParent()
	-- end

	--self:_moveHQ(FightCommon.enemy,function() self:_moveSceneStart() end)
	self:_moveSceneStart()
end

function FightBeginDelegateEx:_moveHQ(team,callback)
	local ComeOutHQ = game_require("view.fight.runner.ComeOutHQ")
	local comeRun = ComeOutHQ.new(team)
	comeRun:start(callback)
end

function FightBeginDelegateEx:_moveSceneStart()

	--local enemyHQComeOut = function()
		-- self:_moveHQ( FightCommon.enemy,function() self:_moveSceneBack() end)
		--self:_moveSceneBack()
--end

	--local time = 0
--	 if FightDirector:getScene():getHQ(FightCommon.enemy) then
--	 	time = 2000
--	 end

	-- self:_moveSceneEnd()
	--self.fog:start(enemyHQComeOut,time)
	scheduler.performWithDelayGlobal(function() self:_moveSceneBack() end,2)
end

function FightBeginDelegateEx:_moveSceneBack()
	local back_speed = 0.3
	local x,y = self:_getTeamPos(FightCommon.mate)
	FightDirector:getCamera():moveSceneTo(x,y,back_speed)

	scheduler.performWithDelayGlobal(function() self:_moveSceneEnd() end,4)
end

function FightBeginDelegateEx:_moveSceneEnd()
	if self.dialogs then
		local dialogsId,dt = self:getDialogId(self.dialogs)
		if dialogsId and dialogsId > 0 then
			repeat
				local fType = self.fightInfo.fightType
				if fType == FightCfg.DUNGEON_FIGHT  then  --副本对话
					if DungeonModel:isDungeonFinish(self.fightInfo.info.id) then
						break  --已经完成了  不对话了
					end
					local dType = DungeonCfg:getDungeonType(self.fightInfo.info.id)
					local lastDid = CCUserDefault:sharedUserDefault():getStringForKey("dDialog"..dType)  --上次对话id是否已经对话过了
					local roleId = CCUserDefault:sharedUserDefault():getStringForKey("roleId")
					print('dType='..dType..'\tlastDid='..lastDid)
					print('roleId:'..roleId..'----RoleModel.roleInfo[RoleConst.ID]:'..RoleModel.roleInfo[RoleConst.ID])
					if roleId == tostring(RoleModel.roleInfo[RoleConst.ID]) and tonumber(lastDid) == dialogsId then
							break
					end
					CCUserDefault:sharedUserDefault():setStringForKey("roleId",RoleModel.roleInfo[RoleConst.ID]) --本地存储一下上次对话id
					CCUserDefault:sharedUserDefault():setStringForKey("dDialog"..dType,dialogsId) --本地存储一下上次对话id
					CCUserDefault:sharedUserDefault():flush()
				end
				local isGuide = false--FightDirector:getSysHandle().isNewHand
				ViewMgr:open(Panel.DIALOG,{id=dialogsId,forbidSkip=isGuide,time=dt,dialogEnd=function() self:_onDialogOut() end})
				return
			until true
		end
	end

	local FightCountDown = game_require("view.fight.runner.FightCountDown")
	self.fightCountDown =  FightCountDown.new()
	self.fightCountDown:start( function() self:_onDialogOut() end)
end

function FightBeginDelegateEx:product()
	local hero = fightHero:getHero()
	local mx,my = FightDirector:getMap():getRandomBorn(FightCommon.left, hero.scope)
	local num = hero.cfg.heroNum or 1
	local flag = false
	for i=1,num do
		if hero.isMonster then
			NewHandle:createMonster(hero,mx,my,FightCommon.mate)
		else
			return NewHandle:createHero(hero,mx,my,FightCommon.mate)
		end
	end
end

function FightBeginDelegateEx:_onDialogOut()
	FightDirector:touchEnabled(true)
	ViewMgr:open(Panel.FIGHT_TOP_UI)
	if FightDirector:isNetFight() then
		FightNet:reqFightStart(self.callback)
	else
		self.callback()
	end
	self.fightInfo = nil
end

function FightBeginDelegateEx:getDialogId(dialogs)
	for i,dialog in ipairs(dialogs) do
		if dialog[1] == 1 then
			return dialog[2],dialog[1]
		end
	end
	return nil
end

-------------------------------------------------------------------------
function FightBeginDelegateEx:_toPlayMagic()
	if self._magicTimer == nil then
		self._magicTimer = scheduler.performWithDelayGlobal(function() self:_readyFight() end,1)
	end
end

return FightBeginDelegateEx
