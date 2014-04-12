///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="Env.ts" />

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
    dbPromise: ng.IPromise<IDBDatabase>;

    constructor ($rootScope, $q) {
      this.$rootScope = $rootScope;
      this.$q = $q;
      this.db = null;
    }

    openDB (dbKey: string): ng.IPromise<{}> {
      var deferred: ng.IDeferred<IDBDatabase>, req: IDBOpenDBRequest;

      deferred = this.$q.defer();
      this.dbPromise = deferred.promise;

      req = indexedDB.open(dbKey, 1);

      req.onerror = () => {
        this.$rootScope.$apply(deferred.reject);
      };
      req.onupgradeneeded = () => {
        var db: IDBDatabase, objectStore: IDBObjectStore;

        db = req.result;
        objectStore = db.createObjectStore("cache", {keyPath: "key"});
        objectStore.createIndex("lastUsed", "lastUsed");
      };
      req.onsuccess = () => {
        this.$rootScope.$apply(() => {
          this.db = req.result;
          deferred.resolve(this.db)
        });
      };

      deferred.promise.finally(() => {
        this.dbPromise = null;
      });

      return deferred.promise;
    }

    getDB (): ng.IPromise<IDBDatabase> {
      var deferred: ng.IDeferred<IDBDatabase>;

      if (this.dbPromise) {
        return this.dbPromise;
      }
      else {
        deferred = this.$q.defer();

        setTimeout(() => {
          this.$rootScope.$apply(() => {
            if (this.db) {
              deferred.resolve(this.db);
            }
            else {
              deferred.reject();
            }
          });
        });

        return deferred.promise;
      }
    }

    set (entry: CacheEntry): ng.IPromise<{}> {
      var deferred: ng.IDeferred<{}>;

      deferred = this.$q.defer();

      return this.getDB().then(
        (db: IDBDatabase) => {
          var tra: IDBTransaction;

          tra = db.transaction("cache", "readwrite");
          tra.objectStore("cache").put(entry);
          tra.oncomplete = () => {
            this.$rootScope.$apply(deferred.resolve);
          };
          tra.onerror = () => {
            this.$rootScope.$apply(deferred.reject);
          };

          return deferred.promise;
        },
        () => {
          setTimeout(() => {
            this.$rootScope.$apply(deferred.reject);
          });

          return deferred.promise;
        }
      );
    }

    get (key: string): ng.IPromise<CacheEntry> {
      var deferred: ng.IDeferred<CacheEntry>;

      deferred = this.$q.defer();

      return this.getDB().then(
        (db: IDBDatabase) => {
          var req: IDBRequest;

          req = db.transaction("cache").objectStore("cache").get(key);
          req.onerror = () => {
            this.$rootScope.$apply(deferred.reject);
          };
          req.onsuccess = () => {
            this.$rootScope.$apply(() => {
              deferred.resolve(req.result || null);
            });
          };

          return deferred.promise;
        },
        () => {
          setTimeout(() => {
            this.$rootScope.$apply(deferred.reject);
          });

          return deferred.promise;
        }
      );
    }

    removeOlderThan(date: number): ng.IPromise<{}> {
      var deferred: ng.IDeferred<{}>;

      deferred = this.$q.defer();

      return this.getDB().then(
        (db: IDBDatabase) => {
          var tra: IDBTransaction, index: IDBIndex,
            cacheStore: IDBObjectStore;

          tra = db.transaction("cache", "readwrite");
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

          return deferred.promise;
        },
        () => {
          setTimeout(() => {
            this.$rootScope.$apply(deferred.reject);
          });

          return deferred.promise;
        }
      );
    }
  }

  angular.module("Cache", ["Env"])
    .factory("cacheService", function (env, $rootScope, $q) {
      var service: CacheService;

      service = new CacheService($rootScope, $q)

      if (!env.test) {
        service.openDB("cache");
      }

      return service;
    });
}

