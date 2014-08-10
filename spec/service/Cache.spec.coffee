describe "App.CacheService", ->
  "use strict"

  unless 'indexedDB' in window
    console.log 'Skipped IndexedDB Test.'
    return

  generateDummyCache = do ->
    testId = Date.now()
    seed = 0

    (date = Date.now()) ->
      seed++

      key: "generated_for_test_uid#{testId}:#{seed}"
      text: "text #{testId}:#{seed}"
      lastModified: date
      lastUpdated: date
      lastUsed: date

  beforeEach ->
    module "Cache"

    inject ($rootScope, $q) =>
      @$q = $q
      @cacheService = new App.Cache.CacheService($rootScope, $q)
      return

    @dummyCache =
      key: "http://menu.2ch.net/bbsmenu.html"
      text: @dummyData.bbsMenuHtml
      lastModified: 0
      lastUpdated: 0
      lastUsed: 0
    return

  describe ".prototype.openDB", ->
    it "DBを開く処理のpromiseをgetDBに格納する", (done) ->
      getDBCallback = jasmine.createSpy("getDBCallback")

      @cacheService.openDB("testCacheDB").then =>
        setTimeout (->
          expect(getDBCallback).toHaveBeenCalled()
          done()
          return
        ), 0
        return

      @cacheService.getDB().then(getDBCallback)
      return
    return

  describe ".prototype.getDB", ->
    describe "openDBが実行されていない状態の場合", ->
      it "何もせずにrejectする", (done) ->
        @cacheService.getDB().then(null, done)
        return
      return

  describe ".prototype.set", ->
    describe "openDBが実行されていない状態で実行された場合", ->
      it "何もせずにrejectする", (done) ->
        @cacheService.set(@dummyCache).then(null, done)
        return
      return

    describe "openDBが実行されている場合", ->
      beforeEach ->
        @cacheService.openDB("testCacheDB")
        return

      it "与えられたキャッシュをDBに格納する", (done) ->
        @cacheService.set(@dummyCache).then(done)
        return
      return
    return

  describe ".prototype.get", ->
    describe "openDBが実行されていない状態で実行された場合", ->
      it "何もせずにrejectする", (done) ->
        @cacheService.get(@dummyCache.key).then(null, done)
        return
      return

    describe "openDBが実行されている場合", ->
      beforeEach (done) ->
        @cacheService.openDB("testCacheDB")
        @cacheService.set(@dummyCache).then(done)
        return

      describe "DBに格納されているキャッシュのキーを指定された場合", ->
        it "該当するキャッシュをコールバックに渡す", (done) ->
          @cacheService.get(@dummyCache.key).then (res) =>
            expect(res).toEqual(@dummyCache)
            done()
            return
          return
        return

      describe "DBに格納されていないキャッシュのキーを指定された場合", ->
        it "コールバックにnullを渡す", (done) ->
          @cacheService.get(@dummyCache.key + "_0").then (res) =>
            expect(res).toBeNull()
            done()
            return
          return
        return
      return
    return

  describe ".prototype.removeOlderThan", ->
    describe "openDBが実行されていない状態で実行された場合", ->
      it "何もしない", (done) ->
        @cacheService.removeOlderThan(Date.now()).then null, ->
          done()
          return
        return
      return

    describe "openDBが実行されている場合", ->
      beforeEach (done) ->
        @cacheService.openDB("testCacheDB").then ->
          done()
          return
        return

      it "指定された時刻よりもlastUsedが古いエントリを全て削除する", (done) ->
        cacheA = generateDummyCache()
        cacheB = generateDummyCache(Date.now() + 50)
        cacheC = generateDummyCache(Date.now() + 100)

        @$q
          .all([
            @cacheService.set(cacheA)
            @cacheService.set(cacheB)
            @cacheService.set(cacheC)
          ])
          .then () =>
            @cacheService.removeOlderThan(cacheB.lastUsed + 10)
          .then () =>
            @$q.all([
              @cacheService.get(cacheA.key)
              @cacheService.get(cacheB.key)
              @cacheService.get(cacheC.key)
            ])
          .then (res) ->
            expect(res).toEqual([null, null, cacheC])
            done()
            return
          return
        return
      return
    return
  return

