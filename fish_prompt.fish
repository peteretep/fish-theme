# name: PeterArmstrong
function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function hg_prompt
    if hg root >/dev/null 2>&1
        set_color normal
        printf ' on '
        set_color magenta
        printf '%s' (hg branch ^/dev/null)
        set_color normal
    end
end

function _hg_branch_name
  echo (command hg branch ^/dev/null)
end

function _is_git_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _is_hg_dirty
  echo (command hg status ^/dev/null)
end

function fish_prompt
  set -l last_status $status
  set -l cyan (set_color -o cyan)
  set -l yellow (set_color -o yellow)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

  if test $last_status = 0
      set arrow "$green➜ "
  else
      set arrow "$red➜ "
  end
  set -l cwd $cyan(basename (prompt_pwd))

  if [ (_git_branch_name) ]
    set -l git_branch $red(_git_branch_name)
    set git_info "$blue git:($git_branch$blue)"

    if [ (_is_git_dirty) ]
      set -l dirty "$yellow ✗"
      set git_info "$git_info$dirty"
    end
  end

  if [ (_hg_branch_name) ]
    set -l hg_branch $red(_hg_branch_name)
    set hg_info "$blue hg:($hg_branch$blue)"

    if [ (_is_hg_dirty) ]
      set -l dirty "$yellow ✗"
      set hg_info "$hg_info$dirty"
    end
  end

  echo -n -s $arrow $cwd $git_info $hg_info $normal ' '
end

