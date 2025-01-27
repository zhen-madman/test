--
-- Author: lyc
-- Date: 2016-05-26 14:51:00
--
local BuildingInfo = game_require("model.town.BuildingInfo")

local BuildingStatusSelect = class('BuildingStatusSelect', function()
	return display.newNode()
end)

BuildingStatusSelect.UIResPath = "ui/building/building_select.pvr.ccz"
BuildingStatusSelect.LUA_PATH = "building_select"

function BuildingStatusSelect:ctor(scene, townPanel)
	self._scene = scene
	--! TownPanel
	self._townPanel = townPanel
	self:retain()
end

function BuildingStatusSelect:_onDelete(event)
	NotifyCenter:dispatchEvent({name=Notify.BUILDING_DELETE, pos=self._buildingObj:getPos()})
end

function BuildingStatusSelect:_onFinish(event)
	if TownModel:getBuildModel():getBuildingStatus(self._buildingObj:getDataId()) == BuildingInfo.Status.CREATE then
		floatText("建筑创建已完成")
	elseif TownModel:getBuildModel():getBuildingStatus(self._buildingObj:getDataId()) == BuildingInfo.Status.LEVELUP then
		floatText("建筑升级已完成")
	end
	self._townPanel:fastFinish(self._buildingObj:getDataId())
	self._townPanel:getMapScene():unSelect()
end
function BuildingStatusSelect:_onDetail(event)
	NotifyCenter:dispatchEvent({name=Notify.BUILDING_UNSELECT})
	ViewMgr:open(Panel.BUILDING_DETAIL, {
		scene=self._scene,
		buildingId=self._buildingObj:getBuildId(),
		buildName=self._buildingObj:getBuildName(),
		dataId=self._buildingObj:getDataId(),
		pos=self._buildingObj:getPos(),
		canDelete = self._buildingObj:canDelete()
	})
end
function BuildingStatusSelect:_onAccelerate(event)
	self._townPanel:getMapScene():unSelect()
	ViewMgr:open(Panel.BUILDING_ACCELERATE, {dataId=self._buildingObj:getDataId(),
			buildingId=self._buildingObj:getBuildId(), scene=self._scene})
end
function BuildingStatusSelect:_onFunction(event)
	local canOpenBuildName = {
		"jianzhu_bubingying",
		"jianzhu_zhanchegongchang",
		"jianzhu_jichang",
	}

	local canOpenFlag = false
	for k,v in ipairs(canOpenBuildName) do
		if self._buildingObj:getBuildName() == v then
			canOpenFlag = true;
			break;
		end
	end

	if not canOpenFlag then
		floatText("功能暂未开放")
		return
	end

	ViewMgr:open(Panel.BUILDING_CREATE_ARMY,{
		scene=self._scene,
		buildingId=self._buildingObj:getBuildId(),
		buildName=self._buildingObj:getBuildName(),
		dataId=self._buildingObj:getDataId(),
		pos=self._buildingObj:getPos()
	})

	NotifyCenter:dispatchEvent({name=Notify.BUILDING_UNSELECT})

end

function BuildingStatusSelect:init(townPanel)
	self._townPanel = townPanel
	ResMgr:loadPvr(BuildingStatusSelect.UIResPath)
	self._priority = self._scene:getPriority()-1
	self.uiNode = UINode.new(self._priority-1)
	self.uiNode:setUI(BuildingStatusSelect.LUA_PATH)
	self:addChild(self.uiNode)

	self.txtDelete = self.uiNode:getNodeByName("text_delete")
	self.btnDelete = self.uiNode:getNodeByName("btn_delete")
	self.btnDelete:addEventListener(Event.MOUSE_CLICK,{self,self._onDelete})
	self.btnFinish = self.uiNode:getNodeByName("btn_finish")
	self.btnFinish:addEventListener(Event.MOUSE_CLICK,{self,self._onFinish})
	self.btnDetail = self.uiNode:getNodeByName("btn_detail")
	self.btnDetail:addEventListener(Event.MOUSE_CLICK,{self,self._onDetail})
	self.btnAccelerate = self.uiNode:getNodeByName("btn_accelerate")
	self.btnAccelerate:addEventListener(Event.MOUSE_CLICK,{self,self._onAccelerate})
	self.btnFunction = self.uiNode:getNodeByName("btn_function")
	self.btnFunction:addEventListener(Event.MOUSE_CLICK,{self,self._onFunction})
end

function BuildingStatusSelect:selectAt(buildingObj)
	self:setScale(1.5)
	local pp = buildingObj:getAnchorPoint()
	local x,y = buildingObj:getPosition()
	print("========selectAt========", pp.x, pp.y, x, y)
	local objSize = self:getContentSize()
	self:setPosition(cc.p(x+objSize.width*1.5/2,y+objSize.height*1.5/2))
	self:setAnchorPoint(cc.p(0.5,0.5))
	self._scene:addChild(self, 101)
	self._buildingObj = buildingObj;
	self._priority = self._buildingObj:getPriority()-1
	self.uiNode:setPriority(self._priority)

	self._buildingObj:selected()
	if not buildingObj:canDelete() then
		self.btnDelete:setEnable(false)
		self.btnDelete:setVisible(false)
		self.txtDelete:setVisible(false)
	else
		self.btnDelete:setEnable(true)
		self.btnDelete:setVisible(true)
		self.txtDelete:setVisible(true)
	end
end

function BuildingStatusSelect:unSelect()
	self._buildingObj:unSelected()
	self._scene:removeChild(self, false)
end

function BuildingStatusSelect:dispose()
	ResMgr:unload(BuildingStatusSelect.UIResPath)
	self.btnDelete:removeEventListener(Event.MOUSE_CLICK,{self,self._onDelete})
	self.btnFinish:removeEventListener(Event.MOUSE_CLICK,{self,self._onFinish})
	self.btnDetail:removeEventListener(Event.MOUSE_CLICK,{self,self._onDetail})
	self.btnAccelerate:removeEventListener(Event.MOUSE_CLICK,{self,self._onAccelerate})
	self.btnFunction:removeEventListener(Event.MOUSE_CLICK,{self,self._onFunction})

	self.uiNode:dispose()
	self:release()
end

return BuildingStatusSelect
