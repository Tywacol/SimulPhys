
HEAD = """<html>
  <head>
    <title>
      Log
   </title>
  </head>
  <body>
    <ul>"""

TAIL = """    </ul>
  </body>
</html>"""

ERR400 = """<html>
  <head>
    <title>
      Bad Request
   </title>
  </head>
  <body>
    <h1>ERROR 400 : Bad Request</h1>
  </body>
</html>"""

def build(L,HEAD,TAIL) : # L -> list to be inserted between <ul> and </ul>J'
    i = 0
    while i < len(L) :
        if L[i] != -1 :
            HEAD = HEAD + "<li>" + L[i].decode("utf-8") + "</li>"
        i += 1

    content = HEAD + TAIL
    return content
