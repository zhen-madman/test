
local FightUi = class("FightUi",function()
								return display.newLayer()
								end)

local FightBottom = game_require("view.fight.fightUI.FightBottom")

function FightUi:ctor(priority)
	self:retain()

	self.priority = priority-1
	if DEBUG == 2 then
		local EditMap = game_require("view.fight.fightUI.EditMap")
		local edit = EditMap.new(self)
	end

	self.fightBottom = FightBottom.new(self.priority)
	self.fightBottom:retain()
	self:addChild(self.fightBottom)
end

--战斗准备的时候  基本上全部移除
function FightUi:prepare()
	if not self.fightBottom:getParent() then
		self:addChild(self.fightBottom)
	end
	self.fightBottom:prepare()
end

--开始战斗ui
function FightUi:start(isShowSkill)
	self.fightBottom:start()
end

function FightUi:getBossHurt()
	return self.title:getBossHurt()
end

function FightUi:passTime( dt )
end

function FightUi:clear()
	self.fightBottom:clear()
end

return FightUi