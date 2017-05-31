function ghci --description "Stack based global GHCi"
  set -l global_stack_yaml $HOME/.stack/global-project/stack.yaml
  command stack --stack-yaml $global_stack_yaml ghci -- $argv
end

