function fish_prompt --description "Write out prompt"
  # suffix
  set -l color_cwd
  set -l suffix
  switch $USER
    case root toor
      if set -q fish_color_cwd_root
        set color_cwd $fish_color_cwd_root
      else
        set color_cwd $fish_color_cwd
      end
      set suffix '#'
    case '*'
      set color_cwd $fish_color_cwd
      set suffix '<'
  end

  # status code
  set -l status_face
  if [ $status -eq 0 ]
    set status_face (set_color green)"(*'-')"(set_color normal)
  else
    set status_face (set_color brcyan)"(;>_<)"(set_color normal)
  end

  echo -n -s "($USER) $status_face $suffix "
end

