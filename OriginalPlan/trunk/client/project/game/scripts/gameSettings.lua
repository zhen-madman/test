﻿
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 0
DEBUG_FPS = true
DEBUG_MEM = true
DEBUG_NOT_GUIDE = 1

LOCAL_RUN = true
--LOCAL_RUN = true

-- design resolution
CONFIG_SCREEN_WIDTH  = 1136
CONFIG_SCREEN_HEIGHT = 640

CONFIG_SCREEN_ORIENTATION = "portrait"

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_HEIGHT"

if device.platform ~= "windows" then
	PLATFORM_ID = GameCfg:getValue("platform")
	SERVER_IP = GameCfg:getValue("serverIP")
	SERVER_PORT = tonumber(GameCfg:getValue("port"))

	DEBUG = 0
	DEBUG_FPS = false
	DEBUG_MEM = false
	DEBUG_NOT_GUIDE = false
	GAME_VER = device.version or "unknow"
else --local
	SERVER_IP = "192.168.1.73" --"192.168.1.245"  --"dev.game.com"--"123.59.83.243" --"www.5colour.com.cn"  --"192.168.0.253"  --
	PLATFORM_ID = 100
	BUG_URL = "http://dev.game.com/www/tools/commit_bug.php"
	SERVER_PORT = 7110   --19999
	GAME_VER = "10.1.1350"
end

CCLuaLog("server ip ...."..SERVER_IP.."  "..PLATFORM_ID.." "..SERVER_PORT )

ACCOUNT_ID = ""  --登录 中央服务器的 账号
GAME_ACCOUNT = ""  --登录游戏服的 账号由中央服发过
GAME_MD5 = ""  --登录游戏服的md5
GAME_SERVER_ID = 1  --游戏服务器id

----------------------------------------------------------------------------------------------

local sharedTextureCache = CCTextureCache:sharedTextureCache()
local sharedDirector = CCDirector:sharedDirector()


if DEBUG_FPS then
    sharedDirector:setDisplayStats(true)
end

if DEBUG_MEM then
	local function showMemoryUsage()
		--collectgarbage("collect")
	    CCLuaLog(string.format("LUA VM MEMORY USED: %0.2f KB", collectgarbage("count")))
	end
    sharedDirector:getScheduler():scheduleScriptFunc(showMemoryUsage, 10.0, false)
end

if DEBUG == 0 then
    if dump then
        function dump( )
        end
    end
    if print then
       function print()
        end
    end
    if assert then
        function assert()
        end
    end
end

