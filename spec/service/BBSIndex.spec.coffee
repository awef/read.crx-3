describe "App.BBSIndex", ->
  "use strict"

  describe ".parse", ->
    it "与えられたHTML文字列をパースし、BBS一覧のデータを返す", ->
      result = App.BBSIndex.BBSIndexService.parse(@dummyData.bbsMenuHtml)

      expect(result.categories.length).toBe(5)

      expect(result.categories[0].name).toBe("地震")
      expect(result.categories[0].boards.length).toBe(5)
      expect(result.categories[0].boards[0].name)
        .toBe("地震headline")
      expect(result.categories[0].boards[0].url)
        .toBe("http://headline.2ch.net/bbynamazu/")
      expect(result.categories[0].boards[4].name)
        .toBe("緊急自然災害")
      expect(result.categories[0].boards[4].url)
        .toBe("http://uni.2ch.net/lifeline/")

      expect(result.categories[4].name).toBe("まちＢＢＳ")
      expect(result.categories[4].boards.length).toBe(2)
      expect(result.categories[4].boards[0].name)
        .toBe("会議室")
      expect(result.categories[4].boards[0].url)
        .toBe("http://www.machi.to/tawara/")
      return

    it "掲示板ではない項目は無視する", ->
      result = App.BBSIndex.BBSIndexService.parse(@dummyData.bbsMenuHtml)

      expect(result.categories[2].name).toBe("特別企画")
      expect(result.categories[2].boards.length).toBe(1)
      expect(result.categories[2].boards[0].name)
        .toBe("テレビ番組欄")
      expect(result.categories[2].boards[0].url)
        .toBe("http://epg.2ch.net/tv2chwiki/")
      return

    it "カテゴリ/板が一件も見つからなかった場合、nullを返す", ->
      result = App.BBSIndex.BBSIndexService.parse("")

      expect(result).toBeNull()
      return
    return
  return

