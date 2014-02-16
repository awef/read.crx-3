///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

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
    $http: ng.IHttpService;
    $q: ng.IQService;

    constructor ($http, $q) {
      this.$http = $http;
      this.$q = $q;
    }

    get (): ng.IPromise<Index> {
      var deferred: ng.IDeferred<Index>;

      deferred = this.$q.defer();

      this.$http({method: "GET", url: "http://menu.2ch.net/bbsmenu.html"})
        .success(function (response) {
          var parseResult: Index;

          parseResult = BBSIndexService.parse(response);
          deferred[parseResult ? "resolve" : "reject"](parseResult);
        })
        .error(function () {
          deferred.reject(null);
        });

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
    .module("BBSIndex", [])
      .factory("bbsIndexService", function ($http, $q) {
        return new BBSIndexService($http, $q);
      });
}

