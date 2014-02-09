beforeEach ->
  @dummyData ?= {}
  
  @dummyData.bbsMenuHtml = """
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=Shift_JIS">
<TITLE>BBS MENU for 2ch</TITLE>
<BASE TARGET="cont">
</HEAD>

<BODY TEXT="#CC3300" BGCOLOR="#FFFFFF" link="#0000FF" alink="#ff0000" vlink="#660099">
<a href=http://www.bb-chat.tv/><img src=http://img.bbchat.tv/images/bannar/7575.gif width=75 hight=75 border=0></a>

<BR>
<font size=2>


<FORM name=f action=http://find.2ch.net/ method=get>
	<INPUT type=hidden value=ALL name=BBS>
	<INPUT type=hidden value=TITLE name=TYPE>
	<INPUT size=10 name=STR>
	<INPUT type=hidden value=SJIS name=ENCODING>
	<INPUT style="PADDING-RIGHT: 1px; PADDING-LEFT: 1px; FONT-SIZE: 90%; PADDING-BOTTOM: 1px; PADDING-TOP: 1px" type=submit value=検索>
	<INPUT type=hidden value=50 name=COUNT>
</FORM>

<A HREF=http://www.2ch.net/ TARGET="_top">2chの入り口</A><br>
<A HREF=http://info.2ch.net/guide/>2ch総合案内</A>

<BR><BR><B>地震</B><BR>
<A HREF=http://headline.2ch.net/bbynamazu/>地震headline</A><br>
<A HREF=http://anago.2ch.net/namazuplus/>地震速報</A><br>
<A HREF=http://hayabusa.2ch.net/eq/>臨時地震</A><br>
<A HREF=http://hayabusa2.2ch.net/eqplus/>臨時地震+</A><br>
<A HREF=http://uni.2ch.net/lifeline/>緊急自然災害</A>

<BR><BR><B>おすすめ</B><BR>
<A HREF=http://uni.2ch.net/base/>プロ野球</A><br>
<A HREF=http://awabi.2ch.net/kaden/>家電製品</A><br>
<A HREF=http://ikura.2ch.net/photo/>写真撮影</A><br>
<A HREF=http://ikura.2ch.net/kyoto/>神社・仏閣</A><br>
<A HREF=http://uni.2ch.net/kinoko/>きのこ</A>

<BR><BR><B>特別企画</B><BR>
<A HREF=http://find.2ch.net/>2ch検索</A><br>
<A HREF=http://be.2ch.net/>be.2ch.net</A><br>
<A HREF=http://find.2ch.net/enq/board.php>アンケート</A><br>
<A HREF=http://2ch.tora3.net/>2chビューア</A><br>
<A HREF=http://epg.2ch.net/tv2chwiki/>テレビ番組欄</A><br>
<A HREF=http://shop.2ch.net/>2chオークション</A><br>
<A HREF=http://watch.2ch.net/>2ch観察帳</A>

<BR><BR><B>be</B><BR>
<A HREF=http://kohada.2ch.net/be/>面白ネタnews</A><br>
<A HREF=http://ikura.2ch.net/nandemo/>なんでも質問</A><br>
<A HREF=http://ikura.2ch.net/argue/>朝生</A>

<BR><BR><B>チャット</B><BR>
<A HREF=http://irc.2ch.net/ TARGET=_blank>２ｃｈ＠ＩＲＣ</A><BR>
<BR><B>運営案内</B><BR>
<A HREF=http://info.2ch.net/guide/adv.html>ガイドライン</A><br>
<!--
<A HREF=http://members.tripod.co.jp/Backy/del_2ch/>削除屋ＭＬ</A><br>
-->
<A HREF=http://info.2ch.net/mag.html>2chメルマガ</A><BR>
<A HREF=http://www.yakin.cc/>夜勤の巣</A><BR>
<A HREF=http://2ch.tora3.net/>●売り場</A>
<BR>◆削除要請は<BR><A HREF=http://qb5.2ch.net/saku/>削除依頼</A>へ
<BR>◆苦情は<BR><A HREF=http://engawa.2ch.net/accuse/>批判要望</A>へ
<BR>おいらの<A HREF=mailto:2ch@2ch.net>メール</A><BR>いたづらはいやづら

<BR><BR><B>ツール類</B><BR>
<A HREF=http://www.monazilla.org/ TARGET=_blank>2chツール</A><br>
<A HREF=http://www.domo2.net/ TARGET=_blank>domo2</A><br>
<A HREF=http://tatsu01.sakura.ne.jp/ TARGET=_blank>DAT2HTML</A><br>
<A HREF=http://monahokan.web.fc2.com/AAE/ TARGET=_blank>AAエディタ</A><br>
<!--
<A HREF=http://dolneco.at.infoseek.co.jp/OFF-LAW/MeChGen.html TARGET=_blank>めすじぇね</A><br>
<A HREF=http://www.amezoscape.to/ TARGET=_blank>大先生の検索</A><br>
-->
<A HREF=http://2ken.net/ TARGET=_blank>2ch検索</A><br>
<A HREF=http://2chs.net/i/2chs.cgi TARGET=_blank>スレッド検索</A>
<!--<A HREF=http://xagebsse.hypermart.net/ TARGET=_blank>発言統計</A><br>
<BR><BR>-->

<BR><BR><B>BBSPINK</B><BR>18歳以上！<BR>子供はだめ！<BR>
<A HREF=http://www.bbspink.com/>TOPページ</A><br>
<A HREF=http://headline.bbspink.com/bbypink/>PINKheadline</A><br>
<A HREF=http://pele.bbspink.com/hnews/>ピンクニュース</A><br>

<BR><BR><B>まちＢＢＳ</B><BR>
<A HREF=http://www.machi.to/ TARGET=_blank>TOPページ</A><br>
<A HREF=http://www.machi.to/tawara/ TARGET=_blank>会議室</A><br>
<A HREF=http://hokkaido.machi.to/hokkaidou/ TARGET=_blank>北海道</A><br>

<BR><BR><B>他のサイト</B><BR>
<A HREF=http://www.megabbs.com/ TARGET=_blank>megabbs</A><br>
<A HREF=http://www.milkcafe.net/ TARGET=_blank>MILKCAFE</A><br>
<A HREF=http://svnews.jp/ TARGET=_blank>レンサバ比較</A><br>
<A HREF=http://ma-na.biz/ TARGET=_blank>ペンフロ</A><br>

<br>更新日13/10/22
</font>
<A href="http://count.2ch.net/?bbsmenu"><IMG 
src="http://count.2ch.net/ct.php/bbsmenu/" 
border=0></A>
</BODY></HTML>
  """
  return

