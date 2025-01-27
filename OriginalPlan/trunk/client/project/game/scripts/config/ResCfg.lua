--
-- Author: wdx
-- Date: 2014-07-14 14:53:43
--
local ResCfg = {}

function ResCfg:init()
	self._resCfg = ConfigMgr:requestConfig("resource",nil,true)
	self._uiMagicCfg = ConfigMgr:requestConfig("ui_magic",nil,true)
end

--根据id  和后缀返回资源
function ResCfg:getRes( id,suffix)
	local res = self._resCfg[tonumber(id)]
	print("res.res..suffix:",id,self._resCfg[id])
	if res == nil then
		CCLuaLog(id.." --资源没配置")
		return nil
	end

	return res.res..suffix
end

--根据id 获取 剪切区域
function ResCfg:getClipRect(id,type)
	local res = self._resCfg[id]
	local clip
	if type == 1 then
		clip = res.clip2
	else
		clip = res.clip
	end
	if clip then
		return CCRect(clip[1],clip[2],clip[3],clip[4])
	else
		return nil
	end
end

--根据id返回ui magic
function ResCfg:getUIMagic( id )
	return self._uiMagicCfg[id]
end

function ResCfg:getResInfo(id)
	return self._resCfg[id]
end

--获取vip的 富文本
function ResCfg:getVipText(vip)
	if not vip then
		return ""
	end
	local str = "<img src=vip></img>"
	local vip = tostring(vip)
	for i=1,#vip do
		local ch = string.sub(vip,i,i)
		str=str..string.format("<img src=#com_nu_%s.png></img>",ch)
	end
	return str
end

return ResCfg