module App.BBSIndex {
  export interface Index {
    lastUpdated: number;
    lastModified: number;
    categories: Category[];
  }

  export interface Category {
    name: string;
    boards: Board[];
  }

  export interface Board {
    name: string;
    url: string;
  }

  export class BBSIndexService {
    static parse (html: string): Index {
      var index: Index,
        regCategory: RegExp,
        regCategoryExecResult: RegExpExecArray,
        regBoard: RegExp,
        regBoardExecResult: RegExpExecArray,
        category: Category;

      index = {
        lastUpdated: 0,
        lastModified: 0,
        categories: []
      };

      regCategory = /<b>(.+?)<\/b>(?:.*[\r\n]+<a .*?>.+?<\/a>)+/gi
      regBoard = /<a href=(http:\/\/(?!info\.2ch\.net\/)\w+\.(?:2ch\.net|machi\.to)\/\w+\/)(?:\s.*?)?>(.+?)<\/a>/gi;

      while (regCategoryExecResult = regCategory.exec(html)) {
        category = {
          name: regCategoryExecResult[1],
          boards: []
        };

        while (regBoardExecResult = regBoard.exec(regCategoryExecResult[0])) {
          category.boards.push({
            name: regBoardExecResult[2],
            url: regBoardExecResult[1]
          });
        }

        if (category.boards.length > 0) {
          index.categories.push(category);
        }
      }

      return index.categories.length > 0 ? index : null;
    }
  }
}

