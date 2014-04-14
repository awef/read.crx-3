///<reference path="../../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../common.d.ts" />
///<reference path="../CachedHTTP.ts" />

module App.Adapter.ChLikeBBS {
  interface URLInfo {
    fixedURL: string;
    isThread: boolean;
    isBoard: boolean;
    boardURL?: string;
  }

  export class AdapterService implements App.AdapterService {
    $rootScope: ng.IScope;
    $q: ng.IQService;
    cachedHTTP: App.CachedHTTP.CachedHTTP;

    constructor ($rootScope, $q, cachedHTTP) {
      this.$rootScope = $rootScope;
      this.$q = $q;
      this.cachedHTTP = cachedHTTP;
    }

    isSupported(url: string): string {
      if (/^http:\/\/\w+\.\w+\.\w+\/test\/read\.cgi\/\w+\/\d+\/?/.test(url)) {
        return "yes";
      }
      if (/^http:\/\/(find|info|p2|ninja)\.2ch\.net\//.test(url)) {
        return "no";
      }
      else if (/^http:\/\/\w+\.2ch\.net\/\w+\/?(?:#.*)?$/.test(url)) {
        return "yes";
      }
      else if (/^http:\/\/\w+\.\w+\.\w+\/\w+\/?(?:#.*)?$/.test(url)) {
        return "unclear";
      }
      else {
        return "no";
      }
    }

    get(url: string): ng.IPromise<App.Entries> {
      return null;
    }
  }

  angular.module("ChLikeBBS", ["CachedHTTP"])
    .factory("chLikeBBSAdapter", function ($rootScope, $q, cachedHTTP) {
      return new AdapterService($rootScope, $q, cachedHTTP);
    });
}

