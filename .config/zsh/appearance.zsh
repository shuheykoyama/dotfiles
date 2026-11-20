autoload -Uz colors
colors

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern cursor)

# ZSH_HIGHLIGHT_STYLES[command]='fg='#268bd2''  # command color
# ZSH_HIGHLIGHT_STYLES[alias]='fg='#268bd2''  # alias color
# ZSH_HIGHLIGHT_STYLES[builtin]='fg='#268bd2''  # shell builtin command color
# ZSH_HIGHLIGHT_STYLES[function]='fg='#268bd2''  # function color
# ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg='#2aa198''  # single-hyphen-option color
# ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg='#2aa198''  # double-hyphen-option color
# ZSH_HIGHLIGHT_STYLES[default]='fg='#2aa198''  # default color
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg='#839496''  # the color of autosuggestion

() {
    # --- Kanagawa Dragon Palette ---
    local K_FG="#DCD7BA"       # normal text (FujiWhite)
    local K_SEL="#2D4F67"      # selection bg (WaveBlue2)
    local K_COMMENT="#727169"  # comment (FujiGray)
    local K_RED="#C34043"      # error/red (DragonRed)
    local K_ORANGE="#FF9E64"   # separator (SurimiOrange)
    local K_YELLOW="#C0A36E"   # string (RoninYellow)
    local K_GREEN="#76946A"    # operator (AutumnGreen)
    local K_PURPLE="#957FB8"   # param (OniViolet)
    local K_CYAN="#7AA89F"     # command (WaveAqua1)
    local K_PINK="#D27E99"     # keyword (SakuraPink)

    # --- 1. zsh-syntax-highlighting の設定 ---
    
    # コマンド・関数系 (Cyan)
    ZSH_HIGHLIGHT_STYLES[command]="fg=${K_CYAN}"
    ZSH_HIGHLIGHT_STYLES[alias]="fg=${K_CYAN}"
    ZSH_HIGHLIGHT_STYLES[builtin]="fg=${K_CYAN}"
    ZSH_HIGHLIGHT_STYLES[function]="fg=${K_CYAN}"

    # パス・オプション (Purple)
    ZSH_HIGHLIGHT_STYLES[path]="fg=${K_PURPLE}"
    ZSH_HIGHLIGHT_STYLES[single-hyphen-option]="fg=${K_PURPLE}"
    ZSH_HIGHLIGHT_STYLES[double-hyphen-option]="fg=${K_PURPLE}"

    # 文字列 (Yellow)
    ZSH_HIGHLIGHT_STYLES[string]="fg=${K_YELLOW}"
    ZSH_HIGHLIGHT_STYLES[back-quoted-argument]="fg=${K_YELLOW}"

    # 予約語・制御構文 (Pink)
    ZSH_HIGHLIGHT_STYLES[reserved-word]="fg=${K_PINK}"

    # コメント (Gray + Italic)
    ZSH_HIGHLIGHT_STYLES[comment]="fg=${K_COMMENT},italic"

    # エラー・不明 (Red)
    ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=${K_RED}"

    # デフォルト文字色
    ZSH_HIGHLIGHT_STYLES[default]="fg=${K_FG}"

    # --- 2. zsh-autosuggestions の設定 ---
    # 予測変換の色 (Gray)
    # ※ここはグローバル変数(-g)にする必要があります
    typeset -g ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=${K_COMMENT}"

    # --- 3. 補完メニュー(TAB押下時) の設定 ---
    # これも追加しておくと統一感が出ます
    
    # 補完候補のハイライト（背景：紺色、文字：白）
    # RGB変換: #2D4F67 -> 45;79;103 | #DCD7BA -> 220;215;186
    zstyle ':completion:*:default' list-colors "=(#b) #([0-9a-z]##)*=01;34=${K_CYAN}"
    zstyle ':completion:*' menu select
    zstyle ':completion:*:*:*:*:*' list-colors "ma=48;2;45;79;103;38;2;220;215;186"
}
