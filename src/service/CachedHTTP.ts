///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="Cache.ts" />
///<reference path="XHR.ts" />

module App.CachedHTTP {
  export class CachedHTTP {
    $http: ng.IHttpService;
    $q: ng.IQService;
    cacheService: App.Cache.CacheService;
    xhrService: App.XHR.XHRService;

    constructor ($http, $q, cacheService, xhrService) {
      this.$http = $http;
      this.$q = $q;
      this.cacheService = cacheService;
      this.xhrService = xhrService;
    }

    get (url: string, expire: number = 0, charSet?: string): ng.IPromise<string> {
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
          var httpGetPromise;

          if (updateNeeded) {
            if (charSet) {
              this.xhrService.overrideMimeType("text/plain; charset=" + charSet, () => {
                httpGetPromise = this.$http({method: 'GET', url: url})
              });
            }
            else {
              httpGetPromise = this.$http({method: 'GET', url: url})
            }

            // 成功時、resolveしてキャッシュを保存
            httpGetPromise
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

  angular.module("CachedHTTP", ["Cache", "XHR"])
    .factory("cachedHTTP", function ($http, $q, cacheService, xhrService) {
      return new CachedHTTP($http, $q, cacheService, xhrService);
    });
}

