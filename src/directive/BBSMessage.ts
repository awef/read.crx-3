///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

angular
  .module("BBSMessage", [])
    .directive("bbsmessage", function ($compile) {
      return {
        link: function (scope, element, attrs) {
          scope.$watch("threadEntry.text", function () {
            var html = scope.threadEntry.text;

            // タグ除去（br/hr/bは残す）
            html = html.replace(/<(?!(?:[bh]r(?: \/)?|\/?b)>).*?(?:>|$)/ig, "");

            // URLリンク
            html = html.replace(
              /(h)?(ttps?:\/\/(?:[a-hj-zA-HJ-Z\d_\-.!~*'();\/?:@=+$,%#]|\&(?!gt;)|[iI](?![dD]:)+)+)/g,
              '<a href="h$2" target="_blank">$1$2</a>'
            );

            element.html(html);
          });
        }
      };
    });

