describe "App.CacheService", ->
  "use strict"

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
  return

