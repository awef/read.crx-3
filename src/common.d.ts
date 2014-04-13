///<reference path="../lib/DefinitelyTyped/angularjs/angular.d.ts" />

declare module App {
  interface Entries {
    url: string;
    title: string;
    date?: number;
    entries: Entry[];
  }

  interface Entry {
    url: string;
    title: string;
    date?: number;
    text: string;
  }

  interface AdapterService {
    isSupported(url: string): string; // yes/no/unclear
    get(url: string): ng.IPromise<Entries>;
  }
}

