-------------------------------------------------------
-- 作用: 分割字符串
-- 参数: 待分割的字符串,分割字符
-- 返回: 子串表.(含有空串)
function stringSplit(str, splitStr, addSpliteFlag)
    local subStrTab = {};
    local spliteStrLen = string.len(splitStr);
    while (true) do
        local pos = string.find(str, splitStr);
        if (not pos) then
	    table.insert(subStrTab, str);
            break;
        end
        local subStr = string.sub(str, 1, pos-1);
	if addSpliteFlag ~= nil then
		subStr = subStr .. splitStr;
	end
	table.insert(subStrTab, subStr);
        str = string.sub(str, pos + spliteStrLen, #str);
    end

    return subStrTab;
end

-------------------------------------------------------
-- 作用: 将两符分割成两部分
-- 参数: 原字符串,目标字串
-- 返回: 串1,串2
function stringSplite1(str, splitStr)
    local subStrTab = {};
    while (true) do
        local pos = string.find(str, splitStr);
        if (not pos) then
            subStrTab[1] = str;
	    subStrTab[2] = "";
	    break;
        end
        local subStr = string.sub(str, 1, pos - 1);
        subStrTab[#subStrTab + 1] = subStr;
        str = string.sub(str, pos + 1, #str);
	subStrTab[#subStrTab + 1] = str;
	break;
    end

    return subStrTab[1],subStrTab[2];
end

-------------------------------------------------------
-- 作用: 分割字符串
-- 参数: 待分割的字符串,分割字符串列表
-- 返回: 子串表.(含有空串)
function stringSplit2(str, splitStrs)
    local subStrTab = {};
    local spliteStrLen = string.len(str);
    local startIndex=1;
    local charStr = "";

    local subStrs = "";
    for i=1,spliteStrLen,1 do
	charStr=string.sub(str,i,i);
	local sp = tableIsExist(splitStrs, charStr);
	if sp then
		subStrs = "";
		if startIndex ~= i then
			subStrs = string.sub(str, startIndex, i-1);
			assert(subStrs ~= nil);
		end
		if subStrs ~= nil then
			local ll = {};
			ll.str = subStrs;
			ll.sp = sp;
			table.insert(subStrTab, ll);
			startIndex=i+1;
			subStrs = "";
		end
	end
    end

    if startIndex < spliteStrLen+1  then
	subStrs = string.sub(str, startIndex, spliteStrLen);
	assert(subStrs ~= nil);
    end
    if subStrs ~= "" then
	local ll = {};
	ll.str = subStrs;
	ll.sp = "";
	table.insert(subStrTab, ll);
    end

    return subStrTab;
end

-------------------------------------------------------
-- 作用: 判断字符串是否存在
-- 参数: 原字符串,目标字串
-- 返回: 真假
function stringIsExist(str, findStr)
	return string.find(str, findStr) ~= nil;
end

-------------------------------------------------------
-- 作用: 删除连续字符
-- 参数: 原字符串,目标字串
-- 返回: 删除后的串
function stringSrimCont(str, trimChar)
	pat = "["..trimChar.."]+";
	return string.gsub(str, pat, trimChar);
end

-------------------------------------------------------
-- 作用: 删除字符串
-- 参数: 原字符串,目标字串
-- 返回: 删除后的串
function stringSrimCont1(str, trimChar)
	pat = trimChar;
	return string.gsub(str, pat, "");
end

-------------------------------------------------------
-- 作用: 删除连续字符
-- 参数: 原字符串,目标字串列表
-- 返回: 删除后的串
function stringSrimCont2(str, trimChars)
	local tempStr = str;
	for k,v in pairs(trimChars) do
		tempStr = stringSrimCont(tempStr, v);
	end

	return tempStr;
end

-------------------------------------------------------
-- 作用: 查找字符串
-- 参数: 原字符串,查找表达式
-- 返回: 查找后的
function findString(str, fmt)
	local startIndex,endIndex = string.find(str, fmt);
	if startIndex ~= nil
	then
		return string.sub(str, startIndex, endIndex-string.len(str)-1);
	end

	return "";
end
-------------------------------------------------------
-- 作用: 查找字符串
-- 参数: 原字符串,查找表达式
-- 返回: 查找后的
function findString2(str, fmt)
	for k in string.gmatch(str, fmt) do
		return k;
	end

	return "";
end
-------------------------------------------------------
-- 作用: 查找字符串
-- 参数: 原字符串,查找表达式
-- 返回: 查找后的
function findString3(str, fmt)
	local strTab = {};
	for k in string.gmatch(str, fmt) do
		table.insert(strTab, k);
	end

	return strTab;
end

-------------------------------------------------------
-- 作用: 查找字符串
-- 参数: 原字符串,查找表达式
-- 返回: 查找后的
function findString4(str, fmt, num)
	local strTab = {};
	if num == 1 then
		for k in string.gmatch(str, fmt) do
			table.insert(strTab, k);
		end
		return strTab[1];
	end
	if num == 2 then
		for k,v in string.gmatch(str, fmt) do
			assert(k ~= nil);
			assert(v ~= nil);
			table.insert(strTab, k);
			table.insert(strTab, v);
		end
		return strTab[1], strTab[2];
	end

	if num == 3 then
		for k,v,x in string.gmatch(str, fmt) do
			assert(k ~= nil);
			assert(v ~= nil);
			assert(x ~= nil);
			table.insert(strTab, k);
			table.insert(strTab, v);
			table.insert(strTab, x);
		end
		return strTab[1], strTab[2], strTab[3];
	end


	if num == 4 then
		for k,v,x,y in string.gmatch(str, fmt) do
			assert(k ~= nil);
			assert(v ~= nil);
			assert(x ~= nil);
			assert(y ~= nil);
			table.insert(strTab, k);
			table.insert(strTab, v);
			table.insert(strTab, x);
			table.insert(strTab, y);
		end
		return strTab[1], strTab[2], strTab[3], strTab[4];
	end

	if num == 5 then
		for k,v,x,y,z in string.gmatch(str, fmt) do
			assert(k ~= nil);
			assert(v ~= nil);
			assert(x ~= nil);
			assert(y ~= nil);
			assert(z ~= nil);
			table.insert(strTab, k);
			table.insert(strTab, v);
			table.insert(strTab, x);
			table.insert(strTab, y);
			table.insert(strTab, z);
		end
		return strTab[1], strTab[2], strTab[3], strTab[4], strTab[5];
	end

	assert(false);
	return nil;
end


-------------------------------------------------------
-- 作用: 删除两端空格
-- 参数: 源字符串
-- 返回: 删除后字符串
function delStringTowEndSpace(str)
        assert(type(str)=="string")
        return str:match("^[%c%s]*(.+)[%c%s]*$")
end

-------------------------------------------------------
-- 作用: 分割替换
-- 参数: 源字符串
-- 返回: 替换后的字符串
function stringSpliteReplace(str, spliteStrs, replaceStrs)
	local tempStr = stringSrimCont2(str, spliteStrs);
	local retSplitsStr = stringSplit2(tempStr, spliteStrs);
	local retStr = "";
	for k,v in pairs(retSplitsStr) do
		local findFlag = tableIsExist(replaceStrs, v.str);
		if not findFlag then
			retStr = retStr .. v.str .. v.sp;
		else
			retStr = retStr .. v.sp;
		end
	end

	return retStr;
end

-------------------------------------------------------
-- 作用: 完整替换
-- 参数: 源字符串
-- 返回: 替换后的字符串
function stringAllReplace(str, replaceStrs)
	local retStr = str;
	for k,v in pairs(replaceStrs) do
		retStr = string.gsub(retStr, v, " ");
	end

	return retStr;
end

xstr = {
	func_list = "trim, capitalize, count, startswith, endswith, expendtabs, isalnum, isalpha, isdigit, islower, isupper, join, lower, upper, partition, zfill, ljust, rjust, center, dir, help",
	-------------------------------------------------------
	-- 作用: 去除str中的所有空格
	-- 参数: 目标字串
	-- 返回: 成功返回去除空格后的字符串,失败返回nil和失败信息
	trim = function (self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		str = string.gsub(str, " ", "")
		return str
	end,
	-------------------------------------------------------
	-- 作用: 将str的第一个字符转化为大写字符
	-- 参数: 目标字串
	-- 返回: 成功返回去除空格后的字符串,失败返回nil和失败信息
	capitalize = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local ch = string.sub(str, 1, 1)
		local len = string.len(str)
		if ch < 'a' or ch > 'z' then
			return str
		end
		ch = string.char(string.byte(ch) - 32)
		if len == 1 then
			return ch
		else
			return ch .. string.sub(str, 2, len)
		end
	end,
	--[[统计str中substr出现的次数。from, to用于指定起始位置，缺省状态下from为1，to为字符串长度。成功返回统计个数，失败返回nil和失败信息]]
	count = function(self, str, substr, from, to)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		from = from or 1
		if to == nil or to > string.len(str) then
			to = string.len(str)
		end
		local str_tmp = string.sub(str, from ,to)
		local n = 0
		_, n = string.gsub(str, substr, '')
		return n
	end,
	--[[判断str是否以substr开头。是返回true，否返回false，失败返回失败信息]]
	startswith = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-stirng parameter is nil"
		end
		if string.find(str, substr) ~= 1 then
			return false
		else
			return true
		end
	end,
	--[[判断str是否以substr结尾。是返回true，否返回false，失败返回失败信息]]
	endswith = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		str_tmp = string.reverse(str)
		substr_tmp = string.reverse(substr)
		if string.find(str_tmp, substr_tmp) ~= 1 then
			return false
		else
			return true
		end
	end,
	--[[使用空格替换str中的制表符，默认空格个数为8。返回替换后的字符串]]
	expendtabs = function(self, str, n)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		n = n or 8
		str = string.gsub(str, "\t", string.rep(" ", n))
		return str
	end,
	--[[如果str仅由字母或数字组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isalnum = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if not ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z') or (ch >= '0' and ch <= '9')) then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isalpha = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if not ((ch >= 'a' and ch <= 'z') or (ch >= 'A' and ch <= 'Z')) then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由数字组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isdigit = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch < '0' or ch > '9' then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由小写字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
	islower = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch < 'a' or ch > 'z' then
				return false
			end
		end
		return true
	end,
	--[[如果str全部由大写字母组成，则返回true，否则返回false。失败返回nil和失败信息]]
	isupper = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch < 'A' or ch > 'Z' then
				return false
			end
		end
		return true
	end,
	--[[使用substr连接str中的每个字符，返回连接后的新串。失败返回nil和失败信息]]
	join = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		local xlen = string.len(str) - 1
		if xlen == 0 then
			return str
		end
		local str_tmp = ""
		for i = 1, xlen do
			str_tmp = str_tmp .. string.sub(str, i, i) .. substr
		end
		str_tmp = str_tmp .. string.sub(str, xlen + 1, xlen + 1)
		return str_tmp
	end,
	--[[将str中的小写字母替换成大写字母，返回替换后的新串。失败返回nil和失败信息]]
	lower = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		local str_tmp = ""
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch >= 'A' and ch <= 'Z' then
				ch = string.char(string.byte(ch) + 32)
			end
			str_tmp = str_tmp .. ch
		end
		return str_tmp
	end,
	--[[将str中的大写字母替换成小写字母，返回替换后的新串。失败返回nil和失败信息]]
	upper = function(self, str)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		local len = string.len(str)
		local str_tmp = ""
		for i = 1, len do
			local ch = string.sub(str, i, i)
			if ch >= 'a' and ch <= 'z' then
				ch = string.char(string.byte(ch) - 32)
			end
			str_tmp = str_tmp .. ch
		end
		return str_tmp
	end,
	--[[将str以substr（从左向右查找）为界限拆分为3部分，返回拆分后的字符串。如果str中无substr则返回str, '', ''。失败返回nil和失败信息]]
	partition = function(self, str, substr)
		if str == nil or substr == nil then
			return nil, "the string or the sub-string parameter is nil"
		end
		local len = string.len(str)
		start_idx, end_idx = string.find(str, substr)
		if start_idx == nil or end_idx == len then
			return str, '', ''
		end
		return string.sub(str, 1, start_idx - 1), string.sub(str, start_idx, end_idx), string.sub(str, end_idx + 1, len)
	end,
	--[[在str前面补0，使其总长度达到n。返回补充后的新串，如果str长度已经超过n，则直接返回str。失败返回nil和失败信息]]
	zfill = function(self, str, n)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		if n == nil then
			return str
		end
		local format_str = "%0" .. n .. "s"
		return string.format(format_str, str)
	end,
	-----------------------------------------------------------------------------------------------------------------------------------------
	--[[设置str的位宽，默认的填充字符为空格。对齐方式为左对齐（rjust为右对齐，center为中间对齐）。返回设置后的字符串。失败返回nil和失败信息]]
	ljust = function(self, str, n, ch)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		ch = ch or " "
		n = tonumber(n) or 0
		local len = string.len(str)
		return string.rep(ch, n - len) .. str
	end,
	rjust = function(self, str, n, ch)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		ch = ch or " "
		n = tonumber(n) or 0
		local len = string.len(str)
		return str .. string.rep(ch, n - len)
	end,
	center = function(self, str, n, ch)
		if str == nil then
			return nil, "the string parameter is nil"
		end
		ch = ch or " "
		n = tonumber(n) or 0
		local len = string.len(str)
		rn_tmp = math.floor((n - len) / 2)
		ln_tmp = n - rn_tmp - len
		return string.rep(ch, rn_tmp) .. str .. string.rep(ch, ln_tmp)
	end,
	------------------------------------------------------------------------------------------------------------------------------------------
	--[[显示xstr命名空间的所有函数名]]
	dir = function(self)
		print(self.func_list)
	end,
	--[[打印指定函数的帮助信息, 打印成功返回true，否则返回false]]
	help = function(self, fun_name)
		man = {
			["trim"] = "xstr:trim(str) --> string | nil, err_msg\n  去除str中的所有空格，返回新串\n  print(xstr:trim(\"  hello wor ld \") --> helloworld",
			["capitalize"] = "xstr:capitalize(str) --> string | nil, err_msg\n  将str的首字母大写，返回新串\n  print(xstr:capitalize(\"hello\") --> Hello",
			["count"] = "xstr:count(str, substr [, from] [, to]) --> number | nil, err_msg\n  返回str中substr的个数, from和to用于指定统计范围, 缺省状态下为整个字符串\n  print(xstr:count(\"hello world!\", \"l\")) --> 3",
			["startswith"] = "xstr:startswith(str, substr) --> boolean | nil, err_msg\n  判断str是否以substr开头, 是返回true，否返回false\n  print(xstr:startswith(\"hello world\", \"he\") --> true",
			["endswith"] = "xstr:endswith(str, substr) --> boolean | nil, err_msg\n  判断str是否以substr结尾, 是返回true, 否返回false\n  print(xstr:endswith(\"hello world\", \"d\")) --> true",
			["expendtabs"] = "xstr:expendtabs(str, n) --> string | nil, err_msg\n  将str中的Tab制表符替换为n格空格，返回新串。n默认为8\n  print(xstr:expendtabs(\"hello	world\")) --> hello        world",
			["isalnum"] = "xstr:isalnum(str) --> boolean | nil, err_msg\n  判断str是否仅由字母和数字组成，是返回true，否返回false\n  print(xstr:isalnum(\"hello world:) 123\")) --> false",
			["isalpha"] = "xstr:isalpha(str) --> boolean | nil, err_msg\n  判断str是否仅由字母组成，是返回true，否返回false\n  print(xstr:isalpha(\"hello WORLD\")) --> true",
			["isdigit"] = "xstr:isdigit(str) --> boolean | nil, err_msg\n  判断str是否仅由数字组成，是返回true，否返回false\n  print(xstr:isdigit(\"0123456789\")) --> true",
			["islower"] = "xstr:islower(str) --> boolean | nil, err_msg\n  判断str是否全部由小写字母组成，是返回true，否返回false\n  print(xstr:islower(\"hello world\")) --> true",
			["isupper"] = "xstr:isupper(str) --> boolean | nil, err_msg\n  判断str是否全部由大写字母组成，是返回true，否返回false\n  print(xstr:isupper(\"HELLO WORLD\")) --> true",
			["join"] = "xstr:join(str, substr) --> string | nil, err_msg\n  使用substr连接str中的每个元素，返回新串\n  print(xstr:join(\"hello\", \"--\")) --> h--e--l--l--o",
			["lower"] = "xstr:lower(str) --> string | nil, err_msg\n  将str中的大写字母小写化，返回新串\n  print(xstr:lower(\"HeLLo WORld 2010\")) --> hello wold 2010",
			["upper"] = "xstr:upper(str) --> string | nil, err_msg\n  将str中的小写字母大写化，返回新串\n  print(xstr:upper(\"hello world 2010\")) --> HELLO WORLD 2010",
			["partition"] = "xstr:partition(str, substr) --> string, string, string | nil, err_msg\n  将str按照substr为界限拆分为3部分，返回拆分后的字符串\n  print(xstr:partition(\"hello*world\", \"wo\")) --> hello*	wo	rld",
			["zfill"] = "xstr:zfill(str, n) --> string | nil, err_msg\n  在str前补0，使其总长度为n。返回新串\n  print(xstr:zfill(\"100\", 5)) --> 00100",
			["ljust"] = "xstr:ljust(str, n, ch) --> string | nil, err_msg\n  按左对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:ljust(\"hello\", 10, \"*\")) --> *****hello",
			["rjust"] = "xstr:ljust(str, n, ch) --> string | nil, err_msg\n  按右对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:ljust(\"hello\", 10, \"*\")) --> hello*****",
			["center"] = "xstr:center(str, n, ch) --> string | nil, err_msg\n  按中间对齐方式，使用ch补充str，使其位宽为n。ch默认为空格，n默认为0\n  print(xstr:center(\"hello\", 10, \"*\")) --> **hello***",
			["dir"] = "xstr:dir()\n  列出xstr命名空间中的函数",
			["help"] = "xstr:help(\"func\")\n  打印函数func的帮助文档\n  xstr:help(\"dir\") --> \nxstr:dir()\n  列出xstr命名空间中的函数",
		}
		print(man[fun_name])
	end,
}
