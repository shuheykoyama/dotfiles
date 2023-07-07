#!/bin/zsh

### OpenAI API key ###
export OPENAI_API_KEY="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"

### Java ###
# UTF-8のコード系で日本語を上手に扱いたいので．UTF-8を使うぞ！
export _JAVA_OPTIONS="-Dfile.encoding=UTF-8"
# export JAVA_HOME=`/usr/libexec/java_home -v "1.8"`
# export JAVA_HOME=`/usr/libexec/java_home -v "11"`
# export JAVA_HOME=`/usr/libexec/java_home -v "17"`
# export JAVA_HOME=`/usr/libexec/java_home -v "18"`
# export JAVA_HOME=`/usr/libexec/java_home -v "19"`
export JAVA_HOME=`/usr/libexec/java_home -v "20"`

### Apache Ant ###
if [ -d "/usr/local/ant" ]
then
    export ANT_HOME="/usr/local/ant"
    echo $PATH | grep --quiet "$ANT_HOME/bin"
    if [ ! $? = 0 ] ; then PATH=$PATH:$ANT_HOME/bin ; fi
    export ANT_OPTS="-Dfile.encoding=UTF-8 -Xmx512m -Xss256k"
fi

### Static Code Analysis ###
echo $PATH | grep --quiet "/usr/local/checker/bin"
if [ ! $? = 0 ] ; then PATH=$PATH:/usr/local/checker/bin ; fi

### Subversion ###
if [ -d "/opt/subversion" ]
then
    export SVN_HOME="/opt/subversion"
    echo $PATH | grep --quiet "$SVN_HOME/bin"
    if [ ! $? = 0 ] ; then PATH=$SVN_HOME/bin:$PATH ; fi
fi

### asdf ###
. "$HOME/.asdf/asdf.sh"
# export PATH=$PATH:$HOME/.asdf/shims
# export PATH=$PATH:$HOME/.asdf/bin
# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

# Move asdf paths to the end of PATH
PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "$HOME/.asdf/shims" | grep -v "$HOME/.asdf/bin" | paste -sd ':' -)
PATH=$PATH:"$HOME/.asdf/shims":"$HOME/.asdf/bin"
export PATH

### Rust ###
. "$HOME/.cargo/env"

### Pythonのバージョン管理（pyenvによる） ###
# if [ -d "$HOME/.pyenv" ]
# then
#   export PYENV_ROOT="$HOME/.pyenv"
#   for each in {bin,shims}
#   do
#     echo $PATH | grep --quiet "$PYENV_ROOT/$each"
#     if [ ! $? = 0 ]
#     then
#       export PATH="$PYENV_ROOT/$each:$PATH"
#     fi
#   done
#   if command -v pyenv 1>/dev/null 2>&1
#   then
#     eval "$(pyenv init -)"
#   fi
# fi

### Rubyのバージョン管理（rbenvによる） ###
# if [ -d "$HOME/.rbenv" ]
# then
#   export RBENV_ROOT="$HOME/.rbenv"
#   echo $PATH | grep --quiet "$RBENV_ROOT/bin"
#   if [ ! $? = 0 ]
#   then
#     export PATH="$RBENV_ROOT/bin:$PATH"
#   fi
#   if command -v rbenv 1>/dev/null 2>&1
#   then
#     eval "$(rbenv init -)"
#   fi
# fi

### Node.jsのバージョン管理（nvmによる） ###
# if [ -d "$HOME/.nvm" ]
# then
#   export NVM_DIR="$HOME/.nvm"
#   echo $PATH | grep --quiet "$NVM_DIR"
#   if [ ! $? = 0 ]
#   then
#     [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#     [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#   fi
# fi

### PHPの設定 ###
# export PATH="/usr/local/opt/php@8.1/bin:$PATH"
# export PATH="/usr/local/opt/php@8.1/sbin:$PATH"
