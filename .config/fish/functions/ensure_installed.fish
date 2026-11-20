function ensure_installed --description 'Run a command if available'
    set -l cmd $argv[1]

    if not type -q $cmd
        echo "# command $cmd not found"
        return 0
    end

    $cmd $argv[2..-1]
    return $status
end
