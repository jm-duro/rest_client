-- without warning
include std/dll.e
include std/search.e
include std/io.e
include std/error.e
include std/filesys.e
include std/text.e
include std/sequence.e
include std/convert.e
include std/console.e
include common.e
include curl.e
include json.e

constant
  PROG_NAME    = "REST Client",
  PROG_VERSION = "0.1.1",
  PROG_AUTHOR  = "Jean-Marc DURO",
  PROG_DATE    = "2019-10-02"

constant DEFAULT_HEADERS = {
  --"User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0 " &
  --  "Gecko/20100101 Firefox/45.0",
  "Content-type: application/json; charset=UTF-8",
  "Accept: application/json"
}

constant GET=1, POST=2, PUT=3, PATCH=4, DELETE=5, HEAD=6, OPTIONS=7, TRACE=8

------------------------------------------------------------------------------

procedure format_json(sequence json_dump, sequence parent="", integer offset=0)
  analyze_object(json_dump, "format_json: json_dump", f_debug)
  if not integer(json_dump[1]) then
    puts(f_debug, "Error: " &  sprint(json_dump[1]) & " is not an integer!\n")
    return
  end if
  switch json_dump[1] do
    case JSON_OBJECT, JSON_ARRAY then
      puts(1, repeat(' ', offset) & parent & "\n")
      for i=2 to length(json_dump) do
        format_json(json_dump[i], to_string(i-1), offset+2)
      end for
    case JSON_DATA then
      switch json_dump[3][2][1] do
      case JSON_OBJECT, JSON_ARRAY then
        format_json(json_dump[3][2], json_dump[2][2], offset+2)
      case else
        puts(1, repeat(' ', offset) & json_dump[2][2] & ":" & json_dump[3][2] & "\n")
      end switch
    case NOT_JSON then
      puts(1, repeat(' ', offset) & json_dump[2] & "\n")
    case else
  end switch
end procedure

------------------------------------------------------------------------------
-- common initialization
------------------------------------------------------------------------------

function init_curl_session(sequence proxy="", integer ssl_no_verif=0)
  atom curl = curl_easy_init()
  log_printf("curl = %d\n", curl)
  if not curl then return 0 end if

  -- Proxy settings

  curl_easy_setopt(curl, CURLOPT_PROXYTYPE, CURLPROXY_HTTP)
  if length(proxy) then
    curl_easy_setopt(curl, CURLOPT_PROXY, proxy)
  else
    curl_easy_setopt(curl, CURLOPT_NOPROXY, "*")
  end if

  -- Cookies settings

  -- beware of already registered cookies!
  -- if a connection fails, first remove or empty the cookie file
  -- before you verify your credentials
  if file_exists(InitialDir & SLASH & "cookies.txt") then
    write_file(InitialDir & SLASH & "cookies.txt", "")
  end if
  curl_easy_setopt(curl, CURLOPT_COOKIEFILE, InitialDir & SLASH & "cookies.txt")
  curl_easy_setopt(curl, CURLOPT_COOKIEJAR, InitialDir & SLASH & "cookies.txt")

  -- Common settings

  curl_easy_setopt(curl, CURLOPT_VERBOSE, 0)
  curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1)

  if ssl_no_verif then
    -- Skip Peer Verification
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYPEER, 0)

    -- Skip Host Verification
    curl_easy_setopt(curl, CURLOPT_SSL_VERIFYHOST, 0)
  end if

  return curl
end function

------------------------------------------------------------------------------

function get_token(atom curl, sequence url, sequence body)
  object res = curl_post(curl, url,
                  {"Content-type: application/json; charset=UTF-8"},
                  body
                )
  if (res[HTTP_STATUS] < 200) or (res[HTTP_STATUS] > 226) then
    puts(f_debug, "POST failed!\n" & res[HTTP_BODY] & "\n")
    return ""
  end if
  for i = 1 to length(res[HTTP_HEADERS][1]) do
    sequence s = split(res[HTTP_HEADERS][1][i], ':')
    puts(f_debug, "s[1]: '" & s[1] & "'\n")
    if equal(s[1], "X-Subject-Token") then
      return trim(s[2])
    end if
  end for
  return ""
end function

------------------------------------------------------------------------------

