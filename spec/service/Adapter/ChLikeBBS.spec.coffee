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
  return
