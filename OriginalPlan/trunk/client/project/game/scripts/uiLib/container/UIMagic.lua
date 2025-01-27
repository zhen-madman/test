--[[
class: UIMagic
inherit: SimpleMagic
desc: 特效封装
author：changao
date: 2014-10-07
example：
	local magic = UIMagic.new(id, -1, function () end, false)
]]--


local UIMagic = class("UIMagic", SimpleMagic)


function UIMagic:ctor(id, loop)
	SimpleMagic.ctor(self, id, loop, 1)
end

function UIMagic:setParent(node, anchor, zindex)
	uihelper.addChild(node, self, anchor, zindex)
end

function UIMagic:dispose()
	print("function UIMagic:dispose()")
	SimpleMagic.dispose(self)
end

return UIMagic