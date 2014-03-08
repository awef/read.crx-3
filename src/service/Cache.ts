///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

module App.Cache {
  export interface CacheEntry {
    key: string;
    text: string;
    lastModified: number;
    lastUpdated: number;
    lastUsed: number;
  }

  export interface CacheDBStatistics {
    numberOfEntries: number;
  }

  export class CacheService {
    $rootScope: ng.IScope;
    $q: ng.IQService;
    db: IDBDatabase;

    constructor ($rootScope, $q) {
      this.$rootScope = $rootScope;
      this.$q = $q;
      this.db = null;
    }

    openDB (dbKey: string): ng.IPromise<{}> {
      var deferred: ng.IDeferred<{}>, req: IDBOpenDBRequest;

      deferred = this.$q.defer();
      req = indexedDB.open(dbKey, 1);

      req.onerror = () => {
        this.db = null;
        this.$rootScope.$apply(deferred.reject);
      };
      req.onupgradeneeded = () => {
        var db: IDBDatabase, objectStore: IDBObjectStore;

        db = req.result;
        objectStore = db.createObjectStore("cache", {keyPath: "key"});
        objectStore.createIndex("lastUsed", "lastUsed");
      };
      req.onsuccess = () => {
        this.db = req.result;
        this.$rootScope.$apply(deferred.resolve);
      };

      return deferred.promise;
    }

    set (entry: CacheEntry): ng.IPromise<{}> {
      var deferred: ng.IDeferred<{}>, tra: IDBTransaction;

      deferred = this.$q.defer();

      if (this.db instanceof (<any>window).IDBDatabase) {
        tra = this.db.transaction("cache", "readwrite");
        tra.objectStore("cache").put(entry);
        tra.oncomplete = () => {
          this.$rootScope.$apply(deferred.resolve);
        };
        tra.onerror = () => {
          this.$rootScope.$apply(deferred.reject);
        };
      }
      else {
        setTimeout(() => {
          this.$rootScope.$apply(() => {
            deferred.reject();
          });
        });
      }

      return deferred.promise;
    }

    get (key: string): ng.IPromise<CacheEntry> {
      var deferred: ng.IDeferred<CacheEntry>, req: IDBRequest;

      deferred = this.$q.defer();

      if (this.db instanceof (<any>window).IDBDatabase) {
        req = this.db.transaction("cache").objectStore("cache").get(key);
        req.onerror = () => {
          this.$rootScope.$apply(deferred.reject);
        };
        req.onsuccess = () => {
          this.$rootScope.$apply(() => {
            deferred.resolve(req.result || null);
          });
        };
      }
      else {
        setTimeout(() => {
          this.$rootScope.$apply(() => {
            deferred.reject();
          });
        });
      }

      return deferred.promise;
    }

    removeOlderThan(date: number): ng.IPromise<{}> {
      var deferred: ng.IDeferred<{}>, tra: IDBTransaction, index: IDBIndex,
        cacheStore: IDBObjectStore;

      deferred = this.$q.defer();

      if (this.db instanceof (<any>window).IDBDatabase) {
        tra = this.db.transaction("cache", "readwrite");
        tra.onerror = () => {
          this.$rootScope.$apply(deferred.reject);
        };
        tra.oncomplete = () => {
          this.$rootScope.$apply(deferred.resolve);
        };

        cacheStore = tra.objectStore("cache")
        index = cacheStore.index("lastUsed");
        index.openKeyCursor((<any>window).IDBKeyRange.upperBound(date, true), "next").onsuccess = function () {
          var cursor: IDBCursor;

          if (cursor = this.result) {
            cacheStore.delete(cursor.primaryKey)
            cursor.continue();
          }
        };
      }
      else {
        setTimeout(() => {
          this.$rootScope.$apply(() => {
            deferred.reject();
          });
        });
      }

      return deferred.promise;
    }
  }

  angular.module("Cache", [])
    .factory("cacheService", function ($rootScope, $q) {
      return new CacheService($rootScope, $q);
    });
}

