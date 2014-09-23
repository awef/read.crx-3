describe "[bbsmessage]", ->
  "use strict"

  beforeEach (done) ->
    module "BBSMessage"

    inject ($compile, $rootScope) =>
      @scope = $rootScope.$new()
      @scope.threadEntry = {}

      @linkTest = =>
        html = "<div data-bbsmessage></div>"
        element = null

        $rootScope.$apply =>
          element = $compile(html)(@scope)
          return

        element

      done()
      return
    return

  it "br, hr以外のhtmlタグを削除する", (done) ->
    @scope.threadEntry.text = """
      <div>TEST</div>
      <p>
        test
        <br>
        <br>
      </p>
      ab<b>cde</b>fg
      <hr>
      <script>alert(123);</script>
    """

    setTimeout (=>
      expect(@linkTest().html()).toBe("""
        TEST
        
          test
          <br>
          <br>
        
        ab<b>cde</b>fg
        <hr>
        alert(123);
      """)

      done()
    ), 0
    return

  it "URLをaタグに置換する", (done) ->
    @scope.threadEntry.text = """
      http://example.com/
      ttp://example.com
      http://example.com/ test http://example.com/ http://example.com/
      <hr> <hr>
      ttp://example.comttp://example.com
      https://example.com/test?test#test
      ttps://example.com/?a=b&c=d&e#aaa?test=#123
      <br>
    """

    setTimeout (=>
      expect(@linkTest().html()).toBe("""
        <a href="http://example.com/" target="_blank">http://example.com/</a>
        <a href="http://example.com" target="_blank">ttp://example.com</a>
        <a href="http://example.com/" target="_blank">http://example.com/</a> test <a href="http://example.com/" target="_blank">http://example.com/</a> <a href="http://example.com/" target="_blank">http://example.com/</a>
        <hr> <hr>
        <a href="http://example.comttp://example.com" target="_blank">ttp://example.comttp://example.com</a>
        <a href="https://example.com/test?test#test" target="_blank">https://example.com/test?test#test</a>
        <a href="https://example.com/?a=b&amp;c=d&amp;e#aaa?test=#123" target="_blank">ttps://example.com/?a=b&amp;c=d&amp;e#aaa?test=#123</a>
        <br>
      """)

      done()
    ), 0
    return
  return

