function fish_right_prompt --description "Write out right prompt"
  segment_right black magenta [(prompt_pwd)]
  segment_right black green
  segment_right black normal (__terlar_git_prompt)
  segment_close
end

