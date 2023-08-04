for name, fn in pairs(require 'text') do
  string['uc_' .. name] = fn
end

-- Replace TODO with their colored counterpart in LaTex
return {
    {
        Str = function (elem)
            if elem.text == "{{TODO}}" then
                -- if FORMAT:match 'latex' then
                --     return {
                --         pandoc.RawInline('latex', '\\todo{'),
                --         pandoc.RawInline('latex', elem.text),
                --         pandoc.RawInline('latex', '}' )   
                --     }
                -- end                          
            else
            return elem
            end
        end,
    }
}