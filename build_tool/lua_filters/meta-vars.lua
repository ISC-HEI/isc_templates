local vars = {}

function get_vars(meta)
  for k, v in pairs(meta) do
    val = v
    if type(val) ~= "string" then
        val = table.unpack(val).text
    end
    vars["{{" .. k .. "}}"] = val
  end
end

function replace(el)
  if type(el.text) == "string" then
    for k, v in pairs(vars) do
      el.text = string.gsub(el.text, k, v)
    end
  end
  return el
end

function Inline(el)
  el = replace(el)
  return pandoc.walk_inline(el)
end

function Block(el)
  el = replace(el)
  return pandoc.walk_block(el)
end

return {
  {Meta = get_vars},
  {Inline = Inline,
   Block = Block}
}