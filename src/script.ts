///<reference path="../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="controller/index.ts" />

angular
  .module("app", ["ngRoute", "BBSIndex"])
    .config([
      "$routeProvider",
      function ($routeProvider) {
        $routeProvider
          .when("/", {
            templateUrl: "view/index.html"
          });
      }
    ]);

