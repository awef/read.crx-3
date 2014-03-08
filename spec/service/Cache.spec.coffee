describe "App.CacheService", ->
  "use strict"

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
    it "DBを.dbに代入し、promiseをresolveする", ->
      callback = jasmine.createSpy()

      @cacheService.openDB("testCacheDB").then(callback)

      waitsFor -> callback.wasCalled

      runs ->
        expect(callback.callCount).toBe(1)
        expect(@cacheService.db instanceof IDBDatabase).toBeTruthy()
        return
      return
    return

  describe ".prototype.set", ->
    describe ".dbがnullの状態で実行された場合", ->
      it "何もしない", ->
        callback = jasmine.createSpy()

        @cacheService.set(@dummyCache).then(null, callback)

        waitsFor -> callback.wasCalled
        return
      return

    describe ".dbにIDBDatabaseが代入されている場合", ->
      beforeEach ->
        callback = jasmine.createSpy()

        @cacheService.openDB("testCacheDB").then(callback)

        waitsFor -> callback.wasCalled
        return

      it "与えられたキャッシュをDBに格納する", ->
        callback = jasmine.createSpy()

        @cacheService.set(@dummyCache).then(callback)

        waitsFor -> callback.wasCalled
        return
      return
    return

  describe ".prototype.get", ->
    describe ".dbがnullの状態で実行された場合", ->
      it "何もしない", ->
        callback = jasmine.createSpy()

        @cacheService.get(@dummyCache.key).then(null, callback)

        waitsFor -> callback.wasCalled
        return
      return

    describe ".dbにIDBDatabaseが代入されている場合", ->
      beforeEach ->
        openCallback = jasmine.createSpy()
        setCallback = jasmine.createSpy()

        @cacheService.openDB("testCacheDB").then(openCallback)

        waitsFor -> openCallback.wasCalled

        runs =>
          setCallback = jasmine.createSpy()

          @cacheService.set(@dummyCache).then(setCallback)
          return

        waitsFor -> setCallback.wasCalled
        return

      describe "DBに格納されているキャッシュのキーを指定された場合", ->
        it "該当するキャッシュをコールバックに渡す", ->
          callback = jasmine.createSpy()

          @cacheService.get(@dummyCache.key).then(callback)

          waitsFor -> callback.wasCalled

          runs ->
            expect(callback).toHaveBeenCalledWith(@dummyCache)
            return
          return
        return

      describe "DBに格納されていないキャッシュのキーを指定された場合", ->
        it "コールバックにnullを渡す", ->
          callback = jasmine.createSpy()

          @cacheService.get(@dummyCache.key + "_0").then(callback)

          waitsFor -> callback.wasCalled

          runs ->
            expect(callback).toHaveBeenCalledWith(null)
            return
          return
        return
      return
    return

  describe ".prototype.removeOlderThan", ->
    describe ".dbがnullの状態で実行された場合", ->
      it "何もしない", ->
        callback = jasmine.createSpy()

        @cacheService.removeOlderThan(Date.now()).then(null, callback)

        waitsFor -> callback.wasCalled
        return
      return

    describe ".dbにIDBDatabaseが代入されている場合", ->
      beforeEach ->
        callback = jasmine.createSpy()

        @cacheService.openDB("testCacheDB").then(callback)

        waitsFor -> callback.wasCalled
        return

      it "指定された時刻よりもlastUsedが古いエントリを全て削除する", ->
        cacheA = generateDummyCache()
        cacheB = generateDummyCache(Date.now() + 50)
        cacheC = generateDummyCache(Date.now() + 100)

        getCallback = jasmine.createSpy("getCallback")

        runs =>
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
            .then(getCallback)
          return

        waitsFor ->
          getCallback.wasCalled

        runs ->
          expect(getCallback).toHaveBeenCalledWith([null, null, cacheC])
          return
        return
      return
    return
  return

