///<reference path="../../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../common.d.ts"/>
///<reference path="BBSMenu.ts" />
///<reference path="ChLikeBBS.ts" />

module App.Adapter.AdapterAgent {
  export class AdapterService {
    rootScope: ng.IRootScopeService;
    q: ng.IQService;
    adapters: App.AdapterService[];

    constructor (rootScope, q) {
      this.rootScope = rootScope;
      this.q = q;
      this.adapters = [];
    }

    register (adapter: App.AdapterService): void {
      this.adapters.push(adapter);
    }

    private findService (url: string) {
      var hold: App.AdapterService, i: string, res: string;

      for (i in this.adapters) {
        res = this.adapters[i].isSupported(url)

        if (res === "yes") {
          return this.adapters[i];
        }
        else if(!hold && this.adapters[i] === "unclear") {
          hold = this.adapters[i];
        }
      }

      return hold || null;
    }

    get (url: string): ng.IPromise<App.Entries> {
      var service: App.AdapterService, deferred: ng.IDeferred<App.Entries>;

      service = this.findService(url);

      if (service) {
        return service.get(url);
      }
      else {
        deferred = this.q.defer();
        this.rootScope.$apply(() => {
          deferred.reject();
        });
        return deferred.promise;
      }
    }

    /*
    TODO
    isSupported (url: string): ng.IPromise {
    }
    */
  }

  angular.module("AdapterAgent", ["BBSMenuAdapter", "ChLikeBBS"])
    .factory("adapterAgent", function ($rootScope, $q, bbsMenuAdapter) {
      var service: AdapterService;

      service = new AdapterService($rootScope, $q);
      service.register(bbsMenuAdapter);

      return service;
    });
}
