
local FightBottom = class("FightBottom",function() return display.newNode() end )

local fGrid = game_require("view.fight.fightUI.fGridEx")
local StatsUnitNumDelegate = game_require("view.fight.delegate.statistics.StatsUnitNumDelegate")
local StatsHPDelegate = game_require("view.fight.delegate.statistics.StatsHPDelegate")
local HeroBottomList = game_require("view.fight.fightUI.HeroBottomList")
--local FightHeroInfo = game_require("view.fight.fightUI.FightHeroInfo")
local NewHandle = game_require("view.fight.handle.NewHandle")

function FightBottom:ctor( priority )
	self.gridW = 56
	self.priority = priority
	local con = display.newNode()
	self:addChild(con)
	self.bottom = con
	self:initBottomBg(con)
	--self:initBottom(con)
	self.statsUnitDele = StatsUnitNumDelegate.new(self)
	self.statsHpDele = StatsHPDelegate.new(self)
	FightDirector:setIntervalRate(self._speedUp)
	self.attackGridList = {}
	self.defenceGridList = {}
end

function FightBottom:initBottomBg(con)
	local bottomBg = display.newXSprite("#fight_xxk.png")
	local size = bottomBg:getContentSize()
	bottomBg:setAnchorPoint(ccp(0,0))
	local startX = (display.width-size.width)/2
	local startY = 0
	bottomBg:setPosition(startX,startY)
	con:addChild(bottomBg)

	local vsIcon = display.newXSprite("#fight_VS_icon.png")
	local vsIconSize = vsIcon:getContentSize()
	vsIcon:setAnchorPoint(ccp(0,0))
	local VSStartX = startX+size.width/2-vsIconSize.width/2
	local VSStartY = size.height-vsIconSize.height-10
	vsIcon:setPosition(VSStartX,VSStartY)
	con:addChild(vsIcon)

	local shieldIcon = display.newXSprite("#fight_fy_icon.png")
	local shieldIconSize = shieldIcon:getContentSize()
	shieldIcon:setAnchorPoint(ccp(0,0))
	local shieldStartX = VSStartX+vsIconSize.width + 20
	local shieldStartY = VSStartY
	shieldIcon:setPosition(shieldStartX,shieldStartY)
	con:addChild(shieldIcon)

	local swordIcon = display.newXSprite("#fight_jg_icon.png")
	local swordIconSize = shieldIcon:getContentSize()
	swordIcon:setAnchorPoint(ccp(0,0))
	local swordStartX = VSStartX-swordIconSize.width-20
	local swordStartY = VSStartY
	swordIcon:setPosition(swordStartX,swordStartY)
	con:addChild(swordIcon)

	self.attack_blood = UIProgressBar.new("#fight_xxk_xt_04.png","#fight_xxk_xt_05.png",CCSize(286, 34),CCSize(286, 34))
	self.attack_blood:setAnchorPoint(ccp(0,0))
	self.attack_blood:setPosition(startX+5,startY+35)
	self.attack_blood:setClipMode(true)
	self.attack_blood:setCurProgress(60,90)
	con:addChild(self.attack_blood)
	self.attack_name = UIText.new(300, 50, 22, nil, UIInfo.color.white, UIInfo.alignment.right, UIInfo.alignment.center, true, false, true)
	con:addChild(self.attack_name)
	self.attack_name:setPosition(swordStartX-305,swordStartY+5)
	self.attack_name:setText("莫哈默德")


	self.defence_blood = UIProgressBar.new("#fight_xxk_xt_06.png","#fight_xxk_xt_05.png",CCSize(286, 34),CCSize(286, 34))
	self.defence_blood:setAnchorPoint(ccp(0,0))
	self.defence_blood:setPosition(shieldStartX+shieldIconSize.width+5,startY+35)
	self.defence_blood:setClipMode(true)
	self.defence_blood:setCurProgress(60,90)
	self.defence_blood:setRightToLeft(true)
	con:addChild(self.defence_blood)
	self.defence_name = UIText.new(300, 50, 22, nil, UIInfo.color.white, UIInfo.alignment.left, UIInfo.alignment.center, true, false, true)
	con:addChild(self.defence_name)
	self.defence_name:setPosition(shieldStartX+vsIconSize.width+7,swordStartY+5)
	self.defence_name:setText("哈巴狗")

	local offX = 10
	local leftIcon = display.newXSprite("#fight_xxk_zl_icon.png")
	leftIcon:setAnchorPoint(ccp(0,0))
	local iconStartX = startX+offX
	leftIcon:setPosition(iconStartX,0)
	con:addChild(leftIcon)

	local rightIcon = display.newXSprite("#fight_xxk_zl_icon.png")
	local iconSize = rightIcon:getContentSize()
	rightIcon:setAnchorPoint(ccp(0,0))
	rightIcon:setScaleX(-1)
	local rIconStartX = startX+size.width-iconSize.width+3*offX
	rightIcon:setPosition(rIconStartX,0)
	con:addChild(rightIcon)
	self:initButton()
	self:setCityWallImage(shieldStartX+shieldIconSize.width+10)

	self.attack_num_text = UIText.new(300, 50, 22, nil, UIInfo.color.white, UIInfo.alignment.left, UIInfo.alignment.bottom, true, false, true)
	con:addChild(self.attack_num_text)
	self.attack_num_text:setAnchorPoint(ccp(0,0))
	self.attack_num_text:setPosition(iconStartX+iconSize.width+5,0)
	self.attack_num_text:setText("100000")

	self.defence_num_text = UIText.new(300, 50, 22, nil, UIInfo.color.white, UIInfo.alignment.right, UIInfo.alignment.bottom, true, false, true)
	con:addChild(self.defence_num_text)
	self.defence_num_text:setAnchorPoint(ccp(0,0))
	self.defence_num_text:setPosition(rIconStartX-300-5*offX,0)
	self.defence_num_text:setText("100")

	local gridW = self.gridW
	local margin = 0
	local w = (display.width - 2*60)/2
	local length = math.floor( w/(gridW + margin) )
	margin = (w - length*gridW)/length
	self.attackHeroScrollList = HeroBottomList.new(ScrollView.HORIZONTAL,w,63,self.priority)
	self.attackHeroScrollList:setTouchEnabled(false)
	self.attackHeroScrollList:setMargin(margin)
	self.attackHeroScrollList:retain()
	self.attackHeroScrollList:setPosition(startX+20,startY+size.height)
	self.attackHeroScrollList.length = length
	con:addChild(self.attackHeroScrollList)

	self.defenceHeroScrollList = HeroBottomList.new(ScrollView.HORIZONTAL,w,63,self.priority)
	self.defenceHeroScrollList:setTouchEnabled(false)
	self.defenceHeroScrollList:setMargin(margin)
	self.defenceHeroScrollList:retain()
	self.defenceHeroScrollList:setPosition(shieldStartX+100,startY+size.height)
	self.defenceHeroScrollList.length = length
	con:addChild(self.defenceHeroScrollList)

	self.timeText = UIText.new(300, 50, 22, nil, UIInfo.color.white, UIInfo.alignment.right, UIInfo.alignment.center, true, false, true)
	con:addChild(self.timeText)
	self.timeText:setAnchorPoint(ccp(0.5,0))
	self.timeText:setPosition(VSStartX+vsIconSize.width/2-125,2)
	self.timeText:setText("00:00")
