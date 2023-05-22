include std/search.e
include std/text.e
include std/convert.e
include std/sequence.e
include std/types.e
include common.e

public constant NOT_JSON=0, JSON_DATA=10, JSON_OBJECT=20, JSON_ARRAY=30,
                JSON_NAME=1, JSON_VALUE=2

--------------------------------------------------------------------------------

function find_matching(integer c, sequence s, integer from=1)
  integer n, e

-- log_puts("find_matching\n")
--analyze_object(s, "s", f_debug)
  if find(c, {'(', '[', '{', '<'}) then
    if c = '(' then
      e = ')'
    elsif c = '[' then
      e = ']'
    elsif c = '{' then
      e = '}'
    elsif c = '<' then
      e = '>'
    end if
    n = 0
    for i = from to length(s) do
      if s[i] = c then n += 1 end if
      if s[i] = e then n -= 1 end if
      if n = -1 then return i end if
    end for
  elsif (c = '\'') or (c = '"') then
    for i = from to length(s) do
      if (s[i] = c) and (s[i-1] != '\\') then return i end if
    end for
  end if
  return 0
end function

--------------------------------------------------------------------------------

public function split_json_list(sequence json, integer delim=',')
  integer i = 0, p = 1, n = 0
  sequence result = {}

  json = trim(json)
  -- printf(f_debug, "split_json_list(%s, %s)\n", {json, delim})
  while i < length(json) do
    i += 1
    if json[i] = '{' then
      n = find_matching('{', json, i+1)
      if n then i = n else printf(f_debug, "Error in column %d: No matching {\n", i) end if
    elsif json[i] = '[' then
      n = find_matching('[', json, i+1)
      if n then i = n else printf(f_debug, "Error in column %d: No matching [\n", i) end if
    elsif json[i] = '"' then
      n = find_matching('"', json, i+1)
      if n then i = n else printf(f_debug, "Error in column %d: No matching \"\n", i) end if
    elsif json[i] = delim then
      result &= {trim(json[p..i-1])}
      p = i+1
    end if
  end while
  result &= {trim(json[p..$])}
  return result
end function

--------------------------------------------------------------------------------

function is_json_data(sequence json)
  sequence objects = split_json_list(json, ':')
  --analyze_object(objects, "objects", f_debug)
  if length(objects) = 1 then
    --puts(f_debug, "length(objects) is 1!\n")
    return 0
  elsif length(objects) > 2 then
    --puts(f_debug, "length(objects) is greater than 2!\n")
    return 0
  end if
  if not begins('"', objects[1]) or not ends('"', objects[1]) then
    puts(f_debug, "'" & objects[1] & "' is not enclosed in double quotes!\n")
    return 0
  end if
  if not is_string(dequote(objects[1])) then
    puts(f_debug, "'" & dequote(objects[1]) & "' is not a string !\n")
    return 0
  end if
  return 1
end function

--------------------------------------------------------------------------------

public function json_type(sequence json)
  json = trim(json)
  if begins('{', json) and ends('}', json) then
    return JSON_OBJECT
  elsif begins('[', json) and ends(']', json) then
    return JSON_ARRAY
  elsif is_json_data(json) then
    return JSON_DATA
  else
    return NOT_JSON
  end if
end function

--------------------------------------------------------------------------------

public function json_to_sequence(sequence json)
  sequence objects, name, s, res

  -- printf(f_debug, "\ndump_json(%s)\n", {json})
  switch json_type(json) do
  case JSON_OBJECT then
    s = trim(dequote(json, {{"{","}"}}))
    objects = split_json_list(s, ',')
    -- analyze_object(objects, "objects", DEBUG)
    res = {JSON_OBJECT}
    for i = 1 to length(objects) do
      res &= {json_to_sequence(objects[i])}
    end for
    return res
  case JSON_ARRAY then
    s = trim(dequote(json, {{"[","]"}}))
    objects = split_json_list(s, ',')
    -- analyze_object(objects, "objects", DEBUG)
    res = {JSON_ARRAY}
    for i = 1 to length(objects) do
      res &= {json_to_sequence(objects[i])}
    end for
    return res
  case JSON_DATA then
    s = trim(json)
    objects = split_json_list(s, ':')
    -- analyze_object(objects, "objects", DEBUG)
    name = dequote(objects[1])
    s = trim(objects[2])
    switch json_type(s) do
    case JSON_OBJECT, JSON_ARRAY then
      return {JSON_DATA, {JSON_NAME, name}, {JSON_VALUE, json_to_sequence(s)}}
    case else
      return {JSON_DATA, {JSON_NAME, name}, {JSON_VALUE, s}}
    end switch
  case else
    s = trim(json)
    return {NOT_JSON, s}
  end switch
  return {}
end function

--------------------------------------------------------------------------------

-- identifies elements to be processed (defaults to all structure items)
function is_valid_item(object x)
  --analyze_object(x, "x", DEBUG)
  if length(x) < 2 then return 0 end if
  if not integer(x[1]) then return 0 end if
  if not find(x[1], {NOT_JSON, JSON_DATA, JSON_OBJECT, JSON_ARRAY,
                JSON_NAME, JSON_VALUE}) then return 0 end if
  return 1
end function

--------------------------------------------------------------------------------

public function sequence_to_json(object x)
  integer subSequence
  sequence s

  --if not is_valid_item(x) then return s end if
  --log_puts("x = " & object_dump(x) & "\n", DEBUG)
  s = ""
  switch x[1] do
    case NOT_JSON then
      s = ""
    case JSON_DATA then
      s = "\"" & sequence_to_json(x[2]) & "\": " & sequence_to_json(x[3])
    case JSON_OBJECT then
      s = "{"
      if length(x) then
        s &= sequence_to_json(x[2])
      end if
      if length(x) > 2 then
        for i= 3 to length(x) do
          s &= ", " & sequence_to_json(x[i])
        end for
      end if
      s &= "}"
    case JSON_ARRAY then
      s = "["
      if length(x) then
        s &= sequence_to_json(x[2])
      end if
      if length(x) > 2 then
        for i= 3 to length(x) do
          s &= ", " & sequence_to_json(x[i])
        end for
      end if
      s &= "]"
    case JSON_NAME then
      s = x[2]
    case JSON_VALUE then
      if atom(x[2]) then
        s = to_string(x[2])
      elsif cstring(x[2]) then
        s = x[2]
      else
        s = sequence_to_json(x[2])
      end if
  end switch
  --analyze_object(s, "s")
  return s
end function

--------------------------------------------------------------------------------

public function json_value(sequence json, sequence key)
  sequence json_dump
  --printf(f_debug, "\njson_value2(%s, %s)\n", {json, key})
  if not is_valid_item(json) then
    json_dump = json_to_sequence(json)
  else
    json_dump = json
  end if
  sequence nodes = find_nested(key, json_dump, NESTED_ALL)
  sequence res = {}
  for i = 1 to length(nodes) do
    sequence s = fetch(json_dump, nodes[i][1..$-2])
    res = append(res, {s[3][2], nodes[i][1..$-2], s[1]})
  end for
  return res
end function
