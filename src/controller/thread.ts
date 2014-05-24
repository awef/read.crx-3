///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../lib/DefinitelyTyped/jquery/jquery.d.ts" />
///<reference path="../service/Adapter/AdapterAgent.ts" />

interface ThreadCtrlScope extends ng.IScope {
  url: string;
  message: string;
  thread: App.Thread;
}

class ThreadCtrl {
  constructor ($scope: ThreadCtrlScope, adapterAgent: App.AdapterService) {
    $scope.message = "取得中"

    adapterAgent.get($scope.url).then(
      (res) => {
        $scope.message = "取得成功";
        $scope.thread = <App.Thread>res;
      },
      () => {
        $scope.message = "取得失敗";
      }
    );
  }
}

angular
  .module("controller/thread", ["AdapterAgent"])
    .controller("ThreadCtrl", function ($scope, adapterAgent: App.AdapterService) {
      new ThreadCtrl($scope, adapterAgent);
    });