function request(sequence target, sequence method, sequence url,
                 sequence additional_headers={}, object body=NULL,
                 sequence token="")

  -- Set proper headers
  sequence headers = DEFAULT_HEADERS -- & {"X-Auth-Token: " & token}
  sequence s = trim(additional_headers)
  if length(s) then
    headers &= split(s, "\r\n")
  end if
  if sequence(body) then
    body = trim(body)
  end if
  analyze_object(headers, "headers", f_debug)

  -- Do the HTTP request
  switch method do
    case "GET" then
      res = curl_get(curl, target & url, headers)
    case "POST" then
      res = curl_post(curl, target & url, headers, body)
    case "PUT" then
      res = curl_put(curl, target & url, headers, body)
    case "PATCH" then
      res = curl_patch(curl, target & url, headers, body)
    case "DELETE" then
      res = curl_delete(curl, target & url, headers)
    case "HEAD" then
      res = curl_head(curl, target & url, headers)
    case "OPTIONS" then
      headers = prepend(headers, "Host: " & target)
      res = curl_options(curl, target & url, headers)
    case "TRACE" then
      headers = prepend(headers, "Host: " & target)
      res = curl_trace(curl, target & url, headers)
  end switch

  if (res[HTTP_STATUS] < 200) or ((res[HTTP_STATUS] > 226) and (res[HTTP_STATUS] != 300)) then
    puts(2, method & " failed!\n")
  else
    puts(f_debug, "Status: " & to_string(res[HTTP_STATUS]) & "\n")
  end if

  puts(1, join(res[HTTP_HEADERS][1], "\n") & "\n\n")
  puts(1, res[HTTP_BODY] & "\n\n")

  if equal(res[HTTP_BODY], "{}") then return "" end if

  sequence json_dump = json_to_sequence(res[HTTP_BODY])
  analyze_object(json_dump, "json_dump", f_debug)
  format_json(json_dump, "Body")
  for i = 1 to length(s) do
    if length(s[i][4]) then
      puts(1, repeat(' ', length(s[i][1])) & s[i][3] & ":" & s[i][4] & "\n")
    else
      puts(1, repeat(' ', length(s[i][1])) & s[i][3] & "\n")
    end if
  end for
  puts(1, "\n")

  return res[HTTP_BODY]
end function

------------------------------------------------------------------------------

function Get(sequence target)
  return request(target, "GET", "/posts")
end function

------------------------------------------------------------------------------

function Post(sequence target)
  return request(target, "POST", "/posts", {}, "{ \"title\": \"foo\", \"body\": \"bar\", \"userId\": 1 }")
end function

------------------------------------------------------------------------------

function Put(sequence target)
  return request(target, "PUT", "/posts/1", {},  "{ \"id\": 1, \"title\": \"foo1\", \"body\": \"bar\", \"userId\": 1 }")
end function

------------------------------------------------------------------------------

function Patch(sequence target)
  return request(target, "PATCH", "/posts/1", {},  "{ \"title\": \"foo2\" }")
end function

------------------------------------------------------------------------------

function Delete(sequence target)
  return request(target, "DELETE", "/posts/1")
end function

------------------------------------------------------------------------------

function Head(sequence target)
  return request(target, "HEAD", "/posts/1")
end function

------------------------------------------------------------------------------

function Options(sequence target)
  return request(target, "OPTIONS", "/posts/1")
end function

------------------------------------------------------------------------------

function Trace(sequence target)
  return request(target, "TRACE", "/posts/1")
end function

------------------------------------------------------------------------------

  -- Set the request parameters
  sequence target = "https://jsonplaceholder.typicode.com"
  sequence s

  f_debug = open(InitialDir & "debug.log", "w")
  debug_level = DEBUG
  debug_time_stamp = 0

  object res = curl_global_init(CURL_GLOBAL_DEFAULT)
  
  atom curl = init_curl_session("", 1)
  -- atom curl = init_curl_session("http://127.0.0.1:8888", 1)  -- ex: Fiddler2 proxy

  -- get authentication token (url depends on API)
  -- sequence token = get_token(curl, target & ":5000/auth/tokens", token_body)
  -- puts(f_debug, "Authentication Token: '" & token & "'\n")

  s = Get(target)
  s = Post(target)
  s = Put(target)
  s = Patch(target)
  s = Delete(target)
  s = Head(target)
  -- s = Options(target)  -- not supported by target
  -- s = Trace(target)    -- not supported by target

  curl_easy_cleanup(curl)
  curl_global_cleanup()

  close(f_debug)
  maybe_any_key()
