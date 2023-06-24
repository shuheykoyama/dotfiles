# ~/zsh/zsh_plugins/zstyle_config.zsh

# 入力された文字通りに補完を試みる．
# 失敗した場合，小文字を大文字に変えて補完を試みる．
# それでも失敗した場合，大文字を小文字に変えて補完を試みる．
# 最後に，現在の単語の右側（末尾）にハイフン，アンダースコア，またはピリオドがある場合，それにアスタリスクを追加して補完を試みる．
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}' 'r:|[-_.]=**'

# 補完候補を一覧表示したとき，tabや矢印で選択できるようにする．
zstyle ':completion:*:default' menu select=1
