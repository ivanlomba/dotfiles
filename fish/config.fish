function __add_to_path
    if test (count $argv) = 1
        set -gx PATH $argv[1] $PATH
    else
        echo "Usage: __add_to_path <path>"
    end
end

function __reload_config
    source ~/.config/fish/config.fish
end

function __fuzzy_find
    fzf -x -m --ansi --reverse --inline-info $argv
    #peco $argv
end

function __make_completion --argument alias command
  complete -c $alias -xa "(
    set -l cmd (commandline -pc | sed -e 's/^ *\S\+ *//' );
    complete -C\"$command \$cmd\";
  )"
end

set -gx EDITOR "vim"
set -gx GIT_EDITOR "vim"
set -gx GREP_OPTIONS "--color=auto"
set -gx CDPATH . "$HOME/Workspace"
set -gx BREW_CELLAR "/usr/local/Cellar"

set -x JAVA_HOME (/usr/libexec/java_home)
__add_to_path $JAVA_HOME/bin

set -x TOMCATS $HOME/Workspace/tomcats
set -x CATALINA_HOME $TOMCATS/apache-tomcat-8.0.29

set -gx RBENV_ROOT /usr/local/var/rbenv
__add_to_path $HOME/.rbenv/versions/2.4.0/bin
status --is-interactive; and . (rbenv init -|psub)

set -x NDENV_ROOT $HOME/.ndenv
__add_to_path $NDENV_ROOT/bin
__add_to_path $NDENV_ROOT/shims
ndenv rehash

set -x PYENV_ROOT $HOME/.pyenv
__add_to_path $PYENV_ROOT/versions/3.5.2/bin
__add_to_path $PYENV_ROOT/shims
pyenv rehash

set -x ANDROID_HOME ~/Library/Android/sdk
set -U fish_user_paths $fish_user_paths $ANDROID_HOME/tools $ANDROID_HOME/platform-tools

eval (direnv hook fish)

set fish_greeting ""
set fish_color_command "green"

function __user_host
  set -l content
  echo -n (set_color --bold yellow)
  echo -n $USER@(hostname|cut -d . -f 1) (set color normal)
end

function __prompt_pwd
  echo -n ' '(set_color green)(echo $PWD | sed -e "s|^$GHQ_ROOT\/github\.com|gh|" | sed -e "s|^$GHQ_ROOT\/bitbucket\.org|bb|" | sed -e "s|^$HOME|~|")(set_color normal)
end

function __prompt_char
  set_color white
  if [ $TMUX ]
    printf '\n> '
  else
    printf '\n~ '
  end
  set_color normal
end

function __rb_prompt
  echo -n (set_color red)''(rbenv version | awk '{print $1}')(set_color normal)
end

set __fish_git_prompt_color 'magenta'
set __fish_git_prompt_show_informative_status 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_char_stateseparator ' '
set __fish_git_prompt_char_stagedstate '+'
set __fish_git_prompt_color_stagedstate 'green'
set __fish_git_prompt_char_dirtystate 'x'
set __fish_git_prompt_color_dirtystate 'red'
set __fish_git_prompt_char_cleanstate \u2713
set __fish_git_prompt_color_cleanstate 'green'

function fish_prompt
    set -l last_status $status

  echo -ne (tput el)
  __user_host
  __prompt_pwd

  if test $last_status -ne 0
    set_color red
    printf ' [%d]' $last_status
    set_color normal
  end

  __fish_git_prompt " "
  __prompt_char
end

function icd
    tree --noreport -d -i -L 1 $CDPATH | grep -v '\(Users\|\.\)' | __fuzzy_find | read tempvar
    if [ $tempvar ]
        cd $tempvar
    end
end

function ifind
    set dir $argv
    if test (count $argv) -gt 2 -o (count $argv) -lt 1
        set dir (pwd)
    end
    find $dir | __fuzzy_find | tr "\n" " " | read tempvar
    if [ $tempvar ]
        commandline -i $tempvar
    end
end

function ihistory
    history | __fuzzy_find | read tempvar
    if [ $tempvar ]
        commandline $tempvar
    end
end

function ik
    ps -fea | awk '{$1=$3=$4=$5=$6=$7=""; print $0}' | __fuzzy_find | awk '{print $1}' | tr "\n" " " | read -l tempvar
    if test (count $tempvar) -gt 0
        kill $tempvar
    end
