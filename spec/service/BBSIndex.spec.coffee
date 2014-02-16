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

describe "bbsIndexService", ->
  "use strict"

  beforeEach ->
    module "BBSIndex"

    inject ($httpBackend, bbsIndexService) =>
      @$httpBackend = $httpBackend
      @bbsIndexService = bbsIndexService
      return
    return

  afterEach ->
    @$httpBackend.verifyNoOutstandingExpectation()
    @$httpBackend.verifyNoOutstandingRequest()
    return

  describe ".get", ->
    describe "bbsmenu.htmlの取得に成功した場合", ->
      describe "取得した内容のパースに成功した場合", ->
        beforeEach ->
          @$httpBackend
            .when("GET", "http://menu.2ch.net/bbsmenu.html")
              .respond(200, @dummyData.bbsMenuHtml)
          return

        it "promiseにパース結果を渡してresolveする", ->
          successSpy = jasmine.createSpy("successSpy")

          @bbsIndexService.get().then(successSpy)

          expect(successSpy).not.toHaveBeenCalled()

          @$httpBackend.flush()

          waitsFor ->
            successSpy.wasCalled

          runs =>
            expect(successSpy).toHaveBeenCalledWith(@dummyData.bbsIndex)
            return
          return
        return

      describe "取得した内容のパースに失敗した場合", ->
        beforeEach ->
          @$httpBackend
            .when("GET", "http://menu.2ch.net/bbsmenu.html")
              .respond(200, "dummy")
          return

        it "nullを渡してrejectする", ->
          errorSpy = jasmine.createSpy("errorSpy")

          @bbsIndexService.get().then((->), errorSpy)

          expect(errorSpy).not.toHaveBeenCalled()

          @$httpBackend.flush()

          waitsFor ->
            errorSpy.wasCalled

          runs =>
            expect(errorSpy).toHaveBeenCalledWith(null)
            return
          return
        return

    describe "通信に失敗した場合", ->
      it "promiseにnullを渡してrejectする", ->
        @$httpBackend
          .when("GET", "http://menu.2ch.net/bbsmenu.html")
            .respond(503, "dummy")

        errorSpy = jasmine.createSpy("errorSpy")

        @bbsIndexService.get().then((->), errorSpy)

        expect(errorSpy).not.toHaveBeenCalled()

        @$httpBackend.flush()

        waitsFor ->
          errorSpy.wasCalled

        runs =>
          expect(errorSpy).toHaveBeenCalledWith(null)
          return
        return
      return
    return
  return

