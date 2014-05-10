///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

angular
  .module("PanelContainer", [])
    .directive("panelcontainer", function ($http, $compile) {
      return {
        link: function (scope, element, attrs) {
          scope.changeUrl(attrs.url);

          scope.$watch("history.current", function () {
            var url: string, templateUrl: string;

            url = scope.history.stack[scope.history.current];

            element.attr("data-url", url);

            // TODO テンプレートの判定を専用のサービスに任せる
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


            scope.templateUrl = templateUrl;
          });
        },
        controller: function ($scope) {
          $scope.history = {
            stack: [],
            current: -1
          };

          $scope.prev = function () {
            if ($scope.history.current > 0) {
              $scope.history.current--;
              return true;
            }
            else {
              console.error("これ以上戻れません");
              return false;
            }
          };

          $scope.next = function () {
            if ($scope.history.current < $scope.history.stack.length - 1) {
              $scope.history.current++;
              return true;
            }
            else {
              console.error("これ以上進めません");
              return false;
            }
          };

          $scope.changeUrl = function (url: string) {
            if ($scope.history.stack.length - 1 !== $scope.history.current) {
              $scope.history.stack = $scope.history.stack.slice(0, $scope.history.current + 1);
            }

            $scope.history.stack.push(url);
            $scope.history.current++;
          };
        }
      };
    });

