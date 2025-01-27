local FightTopPanel = class("FightTopPanel", PanelProtocol)

-----TopMenuPanel 常量定义--------------------
FightTopPanel.LUA_PATH = 'fight_top_ui'


----------常量定义 end-----------------------
function FightTopPanel:init()
    self:_initUI()
end

function FightTopPanel:_initUI()
	-- body
	self:initUINode(self.LUA_PATH)

	local pause_btn = self:getNodeByName('pause')
	if pause_btn then
		pause_btn:addEventListener(Event.MOUSE_CLICK, {self, self._onPause})
	end

	local arouse_btn = self:getNodeByName('arouse')
	if arouse_btn then
		arouse_btn:addEventListener(Event.MOUSE_CLICK, {self, self._onResume})
	end
	self:getNodeByName('tip'):setText("")
end

-- nil是全部隐藏 1是显示暂停按钮 2是显示唤醒按钮
function FightTopPanel:showBtn( flag )
	local pause_btn = self:getNodeByName('pause')
	local resume_btn = self:getNodeByName('arouse')
	pause_btn:setVisible(flag==1)
	pause_btn:setEnable(flag==1)
	resume_btn:setVisible(flag==2)
	resume_btn:setEnable(flag==2)
end

function FightTopPanel:_onPause()
	FightDirector:pause()
	--FightDirector:touchEnabled(false)
	self:showBtn(2)
end

function FightTopPanel:_onResume()
	FightDirector:resume()
	--FightDirector:touchEnabled(true)
	self:showBtn(1)
end

function FightTopPanel:_changeCityBossHp( e )
	self.curTime = self.curTime + e.dt

	self:_onHandleTip(e.dt)
	local getShowObj = function()
		local curArea = FightDirector:getFightArea()
		local curCityWallBoss = FightEngine:getCityWallBoss( curArea )
		local baseBuild = FightDirector:getScene():getHQ(FightCommon.enemy)
		if not baseBuild:isDie() and baseBuild.cInfo.hp<baseBuild.cInfo.maxHp then
			if not self.curObj or self.curObj and self.curObj == baseBuild then
				if curCityWallBoss then
					return curCityWallBoss
				end
				return baseBuild
			end
		end
		return curCityWallBoss
	end

	if self.curTime>1000 then
		local hpProcess = self:getNodeByName('cityHp')
		self.curObj = getShowObj()

		if self.curObj and not self.curObj:isDie() and self.curObj.cInfo.hp<self.curObj.cInfo.maxHp then
			hpProcess:setVisible(true)
			hpProcess:setEnable(true)
			self.curCityWallArea = self.curObj.cInfo.echelonType
			hpProcess:setCurProgress(self.curObj.cInfo.hp,self.curObj.cInfo.maxHp)
			local text = string.format("%s  %s/%s",self.curObj.cInfo.name,self.curObj.cInfo.hp,self.curObj.cInfo.maxHp)
			hpProcess:setText(text,25,nil,ccc3(255,0,0))
		else
			if not self.curObj or self.curObj:isDie() or self.curCityWallArea and self.curObj and self.curCityWallArea ~= self.curObj.cInfo.echelonType then
				hpProcess:setVisible(false)
				hpProcess:setEnable(false)
			end
		end
		self.curTime = 0

	end
end

function FightTopPanel:onOpened(  )
	-- body
	self:showBtn(1)
	self.curTime = 0
	FightTrigger:addEventListener(FightTrigger.CREATURE_DIE, {self,self._onCityWallBossDie})
	local hpProcess = self:getNodeByName('cityHp')
	hpProcess:setVisible(false)
	hpProcess:setEnable(false)
	FightTrigger:addEventListener(FightTrigger.TIME_TICK,{self,self._changeCityBossHp})
end

function FightTopPanel:_onCityWallBossDie( e )
	if e.creature.cInfo.cityWallBoss or e.creature.isHQ then
		local creature = e.creature
		self:getNodeByName('tip'):setText("成功摧毁"..creature.cInfo.name)
		self.tipTime = 2000
	end
end

function FightTopPanel:_onHandleTip( dt )
	if self.tipTime and self.tipTime>0 then
		self.tipTime = self.tipTime - dt
		if self.tipTime<=0 then
			self.tipTime = 0
			self:getNodeByName('tip'):setText("")
		end
	end
end

function FightTopPanel:onCloseed(  )
	-- body
	FightTrigger:removeEventListener(FightTrigger.TIME_TICK,{self,self._changeCityBossHp})
	FightTrigger:addEventListener(FightTrigger.CREATURE_DIE, {self,self._onCityWallBossDie})
end


function FightTopPanel:isSwallowEvent()
	return false
end

function FightTopPanel:isShowMark( )
	return false
end

return FightTopPanel