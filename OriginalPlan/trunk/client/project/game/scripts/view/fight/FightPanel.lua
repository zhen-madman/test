--
--

FightDirector = game_require("view.fight.FightDirector")

local FightScene = game_require("view.fight.FightScene")

local FightUi = game_require("view.fight.fightUI.FightUi")

local SceneTouchDelegate = game_require("view.fight.delegate.SceneTouchDelegate")
local FightBeginDelegate = game_require("view.fight.delegate.FightBeginDelegateEx")
local FightEndDelegate = game_require("view.fight.delegate.FightEndDelegate")
local DropBoxDelegate = game_require("view.fight.delegate.DropBoxDelegate")
local FightLoading = game_require("view.fight.FightLoading")
local EchelonDelegate = game_require("view.fight.delegate.EchelonDelegate")
local FightPanel = class("FightPanel",PanelProtocol)

function FightPanel:init()
	self:initUI()
	XUtil:setAStarFindType(1)
end

function FightPanel:initUI()
	ResMgr:loadPvr("ui/fight/fight.pvr.ccz")
	self._isLoadPvr = true

	self.sceneContainer = display.newNode()
	self:addChild(self.sceneContainer)

	self.scene = FightScene.new()
	self.sceneContainer:addChild(self.scene)
	self.sceneContainer:setContentSize(CCSize(display.width,display.height))

	self.touchDelegate = SceneTouchDelegate.new(self)  --场景触摸代理
	self.beginDelegate = FightBeginDelegate.new(self) --开场委托
	self.endDelegate = FightEndDelegate.new(self) --结束委托
	self.dropDelegate = DropBoxDelegate.new(self)  --掉落委托
	self.echelonDelegate = EchelonDelegate.new()
	self.ui = FightUi.new(self:getPriority())

end

function FightPanel:_onTouchEnded( e,touchs )  --deom用
	self.touchDelegate:_onTouchEnded(e,touchs)
end

function FightPanel:getSceneScale(  )
	return self.scene:getSceneScale()
end

function FightPanel:onStart()
	if self:getParent() == nil then
		return
	end
	self.dropDelegate:start()
	FightDirector:start()
	self.ui:start()
end

function FightPanel:fightBengin()
	self.scene:initScene(self.fightInfo.sceneId)
	FightDirector:prepare()
	if not self.ui:getParent() then
		self:addChild(self.ui)
	end

	self.ui:prepare()

	if self.fightInfo.fightType ~= FightCfg.FILM_FIGHT then  --不是电影播放
		--ViewMgr:open(Panel.SYSTEM_NOTICE,{x = display.cx - 300 })
	end

--	local soundId = FightCfg:getBgSound(self.scene.sceneId)
--	AudioMgr:playGround(soundId)

	self.mateNum = 0
	self.beginDelegate:start(self.fightInfo,handler(self,self.onStart))
	self.echelonDelegate:start(self)
end

function FightPanel:_openLoading()
	self.ui:removeFromParent()
	if not self.fightLoading then
		self.fightLoading = FightLoading.new()
		self:addChild(self.fightLoading)
	end
	self.fightLoading:startLoad(function(...) self:_loadEnd(...) end)
end

function FightPanel:_loadEnd()
	self._musicList = self.fightLoading:getMusicList()
	self.fightLoading:dispose()
	self.fightLoading = nil
	self:fightBengin()
	if not self._timerMusice then
		self._timerMusice = scheduler.scheduleGlobal(function() self:_loadMusice() end, 0.1)
	end
end

function FightPanel:_loadMusice()
	local cur = 0
	for mId,_ in pairs(self._musicList) do
		cur = cur + 1
		self._musicList[mId] = nil
		AudioMgr:preloadEffect(mId)
		if cur >= 1 then
			return true
		end
	end

	if self._timerMusice then
		scheduler.unscheduleGlobal(self._timerMusice)
		self._timerMusice = nil
	end
end

function FightPanel:initTeam(teamMate)
	if teamMate == 2 then  --在右边
		FightCommon.mate = FightCommon.right
		FightCommon.enemy = FightCommon.left
	else
		FightCommon.mate = FightCommon.left
		FightCommon.enemy = FightCommon.right
	end
	if RoleModel.roleInfo then
		if RoleModel.roleInfo.camp == 2 then
			FightCommon.red = FightCommon.mate
			FightCommon.blue = FightCommon.enemy
		else
			FightCommon.red = FightCommon.enemy
			FightCommon.blue = FightCommon.mate
		end
	end
end

function FightPanel:onOpened(params)
	FightCache:init()

	if not self._isLoadPvr then
		ResMgr:loadPvr("ui/fight/fight.pvr.ccz")
		self._isLoadPvr = true
	end
	if params then
		-- params.teamPos = 2
		self:initTeam(params.teamPos)

		self.fightInfo = params
		self.fightInfo.mercNum = 0
		self.info = self.fightInfo.info
		-- if params.fightType == FightCfg.FILM_FIGHT then  --电影播放
		-- 	FightDirector:initFilm(params)
		-- end

		FightDirector:init(self.scene,self.fightInfo)
	else

		self.fightInfo = {}
		self.info = nil

		self.fightInfo.fightType = FightCfg.TEST_FIGHT
		self.fightInfo.monsterProduct = -1

		FightDirector:init(self.scene,self.fightInfo)
	end

	FightDirector:setSceneTouchEnable(true)

--	if self.fightInfo.fightType == FightCfg.TEST_FIGHT then
--		self:fightBengin()
--	else
--		self:_openLoading()
--	end
	self:_openLoading()
end

function FightPanel:onCloseed(params)
	if self._isLoadPvr then
		ResMgr:unload("ui/fight/fight.pvr.ccz")
		self._isLoadPvr = false
	end

	self.ui:clear()

	if self.fightLoading then
		self.fightLoading:dispose()
		self.fightLoading = nil
	end

	if self._timerMusice then
		scheduler.unscheduleGlobal(self._timerMusice)
		self._timerMusice = nil
	end

	--FightDirector:stop()

	self.dropDelegate:clear()

	-- collectgarbage("collect")
	-- if self.parentPanel then
	-- 	ViewMgr:open(self.parentPanel)
	-- end
	-- dump( FightTrigger.listeners)
	self.fightInfo = nil

	if params and params.noChangeMuisc then

	else
		--AudioMgr:playGround(AudioConst.BACK_GROUND_ID)
	end

	--FightModel:clearFightReward()

	self.fightData = nil

	-- FightTrigger:dumpListener()

	FightDirector:touchEnabled(false)
	ViewMgr:close(Panel.FIGHT_TOP_UI)
	-- collectgarbage("collect")
	--ViewMgr:close(Panel.SYSTEM_NOTICE)
end

--是否显示半透明遮罩
function FightPanel:isShowMark( )
	return false
end

return FightPanel