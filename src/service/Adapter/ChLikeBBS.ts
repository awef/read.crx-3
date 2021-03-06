///<reference path="../../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../common.d.ts" />
///<reference path="../CachedHTTP.ts" />

module App.Adapter.ChLikeBBS {
  export interface URLInfo {
    dataUrl: string;
    type: string; // "board" or "thread"
  }

  export class AdapterService implements App.AdapterService {
    $rootScope: ng.IScope;
    $q: ng.IQService;
    cachedHTTP: App.CachedHTTP.CachedHTTP;
    bbsMenuAdapter: App.AdapterService;

    constructor ($rootScope, $q, cachedHTTP, bbsMenuAdapter) {
      this.$rootScope = $rootScope;
      this.$q = $q;
      this.cachedHTTP = cachedHTTP;
      this.bbsMenuAdapter = bbsMenuAdapter;
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

    parseSubjectTxt(url: string, txt: string): App.Board {
      var entries: App.Board, entry: App.BoardEntry, reg: RegExp,
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

    parseDat(url: string, txt: string): App.Thread {
      var thread: App.Thread, entry: App.ThreadEntry, reg: RegExp,
        regRes: RegExpExecArray, numberOfBroken: number;

      thread = {
        url: url,
        title: url,
        date: +/\/(\d+)\/$/.exec(url)[1] * 1000,
        data: []
      };
      reg = /^(.*?)<>(.*?)<>(.*?)<>(.*?)<>(.*?)(?:<>)?$/;
      numberOfBroken = 0;

      txt.split("\n").forEach(function (line, key) {
        regRes = reg.exec(line);

        if (regRes) {
          if (key === 0) {
            thread.title = regRes[5]; // TODO 実体参照デコード
          }

          thread.data.push({
            url: url + (key + 1),
            title: regRes[1] + " [" + regRes[2] + "]" + (regRes[3] ? " " : "") + regRes[3],
            text: regRes[4]
            // TODO date
          });
        }
        else {
          if (line !== "") {
            numberOfBroken++;
            thread.data.push({
              url: url + (key + 1),
              title: "</b>データ破損<b>",
              text: "データが破損しています"
            });
          }
        }
      });

      return thread.data.length === numberOfBroken ? null : thread;
    }

    parse (url: string, txt: string): App.Entries {
      if (url.indexOf("read.cgi") === -1) {
        return this.parseSubjectTxt(url, txt);
      }
      else {
        return this.parseDat(url, txt);
      }
    }

    static getDataUrl (url: string): ChLikeBBS.URLInfo {
      var tmp;

      if (tmp = /^http:\/\/(\w+\.(\w+\.\w+))\/(\w+)\/(?:(\d+)\/)?$/.exec(url)) {
        return {
          dataUrl: "http://" + tmp[1] + "/" + tmp[3] + "/subject.txt",
          type: "board"
        };
      }
      else {
        tmp = /^http:\/\/(\w+\.(\w+\.\w+))\/(?:test|bbs)\/read\.cgi\/(\w+)\/(\d+)\/(?:(\d+)\/)?$/.exec(url);
        return {
          dataUrl: "http://" + tmp[1] + "/" + tmp[3] + "/dat/" + tmp[4] + ".dat",
          type: "thread"
        };
      }
    }

    get(url: string): ng.IPromise<App.Entries> {
      var urlInfo: ChLikeBBS.URLInfo,
        remainJob: number,
        deferred: ng.IDeferred<App.Entries>,
        boardTitle: string,
        entries: App.Entries,
        hoge;

      remainJob = 1;
      urlInfo = AdapterService.getDataUrl(url);

      deferred = this.$q.defer();

      hoge = () => {
        remainJob--;

        if (remainJob === 0) {
          if (entries) {
            if (boardTitle) {
              entries.title = boardTitle;
            }
            deferred.resolve(entries);
          }
          else {
            deferred.reject();
          }
        }
      };

      if (urlInfo.type === "board") {
        remainJob++;
        (<any>this.bbsMenuAdapter).getTitle(url)
          .then((title) => {
            boardTitle = title;
          })
          .finally(hoge);
      }

      this.cachedHTTP
        .get(urlInfo.dataUrl, 1000 * 60 * 60, "Shift_JIS")
        .then(
          (response) => {
            entries = this.parse(url, response);
          }
        )
        .finally(hoge);

      return deferred.promise;
    }
  }

  angular.module("ChLikeBBS", ["BBSMenuAdapter", "CachedHTTP"])
    .factory("chLikeBBSAdapter", function ($rootScope, $q, cachedHTTP, bbsMenuAdapter) {
      return new AdapterService($rootScope, $q, cachedHTTP, bbsMenuAdapter);
    });
}

