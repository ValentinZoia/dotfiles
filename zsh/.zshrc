# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==================================================
# linuxbrew
# ==================================================
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

eval "$( /home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH


# ===========================
# Oh-My-Zsh configuration
# ===========================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
ENABLE_CORECTION="true"
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh


# ==============================
# Aliases basicos
# ===============================
#Ubuntu usa batcat
alias bat="batcat"

# configs
alias zshconfig="zed ~/.zshrc"
alias ohmyzsh="cd ~/.oh-my-zsh"

# ==================================================
# eza (modern ls)
# ==================================================
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza -l --icons --git"
alias la="eza -la --icons --git"
alias tree="eza --tree --icons"



# ==================================================
# fd alias (ubuntu usa fdfind)
# ==================================================

alias fd="fdfind"

# ==================================================
# fzf + fd configuration
# ==================================================

export FZF_DEFAULT_COMMAND="fdfind --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fdfind --type=d --hidden --strip-cwd-prefix --exclude .git"

# vista: SOLO ver directorio actual con fzf
# preview: SOLO los archivos con bat - NO carpetas/directorios
# acciones: NO
alias fzfbat='fzf --preview="batcat --theme=gruvbox-dark --color=always {}"'

# vista: SOLO directorio actual con fzf
# preview: SOLO los archivos con bat - No carpetas/directorios
# acciones: Abrir archivos con zed
alias fzfzed='zed $(fzf --preview="batcat --theme=gruvbox-dark --color=always {}")'

eval "$(fzf --zsh)"


# fd for path completion
_fzf_compgen_path() {
  fdfind --hidden --exclude .git . "$1"
}

# fd for directory completion
_fzf_compgen_dir() {
  fdfind --type=d --hidden --exclude .git . "$1"
}


# ==================================================
# fzf previews
# ==================================================

show_file_or_dir_preview='
if [ -d {} ]; then
  eza --tree --color=always {} | head -200
else
  batcat --style=numbers --color=always --line-range :500 {}
fi
'

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"


# command specific previews
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)
      fzf --preview 'eza --tree --color=always {} | head -200' "$@"
      ;;
    export|unset)
      fzf --preview "eval 'echo \${}'" "$@"
      ;;
    ssh)
      fzf --preview 'dig {}'
      ;;
    *)
      fzf --preview "$show_file_or_dir_preview" "$@"
      ;;
  esac
}

# ==================================================
# zoxide (smart cd)
# ==================================================

eval "$(zoxide init zsh)"


# ==================================================
# fzf functions for development
# ==================================================

# open file in Zed
fe() {
  local file
  file=$(fdfind --type f --hidden --exclude .git | fzf --preview 'batcat --color=always --style=numbers {} | head -200')
  [ -n "$file" ] && zed "$file"
}

# open project directory
fp() {
  local dir
  dir=$(fdfind --type d --max-depth 3 --full-path '/home/valen/Dev/proyectosweb' | fzf --preview 'eza --tree --color=always {} | head -100')
  [ -n "$dir" ] && zed "$dir"
}

# search text in project
frg() {
  local file
  file=$(rg --line-number --no-heading --color=always "" | fzf --ansi \
    --preview 'batcat --color=always {1} --highlight-line {2}' \
    --delimiter : \
    --nth 3..)

  [ -n "$file" ] && zed "$(echo "$file" | cut -d: -f1)"
}


# interactive directory jump
fzfcd() {
  local dir
  dir=$(fdfind --type d --hidden --exclude .git | fzf --preview 'eza --tree --color=always {} | head -100')
  [ -n "$dir" ] && cd "$dir"
}




# Set up fzf key bindings and fuzzy completions
eval "$(fzf --zsh)"



# ==================================================
# neofetch clear function
# ==================================================

cl() {
  command clear
  printf '\e[3J'
  neofetch
}
alias neofetch='neofetch'










# ==================================================
# Node (nvm)
# ==================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ==================================================
# custom tools
# ==================================================
# opencode
export PATH=/home/valen/.opencode/bin:$PATH
alias opencodeconfig="cd /home/valen/.config/opencode"





# ==================================================
# Powerlevel10k config
# ==================================================
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
