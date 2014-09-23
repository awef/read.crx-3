///<reference path="../lib/DefinitelyTyped/angularjs/angular.d.ts" />
///<reference path="Util.ts" />
///<reference path="controller/index.ts" />
///<reference path="controller/board.ts" />
///<reference path="controller/thread.ts" />
///<reference path="directive/PanelContainer.ts" />
///<reference path="directive/BBSMessage.ts" />

angular.module("app", [
  "controller/index",
  "controller/board",
  "controller/thread",
  "PanelContainer",
  "BBSMessage"
]);

