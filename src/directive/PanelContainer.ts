///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

angular
  .module("PanelContainer", [])
    .directive("panelcontainer", function ($http, $compile) {
      return {
        link: function (scope, element, attrs) {
          scope.changeUrl(attrs.url);

          scope.$watch("url", function (url) {
            var templateUrl: string;

            element.attr("data-url", url);

            switch (url) {
              case "view:index":
                templateUrl = "/view/index.html";
                break;
              case "view:testA":
                templateUrl = "/view/testA.html";
                break;
              case "view:testB":
                templateUrl = "/view/testB.html";
                break;
              case "view:testC":
                templateUrl = "/view/testC.html";
                break;
            }

            $http.get(templateUrl).then(function (res) {
              element
                .find(".content")
                  .empty()
                  .append($compile(res.data)(scope.$new()));
            });
          });
        },
        controller: function ($scope) {
          $scope.prev = function () {
            console.log("prev");
          };

          $scope.next = function () {
            console.log("next");
          };

          $scope.changeUrl = function (url: string) {
            $scope.url = url
          };
        }
      };
    });

