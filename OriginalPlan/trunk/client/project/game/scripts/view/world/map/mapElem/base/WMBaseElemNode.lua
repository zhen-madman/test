--[[
	class:		WMBaseElemNode
	desc:
	author:		郑智敏
--]]

local WMElemBase = game_require('view.world.map.mapElem.WMElemBase')
local UIMagic = game_require("uiLib.container.UIMagic")
local WMBaseElemNode = class('WMBaseElemNode', WMElemBase)

--constants n configs---------------
WMBaseElemNode.CLEAR_PROTECT_EFFECT_HANDLER = 'wm_base_elem_node_clear_protect_effect_handler'
-------------------------------------

function WMBaseElemNode:ctor(map)
	SchedulerHandlerExtend.extend(self )
	WMElemBase.ctor(self, map)

	self:_initUI()
	self._map:getblockOriginNode():addChild(self,4)
	self:setAnchorPoint(ccp(0.5,0.5))
end

function WMBaseElemNode:_initUI()
	self.pic = display.newXSprite()
	self:addChild(self.pic)

	self.text = ui.newTTFLabelWithOutline({size=22})
	self.text:setAnchorPoint(ccp(0.5,0))
	self.text:setPositionY(-80)
	self:addChild(self.text,1)

	self._levelBg = display.newSprite("#wbsj_icon_bj.png")
	self._levelBg:setPositionY(-55)
	self._levelBg:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self._levelBg,2)

	self.numNode = ArtNumber.new("wbsj_icon_sz_","1",0,true)
	self.numNode:retain()
	self.numNode:setAnchorPoint(ccp(0.5,0))
	self.numNode:setPositionY(-55)
	self:addChild(self.numNode,3)

	self._nameBg = display.newSprite("#wbsj_ztbj.png")
	self._nameBg:setPositionY(-55)
	self._nameBg:setAnchorPoint(ccp(0.5,0.5))
	self:addChild(self._nameBg,0)

	self.pic:setPosition(15,40)
end

function WMBaseElemNode:updateInfo( info )
	-- body
	self:initInfo(info)
end

function WMBaseElemNode:selected()
	self.text:setVisible(false)
	self._levelBg:setVisible(false)
	self._nameBg:setVisible(false)
	self.numNode:setVisible(false)
end

function WMBaseElemNode:unSelect()
	self.text:setVisible(true)
	self._levelBg:setVisible(true)
	self._nameBg:setVisible(true)
	self.numNode:setVisible(true)
end

function WMBaseElemNode:initInfo( info )
	--WMElemBase.initInfo(self, info)
	self:setVisible(true)
	self._info = info
	local color = WorldCfg:getColorByRelationShip(info.data.worldPlayerInfo.relationShip)
	self.text:setColor(color)
	if info.data.worldPlayerInfo.relationShip == 1 then
		self.text:setOutlineColor(UIInfo.color.black)
	end
	--self.tip:setColor(color)

	local str = ""
	if info.data.worldPlayerInfo.union_name ~= "" then
		str = "["..info.data.worldPlayerInfo.union_name.."]\n"
	end
	--str = str.."Lv."..info.data.worldPlayerInfo.role_level.." "..info.data.worldPlayerInfo.name
	str = str..info.data.worldPlayerInfo.name
	str = str .. string.format("\n( %.0f,%.0f )",info.startPos.x,info.startPos.y)

	self.text:setString(str)
	if info.data.worldPlayerInfo.relationShip == 1 then
		local size = self.text:getContentSize()
		size.width = size.width*1.5
		size.height = size.height*1.5
		self.text:setContentSize(size)
	else
		self.text:setContentSize(self.text:getContentSize())
	end

	if info.data.worldPlayerInfo.role_level == nil then
		info.data.worldPlayerInfo.role_level = 1
	end

	if info.data.worldPlayerInfo.role_level > 5 then
		info.data.worldPlayerInfo.role_level = 5
	elseif info.data.worldPlayerInfo.role_level < 1 then
		info.data.worldPlayerInfo.role_level = 1
	end
	self.numNode:setNumber(info.data.worldPlayerInfo.role_level)

	self.text:setPositionX(-self.text:getContentSize().width/2+20)
	self._nameBg:setPositionX(20)
	self._levelBg:setPositionX(-self._levelBg:getContentSize().width/2+self.text:getPositionX())
	self.numNode:setPositionX(self._levelBg:getPositionX()-1)

	if info.data.attackTime and (os.time()-info.data.attackTime > 10) then
		info.data.now_blood = info.data.max_blood;
	end

