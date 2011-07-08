# jszakmeister@localhost [~/path/to/somewhere] [version-control-status] -------------------------------------------- [something?]

local separator='%{$fg_bold[blue]%}:%{$reset_color%}'
local user_host='%{$fg_bold[yellow]%}%n%{$fg_bold[cyan]%}@%{$fg_bold[blue]%}%M%{$reset_color%}'

_vcs_status() {
    local start="%{$fg_bold[yellow]%}(%{$fg[green]%}"
    local stop="%{$fg_bold[yellow]%})%{$reset_color%}"
    function git_status {
        git rev-parse --git-dir >& /dev/null || return 1
        local ref dirty count ahead behind divergent upstream

        ref=$(git symbolic-ref HEAD 2> /dev/null)
        ref="%{$fg_no_bold[yellow]%}${ref#refs/heads/}%{$reset_color%}"
        upstream=$(git rev-parse --symbolic-full-name @{upstream} 2> /dev/null)
        if [[ $upstream == "@{upstream}" ]]; then
            upstream=""
        else
            upstream=${upstream#refs/remotes/}
        fi

        if [[ -n $(git status -s 2> /dev/null) ]]; then
            dirty="%{$fg_bold[red]%}*%{$reset_color%}"
        else
            dirty=""
        fi

        if [[ -n $upstream ]]; then
            count=${(ps:\t:)$(git rev-list --count --left-right $upstream...HEAD)}
            upstream="...%{$fg_no_bold[white]%}${upstream#refs/remotes/}%{$reset_color%}"
        else
            count=${(ps:\t:)$(git rev-list --count --left-right master...HEAD)}
        fi

            if (( ${count[1]} > 0 )); then
                behind="%{$fg_no_bold[white]%}behind %{$fg_bold[red]%}${count[1]}%{$reset_color%}"
            else
                behind=""
            fi
            if (( $count[3] > 0 )); then
                ahead="%{$fg_no_bold[white]%}ahead %{$fg_bold[green]%}${count[3]}%{$reset_color%}"
            else
                ahead=""
            fi
            if [[ -n $ahead && -n $behind ]]; then
                divergent=" [${behind}, ${ahead}]"
            elif [[ -n $ahead || -n $behind ]]; then
                divergent=" [${behind}${ahead}]"
            else
                divergent=""
            fi


        echo "on ${ref}${dirty}${upstream}${divergent}"
        return 0
    }

    function svn_status {
        return 1
    }

    function bzr_status {
        return 1
    }

    function hg_status {
        return 1
    }

    git_status || svn_status || bzr_status || hg_status
}

local current_dir='%{$terminfo[bold]$fg[yellow]%}[%{$fg_no_bold[magenta]%}${PWD/#$HOME/~}%{$fg[yellow]%}]%{$reset_color%}'
local topline="${user_host} ${current_dir} \$(_vcs_status)"
PROMPT="${topline}
${separator}${separator}"

local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
RPS1="${return_code}"

