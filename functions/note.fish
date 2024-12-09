function note
    set count (count $argv | tr -d \n)

    if test "$count" -lt 1; or test "$count" -gt 2
        echo "Usage: note <name> <type (md|typst)>"
        return 1
    end

    # 获取笔记名称
    set note_name $argv[1]

    # 如果没有指定笔记类型，默认设为 "typst"
    if test "$count" -eq 1
        set note_type "typst"
    else
        set note_type $argv[2]
    end

    # 检查笔记类型是否有效
    if not string match -q "md" $note_type; and not string match -q "typst" $note_type
        echo "Invalid note type. Please use 'md' or 'typst'."
        return 1
    end

    # 创建笔记文件夹
    if test -d $note_name
        echo "Folder '$note_name' already exists!"
        return 1
    end

    mkdir -p $note_name/images
    mkdir -p $note_name/bibliography

    # 根据笔记类型创建相应的主文件
    if test "$note_type" = "md"
        echo > $note_name/main.md
    else if test "$note_type" = "typst"
        echo > $note_name/main.typ
    end

    cd $note_name
    echo '#set text(font: ("LXGW WenKai Mono", "0xProto"))' > ./main.typ


    echo "Note '$note_name' created successfully!"
end
