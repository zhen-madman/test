local MainUI = class("MainUI", PanelProtocol)

local RoleModel = game_require("model.role.RoleModel")

MainUI.UIResPath = "ui/town/town.pvr.ccz"

MainUI.SceneType = {
	Invalid = 0,
	World = 1,
	Town = 2,
}

function MainUI:ctor(panelName)
	-- 场景类型
	self.sceneType = MainUI.SceneType.Invalid
	-- 是否正在战斗场景
	self.isInFight = false
	--! UIButton
	self.btnScene = nil
	--! UIButton
	self.btnFight = nil

	PanelNodeProtocol.ctor(self, panelName)
end

function MainUI:init()
	self:initUINode("main_ui", MainUI.UIResPath)

	NotifyCenter:addEventListener(Notify.ENTER_TOWN, {self, self._onEnterTown})
end

function MainUI:_onEnterTown(event)
	if self.sceneType == MainUI.SceneType.World then
		ViewMgr:close(Panel.WORLD)
		self.sceneType = MainUI.SceneType.Town

		ViewMgr:open(Panel.TOWN)
		self.btnScene:setText("世界")
	end
end

function MainUI:onOpened(params)
	PanelProtocol.onOpened(self, params)

	self.btnScene = self.uiNode:getNodeByName("btn_scene")
	self.btnScene:addEventListener(Event.MOUSE_CLICK, {self, self.clickScene})
	self.btnFight = self.uiNode:getNodeByName("btn_fight")
	self.btnFight:addEventListener(Event.MOUSE_CLICK, {self, self.clickFight})
	NotifyCenter:addEventListener(Notify.BACK_TO_SCENE, {self, self.backToScene})

	ViewMgr:close(Panel.MAIN_UI_ARMY)

	self:menuUIHandler(true)
	self:switchScene(true)
end

function MainUI:menuUIHandler( isOpen )
	if isOpen then
		ViewMgr:open(Panel.MAIN_UI_CHAT)
		ViewMgr:open(Panel.MAIN_UI_FUNCTION)
		ViewMgr:open(Panel.MAIN_UI_DETAIL)
		ViewMgr:open(Panel.MAIN_UI_MISC)
		--ViewMgr:open(Panel.MAIN_UI_ARMY)
	else
		ViewMgr:close(Panel.MAIN_UI_CHAT)
		ViewMgr:close(Panel.MAIN_UI_FUNCTION)
		ViewMgr:close(Panel.MAIN_UI_DETAIL)
		ViewMgr:close(Panel.MAIN_UI_MISC)
		--ViewMgr:close(Panel.MAIN_UI_ARMY)
	end
end

function MainUI:onCloseed(params)
	PanelProtocol.onCloseed(self, params)

	NotifyCenter:removeEventListener(Notify.ENTER_TOWN, {self, self._onEnterTown})
	self.btnScene:removeEventListener(Event.MOUSE_CLICK, {self, self.clickScene})
	self.btnFight:removeEventListener(Event.MOUSE_CLICK, {self, self.clickFight})
	NotifyCenter:removeEventListener(Notify.BACK_TO_SCENE, {self, self.backToScene})

	self:menuUIHandler(false)
end

function MainUI:openFight()
end

function MainUI:openWorld()
end
function MainUI:closeWorld()

end

function MainUI:openTown()
--	self._uiArmy:setVisible(false)
--	self._uiMisc:setVisible(false)
end
function MainUI:closeTown()
--	self._uiArmy:setVisible(false)
--	self._uiMisc:setVisible(false)
end

function MainUI:switchScene(needClose)
	if needClose then
		if self.sceneType == MainUI.SceneType.Invalid then
			self.sceneType = MainUI.SceneType.Town
		else
			if self.sceneType == MainUI.SceneType.World then
				ViewMgr:close(Panel.WORLD)
				self:closeWorld()
				self.sceneType = MainUI.SceneType.Town;
			elseif self.sceneType == MainUI.SceneType.Town then
				ViewMgr:close(Panel.TOWN)
				self:closeTown()
				self.sceneType = MainUI.SceneType.World
			end
		end
	end

	if self.sceneType == MainUI.SceneType.World then
		ViewMgr:open(Panel.WORLD)
		self:openWorld()
		self.btnScene:setText("主城")
--		self.btnFight:setVisible(false)
--		self.btnFight:setEnable(false)
	elseif self.sceneType == MainUI.SceneType.Town then
		ViewMgr:open(Panel.TOWN)
		self:openTown()
		self.btnScene:setText("世界")
--		self.btnFight:setVisible(true)
--		self.btnFight:setEnable(true)
	end
end

function MainUI:clickScene(event)
	self:switchScene(true)
end

function MainUI:backToScene()
	self.btnFight:setVisible(true)
	self.btnScene:setVisible(true)
	self.btnFight:setEnable(true)
	self.btnScene:setEnable(true)
	self.sceneType = MainUI.SceneType.Town
	self:switchScene(false)
	self:menuUIHandler(true)
end

function MainUI:clickFight(event)
	if self.sceneType == MainUI.SceneType.World then
		ViewMgr:close(Panel.WORLD)
		self:closeWorld()
	elseif self.sceneType == MainUI.SceneType.Town then
		ViewMgr:close(Panel.TOWN)
		self:closeTown()
	end

	ViewMgr:open(Panel.FIGHT)
	self:openFight()
	self.sceneType = MainUI.SceneType.Invalid
	self:closeSelf()
end

function MainUI:isShowMark()
    return false
end

function MainUI:isSwallowEvent()
	return false
end

return MainUI
