﻿local Panel = {}
Panel.PanelLayer = {}
Panel.PanelLayer.SCENE = "scene"
Panel.PanelLayer.HUD = "hud"
Panel.PanelLayer.POPUP = "popup"
Panel.PanelLayer.MENU_LAYER = "menu_layer"
Panel.PanelLayer.POPUP_TOP = "popupTop"
Panel.PanelLayer.NOTIFY = "notify"
Panel.PanelLayer.NOTIFY_TOP = "notifyTop"
Panel.PanelLayer.MASK_LAYER = "mask"
Panel.PanelLayer.ERROR_LAYER = "error"
-------------------------------------------------------------------------
Panel.LOADING = "loading"
Panel.TOOLTIP = "tooltip"
Panel.ERROR_TIP_PANEL = "error_tip_panel"
Panel.FIGHT = "fight"
Panel.WORLD = "world"
Panel.TOWN = "town"
Panel.BUILDING_PANEL 	= "building_panel"
Panel.BUILDING_CREATE 	= "building_create"
Panel.BUILDING_ACCELERATE = "building_accelerate"
Panel.BUILDING_DETAIL = "building_detail"
Panel.BUILDING_LEVELUP = "building_levelup"
Panel.BUILDING_CREATE_ARMY = "building_create_army"
Panel.MAIN_UI			= "main_ui"
Panel.MAIN_UI_CHAT		= "main_ui_chat"
Panel.MAIN_UI_FUNCTION	= "main_ui_function"
Panel.MAIN_UI_DETAIL	= "main_ui_detail"
Panel.MAIN_UI_MISC		= "main_ui_misc"
Panel.MAIN_UI_ARMY		= "main_ui_army"
Panel.WORLD_BUTTOM_MENU = "world_buttom_menu"
Panel.FIGHT_TOP_UI      = "fight_top_ui"
Panel.FIGHT_RESULT      = "fight_result"
Panel.Config = {
    [Panel.LOADING] = {
        portal = "view.common.LoadingPanel",
        layer = Panel.PanelLayer.MASK_LAYER
    },
    [Panel.TOOLTIP] = {
        portal = "view.common.ToolTipPanel",
        layer = Panel.PanelLayer.NOTIFY_TOP
    },
    [Panel.ERROR_TIP_PANEL]={
        portal = "view.common.ToolTipPanel",
        layer = Panel.PanelLayer.ERROR_LAYER
    },
	[Panel.FIGHT] = {
		portal = "view.fight.FightPanel",
		layer = Panel.PanelLayer.SCENE,
	},
    [Panel.WORLD] = {
        portal = "view.world.WorldPanel",
        layer = Panel.PanelLayer.SCENE,
    },
	[Panel.TOWN] = {
		portal = "view.town.TownPanel",
		layer = Panel.PanelLayer.SCENE,
	},
	[Panel.BUILDING_PANEL] = {
		portal = "view.town.building.BuildingPanel",
		layer = Panel.PanelLayer.MENU_LAYER,
	},
	[Panel.BUILDING_CREATE] = {
		portal = "view.town.building.BuildingCreatePanel",
		layer = Panel.PanelLayer.POPUP_TOP,
	},
	[Panel.BUILDING_ACCELERATE] = {
		portal = "view.town.building.BuildingAccelerate",
		layer = Panel.PanelLayer.POPUP_TOP,
	},
	[Panel.BUILDING_DETAIL] = {
		portal = "view.town.building.BuildingDetailPanel",
		layer = Panel.PanelLayer.POPUP_TOP,
	},
	[Panel.BUILDING_LEVELUP] = {
		portal = "view.town.building.BuildingLevelUpPanel",
		layer = Panel.PanelLayer.POPUP_TOP,
	},
	[Panel.BUILDING_CREATE_ARMY] = {
		portal = "view.town.building.BuildingCreateArmyPanel",
		layer = Panel.PanelLayer.POPUP_TOP,
	},
	[Panel.MAIN_UI] = {
		portal = "view.main.MainUI",
		layer = Panel.PanelLayer.HUD
	},
	[Panel.WORLD_BUTTOM_MENU] = {
		portal = 'view.world.worldUI.WorldButtomMenuPanel',
		layer = Panel.PanelLayer.HUD
	},
	[Panel.MAIN_UI_CHAT] = {
		portal = 'view.main.MainUIChatPanel',
		layer = Panel.PanelLayer.HUD
	},
	[Panel.MAIN_UI_FUNCTION] = {
		portal = 'view.main.MainUIFunctionPanel',
		layer = Panel.PanelLayer.HUD
	},
	[Panel.MAIN_UI_DETAIL] = {
		portal = 'view.main.MainUIDetailPanel',
		layer = Panel.PanelLayer.HUD
	},
	[Panel.MAIN_UI_MISC] = {
		portal = 'view.main.MainUIMiscPanel',
		layer = Panel.PanelLayer.HUD
	},
	[Panel.MAIN_UI_ARMY] = {
		portal = 'view.main.MainUIArmyPanel',
		layer = Panel.PanelLayer.HUD
	},
	[Panel.FIGHT_TOP_UI] = {
		portal = 'view.fight.fightUI.FightTopPanel',
		layer = Panel.PanelLayer.HUD
	},
	[Panel.FIGHT_RESULT] = {
		portal = 'view.fightResult.FightResultPanel',
		layer = Panel.PanelLayer.POPUP_TOP
	},
}
function Panel:getPanelSys(panelName)
    if Panel.Config[panelName] then
        return Panel.Config[panelName].sys
    end
    return nil
end
function Panel:isLinkPanel(panelName)
    if Panel.Config[panelName] then
        return Panel.Config[panelName].isLinkPanel
    end
    return nil
end
return Panel