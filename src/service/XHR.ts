///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

module App.XHR {
  export class XHRService {
    // TODO 誤爆が起きそうな気がするので対策を入れる
    overrideMimeType (mimeType: string, callback: Function) {
      var originalOpen;

      originalOpen = XMLHttpRequest.prototype.open;

      XMLHttpRequest.prototype.open = function () {
        originalOpen.apply(this, arguments);
        this.overrideMimeType(mimeType);

        XMLHttpRequest.prototype.open = originalOpen;
      };

      callback();
    }
  }

  angular
    .module("XHR", [])
      .factory("xhrService", function () {
        return new XHRService();
      });
}

