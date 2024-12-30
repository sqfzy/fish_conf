source $HOME/.config/fish/common.fish

function __fish_notepreview_complete
    # 设置笔记目录路径
    set -l notes_dir "$HOME/work_space/notes"
    set -l completions  # 用于存储去重后的补全项

    # 遍历目录，查找包含 main.typ 或 main.md 的文件夹
    for dir in (find $notes_dir -type d 2>/dev/null)
        if test -f "$dir/main.typ" -o -f "$dir/main.md"
            # 输出文件夹名称作为补全项
            set completions $completions (basename "$dir")
        end
    end

    # 查找不包含 main.* 文件的 .md 或 .typ 文件
    for file in (find_md_typ_excluding_main $notes_dir "*")
        # 获取文件名并添加到去重列表
        set completions $completions (basename -s .md (basename -s .typ "$file"))
    end

    # 去重并输出补全项
    printf "%s\n" $completions | sort -u
end


# 定义补全逻辑
complete -c notepreview -a "(__fish_notepreview_complete)" -d "Note name"
complete -c notepreview -a "(__fish_complete_path)"
