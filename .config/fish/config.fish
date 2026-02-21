if status is-interactive
# Commands to run in interactive sessions can go here
set -U fish_greeting 

function rmlib
    set ts (date +%Y%m%d-%H%M%S)
    set label restored-personal-library

    mkdir -p .rmlint
    and cd .rmlint
    and rmlint -g --match-extension -c sh:clone \
        -O sh:"rmlint--$label--$ts-script.sh" \
        -O json:"rmlint--$label--$ts-dupes.json" \
        -O uniques:"rmlint--$label--$ts-uniques.txt" \
        --types="minimal" ..
    and ./rmlint--$label--$ts-script.sh -xkcd
end

pokemon-colorscripts -r --no-title
end

alias rm="trash"

# color scheme
cat ~/.cache/wal/sequences
source ~/.cache/wal/colors.fish



starship init fish | source
# pnpm
set -gx PNPM_HOME "/home/miella/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
