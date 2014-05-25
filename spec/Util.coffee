describe "app.Util", ->
  describe "dateToString", ->
    it "Dateを表示に適した文字列に整形する", ->
      date = new Date(Date.parse("2014/01/01 00:00:00") + 1000 * 60 * 15)
      expect(App.Util.dateToString(date)).toBe("2014/01/01 00:15")
      return
    return
  return
