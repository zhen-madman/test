return {
---- 物品系统-----
	[1] = "⊙",  --特殊符号
	["iteminfo"] = {
		["type"] = {[1]="装备", [2]="材料", [3]="灵魂石", [4]="消耗品"},
		["quality"] = {[1]="白", [2]="绿", [3]="蓝", [4]="紫", [5]="橙"},
		["useType"] = {[1]="详细", [3]="使用", [2]="合成"},
	},
	["common"] = { [1] = "系统", [2] = "确定",[3] = "奖励：",[4] = "完成：",[5] = "前往",[6] = "取消", [7] = "该任务未完成",[8] = "领取",[9] ="未完成",[10] = '请输入激活码'
		,[11] = '宝石，游戏的重要资源，有了以后可以任性......', [12] = '金币，游戏的重要资源，多多益善！', [13] = '战术点数，可以用来升级战术技能！',[14]="完成",[15]="已领取",
		[16] = '需加入军团开启飞艇系统',[17]='红蓝对抗币：可以在红蓝对抗兑换装备和科研材料，可以在红蓝对抗中获得',[18]='功勋值：可以用于将领洗练属性',[19]='声望值：可以用于招募将领',
		[20] = '宝石 : 可以买到很多好东西,充值可获得', [21] = '黄金 : 多用途货币',[22] = '<font color=green>领取成功</font>',[23] = '购买',[24]="%s不足",
		[25] = "总战力：%d", [26] = "购买成功",

		[100] = "您的宝石不足\n是否立即前往充值?",[101] = "当前VIP等级不足\n是否立刻往提升VIP等级?",
		ownCoin = "<font color=blue>拥有:</font><font color=white>%s</font><img src=#com_jb.png></img>",
		costMoney="<font color=%s outline=true>消耗: </font><font color=%s outline=true>%s</font> <img src=%s></img>",
		costGold="<font color=%s outline=true>消耗: </font><font color=%s outline=true>%s</font> <img src=#com_zs.png></img>",
		costCoin="<font color=%s outline=true>消耗: </font><font color=%s outline=true>%s</font> <img src=#com_jb.png></img>",
		getDungeon='获得途径',
		notOpen='尚未开放',
		coin_lack='黄金不足',
		need='需要', own='拥有', suit='套装',fightNumber='战斗力',notOpen='暂未开放',jump='跳转',get="获取",
		speed="移动速度",roleExp='指挥官经验',congGain='恭喜你获得了'

		},
	['coinType'] = {['gold'] = '宝石', ['coin'] = '金币', ['guildCoin'] = '军团币', ['arenaCoin'] = '对抗币',},
	["chat"] = { [1] = "发言过于频繁，稍后再发",[2] = "单次请勿超过30个汉字",[3]="点玩家头像发起私聊",[4] = "发送给",[5] ="对你说",[6] = "未加入军团",
				  [7] = "聊天",[8] = "拉黑",[9] = "成功加入黑名单",[10] = "从黑名单删除成功",[11] = "已经在黑名单",[12] = "免费⊙1", [13] = "<img src=#com_gold.png w=25 h=25></img> x ⊙1 ",
				  [14] = "确定", [15] = "取消",[16] = "本次发言需耗费",[17] = "您当前宝石不足",[18] = "无法向黑名单中的人发送消息", [19] = "#com_tx_2.png",[20] = "你还没有加入军团，无法使用军团频道",[21] = "来自军团:",
				  [22] = "您已被[⊙1]加入黑名单，消息发送失败",[23] = "#com_mark_2.png",[24] = "#com_renwu_activity_4_.png",[25] = "世界", [26]="军团",[27]="私聊",[28] = "黑名单",[29] = "<font color=rgb(255,243,218)>欢迎</fount><font color=rgb(70,195,255)>⊙1</fount><font color=rgb(255,243,218)>来到魔戒英雄!</fount>",
				  [30] = "加好友",[31] = "频道"},
	['bag'] = {
		['ItemSale']={[1]='出售成功', [2]='出售失败'},
		strengthSuccess='强化成功',upStarSuccess='升星成功',canNotSelect='无法选择更多的装备了',equipFirst="请先穿戴装备",
		notEnougthLevel="战队等级未到使用等级",reachMaxStar="该装备已达到星级上限，无法再提升",pleaseAddAnEqm="请至少添加一件装备",
		currentMaxLevel="已达到当前指挥官等级的最大强化等级, 请先提升等级后再来强化"
	},
	['eqm'] = {
		needStrengthenLevel = '需要装备等级:<font color=%s> %s</font>/<font color=%s>%s</font>',
		autoAddEquipError='低品质装备数量不足，请前往收集或手动选择高级装备',
	},
	["activity"] = { [1] = "通关战役副本任意关卡 <font color=rgb(15,150,250)>%d</font> 次", [2] = "通关组队副本任意关卡 <font color=rgb(15,150,250)>%d</font> 次", [3] = "通关日常副本任意关卡 <font color=rgb(15,150,250)>%d</font> 次", [4] = "在战争前线中参与战斗 <font color=rgb(15,150,250)>%d</font> 次", [5] = "参与世界防卫战 <font color=rgb(15,150,250)>%d</font> 次", [6] = "参与夺宝奇兵 <font color=rgb(15,150,250)>%d</font> 次", [7] = "冶炼金币 <font color=rgb(15,150,250)>%d</font> 次", [8] = "参与红蓝对抗 <font color=rgb(15,150,250)>%d</font> 次", [9] = "研究院消耗 <font color=rgb(15,150,250)>%d</font> 点资源点", },
	["task"] = {[1] = "拥有 <font color=rgb(15,150,250)>%d</font> 种单位", [2] = "指挥官等级等级达到 <font color=rgb(15,150,250)>%d</font> 级", [3] = "通关经典战役第 <font color=rgb(15,150,250)>%d</font> 章", [4] = "通关经典战役第 <font color=rgb(15,150,250)>%d</font> 章", [5] = "通关经典战役第 <font color=rgb(15,150,250)>%d</font> 章", [6] = "通关经典战役第 <font color=rgb(15,150,250)>%d</font> 章", [7] = "参与世界防卫战 <font color=rgb(15,150,250)>%d</font> 次", [8] = "在战争前线中完成阵营任务 <font color=rgb(15,150,250)>%d</font> 次", [9] = "在红蓝对抗中胜利 <font color=rgb(15,150,250)>%d</font> 次", [10] = "研究院已开启研究项目达到 <font color=rgb(15,150,250)>%d</font> 个", [11] = "获得装备数达到 <font color=rgb(15,150,250)>%d</font> 个", },

	['attr'] = {['hp']='血量', ['phy_atk']='物理攻击', ['mp_atk']='魔法攻击', ['phy_def']='物理防御', ['mp_def']='魔法防御', ['speed']="速度", ['speed_string'] = "速度",
	['speedValue']={[1]="快", [2]="中", [3]="慢", [4]="极慢", [5]="无可救药的慢"}},
	["dungeon"] = {[1] = "先通过前面副本",[2] = "战队等级达到⊙1级后开启",[3]="章节暂未开放",[4]="请选择上阵单位",
		[5] = '无法扫荡',[6] =  '扫荡%d次',[7] = '该关卡进入次数已达本日上限',[8] = '今日已购买⊙1/⊙2次,达到购买上限\n<font color=rgb(15,150,250)>提升vip等级增加购买次数?</font>',
		[9] = '重置精英关卡需要%d宝石,\n您的宝石不足,是否充值?',[10] = '是否确定以<font color=green>⊙1</font><img src=#com_zs.png></img>购买\n<font color=yellow>[⊙2]</font>⊙3次进入次数?\n<font color=rgb(255,255,255)>今日已购买</font><font color=green>⊙4/⊙5</font><font color=rgb(255,255,255)>次</font>',
		[11] = '扫荡卷不足\n是否花费%d宝石完成扫荡?', [12] = '扫荡券不足', [13] = '宝石不足',[14] = '第%d战',[15] = '额外奖励',
		[16] = '本次扫荡没有获取物品',[17] = '该章节尚未开启',[18] = '重置副本',[19] = '开始战斗',[20] = '通关前一关卡解锁该关卡',[21] = '获得该关卡的%s评价或提升至VIP3后可扫荡',
		[22] = '第%d章%d%s副本宝箱奖励领取成功',[23] = '已领取', [24] = '领取' , [25] = '未达成', [26] = 'S精英', [27] = 'S普通',
		[28] = '开启新章节--<font color=rgb(255,197,21)>%s</font>',[29] = '通关本章所有普通副本后开启精英副本', [30] = '通关前一关卡解锁该关卡',[31] = '战队等级达到<font color=rgb(149,3,4)>%d</font>级后可以开启该关卡',
		[32] = '开启该章节需:\n1.通关【<font color=rgb(149,3,4)>%s</font>】章节,\n2.获得【<font color=rgb(149,3,4)>%s</font>】章节中普通副本<font color=rgb(149,3,4)>S</font>评价数达<font color=rgb(149,3,4)>%d</font>\n3.战队等级达到<font color=rgb(149,3,4)>%d</font>级',
		[33] = '通关该关卡即可进行扫荡',[34] = '1.通关【<font color=rgb(149,3,4)>%s</font>】章节',[35] = '(<font color=rgb(149,3,4)>未达成</font>)',[36] = '(<font color=rgb(71,123,254)>已达成</font>)',
		[37] = '2.获得【<font color=rgb(149,3,4)>%s</font>】章节中普通副本<font color=rgb(149,3,4)>S</font>评价数达<font color=rgb(149,3,4)>%d</font>',
		[38] = '3.战队等级达到<font color=rgb(149,3,4)>%d</font>级',[39] = '通关送<font color=rgb(255,197,21)>vip%d</font>',
		[40] = '星奖励',[43]='未完成副本',[44]='3星通关或VIP%d以上才可进行扫荡',[45] = '<font color=blue>消耗:</font>%d<img src=#com_tl.png></img>',
		[46] = '请点击扫荡按钮',[47] = '第%d次扫荡', [48] = "目标：%s",
		[49] = '恭喜您创造通关纪录',[50] = '最低通关纪录:\n<font color=rgb(178,205,235)>【⊙1】</font>\n战力:<font color=rgb(255,255,255)>⊙2</font>',[51] = '最快通关:\n<font color=rgb(178,205,235)>【⊙1】</font>\n时间:<font color=rgb(255,255,255)>⊙2秒</font>',
		[52] = '我的最佳战绩:<font color=green>⊙1</font>',
	},

	["kinBoss"]={ [1] = "近期通关:<font color=rgb(178,205,235)>⊙1</font>\n战斗力:<font color=rgb(255,255,255)>⊙2</font>\n通关耗时:<font color=rgb(0,255,0)>⊙3</font>秒\n我的最快耗时:<font color=rgb(0,255,0)>⊙4</font>秒",
				  [2] = "可重置次数:<font color=green>⊙1</font>\n当前可扫荡至:<font color=rgb(255,133,0)>⊙2</font>",
				  [3] = "第⊙1层BOSS【⊙2】",
				  [4] = "当前免费重置次数已用完，是否花费⊙1<img src=#com_zs.png></img>重置副本？",
				  [5] = "成为VIP3后可使用此功能\n点击此按钮会自动扫荡到当前可扫荡的所有副本",
				  [6] = "是否花费⊙1<img src=#com_zs.png></img>立即完成扫荡?",
	},

	["arena"] = { [1]="第⊙1至第⊙2名",[2] = "1.红蓝对抗中禁止使用原子弹、轰炸机等大规模杀伤性武器！\r2.每天晚上21点根据排名发送奖励，在“领奖”处领取\r3.每提升一次历史最高排名都可以获得丰厚的宝石奖励\r4.每天每个玩家可以免费发起战斗15次",[3] = "第<font color=rgb(0,255,0)>%d</font>名:",[4]="膜拜成功，获得⊙1黄金", [5]="⊙1天前",[6] ="⊙1小时前",[7] ="⊙1分钟前",[8] = "⊙1秒前",[9]="进入次数已用完，请及时购买",[10] = "购买次数已用完，请及时升级VIP",[11] = "您是否花费⊙1<img src=#com_zs.png></img>来重置进入次数"
					,[12] ="您的宝石不足，无法重置",[13] = "   挑战时间正在冷却中，请先重置时间   ",[14] = "膜拜次数用完了",[15]="成功重置挑战时间",[16]="成功购买挑战次数",[17]="对战",[18]="膜拜",[19]="兑换",[20]="剩余⊙1天发放:",[21]="<font color=rgb(255,0,0) ></font><img src=#com_gold.png w=35 h=35></img>⊙1 <img src=#com_coin.png w=35 h=35></img>⊙2 ",
					 [22] ="周累计奖励",[23]="你总共被膜拜⊙1次",[11] = "您是否花费⊙1<img src=#com_zs.png></img>来刷新CD时间"},

	["fight"]={},

	["guild"] = { 	[1] = "请输入正确的军团名称",[2] = "最长只能五个字",[3] ="请输入军团名称",[4] = "恭喜你加入军团[⊙1]，赶紧去看看吧！",[5] = "好的",[6] = "降为会员",[7] = "升为副团长",[8]="修改成功",[9] = "处理完毕",
					[10] = "恭喜你创建[⊙1]成功，赶紧去看看吧！",[11] = "公告内容太长",[12] = "公告修改成功",[13]="需要验证才可加入",[14]="所有人都可加入",[15]="不可以加入",
					[16] = "你确定离开军团吗？你将在5分钟内无法加入其他军团，1小时内无法回到本军团！",[17] = "你确定解散军团吗？你将在5分钟内无法加入其他军团，同时本军团将被解散！",[18] ="你已退出军团",[19] = "⊙1/⊙2",
					[20]="等级达到⊙1级", [21] = "军团收人，活跃就好，多捐点科技不要求满捐。",[22] = "获得⊙1点贡献",[23] = "你确定花费⊙1<img src=#com_zs.png></img>创建新军团吗",[24] = "请选择军团政策科技的发展方向",
					[25] = "今日已达金币捐献获得贡献上限，继续捐赠将不再获得贡献，请问是否继续捐赠。",[26] = "今日已达宝石捐献获取贡献上限，继续捐赠将不再获得贡献，请问是否继续捐赠。",[27] = "确定将[⊙1]设为军团长吗，你将成为普通会员!",[28] = "确定将[⊙1]踢出军团吗？他将在1小时内无法加入其他军团，两天内无法回到本军团！",
					[29] = "成员获得一点军团贡献，军团繁荣度增加一点。",[30]="你已加入军团",[31] = "今日已捐献%s次，达到捐献上线\n  提升vip等级增加捐献次数",[32] = "军团等级Lv.⊙1解锁",[33] = "<font color=white>科技等级已满</font>",
					[34] = '今日捐献剩余次数:<font color=white>⊙1</font>',
		},

	['checkIn'] = {	[1] = '双倍',[2] = 'vip%d获双倍奖励',[3] = '到达vip%d级后可以获得双倍奖励\n是否充值?',[4] = '签到%d次后可领取',
		[5] = "月签到奖励",[6] = '每月累计签到天数，领取相应的签到奖励。\n\n某些天数奖励，达到对应VIP等级及以上的玩家可以领取双倍奖励！第二份奖励可以当日内升级VIP等级后补领。\n\n签到奖励在每天的5:00计算隔天，当天未领取的奖励隔天不可以再补领。',
		[7] = '游戏的重要资源，多多益善！',[8] = '全勤礼包',[9] = '<font color=blue>%d宝石</fong>和1件<font color=purple>紫色装备</font>距离全勤还有\r<font color=yellow>%d</font>天',
		[10] = '<font color=green>领取成功<font>',[11]='<font color=purple>紫色装备</font>\n500<img src=#com_zs.png></img>',
		[12] = "签到", [13] = "VIP每日礼包", [14] = "VIP等级越高\n奖励越丰富", [15] = "当前VIP等级：VIP%d"
	},
	['challenge'] = { [1] = '难度', [2] = '未开启', [3] = '战队等级到达%d级可进入', [4] = '今日挑战次数已用完',[5] = '冷却时间未到,无法进入',
		[6] = '今日已重置双塔副本%d次,达到重置上限，\n提升VIP至4、9、15级上限各增加1次剩余重置,是否提升vip以获得更多重置次数?',
		[7] = '重置双塔副本需要%d宝石,\n您的宝石不足,是否充值?',[8] = '重置双塔副本需要%d宝石,\n确定进行重置?',
	},
	['guildDungeon'] = { [1] = "",[2] = '尚无人通关',[3] = '完成%s后可开启宝箱',
		[4] = '需要vip10才可开启该宝箱', [5] = '1.夺宝奇兵的战斗，敌我双方的生命值不会重置，将延续上次战斗结束后的状态。\n2.已阵亡的单位不会复活，无法再次上阵。\n3.每天可参与一次夺宝奇兵，每通过一关即可开启该关卡的宝箱，VIP10以上还可额外开启一次宝箱。\n4.宝箱将掉落大量的金币、道具、灵魂石、军团币，还有可能直接获得单位。\n5.如果当前副本已被军团成员通关，那么之后参与该副本的成员将获得增益效果，极大的提高参战单位的能力。\n6.第一个通过最高副本的成员将获得额外奖励，奖励将在第二天5点通过邮箱发送。',
		[6] = '第一关',[7] = '第二关',[8] = '第三关',[9] = '第四关',[10] = '第五关',[11] = '第六关',[12] = '第七关',[13] = '第八关',
		[14] = '第九关',[15] = '第十关',[16] = '第十一关',[17] = '第十二关',[18] = '第十三关',[19] = '第十四关',[20] = '第十五关',
		[21]="[%s]明日超时空危机攻击+1%%",[22]="昨日被膜拜%d次，战斗额外获得：<font color=rgb(24,255,0)>攻击+%d%%</font>"
	},
	['role'] = { [1] = '输入的名称与原战队名称重复', [2] = '战队名称太长', [3] = '改名需花费100宝石\n是否继续?', [4] = '您的宝石不足',
		[5] = '请输入您的战队名称', [6] = '基础头像', [7] = '单位头像', [8] = '温馨提示:单位进阶到紫色可以设置为头像',
		[9] = '关闭声音', [10] = '开启声音', [11] = '还需要%d小时%d分钟后才可改名', [12] = '确定退出吗?',
		roleUpExp="升级经验:\n<img src=#com_fgx.png clip=rect(0,0,%s,6)></img>\n<node w=%s h=%s align=center valign=top color=%s>%s/%s</node>",
		roleReputation="功勋值:\n<img src=#com_fgx.png clip=rect(0,0,%s,6)></img>\n<node w=%s h=%s align=center valign=top color=%s>%s</node>",
		roleFightValue="战斗力:\n<img src=#com_fgx.png clip=rect(0,0,%s,6)></img>\n<node w=%s h=%s align=center valign=top color=%s>%s</node>",
		roleRenown="声望:\n<img src=#com_fgx.png clip=rect(0,0,%s,6)></img>\n<node w=%s h=%s align=center valign=top color=%s>%s</node>",

	},
	['leader'] = {
		gotoFightSuccess = '指挥官上阵成功',upstarNotice='突破可增加属性条目',upStarSuccess='升星成功',
		recruitRoleLevel="指挥官等级达到%s级",recruitVip="VIP等级达到%s",recruitReputation="功勋消耗%s",recruitDungeon="通关副本%s",recruitRenown="声望消耗:%s",
		tipUpNotice='【突破可升级技能】',tipUpNoticeMax='【当前技能已满级】',
		validArm="<font color=blue>(仅对</font><font color=red>%s</font><font color=blue>类型部队有加成)</font>"
	},
	['shop'] = { [1] = "排名达到⊙1",[2] = "军团等级达到⊙1",[3] = "今日活跃达到⊙1",[4] = "红蓝对抗当前排名达到⊙1才可购买",[5] = "可购次数不足，等明天再买吧！",[6] = "每天清晨5点重置购买次数",
		[7] = "您的%s不足", [8] = "物品", [9] = "珍品", [10] = "%d<img src=#com_jt.png></img>%d<img src=#com_zs.png></img>",
		[11] = "<img src=%s></img>\n  %s%d",[12] = "指挥官大人，您每天会获得一定的免费兑换次数，可以任意兑换上面几种资源。\n免费次数每天重置，请记得用光哦！另外，VIP等级越高，免费次数越多哦！",
		[13] = "%d<img src=#com_zs.png></img>", [14] = "免费获得", [15] = "点击获得", [16] = "许愿获得了<img src=%s></img>%d",
		[17] = "可购次数：<font color=%s>%d</font>次",[18] = "<font color=orange>今日免费兑换次数：</font>%d",
		[19] = "<font color=orange>今日还可兑换次数：</font>%d", [20] = "刷新次数已用完",
	},
	['stone'] = { [1] = "您的宝石不足,是否充值?", [2] = "使用点金石失败", [3] = '暴击x', [4] = "使用", [5] = "查看vip",
		[6] = '获得黄金:', [7] = '使用', [8] = '获得', [9] = "今日点金手次数已用完\n充值vip以获得更多的使用次数",
	},
	['vit'] = {	[1] = "当前时间", [2] = '已买原油次数', [3] = "原油已回满", [4] = '下点原油恢复',
		[5] = '全部原油恢复', [6] = "恢复时间间隔: %d分钟", [7] = "<font color=rgb(255,255,255)>今日已购买</font><font color=rgb(254,0,0)>%d</font><font color=rgb(255,255,255)>次,达到购买上限</font>\n\n提升vip等级增加购买次数",
		[8] = "是否支付<font color=green>%d</font><img src=#com_zs.png></img>购买<font color=green>%d</font><img src=#com_tl.png></img>\n\n<font color=rgb(255,255,255)>今日已购买</font><font color=green>%d/%d</font><font color=rgb(255,255,255)>次</font>", [9] = "您的宝石不足", [10] = "您的原油太多,先用掉一些吧!",
		[11]= '购买失败', [12] = '购买成功',
	},
	['treasure'] = { [1] = '次免费', [2] = '后免费', [3] = "再抽十次", [4] = "再抽一次", [5] = "您的宝石不足\n是否充值?",
		[6] = "单抽\n有机会获得<font color=rgb(148,0,211)>紫色</font>或者<font color=rgb(255,140,0)>橙色</font>",
		[7] = "十连抽\n必得<font color=rgb(148,0,211)>紫色</font>或者<font color=rgb(255,140,0)>橙色</font>",
		[8] = "请求互助成功!",[9] = "帮助成功!",[10] = "内容不得超过20个字",[11] = "请输入内容！",[12] = "紧急求助，军用商店告急，请求支援！",
		[13] = "注意:\n点击求助，会发送一条求助信息到军团频道求援，凑齐10个支援可以额外获得1次免费购买图纸的机会",
		[14] = "%s支援了您的军用商店",[15]="军用商店已筹集%d个支援，获1次免费购买机会",[16]="买一次",[17]="买十次"
	},
	['quickEquip']= { [1] = '穿戴装备成功',

	},
	['activationCode'] = {[1] = '兑换[%s]成功,获得以下奖励'

	},
	['NeedCoin'] = {[1] = '%s今天未开放', [2] = '加入军团开启夺宝奇兵'},
	['newSystemTips'] = {[1] = '开启%s',},
	['funActivatity'] = {[1] = '活动期间已消费%d宝石',[2] = '活动期间已充值%d宝石',[3] = '活动期间已连续登陆%d天',[4] = '尚未获得首次充值奖励',[5] = '已获得首次充值奖励',
	[6] = '活动时间:',[7] = '%d年%d月%d日%02d时%02d分—%d年%d月%d日%02d时%02d分\n',[8] = '活动内容:',[9] = '我的状况:',[10] = '更新公告',
	[11] = '%d号%d:%02d截止',[12] = '更新公告', [13] = '当前没有精彩活动', [14] = '每日签到',[15] = '7日签到',[16]='第二天登陆，即送飞碟',
	[17] = '一次性花费<font color=rgb(255,133,0)>%d</font>宝石',[18]='累积获取<font color=rgb(255,133,0)>%d</font>宝石返还',[19]='确认购买',[20]='前往充值',
	[21] = 'VIP等级不足，请前往充值',[22]='宝石不足，请前往充值',[23]='%d宝石',[24]='到达LV%d领取',[25]='VIP%d以上方可购买,请前行充值',
	[26] = '<font color=yellow>购买成功</font>', [27] = "今日图纸转盘次数不足，\n提升VIP等级可增加转盘次数", [28] = "VIP权限",
	[101] = '领取', [102] = '已领取', [103] = '未领取',[104] = '从邮件获取',[105] = '不可领取', [106] = '前往获取'},
	["friend"] = {[1] = "当前活跃度每次接受祝福可获得⊙1点原油，查看详情",[2] ="邀请⊙1/⊙2个好友奖励⊙3宝石(⊙4)",[3] ="⊙1/⊙2个好友达到⊙3级奖励⊙4宝石(⊙5)",[4] ="<font color=green>领取成功</font>",[5] = "近三日活跃度达到[⊙1,⊙2]，每次接受祝福可获得⊙3点原油",
				 [6]="赠送成功",[7]="接受成功",[8]="邀请成功",[9] = "处理成功",[10]="快去下載《從夏爾出發》，與我一起大戰史矛革！遊戲的Googleplay下載鏈接，這是我的邀請碼：⊙1，記得在好友處填寫我的邀請碼！"},

	['wboss'] = {[1]='%s-%s才能挑战世界BOSS', [2]="boss已死亡，请在每天的挑战时间内重置",[3]="今天挑战次数已用完，请明天再来",[4]="boss已死亡，明天请在挑战时间内完成挑战",
			[5]="花费<font color=%s>%s</font>宝石重置挑战次数\n今日已重置<font color=%s>%s</font>次",[6]="今日已重置<font color=%s>%s</font>次，达到重置上限\n提升VIP至9、12、15级上限各增加1次",
			[7] = '<font color=blue>剩余次数：</font>%d/%d',[8] = '是否花费%d<img src=#com_zs.png></img>重置时间？',
			[9] = "<font color=blue>冷却时间：</font>%s", [10] = "立即挑战", [11] = "立即重置",[12] = "<font color=blue>获得金币:</font>%d",
			[13] = "世界boss(Lv.%d)已经被打败，接下来，\nboss将会提升自己的攻击威力和生命值。\n祝您好运！",
			[14] = "购买次数", [15] = '是否花费%d<img src=#com_zs.png></img>购买一次挑战？',
			['resetText']='重置次数',['fightText']='参与挑战',['viewVip']='查看VIP', ['revival']='%s后复活',},
	['heroPoetry'] = {[1] = '%d年%d月%d日-%d年%d月%d日',[2] = '可能获取',[3]='任务说明:\n',[4] = '该任务以结束',[5] = '该任务尚未开始', [6] = '奖励已领取',
		[7] = '领取奖励',[8] = '进行任务',[9] = '您的原油不足',[10]='本次问答结束,共答对<font color=rgb(149,3,4)>%d</font>道题',[11] = '领奖成功,获取以下奖励:',
	},
	['camp'] = {[1] = '盟军',[2] = '苏联'},
	['inst'] = {numberTip='提高VIP等级可以增加研究上限', needRoleLevel='需要指挥官等级：<font color=%s>Lv.%s</font>/<font color=%s>Lv.%s</font>',
			upSuccess='升级成功', maxLevel='已达到最大等级, 提升指挥官等级可提升部队等级上限',resolveSuccess='分解成功,获得',
			maxBuyTimes='今日购买次数已达上限',maxSP="已满",noNeedTech="<font color=white>无需科技!</font>",noNeedItems='无需材料!',guildTech="军团科技",
			buyInstPointText="超级计算机中心还需<font color=red>%s</font>\n才能再次分配计算力\n\n<font color=rgb(237,178,0)>是否支付</font><font color=cyan>%s</font><img src=#com_zs.png></img><font color=rgb(237,178,0)>马上获得</font><font color=cyan>%s</font><font color=rgb(237,178,0)>计算力</font>",
			firstInstPointFmt="<font color=white>%s</font><font color=red>(%s后恢复1点)</font><img src=#com_jia.png></img>",
			leftInstPointFmt="<font color=blue>超算资源: </font><font color=white>%s (%s)</font>",
			unlockCond="请先提升前置单位的等级以解锁本单位", produceHero="单位数量为0,请至[单位生产]界面生产至少1个单位",
	},
	['hero'] = {needHeroLevel='需要单位等级：<font color=%s>Lv.%s</font>/<font color=%s>Lv.%s</font>', notPassDungeon="未通关",notHave='暂未获得',pleaseGetFirst="请先获得",
		stockTips="<font color=yellow>%s:</font><font color=white>单次战斗里</font><font color=blue>%s</font><font color=white>出战架数上升为</font><font color=cyan>%s</font>",
		maxLevel="已达顶级",upQuality="确定升衔"
	},
	['defender'] = {[1] = '是否消耗<font color=white>%d</font><img src=#com_zs.png></img>,立即进入战斗？',[2] = '宝石不足',[3] = '剩余次数:<font color=white>⊙1/⊙2</font>',
					[4] = '冷却时间:<font color=white>⊙1</font>',[5] = '今日次数已使用完！'},
	['foundry'] = {[1] = '今日锻造次数已用完\n提升VIP等级可获更多锻造次数',
	[2] = '连续铸币<font color=orange>%d次</font>，获得了<img src=#com_jb.png></img><font color=orange>%d</font>',
	[3] = '恭喜您本次铸币获得了<img src=#com_jb.png></img><font color=orange>%d</font>',
	[4] = '军团科技：铸币厂产量提升<font color=white>⊙1%</font>'},
	['rank'] = {[1] = '当前未上榜，请再接再厉',[2] = '战斗力：', [3] = '最高伤害：',[4] = '军团：',[5] = '尚未加入军团',[6] = '积分：',
			[7] = '我的等级：%d    我的战斗力：%d\n我的排名：%d    军团：%s',[8]='目前无人上榜',[9]='<font color=blue>战力要求：</font><font color=%s>%d</font>',
			[10] = '<font color=blue>人数限制：</blue>',[11]='<font color=blue>对%s以下：</font>攻击<font color=green>+5%%</font>',
			[12] = '<font color=blue>新加特权：</font>%s',[13] = '不限',[14]='无',
			[15] = '战役指挥官经验<font color=green>+%d%%</font>',
			[16] = '金矿争夺每天扫荡次数<font color=green>+%d</font>',
			[17] = '建筑每天<font color=green>%d</font>小时内自动升级',
			[18] = '采集水晶产量<font color=green>+%d%%</font>',
			[19] = '采集铀产量<font color=green>+%d%%</font>',
			[20] = '采集铁产量<font color=green>+%d%%</font>',
			[21] = '<font color=green>%d</font>支部队自动采矿8小时',
			[22] = '军需库10连抽<font color=green>%d</font>折',
			[23] = '无特权',[24]='军饷',[25]='<font color=yellow>恭喜指挥官阁下,您普升为%s</font>',
			[26] = '冶炼厂每小时自动产出钢铁资源<font color=green>+%d%%</font>',
			[27] = '冶炼厂每小时自动产出水晶资源<font color=green>+%d%%</font>',
			[28] = '冶炼厂每小时自动产出铀资源<font color=green>+%d%%</font>',
			[29] = '战役结算黄金获得<font color=green>+%d%%</font>',
			[30] = '铸币厂获得黄金<font color=green>+%d%%</font>',
			[31] = '<font color=yellow>%s特权：</font>',
			},
	['building'] = {[1] = 'VIP4可以额外解锁一条建筑队列',[2] = '免费加速',[3] = '道具加速',[4] = '请选择加速道具',
		[5] = '<font color=yellow>距离免费加速(%s)</font>',[6] = '当前加速时间超过建筑所需时间，是否继续使用？'},
	['wilderness'] = {[1] = '是否支付<font color=green>%d</font><img src=#com_zs.png></img>购买',
		[2] = '<font color=green>%d</font><img src=%s></img>',
		[3] = '\n\n<font color=rgb(255,255,255)>今日已购买</font><font color=green>%d/%d</font><font color=rgb(255,255,255)>次</font>',
		[4] = '购买次数已用完，请及时升级VIP',[5] = '下次可购买时间：%s',[6] = '%s不足,是否使用下列功能获得%s',
		[7] = '水晶',[8]='铁',[9]='铀',
		[10] = '<font color=green>+%d%%</font><img src=%s></img>',
		[11] = '自动产出(%s)速度<font color=green>+100%%</font>',
		[12] = '提升主基地到20级解锁部队3',
		[13] = '是否花费<font color=green>⊙1</font><img src=#com_zs.png></img>进行迁城？',
		[14] = '该对手超过您的实力，是个不好惹的角色，是否还要继续进攻？' ,[15]="迁城成功",
		[16] = '<font color=white>出征返回时间较长，请问是否继续？</font>\n<font color=green>提示：迁城到附近，将大量减少出征时间。</font>',
		[17] = "<font color=rgb(0,255,0)>联合采矿</font>采集效率倍增,详情可查看说明",
		[18] = "宝石不足！",
		[19] = "确定使用⊙1<img src=#com_zs.png></img>购买部队4\n500小时使用权?\n(<font color=yellow>VIP7免费使用</font>)",
		[20] = "该矿点已被其他人在联合采矿中，无法出征。",
		[21] = "出征空地可能无法采集到资源，确定出征？",
		[22] = "<font color=rgb(53,191,254)>城防：</font>⊙1/⊙2<font color=rgb(53,191,254)>，自动修复：</font>⊙3/分钟\n<font color=rgb(53,191,254)>花费</font>⊙4<img src=#yw_icon_t.png></img><font color=rgb(53,191,254)>立即修复</font>⊙5<font color=rgb(53,191,254)>点城防?</font>",
		[23] = "修复1次",
		[24] = "修复10次",
		[25] = "<font color=blue>⊙1</font><font color=green>⊙2</font>将您的基地城防彻底摧毁了\n系统将随机为您安排一个新地址",
		[26] = "您将<font color=blue>⊙1</font><font color=green>⊙2</font>的基地城防彻底摧毁了\n系统将随机为他安排一个新地址",
		[27] = "<font color=white>登陆启动自动修复，直到完全恢复，回复速度：⊙1城防/分钟</font>",
		[28] = "提升VIP等级解锁更多部队",
		[29] = "<font color=rgb(53,194,254)>城防：</font><font color=white>⊙1</font>",
		[30] = "您有1次免费主动迁城的机会,\n以后每次迁城需要花费<font color=green>⊙1</font><img src=#com_zs.png></img>,\n是否免费迁城？",
		[31] = "是否消耗一张迁城令进行迁城？\n（迁城令剩余<font color=green>⊙1</font>张）",
		[32] = "指挥官，\n请先撤回所有出征的部队，才可以迁城。",
		[33] = "<font color=rgb(53,191,254)>侦查玩家：</font>⊙1 Lv.⊙2\n<font color=rgb(53,191,254)>所属军团：</font>⊙3\n<font color=rgb(53,191,254)>侦查时间：</font>⊙4\n<font color=rgb(53,191,254)>据点坐标：</font><img src=#yw_img_2.png></img>⊙5",
		[34] = "<font color=rgb(53,191,254)>侦查玩家：</font>⊙1 Lv.⊙2\n<font color=rgb(53,191,254)>所属军团：</font>⊙3\n<font color=rgb(53,191,254)>侦查时间：</font>⊙4",
		[35] = "确定花费%d水晶进行侦查？",
		[36] = "<font color=rgb(53,191,254)>⊙1: </font><font color=rgb(32,107,146)>⊙5</font>⊙2 Lv.⊙8<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>(⊙3,⊙4)</font>\n<font color=rgb(53,191,254)>战斗时间: </font>⊙6     <font color=rgb(53,191,254)>战斗结果: </font>⊙7",
		[37] = "<font color=red>防守失败</font>",[38] = "<font color=green>防守成功</font>",[39] = "<font color=red>袭击失败</font>",[40] = "<font color=green>袭击成功</font>",
		[41] = "<font color=rgb(53,191,254)>资源掠夺情况: </font>",
		[42] = "<font color=rgb(53,191,254)>可掠夺资源: </font>",
		[43] = "可获得配件增强材料",
		[44] = "可获得一定数量的宝石",
		[45] = "可获得各种道具",
		[46] = "<font color=rgb(53,191,254)>军团科技负重加成:</font>\n",
		[47] = "<font color=rgb(255,255,255)>紫晶x%d</font>\n今日功勋达到<font color=rgb(255,255,255)>%d</font>可以领取\n进度:<font color=rgb(0,255,0)>%d</font>/<font color=rgb(255,255,255)>%d</font>",
		[48] = "功勋值和奖励列表每天<font color=rgb(255,255,254)>5:00</font>更新"
		},
	['battlefront'] = {[1] = 'VIP⊙1开启托管',[2]='取消托管',[3]='开启托管',[4]='战场未开启',[5]='活动进行中'},
	['wildernessBattle'] = {
	[1] = '在⊙1被<font color=white>⊙2</font><font color=red>⊙3</font>袭击<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙4 Y:⊙5</font>防御⊙6',
	[2] = '您的主基地被<font color=white>⊙1</font><font color=red>⊙2</font>袭击<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙3 Y:⊙4</font>防御⊙5',
	[3] = '袭击<font color=white>⊙1</font><font color=rgb(32,107,146)>⊙2</font><font color=red>⊙3</font>的部队<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙4 Y:⊙5</font>袭击⊙6',
	[4] = '袭击<font color=white>⊙1</font><font color=rgb(32,107,146)>⊙2</font><font color=red>⊙3</font>的基地<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙4 Y:⊙5</font>袭击⊙6',
	[5] = '袭击',[6] = '防御',[7] = '<font color=rgb(255,0,0)>失败</font>',[8] = '<font color=rgb(0,255,0)>成功</font>',[9] = '发生在: <font color=rgb(255,133,0)>X:⊙1  Y:⊙2</font>',[10] = '\n<font color=rgb(53,194,254)>军团繁荣度:</font>',[11] = '部队采集:',[12] = '部队袭击Lv.⊙1⊙2⊙3',[13] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font>',
	[14] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>被<font color=white>[⊙5]</font><font color=rgb(32,107,146)>⊙6</font><font color=red>⊙7</font>袭击,防御⊙8。团长对入侵行为表示强烈谴责。',
	[15] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>袭击<font color=white>[⊙5]</font><font color=rgb(32,107,146)>⊙6</font><font color=red>⊙7</font>,袭击⊙8。',
	[16] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>向此处发起增援请求，在线的朋友请驻军到该坐标附近。',
	[17] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>向此处发起集结进攻，在线的朋友请出征。',
	[18] = '<font color=rgb(255,0,0)>失败</font>。真是遗憾。',[19] = '<font color=rgb(0,255,0)>成功</font>。威武。',
	[20] = '  <font color=rgb(53,194,254)>袭击目标：</font>⊙1  加成×⊙2',
	[21] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>被<font color=red>⊙5</font>袭击,防御⊙6。团长对入侵行为表示强烈谴责。',
	[22] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>袭击<font color=red>⊙5</font>,袭击⊙6。',
	[23] = '暂无信息哦！',[24] = '可恶的<font color=red>⊙1</font>袭击了您的⊙2,防御⊙3',[25] = '军团繁荣度:<font color=white>⊙1</font>',[26] = '部队损失:<font color=white>⊙1</font>',
	[27] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>邀请朋友们到此处联合采矿。',
	[28] = '<img src=#yw_img_2.png></img><font color=rgb(255,133,0)>X:⊙1 Y:⊙2</font><font color=rgb(32,107,146)>⊙3</font><font color=green>⊙4</font>邀请朋友们迁城到此附近。',

	[29] = "<font color=blue>⊙1</font><font color=green>⊙2</font>请求增援，在线朋友请驻军支援。",
	[30] = "<font color=blue>⊙1</font><font color=green>⊙2</font>向此处发起集结进攻，在线的朋友请出征。",
	[31] = "<font color=blue>⊙1</font><font color=green>⊙2</font>邀请朋友们到此处联合采矿。",
	[32] = "<font color=blue>⊙1</font><font color=green>⊙2</font>邀请朋友们迁城到此附近。",},
	['flashActivity'] = {
		[1] = 'VIP<font color=yellow>3/5/7/9</font>有更多机会呦！', [2] = '<font color=green>活动时间：%s -- %s</font>', [3] = '<font color=blue>拥有：</font>%d<img src=#com_zs.png></img>',
		[4] = '<font color=blue>剩余次数:</font>%d', [5] = '<font color=blue>本次最高可获得:</font>%d<img src=#com_zs.png></img>', [6] = '需要:<img src=#com_zs.png></img>%d',
		[7] = '<font color=green>%d天</font>',[8] = '%s<font color=blue>获得</font>%s%d', [9] = '<img src=#com_zs.png></img>', [10] = '提高VIP等级可以增加招财次数',
		[11] = '探宝有几率获得<font color=orange>%s</font>',[12]='在本活动中购买金币获得探宝令牌',[13]="<font color=blue>已探宝次数：</font>%d",
		[14] = '<font color=blue>拥有：</font>%s%d',[15]='<img src=#xs_icon_lp.png></img>',[16]="根据探宝次数进行排名，活动结束后发放相应奖励，探宝<font color=green>%d次</font>以上才可获得排名奖励",
		[17] = "<font color=blue>消耗:</font>%d%s",[18] = "领取%d个", [19] = "探宝%d次",[20] = "活动期间探宝次数前十的玩家可以获得以下奖励",[21]='%d次',[22]='第%d名',
		[23] = '购买%d%s', [24] = '<img src=#com_jb.png></img>',[25] = '排名奖励', [26] = '探宝预览', [27] ='<img src=#hdtb_hdsj.png></img>',
		[28] = "%d天%d小时%d分钟%d秒",[29] = '第%d天',[30] = '时间没到，还未开启',[31] = '未开启',[32] = '第%d - %d名',
		[33] = '送%s%s%d',[34]='<font color=orange>已有%s</font><font color=green>%d</font>/30',[35] = '签到成功',
		[36] = '领取奖励', [37] = '已经领取', [38] = '不可领取',[39] = '进度:%d/%d',[40] = '活动剩余时间：<font color=green>%d天%d小时%d分钟%d秒</font>',
		[41] = '黄金', [42] = '宝石', [43] = "我要充值", [44] = "物品不足", [45] = "<font color=orange>切换倒计时：</font>%s",
		[46] = "<font color=blue>免费(%d)</font>", [47] = "<font color=blue>当前主题：</font>%s", [48] = "<font color=blue>Next：</font>%s",
		[49] = "积分：<font color=green>%d</font>/%d", [50] = "<font color=blue>现价:</font>%d%s",
		[51] = "<font color=blue>原价:</font>%d%s", [52] = "活动时间：%s - %s",
		[53] = "<font color=blue>总价：</font><font color=%s>%d</font>%s", [54] = "可购买：<font color=white>%d</font>次",
		[55] = "可领取次数：%d", [56] = "返还", [57] = "领取返还", [58] = "活动期间扩充单位将会获得<font color=orange>%d%%</fon>返利",
		[59] = "扩充将获得：", [60] = "特训至%s可返还",
	},
	['adjunct'] = {
		[1] = '1、每个增强材料都可以提升配件属性;\n\r2、进阶材料可以大幅度提高配件属性;\n\r3、进阶同时消耗增强材料和进阶材料;\n\r4、分解材料可以获得材料精华;\n\r5、材料精华可以兑换指定材料',
		[2] ="尚未拥有该配件，请到野外获取！", [3] = "首次击杀【世界】中的野怪可获得配件!想要美国大兵的配件就去打美国大兵！",
		[4]="尚未拥有该配件，可到商店兑换！",[5]="各随机商店有几率刷出此配件！",[6] ="到【世界】击杀野怪可获得配件材料!击杀越高级的野怪可获得越高级物品！"
	}
}
