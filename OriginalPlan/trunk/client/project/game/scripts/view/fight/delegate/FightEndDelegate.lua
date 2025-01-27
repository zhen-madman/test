
--战斗结束的  动作 动画委托
local FightEndDelegate = class("FightEndDelegate")

function FightEndDelegate:ctor(fightPanel)
	self.fightPanel = fightPanel
	FightTrigger:addEventListener(FightTrigger.RESULT,{self,self.onFightOver})
end

function FightEndDelegate:onFightOver(event)
	if event.isWin then
		self.fightPanel.dropDelegate:pickupAll()
	end

	if event.isSlowRate then
		-- if event.isWin then
		-- 	FightDirector:getCamera():setSceneRight()
		-- else
		-- 	FightDirector:getCamera():setSceneLeft()
		-- end
		FightDirector:getCamera():lockCamera(true)
		FightEngine:setRunRate(0.25,99999999)
	end

	self.fightInfo = FightDirector.fightInfo

	self.isWin = event.isWin
	self.isTimeOut= event.isTimeOut
	self.isSlowRate = event.isSlowRate

	FightDirector:touchEnabled(false)

	if isWin and info and info.dialogs then  --胜利才有对话
		local dialogsId,dt = self:getDialogId(info.dialogs)
		if dialogsId then
			local fType = self.fightInfo.fightType
			if fType == FightCfg.DUNGEON_FIGHT and GameConst.IS_GM ~= 1 then  --副本对话
				if not DungeonModel:isDungeonFinish(self.fightInfo.info.id) then  --最大进度
					local dType = DungeonCfg:getDungeonType(self.fightInfo.info.id)
					CCUserDefault:sharedUserDefault():setStringForKey("dDialog"..dType,dialogsId) --本地存储一下上次对话id
					CCUserDefault:sharedUserDefault():flush()
					ViewMgr:open(Panel.DIALOG,{id=dialogsId,time=dt,dialogEnd=function() self:_onDialogOut() end})
					return
				end
			else
				ViewMgr:open(Panel.DIALOG,{id=dialogsId,time=dt,dialogEnd=function() self:_onDialogOut() end})
				return
			end
		end
	end

	self:_onDialogOut()
end

--对话结束
function FightEndDelegate:_onDialogOut()
	if self.isSlowRate then
		scheduler.performWithDelayGlobal(handler(self,self.sysFightEndHandle), 3)
	else
		self:sysFightEndHandle()
	end

end

function FightEndDelegate:sysFightEndHandle()
	local sysHandle = FightDirector:getSysHandle()
	if sysHandle then
		sysHandle:fightEnd(self.isWin,handler(self,self.fightEndCallback))
	end
end

function FightEndDelegate:fightEndCallback(event)
	-- self.fightPanel:fightEnd(event)
end

function FightEndDelegate:getDialogId(dialogs)
	for i,dialog in ipairs(dialogs) do
		if dialog[1] == 2 then
			return dialog[2],dialog[1]
		end
	end
	return nil
end


return FightEndDelegate