--	self:_showHurtMagic2(true,90002)

	local hpRate = info.data.now_blood/info.data.max_blood
	if hpRate <= 0.6 then
		self.pic:setSpriteImage("#base_1.png")
		if hpRate <= 0.3 then
			self:_showHurtMagic2(true,90002)
		else
			self:_showHurtMagic2(true,90002)
		end
	else
		self.pic:setSpriteImage("#base.png")
		self:_showHurtMagic2(false)
	end

	-- local timeStamp = TimeCenter:getTimeStamp()
	-- if timeStamp < self._info.data.protect_time then
		-- local diffTime = self._info.data.protect_time - timeStamp
		-- self:_addProtectEffect()

		-- self:scheduleHandle(self.CLEAR_PROTECT_EFFECT_HANDLER, function() self:_clearProtectEffect() end, diffTime)
	-- else
		-- self:_clearProtectEffect()
	-- end
end

function WMBaseElemNode:_update(dt)
	if self._info.data.attackTime and (os.time()-self._info.data.attackTime > 10) then
		self._info.data.now_blood = self._info.data.max_blood;

		self:_showHurtMagic2(false)
		return
	end
end

function WMBaseElemNode:_showHurtMagic2(flag,pId)
	if flag then
		if not self._hurtMagic then
			self._timerId = scheduler.scheduleUpdateGlobal(function(dt)
				self:_update(dt)
			end)
			self._hurtMagic = UIMagic.new(1, -1)
			self._hurtMagic:play()
			self._hurtMagic:setParent(self, ccp(0.5,0.5), 10)
			self._hurtMagic:setPosition(ccp(20, -10))
		end
	else
		if self._timerId then
			scheduler.unscheduleGlobal(self._timerId)
			self._timerId = nil
		end

		if self._hurtMagic then
			self._hurtMagic:stop();
			self._hurtMagic:removeFromParent()
			self._hurtMagic = nil
		end
	end
end
function WMBaseElemNode:_showHurtMagic(flag,mId,x,y)
--	if flag then
--		if not self._hurtMagic then
--			self._hurtMagic = SimpleMagic.new(mId)
--			self._hurtMagic:setScale(1.5)
--			self._hurtMagic:setMagicType(2)
--			self._hurtMagic:setPosition(x,y)
--			self:addChild(self._hurtMagic)
--		end
--	else
--		if self._hurtMagic then
--			self._hurtMagic:removeFromParent()
--			self._hurtMagic = nil
--		end
--	end

	self:_showHurtMagic2(flag, mId)
end

function WMBaseElemNode:getBlockPosRange(  )
	-- body
	return ccp(self._info.startPos.x, self._info.startPos.y), ccp(self._info.endPos.x , self._info.endPos.y)
end

function WMBaseElemNode:_addProtectEffect()
	if not self._protectEffect then
		self._protectEffect = SimpleMagic.new(109,-1,false)
		self:addChild(self._protectEffect,2)
	end
end

function WMBaseElemNode:_clearProtectEffect(  )
	-- body
	self:unscheduleHandle(self.CLEAR_PROTECT_EFFECT_HANDLER)
	if nil ~= self._protectEffect then
		self._protectEffect:dispose()
		self._protectEffect = nil
	end
end

function WMBaseElemNode:clear()
	self:_showHurtMagic2(false)
	self:setVisible(false)
	self:_clearProtectEffect()
end

function WMBaseElemNode:dispose()
	self:_showHurtMagic2(false)
	self.text:removeFromParent()
	self:_clearProtectEffect()
	WMElemBase.dispose(self)
	if self.numNode ~= nil then
		self.numNode:dispose()
	end
end

return WMBaseElemNode