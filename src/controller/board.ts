///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="../service/Adapter/AdapterAgent.ts" />
///<reference path="../Util.ts" />

interface BoardCtrlScope extends ng.IScope {
  url: string;
  message: string;
  boardEntries: App.Board;
  move: Function;
  dateToString: Function;
}

class BoardCtrl {
  constructor ($scope: BoardCtrlScope, adapterAgent: App.AdapterService) {
    $scope.message = "取得中"
    $scope.dateToString = function (date: number) {
      return App.Util.dateToString(new Date(date));
    };

    adapterAgent.get($scope.url).then(
      (res) => {
        $scope.message = "取得成功"
        $scope.boardEntries = <App.Board>res;
        $scope.move = (url: string) => {
          (<any>$scope.$parent.$parent).url = url;
        };
      },
      () => {
        $scope.message = "取得失敗";
      }
    );
  }
}

angular
  .module("controller/board", ["AdapterAgent"])
    .controller("BoardCtrl", function ($scope: BoardCtrlScope, adapterAgent: App.AdapterService) {
      new BoardCtrl($scope, adapterAgent);
    });