end

function FightBottom:setCityWallImage(startX)
	if not self.cityWallimgs then
		self.cityWallimgs = {}
		for k=1,3 do
			local cityWallImg = UIImage.new("#fight_fycq_icon.png")
			local iconSize = cityWallImg:getContentSize()
			cityWallImg:setAnchorPoint(ccp(0,0))
			cityWallImg:setPosition(startX+(k-1)*(iconSize.width+5),5)
			self.bottom:addChild(cityWallImg)
			self.cityWallimgs[k] = cityWallImg
		end
	else
		for k=1,3 do
			local cityWallImg = self.cityWallimgs[k]
			cityWallImg:setNewImage("#fight_fycq_icon.png")
		end
	end
end

function FightBottom:initButton()
	if not self._speedBtn then
		self._speedBtn = UIButton.new({"#fight_btn_1b.png"},self.priority)
		self.bottom:addChild(self._speedBtn)
		self._speedBtn:setPosition(display.width-120,95)
		self._speedBtn:setAnchorPoint(ccp(0,0))
		self._speedBtn:addEventListener(Event.MOUSE_CLICK, {self,self._onSpeed})
	end

	self._skipBtn = UIButton.new({"#fight_tg_btn.png"},self.priority)
	self.bottom:addChild(self._skipBtn)
	self._skipBtn:setPosition(display.width-129.5,0)
	self._skipBtn:setAnchorPoint(ccp(0,0))
	self._skipBtn:addEventListener(Event.MOUSE_CLICK, {self,self._skip})
end

function FightBottom:_skip()
	FightDirector:fightOver(true,false,true)
end

