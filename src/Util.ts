module App.Util {
  export function dateToString (date: Date): string {
    var fixDigitNumber = function (a: number): string {
      return (a < 10 ? "0" : "") + a;
    };

    return (
      date.getFullYear() +
      "/" + fixDigitNumber(date.getMonth() + 1) +
      "/" + fixDigitNumber(date.getDate()) +
      " " + fixDigitNumber(date.getHours()) +
      ":" + fixDigitNumber(date.getMinutes())
    );
  }
}
