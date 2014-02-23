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
    db: IDBDatabase;

    constructor () {
      this.db = null;
    }

    openDB (dbKey: string, callback: Function): void {
      var req: IDBOpenDBRequest;

      req = indexedDB.open(dbKey, 1);

      req.onerror = () => {
        this.db = null;
        callback();
      };
      req.onupgradeneeded = () => {
        var db: IDBDatabase, objectStore: IDBObjectStore;

        db = req.result;
        objectStore = db.createObjectStore("cache", {keyPath: "key"});
        objectStore.createIndex("lastUsed", "lastUsed");
        objectStore.transaction.oncomplete = () => {
          this.db = db;
          callback();
        };
      };
      req.onsuccess = () => {
        this.db = req.result;
        callback();
      };
    }

    set (entry: CacheEntry, callback?: Function): void {
      var tra: IDBTransaction;

      if (this.db instanceof IDBDatabase) {
        tra = this.db.transaction("cache", "readwrite");
        tra.objectStore("cache").put(entry);
        tra.oncomplete = () => { if (callback) { callback(true); } };
        tra.onerror = () => { if (callback) { callback(false); } };
      }
      else {
        if (callback) {
          callback(false);
        }
      }
    }

    get (key: string, callback: Function): void {
      var req: IDBRequest;

      if (this.db instanceof IDBDatabase) {
        req = this.db.transaction("cache").objectStore("cache").get(key);
        req.onerror = function () {
          callback(null);
        };
        req.onsuccess = function () {
          callback(req.result || null);
        };
      }
      else {
        callback(null);
      }
    }
  }
}

