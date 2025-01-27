--region BiaoQingCfg.lua
--Author : zhangzhen
--Date   : 2014/12/15
--此文件由[BabeLua]插件自动生成

local BiaoQingCfg = {}

function BiaoQingCfg:init()
	self._cfg = ConfigMgr:requestConfig("biaoqing",nil,true)
end


function BiaoQingCfg:getCfg()
    return self._cfg
end


function BiaoQingCfg:getInfoById(id)
	return self._cfg[id]
end

function BiaoQingCfg:biaoQIng2String( cfg, content )

    return content..cfg.des
end

function BiaoQingCfg:string2BiaoQing( content,w,h )

    for k,v in pairs(self._cfg) do
        if w and h then
            content = string.gsub(content,v.des,"<img src=#"..v.resName.." w="..w.." h="..h.."></img>")
        else
            content = string.gsub(content,v.des,"<img src=#"..v.resName.."></img>")
        end
    end

    return content
end

return BiaoQingCfg


--endregion
