--红点提示 相关的

local TipCenter = {}

-----------各个系统提示放这里
TipCenter.CHECK_IN = 1 --签到
TipCenter.CHAT = 2 --聊天
TipCenter.CHEST = 3   --抽宝箱

-----------------------------------------
function TipCenter:init()
	self._tipList = {}
end

function TipCenter:hasTip(sys)
	return self._tipList[sys] ~= nil
end

function TipCenter:setTip(sys,value)
	self._tipList[sys] = value
	NotifyCenter:dispatchEvent({name=Notify.SHOW_TIP, system=sys,isShow=(value ~= nil),value=value })
end

function TipCenter:setTipByKey(sys,key,value)
	local info = self._tipList[sys]
	if not info then
		info = {}
	end
	info[key] = value
	self:setTip(sys,info)
end

function TipCenter:getTipByKey(sys,key)
	local info = self._tipList[sys]
	if info then
		return info[key]
	end
	return nil
end

function TipCenter:removeTipByKey(sys,key)
	local info = self._tipList[sys]
	local hasValue = false
	if info then
		info[key] = nil
		for k,v in pairs(info) do
			hasValue = true
			break
		end
	end
	if hasValue then
		self:setTip(sys,info)
	else --not info or info is empty
		self:removeTip(sys)
	end
end

function TipCenter:getTip(sys)
	return self._tipList[sys]
end

function TipCenter:removeTip(sys)
	self:setTip(sys,nil)
end

return TipCenter