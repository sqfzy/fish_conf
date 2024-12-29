function show_help
    echo
    echo "Usage: notepreview [note_name]"
    echo
    echo "Examples:"
    echo '  notepreview             # Preview the main note (main.md or main.typ) in the current directory'
    echo '  notepreview mynote      # Preview a note named "mynote" (searches for main.md or main.typ in the directory)'
    echo '  notepreview mynote.md   # Preview the specific note file "mynote.md"'
    echo
end

function notepreview
    # 设置笔记目录路径
    set notes_dir "$HOME/work_space/notes"

    # 检查目录是否存在
    if not test -d $notes_dir
        echo "Error: Notes directory does not exist: $notes_dir" >&2
        echo "Please create the directory with: mkdir -p $notes_dir"
        return 1
    end

    # 检查参数数量
    if test (count $argv) -gt 1
        show_help
        return 1
    end

    if test (count $argv) -eq 1 -a $argv[1] = "--help" 
        show_help
        return 0
    end

    set note_path ""

    if test (count $argv) -eq 0
        # 默认使用当前目录下的main.md或main.typ
        if test -f "main.typ"
            set note_path "main.typ"
        else if test -f "main.md"
            set note_path "main.md"
        else
            echo "Error: No main.typ or main.md found in current directory" >&2
            return 1
        end 
    else if test (string match -q -r ".*\.(md|typ)\$" $argv[1])
        set note_base_name $argv[1]
        set note_paths (find $notes_dir -type f -name "$note_base_name")

        set note_path (switch_note_path $note_base_name $note_paths)
        if test $status -ne 0
            return 1
        end
    end

    if test -z "$note_path"
        # 根据用户输入的笔记名称进行查找
        set note_stem_name $argv[1]
        set note_dir_paths (find $notes_dir -type d -name "$note_stem_name")

        set note_dir_path (switch_note_path $note_stem_name $note_dir_paths)
        if test $status -ne 0
            return 1
        end

        # 检查主文件
        if test -f "$note_dir_path/main.typ"
            set note_path "$note_dir_path/main.typ"
        else if test -f "$note_dir_path/main.md"
            set note_path "$note_dir_path/main.md"
        else
            echo "Error: Note does not contain main.typ or main.md" >&2
            return 1
        end
    end

    # 验证文件类型
    set note_type (string split "." (basename $note_path))[2]
    if not string match -qr "(md|typ)" $note_type
        echo "Error: Invalid note type. Please use 'md' or 'typ'." >&2
        return 1
    end

    # 预览文件
    echo "Previewing note: $note_path"
    if test $note_type = "md"
        glow $note_path
    else
        tinymist preview $note_path
    end
end

function switch_note_path
    set -l name $argv[1]
    set -l paths $argv[2..-1]

    switch (count $paths)
        case 0
            echo "Error: Note not found: $name" >&2
            return 1
        case 1
            echo $paths[1]
        case '*'
            echo "Multiple matches found for '$name':" >&2
            for i in (seq 1 (count $paths))
                echo "$i. $paths[$i]" >&2
            end
            echo "Enter the number of the note to preview (default is 1):" >&2
            read choice

            # 默认选择第一个
            if test -z "$choice"
                set choice 1
            end

            if not string match -qr '^[0-9]+$' -- $choice
                echo "Error: Invalid input, must be a number" >&2
                return 1
            end

            if test $choice -le 0 -o $choice -gt (count $paths)
                echo "Error: Choice out of range" >&2
                return 1
            end

            echo $paths[$choice]
    end
end
