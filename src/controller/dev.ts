///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="../service/BBSIndex.ts" />

interface DevCtrlScope {
  message: string;
  getBBSMenu: Function;
}

class DevCtrl {
  constructor ($scope: DevCtrlScope, bbsIndexService: App.BBSIndex.BBSIndexService) {
    $scope.message = "Hello World";

    $scope.getBBSMenu = function () {
      bbsIndexService.get().then(
        function () {
          console.log("getBBSMenu success", arguments);
        },
        function () {
          console.log("getBBSMenu error", arguments);
        }
      );
    };
  }
}

angular
  .module("controller/dev", ["BBSIndex"])
    .controller("DevCtrl", function ($scope: DevCtrlScope, bbsIndexService: App.BBSIndex.BBSIndexService) {
      new DevCtrl($scope, bbsIndexService);
    });

