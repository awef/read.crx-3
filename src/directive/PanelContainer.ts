///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

angular
  .module("PanelContainer", [])
    .directive("panelcontainer", function ($http, $compile) {
      return {
        link: function (scope, element, attrs) {
          scope.changeUrl(attrs.url);

          scope.$watch("url", function (url) {
            element.attr("data-url", url);

            // TODO $scope.urlの値から適当なテンプレートを呼び出す

            $http.get("/view/index.html").then(function (res) {
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

