///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="../service/BBSIndex.ts" />

interface DevCtrlScope {
  message: string;
  bbsIndex: App.BBSIndex.Index;
  getBBSMenu: Function;
}

class DevCtrl {
  constructor ($scope: DevCtrlScope, bbsIndexService: App.BBSIndex.BBSIndexService) {
    $scope.message = "Hello World";

    $scope.bbsIndex = null;

    $scope.getBBSMenu = function () {
      bbsIndexService.get().then(
        function (index) {
          console.log("getBBSMenu success", arguments);
          $scope.bbsIndex = index;
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

