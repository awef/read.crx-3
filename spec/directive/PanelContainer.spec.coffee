describe "[panelcontainer]", ->
  "use strict"

  beforeEach (done) ->
    module "PanelContainer"

    inject ($templateCache, $httpBackend, $compile, $rootScope) =>
      @$templateCache = $templateCache

      @$httpBackend = $httpBackend

      for key in ["A", "B", "C"]
        @$httpBackend
          .whenGET("/view/test#{key}.html")
          .respond(
            200,
            """
            <div class="test#{key}">
              <h1>view/test#{key}</h1>
            </div>
            """
          )

      html = """
      <div data-panelcontainer data-url="view:testA">
        <div class="content" data-ng-include="templateUrl"></div>
      </div>
      """

      $rootScope.$apply =>
        @scope = $rootScope.$new()
        @element = $compile(html)(@scope)
        return

      @$templateCache.removeAll()
      @$httpBackend.flush()

      done()
      return
    return

  afterEach ->
    @$httpBackend.verifyNoOutstandingExpectation()
    @$httpBackend.verifyNoOutstandingRequest()
    return

  describe "$scope.changeUrl", ->
    it  "指定されたURLに相当するテンプレートを読み込む", () ->
      @scope.changeUrl "view:testB"
      @$templateCache.removeAll()
      @$httpBackend.flush()

      expect(@scope.url).toBe("view:testB")
      expect(@element.find("h1").text()).toBe("view/testB")
      return

    describe "履歴の最先端以外の場所に居た場合", ->
      beforeEach ->
        @scope.changeUrl "view:testB"
        @$templateCache.removeAll()
        @$httpBackend.flush()

        @scope.changeUrl "view:testC"
        @$templateCache.removeAll()
        @$httpBackend.flush()

        @scope.prev()
        @$templateCache.removeAll()
        @$httpBackend.flush()
        return

      it "以降の履歴を捨てる", ->
        @scope.changeUrl "view:testA"
        @$templateCache.removeAll()
        @$httpBackend.flush()

        expect(@scope.url).toBe("view:testA")
        expect(@scope.history.stack[@scope.history.stack.length - 1])
          .toBe("view:testA")
        return
      return
    return

  describe "$scope.prev", ->
    describe "戻るべきURLが無い場合", ->
      it "何もしない", ->
        expect(@scope.url).toBe("view:testA")
        expect(@scope.prev()).toBeFalsy()
        return
      return

    describe "戻るべきURLが有る場合", ->
      beforeEach ->
        @scope.changeUrl "view:testB"
        @$templateCache.removeAll()
        @$httpBackend.flush()

        @scope.changeUrl "view:testC"
        @$templateCache.removeAll()
        @$httpBackend.flush()
        return

      it "戻る", ->
        @scope.prev()
        @$templateCache.removeAll()
        @$httpBackend.flush()

        expect(@scope.url).toBe("view:testB")
        expect(@element.find("h1").text()).toBe("view/testB")
        expect(@element.attr("data-url")).toBe("view:testB")
        return
      return
    return

  describe "$scope.next", ->
    describe "進むべきURLが無い場合", ->
      it "何もしない", ->
        expect(@scope.url).toBe("view:testA")
        expect(@scope.next()).toBeFalsy()
        return
      return

    describe "進むべきURLが有る場合", ->
      beforeEach ->
        @scope.changeUrl "view:testB"
        @$templateCache.removeAll()
        @$httpBackend.flush()

        @scope.changeUrl "view:testC"
        @$templateCache.removeAll()
        @$httpBackend.flush()

        @scope.prev()
        @$templateCache.removeAll()
        @$httpBackend.flush()
        return

      it "進む", ->
        @scope.next()
        @$templateCache.removeAll()
        @$httpBackend.flush()

        expect(@scope.url).toBe("view:testC")
        expect(@element.find("h1").text()).toBe("view/testC")
        expect(@element.attr("data-url")).toBe("view:testC")
        return
      return
    return
  return
