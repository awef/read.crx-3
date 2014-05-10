///<reference path="../../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../common.d.ts" />
///<reference path="../CachedHTTP.ts" />

module App.Adapter.BBSMenu {
  export class BBSMenuAdapter implements App.AdapterService {
    cachedHTTP: App.CachedHTTP.CachedHTTP;
    $q: ng.IQService;

    constructor (cachedHTTP, $q) {
      this.cachedHTTP = cachedHTTP;
      this.$q = $q;
    }

    get (url: string): ng.IPromise<App.BBSMenu> {
      var deferred: ng.IDeferred<App.BBSMenu>;

      deferred = this.$q.defer();

      this.cachedHTTP.get(url, 1000 * 60 * 60)
        .then(
          function (response) {
            var parseResult: App.BBSMenu;

            parseResult = BBSMenuAdapter.parse(response);
            deferred[parseResult ? "resolve" : "reject"](parseResult);
          },
          function () {
            deferred.reject(null);
          }
        );

      return deferred.promise;
    }

    isSupported(url: string): string {
      if (url === "http://menu.2ch.net/bbsmenu.html") {
        return "yes";
      }
      else {
        return "no";
      }
    }

    static parse (html: string): App.BBSMenu {
      var menu: App.BBSMenu,
        regCategory: RegExp,
        regCategoryExecResult: RegExpExecArray,
        regBoard: RegExp,
        regBoardExecResult: RegExpExecArray,
        category: App.BBSCategory;

      menu = {
        url: "http://menu.2ch.net/bbsmenu.html",
        title: "bbsmenu",
        data: []
      };

      regCategory = /<b>(.+?)<\/b>(?:.*[\r\n]+<a .*?>.+?<\/a>)+/gi
      regBoard = /<a href=(http:\/\/(?!info\.2ch\.net\/)\w+\.(?:2ch\.net|machi\.to)\/\w+\/)(?:\s.*?)?>(.+?)<\/a>/gi;

      while (regCategoryExecResult = regCategory.exec(html)) {
        category = {
          url: null,
          title: regCategoryExecResult[1],
          data: []
        };

        while (regBoardExecResult = regBoard.exec(regCategoryExecResult[0])) {
          category.data.push({
            title: regBoardExecResult[2],
            url: regBoardExecResult[1],
            data: null
          });
        }

        if (category.data.length > 0) {
          menu.data.push(category);
        }
      }

      return menu.data.length > 0 ? menu : null;
    }
  }

  angular
    .module("BBSMenuAdapter", ['CachedHTTP'])
      .factory("bbsMenuAdapter", function (cachedHTTP, $q) {
        return new BBSMenuAdapter(cachedHTTP, $q);
      });
}

