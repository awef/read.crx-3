describe "App.Adapter.BBSMenu", ->
  "use strict"

  beforeEach () ->
    module "BBSMenuAdapter"

    inject (bbsMenuAdapter) =>
      @bbsMenuAdapter = bbsMenuAdapter
      return
    return

  describe ".parse", ->
    it "与えられたHTML文字列をパースし、BBS一覧のデータを返す", ->
      result = App.Adapter.BBSMenu.BBSMenuAdapter.parse(@dummyData.bbsMenuHtml)

      expect(result.data.length).toBe(5)

      expect(result.data[0].title).toBe("地震")
      expect(result.data[0].data.length).toBe(5)
      expect(result.data[0].data[0].title)
        .toBe("地震headline")
      expect(result.data[0].data[0].url)
        .toBe("http://headline.2ch.net/bbynamazu/")
      expect(result.data[0].data[4].title)
        .toBe("緊急自然災害")
      expect(result.data[0].data[4].url)
        .toBe("http://uni.2ch.net/lifeline/")

      expect(result.data[4].title).toBe("まちＢＢＳ")
      expect(result.data[4].data.length).toBe(2)
      expect(result.data[4].data[0].title)
        .toBe("会議室")
      expect(result.data[4].data[0].url)
        .toBe("http://www.machi.to/tawara/")
      return

    it "掲示板ではない項目は無視する", ->
      result = App.Adapter.BBSMenu.BBSMenuAdapter.parse(@dummyData.bbsMenuHtml)

      expect(result.data[2].title).toBe("特別企画")
      expect(result.data[2].data.length).toBe(1)
      expect(result.data[2].data[0].title)
        .toBe("テレビ番組欄")
      expect(result.data[2].data[0].url)
        .toBe("http://epg.2ch.net/tv2chwiki/")
      return

    it "カテゴリ/板が一件も見つからなかった場合、nullを返す", ->
      result = App.Adapter.BBSMenu.BBSMenuAdapter.parse("")

      expect(result).toBeNull()
      return
    return

  describe ".getTitle", ->
    beforeEach ->
      inject ($rootScope, $q, cachedHTTP) =>
        spyOn(cachedHTTP, "get").and.callFake =>
          setTimeout => $rootScope.$apply(); return
          $q.when @dummyData.bbsMenuHtml
        return
      return

    it "BBSMenuから板名を取得する", (done) ->
      @bbsMenuAdapter.getTitle("http://epg.2ch.net/tv2chwiki/").then (res) ->
        expect(res).toBe("テレビ番組欄")
        done()
        return
      return

    it "BBSMenuからの板名取得に失敗した場合はrejectする", (done) ->
      @bbsMenuAdapter.getTitle("http://epg.2ch.net/dummy/").then(
        (->),
        ->
          done()
          return
      )
      return
    return
  return

