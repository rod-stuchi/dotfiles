if status is-interactive
    # Commands to run in interactive sessions can go here
    # bind \ce forward-char (arrow right, ctrl-f do the same)
end

zoxide init fish | source

# startship .......................................
function starship_transient_prompt_func
    starship module character
end

starship init fish | source
# startship =======================================

enable_transience

# direnv source
direnv hook fish | source
