///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="../../lib/DefinitelyTyped/jquery/jquery.d.ts" />

interface DevCtrlScope {
  message: string;
}

class DevCtrl {
  constructor ($scope: DevCtrlScope) {
    $scope.message = "Hello World";
  }
}

angular
  .module("controller/dev", [])
    .controller("DevCtrl", function ($scope) {
      new DevCtrl(<DevCtrlScope>$scope);
    });

