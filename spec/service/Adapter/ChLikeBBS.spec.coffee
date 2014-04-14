describe "adapter/chLikeBBS", ->
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
  return
