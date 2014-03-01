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
    @cacheService = new App.Cache.CacheService()

    @dummyCache =
      key: "http://menu.2ch.net/bbsmenu.html"
      text: @dummyData.bbsMenuHtml
      lastModified: 0
      lastUpdated: 0
      lastUsed: 0

    return

  describe ".prototype.openDB", ->
    it "DBを.dbに代入し、コールバックを呼ぶ", ->
      callback = jasmine.createSpy()

      @cacheService.openDB("testCacheDB", callback)

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

        @cacheService.set(@dummyCache, callback)

        expect(callback).toHaveBeenCalledWith(false)
        return
      return

    describe ".dbにIDBDatabaseが代入されている場合", ->
      beforeEach ->
        callback = jasmine.createSpy()

        @cacheService.openDB("testCacheDB", callback)

        waitsFor -> callback.wasCalled
        return

      it "与えられたキャッシュをDBに格納する", ->
        callback = jasmine.createSpy()

        @cacheService.set(@dummyCache, callback)

        waitsFor -> callback.wasCalled

        runs ->
          expect(callback).toHaveBeenCalledWith(true)
          return
        return
      return
    return

  describe ".prototype.get", ->
    describe ".dbがnullの状態で実行された場合", ->
      it "何もしない", ->
        callback = jasmine.createSpy()

        @cacheService.get(@dummyCache.key, callback)

        expect(callback).toHaveBeenCalledWith(null)
        return
      return

    describe ".dbにIDBDatabaseが代入されている場合", ->
      beforeEach ->
        openCallback = jasmine.createSpy()
        setCallback = jasmine.createSpy()

        @cacheService.openDB("testCacheDB", openCallback)

        waitsFor -> openCallback.wasCalled

        runs =>
          setCallback = jasmine.createSpy()

          @cacheService.set(@dummyCache, setCallback)
          return

        waitsFor -> setCallback.wasCalled
        return

      describe "DBに格納されているキャッシュのキーを指定された場合", ->
        it "該当するキャッシュをコールバックに渡す", ->
          callback = jasmine.createSpy()

          @cacheService.get(@dummyCache.key, callback)

          waitsFor -> callback.wasCalled

          runs ->
            expect(callback).toHaveBeenCalledWith(@dummyCache)
            return
          return
        return

      describe "DBに格納されていないキャッシュのキーを指定された場合", ->
        it "コールバックにnullを渡す", ->
          callback = jasmine.createSpy()

          @cacheService.get(@dummyCache.key + "_0", callback)

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

        @cacheService.removeOlderThan(Date.now(), callback)

        expect(callback).toHaveBeenCalledWith(false)
        return
      return

    describe ".dbにIDBDatabaseが代入されている場合", ->
      beforeEach ->
        callback = jasmine.createSpy()

        @cacheService.openDB("testCacheDB", callback)

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
          @cacheService.set(cacheA, setCallbackA)

          setCallbacks.push(setCallbackB = jasmine.createSpy("setCallbackB"))
          @cacheService.set(cacheB, setCallbackB)

          setCallbacks.push(setCallbackC = jasmine.createSpy("setCallbackC"))
          @cacheService.set(cacheC, setCallbackC)
          return

        waitsFor ->
          setCallbacks.every((callback) -> callback.wasCalled)

        rotCallback = jasmine.createSpy("rotCallback")

        runs ->
          @cacheService.removeOlderThan(cacheB.lastUsed + 10, rotCallback)
          return

        waitsFor ->
          rotCallback.wasCalled

        runs ->
          expect(rotCallback).toHaveBeenCalledWith(true)

        getCallbacks = []

        runs ->
          getCallbacks.push(getCallbackA = jasmine.createSpy("getCallbackA"))
          @cacheService.get(cacheA.key, getCallbackA)

          getCallbacks.push(getCallbackB = jasmine.createSpy("getCallbackB"))
          @cacheService.get(cacheB.key, getCallbackB)

          getCallbacks.push(getCallbackC = jasmine.createSpy("getCallbackC"))
          @cacheService.get(cacheC.key, getCallbackC)
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

