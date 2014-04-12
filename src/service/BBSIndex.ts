///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="CachedHTTP.ts" />

module App.BBSIndex {
  export interface Index {
    categories: Category[];
  }

  export interface Category {
    name: string;
    boards: Board[];
  }

  export interface Board {
    name: string;
    url: string;
  }

  export class BBSIndexService {
    cachedHTTP: App.CachedHTTP.CachedHTTP;
    $q: ng.IQService;

    constructor (cachedHTTP, $q) {
      this.cachedHTTP = cachedHTTP;
      this.$q = $q;
    }

    get (): ng.IPromise<Index> {
      var deferred: ng.IDeferred<Index>;

      deferred = this.$q.defer();

      this.cachedHTTP.get("http://menu.2ch.net/bbsmenu.html", 1000 * 60 * 60)
        .then(
          function (response) {
            var parseResult: Index;

            parseResult = BBSIndexService.parse(response);
            deferred[parseResult ? "resolve" : "reject"](parseResult);
          },
          function () {
            deferred.reject(null);
          }
        );

      return deferred.promise;
    }

    static parse (html: string): Index {
      var index: Index,
        regCategory: RegExp,
        regCategoryExecResult: RegExpExecArray,
        regBoard: RegExp,
        regBoardExecResult: RegExpExecArray,
        category: Category;

      index = {
        categories: []
      };

      regCategory = /<b>(.+?)<\/b>(?:.*[\r\n]+<a .*?>.+?<\/a>)+/gi
      regBoard = /<a href=(http:\/\/(?!info\.2ch\.net\/)\w+\.(?:2ch\.net|machi\.to)\/\w+\/)(?:\s.*?)?>(.+?)<\/a>/gi;

      while (regCategoryExecResult = regCategory.exec(html)) {
        category = {
          name: regCategoryExecResult[1],
          boards: []
        };

        while (regBoardExecResult = regBoard.exec(regCategoryExecResult[0])) {
          category.boards.push({
            name: regBoardExecResult[2],
            url: regBoardExecResult[1]
          });
        }

        if (category.boards.length > 0) {
          index.categories.push(category);
        }
      }

      return index.categories.length > 0 ? index : null;
    }
  }

  angular
    .module("BBSIndex", ['CachedHTTP'])
      .factory("bbsIndexService", function (cachedHTTP, $q) {
        return new BBSIndexService(cachedHTTP, $q);
      });
}

