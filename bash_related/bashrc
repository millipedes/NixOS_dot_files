# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# This is What Appears Before your Cursor in a Terminal Emulator
# I have added colors (i.e.  \033[0m ...)
_set_my_PS1() {
	PS1='\033[0;36m${PWD/#$HOME/"~"}\n|->>\033[0m '
}
_set_my_PS1
unset -f _set_my_PS1

alias l='ls --color=auto'						# lazy ls
alias ll='ls -alhF --color=auto'		# ls++
alias opal='evince'								  # pdfs
alias ltd1='~/.screenlayout/laptop-to-desktop1.sh' # Monitor Scripts
alias octave='octave -q'						# Don't Show Me the License Every Time
alias gdb='gdb -q'                  # Don't Show Me the License Every Time
alias vim='nvim'									  # Bram let other people commit please!
alias ccke='sl -aF'									# encourage toxicity
alias cck='sl -l'								    # encourage toxicity	
alias vvle='sl -aF'									# encourage toxicity
alias vvl='sl -l'									  # encourage toxicity
alias vvlr='sl -l'									# encourage toxicity
alias ssh='TERM=xterm-256color ssh'
alias fpc='fpc -gv'

[[ "$(whoami)" = "root" ]] && return

# limits recursive functions, see 'man bash'
[[ -z "$FUNCNEST" ]] && export FUNCNEST=100

#---------------------------------------------------------------
# My custom bash scripts:
source ~/.config/bash_scripts/functions/cclear.sh
source ~/.config/bash_scripts/functions/cdc.sh
source ~/.config/bash_scripts/functions/c_project.sh
source ~/.config/bash_scripts/functions/c_object.sh
source ~/.config/bash_scripts/functions/simple_latex.sh
#---------------------------------------------------------------

readonly LIN=/home/knd/Documents/nmt/2021-2022/semester2/math454/
readonly STO=/home/knd/Documents/nmt/2021-2022/semester2/math486/
readonly AOS=/home/knd/Documents/nmt/2021-2022/semester2/cse489/
readonly ARC=/home/knd/Documents/nmt/2021-2022/semester2/cse331/
readonly SE=/home/knd/Documents/nmt/2021-2022/semester2/cse326/

# My C program for Easy Loading Terminal Art
/home/knd/.config/rice-terminal/terminal_startup_rice \
  /home/knd/.config/rice-terminal/new_pics.txt        \
  /home/knd/.config/rice-terminal/quotes.txt | lolcat -S 218
