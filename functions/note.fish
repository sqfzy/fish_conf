function show_help
    echo
    echo "Usage: note <name> [OPTIONS]"
    echo
    echo "Options:"
    printf "  %-25s %s\n" "-k, --keywords <keywords>" "Specify keywords for the note (comma-separated)"
    printf "  %-25s %s\n" "-t, --type <type>" "Specify the note type (md|typ). Default is 'typ'"
    printf "  %-25s %s\n" "-h, --help" "Display this help message"
    echo
    echo "Examples:"
    echo '  note mynote -k "work,project" -t md'
    echo '  note mynote --keywords "personal,diary" --type typ'
    echo '  note mynote.md -k "work,project"'
    echo
end

function note
    set count (count $argv)
    if test (count $argv) -eq 0
        show_help
        return 1
    end

    set -l options (getopt -o "k:t:h" --long "keywords:,type:,help" -- $argv)
    or begin
        echo "Error: Invalid options."
        return 1
    end

    eval set argv $options

    set note_name ""
    set note_type "typ"
    set single_file false
    set keywords ""
    
    while true
        switch $argv[1]
            case "-k" "--keywords"
                set keywords $argv[2]
                set argv $argv[3..-1]
            case "-t" "--type"
                set note_type $argv[2]
                if not string match -q -r "(md|typ)" $note_type
                    echo "Error: Invalid note type '$note_type'. Please use 'md' or 'typ'."
                    return 1
                end
                set argv $argv[3..-1]
            case "-h" "--help"
                show_help
                return 0
            case "--"
                # 停止解析选项，剩下的为位置参数
                set argv $argv[2..-1]
                break
        end
    end

    set note_name $argv[1]


    # 如果note_name以.md或.typ结尾，则认为是single_file
    if string match -q -r ".*\.(md|typ)\$" $note_name
        set single_file true
        set note_type (string split "." $note_name)[2]
        set note_name (string split "." $note_name)[1]
    end


    # 给关键词加上双引号
    set quoted_keywords (string join "," (for kw in (string split "," $keywords); echo "\"$kw\""; end))

    # 确定文件路径
    if test $single_file = true
        set note_path $note_name.$note_type

        # 检查文件是否存在
        if test -f $note_path
            echo "File "$note_path" already exists!"
            return 1
        end

        touch $note_path 
    else
        set note_dir_path $note_name
        set note_path $note_dir_path/main.$note_type

        # 检查文件夹是否存在
        if test -d $note_dir_path 
            echo "Folder '$note_dir_path' already exists!"
            return 1
        end

        create_note_dir $note_name $note_type
    end

    # 写入 metadata
    set title $note_name
    set author "sqfzy"
    set datetime (date "+%Y-%m-%d-%H-%M-%S" | string split "-")

    if test $note_type = "md"
        echo "---" > $note_path
        echo "title: \"$title\"" >> $note_path
        echo "author: \"$author\"" >> $note_path
        echo "keywords: [$quoted_keywords]" >> $note_path
        echo "date: \"$datetime[1]-$datetime[2]-$datetime[3] $datetime[4]:$datetime[5]:$datetime[6]\"" >> $note_path
        echo "---" >> $note_path
        echo -e "\n" >> $note_path
    else
        echo "#set document(title: \"$title\", author: \"$author\", keywords: ($quoted_keywords), date: datetime(year: $datetime[1], month: $datetime[2], day: $datetime[3], hour: $datetime[4], minute: $datetime[5], second: $datetime[6]))" >> $note_path
        echo "" >> $note_path
        echo "#import \"@local/common:0.0.1\": *" >> $note_path
        echo "#show: common.with()" >> $note_path
        echo -e "\n" >> $note_path
    end

    echo "Note "$note_name" created successfully!"
end

function create_note_dir
    set note_name $argv[1]
    set note_type $argv[2]

    mkdir -p $note_name/images
    mkdir -p $note_name/bibliography
    mkdir -p $note_name/chapter
    touch $note_name/bibliography/chatgpt.md
    touch $note_name/bibliography/chatgpt.typ
    touch $note_name/bibliography/refs.bib

    echo '% @article{netwok2020,
%   title={At-scale impact of the {Net Wok}: A culinarically holistic investigation of distributed dumplings},
%   author={Astley, Rick and Morris, Linda},
%   journal={Armenian Journal of Proceedings},
%   volume={61},
%   pages={192--219},
%   year=2020,
%   publisher={Automatic Publishing Inc.}
% }
%
% @article{netwok2022,
%   title={{Net Wok}++: Taking distributed dumplings to the cloud},
%   author={Morris, Linda and Astley, Rick},
%   journal={Armenian Journal of Proceedings},
%   volume={65},
%   pages={101--118},
%   year=2022,
%   publisher={Automatic Publishing Inc.}' > $note_name/bibliography/refs.bib

    # 根据笔记类型创建主文件
    touch $note_name/main.$note_type
end
