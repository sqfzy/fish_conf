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

    # 替换 align(center) 为 align(left)，仅在紧跟 [#table 时
    sed -i '/align(center).*#table(/s/align(center)/align(left)/g' $file

    # 修改多行列表的格式
    # 将 `[-` 替换为 `[`，并在首行添加换行
    sed -i '/^\s*\[- /s/\[-/[\n  -/' $file

    # 去除多余空行，确保文件结构正确
    sed -i ':a;N;$!ba;s/\n\n/\n/g' $file

    sed -i '1i#import "@local/common:0.0.1": *\n#show: common.with()\n' $file
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

    # 替换 align 和调整列表格式
    replace_align_center_with_left $output_file 

    echo "Conversion complete."
end

