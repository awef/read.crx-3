///<reference path="../lib/DefinitelyTyped/angularjs/angular.d.ts" />

declare module App {
  interface Entries {
    url: string;
    title: string;
    data: Entry[];
  }

  interface Entry {
    url: string;
    title: string;
  }

  interface BBSMenu extends Entries {
    data: BBSCategory[];
  }

  interface BBSCategory extends Entry {
    data: Board[];
  }

  interface Board extends Entries {
    data: BoardEntry[];
  }

  interface BoardEntry extends Entry {
    date: number;
    resCount: number;
  }

  interface Thread extends Entries {
    data: ThreadEntry[];
    date: number;
  }

  interface ThreadEntry extends Entry {
    date?: number;
    text: string;
  }

  interface AdapterService {
    isSupported(url: string): string; // yes/no/unclear
    get(url: string): ng.IPromise<Entries>;
  }
}

