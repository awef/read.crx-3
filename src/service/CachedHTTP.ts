///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="Cache.ts" />

module App.CachedHTTP {
  export class CachedHTTP {
    $http: ng.IHttpService;
    $q: ng.IQService;
    cacheService: App.Cache.CacheService;

    constructor ($http, $q, cacheService) {
      this.$http = $http;
      this.$q = $q;
      this.cacheService = cacheService;
    }

    get (url: string, expire: number = 0): ng.IPromise<string> {
      var deferred: ng.IDeferred<string>, updateNeeded: boolean;

      deferred = this.$q.defer();

      updateNeeded = null;

      this.cacheService
        .get(url)
        .then(
          (result: App.Cache.CacheEntry) => {
            // キャッシュが有った場合
            if (result) {
              // 有効期限内だった場合、resolveでキャッシュを送出
              if (result.lastUpdated + expire > Date.now()) {
                deferred.resolve(result.text);
              }
              // 有効期限切れだった場合、notifyでキャッシュを送出
              else {
                updateNeeded = true;
                deferred.notify(result.text);
              }
            }
            else {
              updateNeeded = true;
              deferred.notify(null);
            }
          },
          () => {
            updateNeeded = true;
            deferred.notify(null);
          }
        )
        .finally(() => {
          if (updateNeeded) {
            // GET実行
            this.$http({method: 'GET', url: url})
              // 成功時、resolveしてキャッシュを保存
              .success((response, status, headers) => {
                var cache: App.Cache.CacheEntry, lastModified: number;

                try {
                  lastModified = Date.parse(headers("Last-Modified"));
                }
                catch (_) {
                  lastModified = 0;
                }

                cache = {
                  key: url,
                  text: response,
                  lastModified: lastModified,
                  lastUpdated: Date.now(),
                  lastUsed: Date.now()
                };

                this.cacheService.set(cache);

                deferred.resolve(response);
              })
              // 失敗時、rejectする
              .error(() => {
                deferred.reject(null);
              });
          }
        });

      return deferred.promise;
    }
  }

  angular.module("CachedHTTP", ["Cache"])
    .factory("cachedHTTP", function ($http, $q, cacheService) {
      return new CachedHTTP($http, $q, cacheService);
    });
}

