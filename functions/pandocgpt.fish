function replace_align_center_with_left
    if test (count $argv) -ne 1
        echo "Usage: replace_align_center_with_left <file>"
        return 1
    end

    set file $argv[1]

    # 检查文件是否存在
    if not test -f $file
        echo "Error: File '$file' does not exist."
        return 1
    end

    # 使用 sed 进行原地替换，仅在 align(center) 紧跟 [#table 时替换为 align(left)
    sed -i '/align(center).*#table(/s/align(center)/align(left)/g' $file
end

# 使用示例: pandocgpt ./bibliography/chatgpt.md
function pandocgpt
    # 检查是否提供了输入文件
    if test (count $argv) -lt 1
        echo "Usage: pandocgpt <input_file>"
        return 1
    end

    # 获取输入文件路径
    set input_file $argv[1]
    set output_file (string replace -r ".md" ".typ" $input_file)

    # 使用 pandoc 进行转换
    pandoc $input_file --lua-filter=/home/sqfzy/.config/fish/functions/pandocgpt_filter.lua -o $output_file

    replace_align_center_with_left $output_file 

    echo "Conversion complete."
end
