function convert_format
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

    # 将 '-\n  <content>` 或 '-\n<content>' 替换为 '- <content>`
    sed -i -z 's/-\n /\n-/g' $file
    sed -i -z 's/-\n/\n- /g' $file

    # # 去除多余空行，确保文件结构正确
    # sed -i ':a;N;$!ba;s/\n\n/\n/g' $file

    # 替换```c为```C
    sed -i 's/```c/```C/g' $file

    # 替换'\('为'\ ('
    # 例如：正态分布 \(Normal Distribution) -> 正态分布 \ (Normal Distribution)
    # sed -i 's/\\\(/\\\ (/g' $file

    sed -i 's/#none//g' $file

    # 使用

    sed -i '1i#import "@local/common:0.0.1": *\n#show: common.with()\n' $file

end

# 使用示例: pandocgpt ./bibliography/chatgpt.md
function pandocgpt
    # 检查是否提供了输入文件
    if test (count $argv) -gt 1
        echo "Usage: pandocgpt [input_file]"
        return 1
    end

    if test (count $argv) -lt 1
        set input_file "./bibliography/chatgpt.md"
    else
        # 获取输入文件路径
        set input_file $argv[1]
    end

    set output_file (string replace -r ".md" ".typ" $input_file)

    # 使用 pandoc 进行转换
    # tex_math_single_backslash 用于将`\( \)`识别为Math节点，使用`pandoc --list-extensions`可以查看更多扩展
    pandoc $input_file --from=markdown+tex_math_single_backslash --lua-filter=/home/sqfzy/.config/fish/functions/pandocgpt_filter.lua -o $output_file

    # 替换 align 和调整列表格式
    convert_format $output_file 

    echo "Converted $input_file to $output_file."
end

