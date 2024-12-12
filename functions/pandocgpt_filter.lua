function RawInline(el)
  -- 将 <br> 替换为换行符
  if el.format:match("html") and el.text:lower():match("<br ?/?>") then
    return pandoc.RawInline("typst", "\n")
  end
end
