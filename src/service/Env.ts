///<reference path="../../lib/DefinitelyTyped/angularjs/angular.d.ts" />

module App.Env {
  export interface Env {
    production: boolean;
    development: boolean;
    test: boolean;
  }
}

angular.module("Env", []).factory("env", function () {
  var env: App.Env.Env = {
    production: null,
    development: null,
    test: null
  };

  env.test = "jasmine" in window;
  env.development = !env.test && /^chrome\-extension:/.test(location.href);
  env.production = !env.test && !env.development;

  console.log(env);

  return env;
});

