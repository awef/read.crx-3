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

    parseSubjectTxt(url: string, txt: string): App.Entries {
      var entries: App.Entries, entry: App.BoardEntry, reg: RegExp,
        regRes: RegExpExecArray, baseUrl: string;

      regRes = /^http:\/\/(\w+\.(\w+\.\w+))\/(\w+)\/(\w+)?/.exec(url);
      baseUrl = "http://" + regRes[1] + "/test/read.cgi/" + regRes[3] + "/";

      entries = {
        url: url,
        title: url,
        data: []
      };

      reg = /^(\d+)\.dat<>(.+) \((\d+)\)$/gm;

      while (regRes = reg.exec(txt)) {
        entry = {
          url: baseUrl + regRes[1] + "/",
          title: regRes[2], // TODO 実体参照デコード
          date: +regRes[1] * 1000,
          resCount: +regRes[3]
        };

        entries.data.push(entry);
      }

      return entries;
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

