# Done notification
# Based on ryoppippi/dotfiles
# Notify when a command takes longer than threshold

# Threshold in milliseconds (30 seconds)
set -g NOTIFY_ON_COMMAND_DURATION 30000

# Programs to exclude from notifications (TUI tools)
set -g NOTIFY_EXCLUDE_PROGRAMS vim nvim lazygit lazydocker claude codex yazi gitu bottom ctop top viddy tmux jid jnv fx less man ssh

function __done_notification --on-event fish_postexec
    # Check if CMD_DURATION exists and exceeds threshold
    if not set -q CMD_DURATION
        return
    end

    if test $CMD_DURATION -lt $NOTIFY_ON_COMMAND_DURATION
        return
    end

    # Get the command name (first word of the command)
    set -l cmd_name (echo $argv[1] | string split ' ' | head -1)

    # Check if the command should be excluded
    if contains $cmd_name $NOTIFY_EXCLUDE_PROGRAMS
        return
    end

    # Calculate duration in seconds
    set -l duration (math -s 1 "$CMD_DURATION / 1000")

    # Build notification message
    set -l message "Command '$cmd_name' finished after "$duration"s"

    # Send notification (macOS)
    if type -q terminal-notifier
        terminal-notifier -message $message -title "Command Done" -sound default
    else if type -q osascript
        osascript -e "display notification \"$message\" with title \"Command Done\""
    end
end
