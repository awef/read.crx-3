///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

angular
  .module("PanelContainer", [])
    .directive("panelcontainer", function ($http, $compile) {
      return {
        link: function (scope, element, attrs) {
          scope.url = attrs.url;

          scope.$watch("url", function () {
            var templateUrl: string;

            element.attr("data-url", scope.url);

            if (!scope._historyLock) {
              if (scope.history.stack.length - 1 !== scope.history.current) {
                scope.history.stack = scope.history.stack.slice(0, scope.history.current + 1);
              }
              scope.history.stack.push(scope.url);
              scope.history.current++;
            }
            else {
              scope._historyLock = false;
            }

            // TODO テンプレートの判定を専用のサービスに任せる
            switch (scope.url) {
              case "view:index":
                templateUrl = "view/index.html";
                break;
              case "view:testA":
                templateUrl = "view/testA.html";
                break;
              case "view:testB":
                templateUrl = "view/testB.html";
                break;
              case "view:testC":
                templateUrl = "view/testC.html";
                break;
            }

            if (!templateUrl) {
              if (/\/read\.cgi\//.test(scope.url)) {
                templateUrl = "view/thread.html";
              }
              else {
                templateUrl = "view/board.html";
              }
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
              $scope._historyLock = true;
              $scope.history.current--;
              $scope.url = $scope.history.stack[$scope.history.current];
              return true;
            }
            else {
              console.error("これ以上戻れません");
              return false;
            }
          };

          $scope.next = function () {
            if ($scope.history.current < $scope.history.stack.length - 1) {
              $scope._historyLock = true;
              $scope.history.current++;
              $scope.url = $scope.history.stack[$scope.history.current];
              return true;
            }
            else {
              console.error("これ以上進めません");
              return false;
            }
          };
        }
      };
    });

