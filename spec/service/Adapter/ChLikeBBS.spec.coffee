describe "chLikeBBSAdapter", ->
  "use strict"

  beforeEach ->
    module "ChLikeBBS"

    inject (chLikeBBSAdapter) =>
      @chLikeBBSAdapter = chLikeBBSAdapter
      return
    return

  describe ".isSupported", ->
    it "与えられたURLから、対応状況を返す", ->
      expect(@chLikeBBSAdapter.isSupported("http://anago.2ch.net/")).toBe("no")

      # 掲示板以外のURL
      expect(@chLikeBBSAdapter.isSupported("http://find.2ch.net/dummy/")).toBe("no")
      expect(@chLikeBBSAdapter.isSupported("http://p2.2ch.net/dummy/")).toBe("no")
      expect(@chLikeBBSAdapter.isSupported("http://info.2ch.net/dummy/")).toBe("no")
      expect(@chLikeBBSAdapter.isSupported("http://ninja.2ch.net/dummy/")).toBe("no")

      expect(@chLikeBBSAdapter.isSupported("http://anago.2ch.net/namazuplus/")).toBe("yes")
      expect(@chLikeBBSAdapter.isSupported("http://anago.2ch.net/namazuplus")).toBe("yes")
      expect(@chLikeBBSAdapter.isSupported("http://anago.2ch.net/namazuplus/#1")).toBe("yes")

      expect(@chLikeBBSAdapter.isSupported("http://www.example.com/test/")).toBe("unclear")

      expect(@chLikeBBSAdapter.isSupported("http://anago.2ch.net/test/read.cgi/namazuplus/1234567890/")).toBe("yes")
      expect(@chLikeBBSAdapter.isSupported("http://anago.2ch.net/test/read.cgi/namazuplus/1234567890")).toBe("yes")
      expect(@chLikeBBSAdapter.isSupported("http://anago.2ch.net/test/read.cgi/namazuplus/1234567890/-100")).toBe("yes")

      # ドメインの形式が異なる
      expect(@chLikeBBSAdapter.isSupported("http://2ch.net/test/read.cgi/namazuplus/1234567890/-100")).toBe("no")

      # このモジュールでは担当しない範囲
      expect(@chLikeBBSAdapter.isSupported("http://jbbs.shitaraba.net/computer/42710/")).toBe("no")
      expect(@chLikeBBSAdapter.isSupported("http://jbbs.shitaraba.net/bbs/read.cgi/computer/42710/1377173481/")).toBe("no")
      expect(@chLikeBBSAdapter.isSupported("http://www.machi.to/tawara/")).toBe("unclear")
      expect(@chLikeBBSAdapter.isSupported("http://www.machi.to/bbs/read.cgi/tawara/1234567890/")).toBe("no")
      return
    return

  describe ".parseSubjectTxt", ->
    it "subject.txtをパースする", ->
      url = "http://qb5.2ch.net/operate/"
      text = """
        1301664644.dat<>【粛々と】シークレット★忍法帖巻物 8【情報収集、集約スレ】 (174)
        1301751706.dat<>【news】ニュース速報運用情報759【ν】 (221)
        1301761019.dat<>[test] 書き込みテスト 専用スレッド 240 [ﾃｽﾄ] (401)
        1295975106.dat<>重い重い重い重い重い重い重い×70＠運用情報 (668)
        1294363063.dat<>【お止め組。】出動予定＆連絡 詰所◆13 (312)
      """
      expected = {
        url: "http://qb5.2ch.net/operate/"
        title: "http://qb5.2ch.net/operate/"
        data: [
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1301664644/"
            title: "【粛々と】シークレット★忍法帖巻物 8【情報収集、集約スレ】"
            resCount: 174
            date: 1301664644000
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1301751706/"
            title: "【news】ニュース速報運用情報759【ν】"
            resCount: 221
            date: 1301751706000
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1301761019/"
            title: "[test] 書き込みテスト 専用スレッド 240 [ﾃｽﾄ]"
            resCount: 401
            date: 1301761019000
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1295975106/"
            title: "重い重い重い重い重い重い重い×70＠運用情報"
            resCount: 668
            date: 1295975106000
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1294363063/"
            title: "【お止め組。】出動予定＆連絡 詰所◆13"
            resCount: 312,
            date: 1294363063000
          }
        ]
      }

      expect(@chLikeBBSAdapter.parseSubjectTxt(url, text)).toEqual(expected)
      return
    return

  describe ".parseDat", ->
    it "dat形式のテキストをパースする", ->
      url = "http://qb5.2ch.net/test/read.cgi/operate/1234567890/"
      dat = """
        ﾉtasukeruyo </b>忍法帖【Lv=10,xxxPT】<b> </b>◆0a./bc.def <b><><>2011/04/04(月) 10:19:46.92 ID:abcdEfGH0 BE:1234567890-2BP(1)<> テスト。 <br> http://qb5.2ch.net/test/read.cgi/operate/132452341234/1 <br> <hr><font color="blue">Monazilla/1.00 (V2C/2.5.1)</font> <>[test] テスト 123 [ﾃｽﾄ]
         </b>【東電 84.2 %】<b>  </b>◆0a./bc.def <b><>sage<>2011/04/04(月) 10:21:08.27 ID:abcdEfGH0<> てすとてすとテスト! <>
         </b>忍法帖【Lv=11,xxxPT】<b> <>sage<>2011/04/04(月) 10:24:46.33 ID:abc0DEFG1<> <a href="../test/read.cgi/operate/1234567890/1" target="_blank">&gt&gt1</a> <br> 乙 <br> てすとてすと試験てすと <>
        動け動けウゴウゴ２ちゃんねる<>sage<>2011/04/04(月) 10:25:17.27 ID:ABcdefgh0<> てすと、テスト <>
        動け動けウゴウゴ２ちゃんねる<><>2011/04/04(月) 10:25:51.88 ID:aBcdEfg+0<> てす <>

      """

      expect(@chLikeBBSAdapter.parseDat(url, dat)).toEqual
        url: url,
        date: 1234567890 * 1000
        title: "[test] テスト 123 [ﾃｽﾄ]"
        data: [
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1234567890/1"
            title: "ﾉtasukeruyo </b>忍法帖【Lv=10,xxxPT】<b> </b>◆0a./bc.def <b> [] 2011/04/04(月) 10:19:46.92 ID:abcdEfGH0 BE:1234567890-2BP(1)"
            text: ' テスト。 <br> http://qb5.2ch.net/test/read.cgi/operate/132452341234/1 <br> <hr><font color="blue">Monazilla/1.00 (V2C/2.5.1)</font> '
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1234567890/2"
            title: " </b>【東電 84.2 %】<b>  </b>◆0a./bc.def <b> [sage] 2011/04/04(月) 10:21:08.27 ID:abcdEfGH0"
            text: " てすとてすとテスト! "
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1234567890/3"
            title: " </b>忍法帖【Lv=11,xxxPT】<b>  [sage] 2011/04/04(月) 10:24:46.33 ID:abc0DEFG1"
            text: ' <a href="../test/read.cgi/operate/1234567890/1" target="_blank">&gt&gt1</a> <br> 乙 <br> てすとてすと試験てすと '
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1234567890/4"
            title: "動け動けウゴウゴ２ちゃんねる [sage] 2011/04/04(月) 10:25:17.27 ID:ABcdefgh0"
            text: " てすと、テスト "
          }
          {
            url: "http://qb5.2ch.net/test/read.cgi/operate/1234567890/5"
            title: "動け動けウゴウゴ２ちゃんねる [] 2011/04/04(月) 10:25:51.88 ID:aBcdEfg+0"
            text: " てす "
          }
        ]
      return

    it "一部が破損したdatも適切に扱える", ->
      url = "http://__dummy.2ch.net/test/read.cgi/dummy/1234567890/"
      dat = """
        偽*** ★<><>2011/10/21(金) 19:26:30.52 ID:???<> てすと　試験テスト <>***を追跡する #dummy
        </b> dummy <b><><>11/10/21(金) 20:49:40 ID:ehenfox<>62¥¥¥
        ぬふあ <br> <>twitter
        ***<><>2011/10/21(金) 20:50:00.66 ID:abcDeFgh<> よ <>
      """

      expect(@chLikeBBSAdapter.parseDat(url, dat)).toEqual
        url: url,
        date: 1234567890 * 1000
        title: "***を追跡する #dummy"
        data: [
          {
            url: "http://__dummy.2ch.net/test/read.cgi/dummy/1234567890/1"
            title: "偽*** ★ [] 2011/10/21(金) 19:26:30.52 ID:???"
            text: " てすと　試験テスト "
          }
          {
            url: "http://__dummy.2ch.net/test/read.cgi/dummy/1234567890/2"
            title: "</b>データ破損<b>"
            text: "データが破損しています"
          }
          {
            url: "http://__dummy.2ch.net/test/read.cgi/dummy/1234567890/3"
            title: "</b>データ破損<b>"
            text: "データが破損しています"
          }
          {
            url: "http://__dummy.2ch.net/test/read.cgi/dummy/1234567890/4"
            title: "*** [] 2011/10/21(金) 20:50:00.66 ID:abcDeFgh"
            text: " よ "
          }
        ]
      return

    it "1行もdatとして解釈できなかった場合、nullを返す", ->
      # 2chで一部のスレが302 -> 200で404.htmlが返される事が有る
      url = "http://hibari.2ch.net/test/read.cgi/pc/123/"
      dat = """
      <html>
        <head><title>test</title></head>
        <body>
          Error
        </body>
      </html>
      """

      expect(@chLikeBBSAdapter.parseDat(url, dat)).toBeNull()
      return
    return
  return
