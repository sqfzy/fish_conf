以下是 `complete` 命令常用参数的总结表格，以便更好地理解它们的功能和使用场景：

| 参数/选项                  | 描述                                                                                  | 示例                                                                 |
|---------------------------|-------------------------------------------------------------------------------------|----------------------------------------------------------------------|
| `-c` / `--command`        | 指定命令的名称。                                                                   | `complete -c gcc`                                                   |
| `-p` / `--path`           | 指定命令的绝对路径（可以包含通配符）。                                              | `complete -p /usr/bin/mycommand`                                    |
| `-e` / `--erase`          | 删除指定命令的补全配置。                                                             | `complete -c gcc -e`                                                |
| `-s` / `--short-option`   | 为命令添加短选项（如 `-o`）。                                                        | `complete -c gcc -s o`                                              |
| `-l` / `--long-option`    | 为命令添加 GNU 风格的长选项（如 `--help`）。                                         | `complete -c gcc -l help`                                           |
| `-o` / `--old-option`     | 添加旧风格选项（短或长）。                                                           | `complete -c gcc -o Wall`                                           |
| `-a` / `--arguments`      | 为命令的选项或参数添加补全内容。                                                     | `complete -c grep -a "read skip recurse"`                           |
| `-k` / `--keep-order`     | 保持 `--arguments` 中参数的顺序，而不是按字母排序。                                   | `complete -c mycmd -a "arg1 arg2" -k`                               |
| `-f` / `--no-files`       | 指定补全内容后不自动补全文件名。                                                     | `complete -c mycmd -f`                                              |
| `-F` / `--force-files`    | 指定补全内容后可以补全文件名，即使存在 `--no-files`。                                 | `complete -c mycmd -F`                                              |
| `-r` / `--require-parameter` | 指定选项必须有参数，不能跟随另一个选项。                                             | `complete -c gcc -s o -r`                                           |
| `-x` / `--exclusive`      | 简写形式，相当于 `-r` 和 `-f` 的组合。                                               | `complete -c su -x -a "(cat /etc/passwd \| cut -d : -f 1)"`           |
| `-w` / `--wraps`          | 继承另一个命令的补全定义。                                                           | `complete -c hub -w git`                                            |
| `-n` / `--condition`      | 设置条件，当条件命令返回 0 时才启用该补全。                                           | `complete -c rpm -n "__fish_contains_opt -s e erase"`               |
| `-C` / `--do-complete`    | 对指定字符串尝试查找补全内容。如果未指定字符串，则对当前命令行查找。                    | `complete -C "gcc -"`                                               |
| `--escape`                | 与 `-C` 一起使用，转义补全中的特殊字符。                                              | `complete -C "command" --escape`                                    |
