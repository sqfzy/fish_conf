function __fish_notepreview_complete
    # 设置笔记目录路径
    set notes_dir "$HOME/work_space/notes"

    # 遍历目录
    for dir in (find $notes_dir -type d 2>/dev/null)
        # 检查文件夹中是否包含 basename 为 main 的文件
        if test -f "$dir/main.typ" -o -f "$dir/main.md"
            # 输出文件夹名称作为补全项
            echo (basename "$dir")
        end
    end

    # 掠过包含 main.* 文件的文件夹，找到所有 .md 或 .typ 文件
    for file in (find $notes_dir -type d \( -exec sh -c 'ls "$0"/main.* >/dev/null 2>&1' {} \; -prune \) -o -type f \( -name "*.md" -o -name "*.typ" \) -print)
        # 输出文件名（去除扩展名）作为补全项
        echo (basename -s .md -s .typ "$file")
    end
end

# 定义补全逻辑
complete -c notepreview -a "(__fish_notepreview_complete)" -f -d "Note name"
complete -c notepreview -a "(__fish_complete_path)" 
