# Tokyo Night: a compact, foreground-colored Zim prompt.
setopt NO_PROMPT_BANG PROMPT_CR PROMPT_PERCENT PROMPT_SP PROMPT_SUBST
typeset -g VIRTUAL_ENV_DISABLE_PROMPT=1
autoload -Uz add-zsh-hook
typeset -g TOKYO_NIGHT_DISTRO_SYMBOL=${TOKYO_NIGHT_DISTRO_SYMBOL:-}

typeset -gA _tokyo_night_c
_tokyo_night_c=(
  path      '#7aa2f7'
  branch    '#bb9af7'
  muted     '#a9b1d6'
  indexed   '#9ece6a'
  unindexed '#e0af68'
  untracked '#ff9e64'
  status_red '#f7768e'
  alert     '#f7768e'
  sync      '#bb9af7'
  stash     '#7aa2f7'
  venv      '#7dcfff'
  duration  '#e0af68'
  success   '#9ece6a'
)

# Set TOKYO_NIGHT_PALETTE_FILE to load another associative _tokyo_night_c palette.
if [[ -n ${TOKYO_NIGHT_PALETTE_FILE:-} ]]; then
  source "$TOKYO_NIGHT_PALETTE_FILE" || return 1
fi

typeset -g _tokyo_night_sp=' '

zstyle ':zim:prompt-pwd' git-root yes
zstyle ':zim:prompt-pwd:fish-style' dir-length 1
zstyle ':zim:duration-info' threshold 3
zstyle ':zim:duration-info' format "${_tokyo_night_sp}%F{${_tokyo_night_c[duration]}} %d%f"
add-zsh-hook preexec duration-info-preexec
add-zsh-hook precmd duration-info-precmd

if [[ ${TOKYO_NIGHT_GIT_DETAIL:-0} == 1 ]]; then
  # Opt-in detailed status. Staged states are green; unstaged, untracked,
  # and conflicted states are red, following Git's default color semantics.
  zstyle ':zim:git-info' verbose yes
  zstyle ':zim:git-info:index-added' format "${_tokyo_night_sp}%F{${_tokyo_night_c[indexed]}}+A%a%f"
  zstyle ':zim:git-info:index-deleted' format "${_tokyo_night_sp}%F{${_tokyo_night_c[indexed]}}+D%x%f"
  zstyle ':zim:git-info:index-renamed' format "${_tokyo_night_sp}%F{${_tokyo_night_c[indexed]}}+R%r%f"
  zstyle ':zim:git-info:index-modified' format "${_tokyo_night_sp}%F{${_tokyo_night_c[indexed]}}+M%m%f"
  zstyle ':zim:git-info:work-deleted' format "${_tokyo_night_sp}%F{${_tokyo_night_c[status_red]}}!D%X%f"
  zstyle ':zim:git-info:work-modified' format "${_tokyo_night_sp}%F{${_tokyo_night_c[status_red]}}!M%M%f"
  zstyle ':zim:git-info:untracked' format "${_tokyo_night_sp}%F{${_tokyo_night_c[status_red]}}?%u%f"
  zstyle ':zim:git-info:unmerged' format "${_tokyo_night_sp}%F{${_tokyo_night_c[status_red]}}~%U%f"
  zstyle ':zim:git-info:keys' format 'prompt' "${_tokyo_night_sp}%b%c%a%x%r%m%X%M%u%U%s%A%B%S"
else
  # Preserve the original compact prompt unless detailed mode is requested.
  if [[ ${TOKYO_NIGHT_GIT_VERBOSE:-1} == 0 ]]; then
    zstyle ':zim:git-info' verbose no
    zstyle ':zim:git-info:indexed' format "${_tokyo_night_sp}%F{${_tokyo_night_c[indexed]}}+%f"
    zstyle ':zim:git-info:unindexed' format "${_tokyo_night_sp}%F{${_tokyo_night_c[unindexed]}}!%f"
  else
    zstyle ':zim:git-info' verbose yes
    zstyle ':zim:git-info:indexed' format "${_tokyo_night_sp}%F{${_tokyo_night_c[indexed]}}+%i%f"
    zstyle ':zim:git-info:unindexed' format "${_tokyo_night_sp}%F{${_tokyo_night_c[unindexed]}}!%I%f"
  fi
  zstyle ':zim:git-info:untracked' format "${_tokyo_night_sp}%F{${_tokyo_night_c[untracked]}}?%u%f"
  zstyle ':zim:git-info:unmerged' format "${_tokyo_night_sp}%F{${_tokyo_night_c[alert]}}~%U%f"
  zstyle ':zim:git-info:keys' format 'prompt' "${_tokyo_night_sp}%b%c%i%I%u%U%s%A%B%S"
fi

zstyle ':zim:git-info' ignore-submodules all
zstyle ':zim:git-info:branch' format "%F{${_tokyo_night_c[branch]}}%b%f"
zstyle ':zim:git-info:commit' format "%F{${_tokyo_night_c[muted]}}@%c%f"
zstyle ':zim:git-info:action' format "${_tokyo_night_sp}%F{${_tokyo_night_c[branch]}}%s%f"
zstyle ':zim:git-info:ahead' format "${_tokyo_night_sp}%F{${_tokyo_night_c[sync]}}⇡%A%f"
zstyle ':zim:git-info:behind' format "${_tokyo_night_sp}%F{${_tokyo_night_c[sync]}}⇣%B%f"
zstyle ':zim:git-info:stashed' format "${_tokyo_night_sp}%F{${_tokyo_night_c[stash]}}*%S%f"
add-zsh-hook precmd git-info

_tokyo_night_prompt_data() {
  prompt-pwd _tokyo_night_path
  local name=${VIRTUAL_ENV_PROMPT//[() ]/}
  if [[ -n $VIRTUAL_ENV && ( -z $name || $name == (.venv|venv) ) ]]; then
    name=${VIRTUAL_ENV:t}
    [[ $name == (.venv|venv) ]] && name=${${VIRTUAL_ENV:h}:t}
  fi
  _tokyo_night_venv=${name:+${_tokyo_night_sp}%F{${_tokyo_night_c[venv]}} ${name//\%/%%}%f}
}
typeset -g _tokyo_night_path _tokyo_night_venv
add-zsh-hook precmd _tokyo_night_prompt_data

PS1='%F{${_tokyo_night_c[path]}}${TOKYO_NIGHT_DISTRO_SYMBOL}%f'
PS1+='${_tokyo_night_sp}%F{${_tokyo_night_c[path]}}%B${_tokyo_night_path}%b%f${(e)git_info[prompt]}${_tokyo_night_venv}${duration_info}'
PS1+='%(?.. ${_tokyo_night_sp}%F{${_tokyo_night_c[alert]}}✘%?%f)'
PS1+=' ${_tokyo_night_sp}%(!.%F{${_tokyo_night_c[alert]}}⮞#.%(?.%F{${_tokyo_night_c[success]}}⮞.%F{${_tokyo_night_c[alert]}}⮞))%f${_tokyo_night_sp}'
PS2='%_ > '
unset RPS1 RPROMPT
