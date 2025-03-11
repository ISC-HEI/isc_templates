-- Replaces stars either with a star emoji or a star symbol in LaTeX
function Str(elem)
    if FORMAT:match 'latex' then        
        -- This is not complete, but it is a start
        -- it should be replaced with \emotion{⭐} but regexp replacement
        -- it not outputting raw latex but interprets it.
        elem.text = string.gsub(elem.text, ":STAR:", "*")
        return elem
    elseif FORMAT:match 'html' then
        elem.text = string.gsub(elem.text, ":STAR:", "⭐")
        return elem
    else
        return elem
    end
end
