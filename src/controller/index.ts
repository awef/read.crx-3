///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="../service/Adapter/AdapterAgent.ts" />

interface IndexCtrlScope extends ng.IScope {
  message: string;
  bbsMenu: App.BBSMenu;
  getBBSMenu: Function;
  move: Function;
}

class IndexCtrl {
  constructor ($scope: IndexCtrlScope, adapterAgent: App.AdapterService) {
    $scope.message = "bbsmenu取得中";

    $scope.bbsMenu = null;

    adapterAgent.get("http://menu.2ch.net/bbsmenu.html").then(
      function (bbsMenu: App.BBSMenu) {
        $scope.message = "bbsmenu取得成功";
        $scope.bbsMenu = bbsMenu;

        $scope.move = (url: string) => {
          (<any>$scope.$parent.$parent).url = url;
        };
      },
      function () {
        $scope.message = "bbsmenu取得失敗";
      }
    );
  }
}

angular
  .module("controller/index", ["AdapterAgent"])
    .controller("IndexCtrl", function ($scope: IndexCtrlScope, adapterAgent: App.AdapterService) {
      new IndexCtrl($scope, adapterAgent);
    });