end

function ips
    ps -fea | awk '{$1=$3=$4=$5=$6=$7=""; print $0}' | __fuzzy_find | awk '{print $1}' | tr "\n" " " | read tempvar
    if [ $tempvar ]
        commandline -i $tempvar
    end
end

function ircd
    set dir $argv
    if test (count $argv) -gt 2 -o (count $argv) -lt 1
        set dir (pwd)
    end
    #find $dir -type d | __fuzzy_find | read tempvar
    find $dir -type d -not -path "*/.*/*" -not -name ".*" | __fuzzy_find | tr -d "\n" | read tempvar
    if [ $tempvar ]
        cd $tempvar
    end
end

function v
    echo -e (set_color green) "node\t" (set_color normal) (ndenv version | awk '{print $1}'); and \
    echo -e (set_color red) "ruby\t" (set_color normal) (rbenv version | awk '{print $1}'); and \
    echo -e (set_color yellow) "python\t" (set_color normal) (pyenv version | awk '{print $1}')
end

function fish_user_key_bindings
    bind \eb 'prevd; commandline -f repaint'
    bind \eu 'cd ..; commandline -f repaint'
    bind \cr 'ihistory; commandline -f repaint'
    bind \eo 'ips; commandline -f repaint'
    bind \ep 'ifind; commandline -f repaint'
    bind \ec 'ircd; commandline -f repaint'
    bind \ew 'ighq; commandline -f repaint'
end

alias vim   "nvim"
alias vlc   "/opt/homebrew-cask/Caskroom/vlc/2.2.1/VLC.app/Contents/MacOS/VLC"
alias wtr   "curl -4 wttr.in"
alias atmux "tmux -L atom"
alias tx "tmuxinator"
alias bb "cd $GHQ_ROOT/bitbucket.org/ivanlomba"
alias gh "cd $GHQ_ROOT/github.com/ivanlomba"

function ranger-cd
    set tempfile '/tmp/ranger-cd'
    ranger --choosedir=$tempfile (pwd)

    if test -f $tempfile
        if test (cat $tempfile) != (pwd)
            cd (cat $tempfile)
        end
    end
    rm -f $tempfile
end

alias r     "ranger"
alias rr    "ranger-cd"

function igitbranch
    git branch | __fuzzy_find | xargs git checkout
end

function igitbranch
    git branch | __fuzzy_find | xargs git checkout
end

alias g "git"

set -x GHQ_ROOT "$HOME/Workspace/src"

function ighq
    ghq list | __fuzzy_find | read tempvar
    if test (count $tempvar) -gt 0
        cd (ghq root)/$tempvar
    end
end

function gg
    if test (count $argv) = 1
      if test (echo $argv[1] | grep -o "/" | wc -l | tr -d " ") = "2"
            set -l __repository (echo $argv[1] | cut -d"/" -f 2-)
            set -l __hub (echo $argv[1] | cut -d"/" -f 1)
            if test $__hub = "bb"
                  ghq get git@bitbucket.org:$__repository.git
            end
      else
            ghq get -p $argv[1]
      end
   end
end

function __update_docker_host
        sudo sed -i '' '/[[:space:]]docker\.local$/d' /etc/hosts
        set -x DOCKER_IP (echo $DOCKER_HOST | grep -oE '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}')
    if [ $DOCKER_IP ]
            sudo /bin/bash -c "echo \"$DOCKER_IP        docker.local\" >> /etc/hosts"
    end
end

function dml
    if test (count $argv) = 1
        docker-machine env $argv[1] | source
        set -gx DOCKER_TLS_VERIFY $DOCKER_TLS_VERIFY
        set -gx DOCKER_CERT_PATH $DOCKER_CERT_PATH
        set -gx DOCKER_HOST $DOCKER_HOST
        __update_docker_host
    else
        echo "Usage: dml <machine name>"
    end
end

function dr
    if test (count $argv) = 2
        docker run --rm -t -i -v (bash -c "echo \$(cd $argv[2] && pwd)"):/volume -w /volume $argv[1] /bin/bash
    else
        echo "Usage: dr <image> <directory>"
    end
end

alias dm "docker-machine"
alias dc "docker-compose"
alias d  "docker"

set -gx TRABE_ROOT $HOME/.trabe/trabe
__add_to_path $TRABE_ROOT/bin
status --is-interactive; and trabe init - | source