function FightBottom:initBottom(con)
	local gridW = 137
	local margin = 0
	local w = (display.width - 2*60)/2
	local length = math.floor( w/(gridW + margin) )
	margin = (w - length*gridW)/length
	self.attackHeroScrollList = HeroBottomList.new(ScrollView.HORIZONTAL,w,100,self.priority)
	self.attackHeroScrollList:setTouchEnabled(false)
	self.attackHeroScrollList:setMargin(margin)
	self.attackHeroScrollList:retain()
	self.attackHeroScrollList:setPosition(93,10)
	self.attackHeroScrollList.length = length
	con:addChild(self.attackHeroScrollList)


	self.defenceHeroScrollList = HeroBottomList.new(ScrollView.HORIZONTAL,w,100,self.priority)
	self.defenceHeroScrollList:setTouchEnabled(false)
	self.defenceHeroScrollList:setMargin(margin)
	self.defenceHeroScrollList:retain()
	self.defenceHeroScrollList:setPosition(60,10)
	self.defenceHeroScrollList.length = length
	con:addChild(self.defenceHeroScrollList)
end

function FightBottom:initHero()
	self.attackHeroList,self.defenceHeroList = FightDirector:getSysHandle():getFightHeroList()

	for i,hero in ipairs(self.attackHeroList) do
		local grid = self:newGrid(i,hero)
		table.insert(self.attackGridList,grid)
	end
	print("AAAAAAAAAAAAAAAAAA",#self.attackGridList)
	self.attackHeroScrollList:setGridList(self.attackGridList,self.attackHeroScrollList.length)

	self.attackHeroScrollList:refreshPage()
	for i,hero in ipairs(self.defenceHeroList) do
		local grid = self:newGrid(i,hero)
		table.insert(self.defenceGridList,grid)
	end

	self.defenceHeroScrollList:setGridList(self.defenceGridList,self.defenceHeroScrollList.length)
	self.defenceHeroScrollList:refreshPage()
end

function FightBottom:newGrid( index,hero )
	local grid = fGrid.new(self,index,hero,self.priority,self.gridW,self.gridW)
	return grid
end

function FightBottom:_onSpeed()

	if FightDirector.status == FightCommon.start then
		if self._speedUp == 1 then
			self._speedUp = 2
			self._speedBtn:setUpImage("#fight_btn_2b.png", true)
		elseif self._speedUp == 2 or self._speedUp == 0 then
--			self._speedUp = 3
--			self._speedBtn:setUpImage("#fight_btn_3b.png", true)
--		elseif self._speedUp == 3 or self._speedUp == 0 then
			self._speedUp = 1
			self._speedBtn:setUpImage("#fight_btn_1b.png", true)
		end
		do
			return
		end
		FightDirector:setIntervalRate(self._speedUp)
	end
end

function FightBottom:prepare()
	self._speedUp = 0
	self.bottom:setPositionY(-110)
	if self._speedBtn then
		self._speedBtn:setVisible(false)
	end
end

function FightBottom:start()
	FightTrigger:addEventListener(FightTrigger.TIME_TICK,{self,self._passTime})
	FightTrigger:addEventListener(FightTrigger.CREATURE_DIE, {self,self._onCityWallBossDie})
	FightTrigger:addEventListener(FightTrigger.TIME_TICK,{self,self._refresh})
	self.totalTime = FightDirector:getSysHandle():getFightTime()*1000
	self.defence_num_text:setText(tostring(self.curDefpNum))
	self.attack_num_text:setText(tostring(self.curAttackPNum))
	UIAction.setMoveTo(self.bottom, 0, 0, 0.3)
	if self._speedBtn then
		self._speedBtn:setVisible(true)
		self:_onSpeed()
	end
	self:initHero()
	self.statsUnitDele:start()
	self.statsHpDele:start()
end

function FightBottom:_passTime(event)
	if FightDirector.status == FightCommon.start then
		local dt = event.dt
	end
end

function FightBottom:_onCityWallBossDie(e)
	if e.creature.cInfo.cityWallBoss then
		local creature = e.creature
		local doorsill = math.floor(creature.cInfo.echelonType/10)
		if self.cityWallimgs then
			self.cityWallimgs[doorsill]:setNewImage("#fight_fycqX_icon01.png")
		end
	end
end

function FightBottom:clear()
	FightTrigger:removeEventListener(FightCommon.TIME_TICK,{self,self._passTime})
	FightTrigger:removeEventListener(FightTrigger.CREATURE_DIE, {self,self._onCityWallBossDie})
	self.bottom:setPositionY(-110)
	self._speedUp = 0
	self.statsUnitDele:clear()
	self.statsHpDele:clear()
	self:setCityWallImage()
	self.attackHeroScrollList:clear()
	self.defenceHeroScrollList:clear()
	self.attackGridList = {}
	self.defenceGridList = {}
	FightTrigger:removeEventListener(FightTrigger.TIME_TICK,{self,self._refresh})
end

function FightBottom:_refresh( e )
	local time = math.floor(self.totalTime - FightEngine:getCurTime()+0.5)
	local t,_ = math.modf(time/1000)
	self.timeText:setText(util.formatTime(t))
end

return FightBottom
