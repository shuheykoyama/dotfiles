autoload -Uz colors
colors

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main pattern cursor)

ZSH_HIGHLIGHT_STYLES[command]='fg='#268bd2''  # command color
ZSH_HIGHLIGHT_STYLES[alias]='fg='#268bd2''  # alias color
ZSH_HIGHLIGHT_STYLES[builtin]='fg='#268bd2''  # shell builtin command color
ZSH_HIGHLIGHT_STYLES[function]='fg='#268bd2''  # function color
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg='#2aa198''  # single-hyphen-option color
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg='#2aa198''  # double-hyphen-option color
ZSH_HIGHLIGHT_STYLES[default]='fg='#2aa198''  # default color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg='#839496''  # the color of autosuggestion
