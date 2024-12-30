function find_md_typ_excluding_main
    set -l notes_dir $argv[1]
    set -l note_name $argv[2]

    if test -z $note_name
        echo "Error: Note name not provided" >&2
        return 1
    end

    if test -z $notes_dir
        echo "Error: Notes directory not provided" >&2
        return 1
    end

    # 查找包含 main.* 文件的目录
    set -l exclude_dirs (find $notes_dir -type f -name "main.*" -exec dirname {} \; | sort -u)

    # 构建排除目录的 find 参数
    set -l find_cmd "find $notes_dir"
    for dir in $exclude_dirs
        set find_cmd "$find_cmd ! -path \"$dir/*\""
    end

    set find_cmd "$find_cmd -type f \( -name \"$note_name.md\" -o -name \"$note_name.typ\" \)"

    # 执行构建的 find 命令
    eval $find_cmd
end
