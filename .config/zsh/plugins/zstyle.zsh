# ~/zsh/zsh_plugins/zstyle.zsh

# Attempts to complete the input exactly as it is entered.
# If it fails, it tries to complete by changing lowercase letters to uppercase letters.
# If it fails, the completion is attempted with uppercase letters converted to lowercase.
# Finally, if there is a hyphen, underscore, or period to the right (at the end) of the current word,
# an asterisk is added and completion is attempted.
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' '+m:{A-Z}={a-z}' 'r:|[-_.]=**'

# When a list of completion candidates is displayed, they can be selected by tab or arrow keys.
zstyle ':completion:*:default' menu select=1
