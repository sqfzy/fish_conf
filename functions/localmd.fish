#!/usr/bin/env fish

function localmd
    set md_file $argv[1]
    set output_dir (basename $md_file .md)
    mkdir -p $output_dir

    # 正则匹配 Markdown 文件中的图片链接
    # 例如，https://user-images.githubusercontent.com/87457873/127256431-b8dde885-d774-40d7-a556-5ae5ee1b7196.png
    set images (grep -oE '!\[image]\((http.*?)\)' $md_file | sed -E 's/!\[.*?\]\((http.*?)\)/\1/')

    for image_url in $images
        # 127256431-b8dde885-d774-40d7-a556-5ae5ee1b7196.png
        set file_name (basename $image_url)
        # $output_dir/127256431-b8dde885-d774-40d7-a556-5ae5ee1b7196.png
        set local_path "$output_dir/$file_name"

        # 下载图片到本地
        echo "Downloading $image_url -> $local_path"
        curl -s $image_url -o $local_path


        # 替换 Markdown 中的链接为本地路径
        sed -i "s|!\[image\]($image_url)|![image]($file_name)|g" $md_file
    end

    mv $md_file $output_dir

    echo "Down!"
end
