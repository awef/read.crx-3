///<reference path="../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="service/BBSIndex.ts" />
///<reference path="service/Cache.ts" />
///<reference path="controller/dev.ts" />

angular
  .module("app", ["ngRoute", "BBSIndex"])
    .config([
      "$routeProvider",
      function ($routeProvider) {
        $routeProvider
          .when("/dev", {
            templateUrl: "view/dev.html"
          });
      }
    ]);

