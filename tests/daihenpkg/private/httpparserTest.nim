import unittest, macros

import daihenpkg/private/httpparser

suite "my suite1":
  setup:
    echo "before test"

  teardown:
    echo "after test"

  test "call method1":
    echo "call method1"

    var data = """
DEBUG, [2018-03-21T12:38:51] -- daihen: readLine: GET / HTTP/1.1
Host: localhost:12345
Connection: keep-alive
Cache-Control: max-age=0
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/64.0.3282.186 Safari/537.36
Accept: text/html,application/xhtml+xml,application/xml;q=0."""
    var result = extractHost(data)

    check:
      result.hostname == "localhost"
      result.port == 12345
