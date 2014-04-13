///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="../service/BBSIndex.ts" />

interface IndexCtrlScope {
  message: string;
  bbsIndex: App.BBSIndex.Index;
  getBBSMenu: Function;
}

class IndexCtrl {
  constructor ($scope: IndexCtrlScope, bbsIndexService: App.BBSIndex.BBSIndexService) {
    $scope.message = "bbsmenu取得中";

    $scope.bbsIndex = null;

    bbsIndexService.get().then(
      function (index) {
        $scope.message = "bbsmenu取得成功";
        $scope.bbsIndex = index;
      },
      function () {
        $scope.message = "bbsmenu取得失敗";
      }
    );
  }
}

angular
  .module("controller/index", ["BBSIndex"])
    .controller("IndexCtrl", function ($scope: IndexCtrlScope, bbsIndexService: App.BBSIndex.BBSIndexService) {
      new IndexCtrl($scope, bbsIndexService);
    });

