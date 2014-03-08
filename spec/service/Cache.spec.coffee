describe "App.CacheService", ->
  "use strict"

  generateDummyCache = do ->
    testId = Date.now()
    seed = 0

    ->
      seed++

      key: "generated_for_test_uid#{testId}:#{seed}"
      text: "text #{testId}:#{seed}"
      lastModified: Date.now()
      lastUpdated: Date.now()
      lastUsed: Date.now()

  beforeEach ->
    module "Cache"

    inject ($rootScope, $q) =>
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
        cacheB = null
        cacheC = null

        setTimeout((-> cacheB = generateDummyCache()), 50)
        setTimeout((-> cacheC = generateDummyCache()), 100)

        waitsFor ->
          cacheC

        setCallbacks = []

        runs =>
          setCallbacks.push(setCallbackA = jasmine.createSpy("setCallbackA"))
          @cacheService.set(cacheA).then(setCallbackA)

          setCallbacks.push(setCallbackB = jasmine.createSpy("setCallbackB"))
          @cacheService.set(cacheB).then(setCallbackB)

          setCallbacks.push(setCallbackC = jasmine.createSpy("setCallbackC"))
          @cacheService.set(cacheC).then(setCallbackC)
          return

        waitsFor ->
          setCallbacks.every((callback) -> callback.wasCalled)

        rotCallback = jasmine.createSpy("rotCallback")

        runs ->
          @cacheService.removeOlderThan(cacheB.lastUsed + 10).then(rotCallback)
          return

        waitsFor ->
          rotCallback.wasCalled

        getCallbacks = []

        runs ->
          getCallbacks.push(getCallbackA = jasmine.createSpy("getCallbackA"))
          @cacheService.get(cacheA.key).then(getCallbackA)

          getCallbacks.push(getCallbackB = jasmine.createSpy("getCallbackB"))
          @cacheService.get(cacheB.key).then(getCallbackB)

          getCallbacks.push(getCallbackC = jasmine.createSpy("getCallbackC"))
          @cacheService.get(cacheC.key).then(getCallbackC)
          return

        waitsFor ->
          getCallbacks.every((callback) -> callback.wasCalled)

        runs ->
          expect(getCallbacks[0]).toHaveBeenCalledWith(null)
          expect(getCallbacks[1]).toHaveBeenCalledWith(null)
          expect(getCallbacks[2]).toHaveBeenCalledWith(cacheC)
          return
        return
      return
    return
  return

