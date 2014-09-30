# No arguments: `cd ~`
# With arguments: acts like `z`
# Requires the z oh-my-zsh plugin
j() {
  if [[ $# > 0 ]]; then
    _z $@ 2>&1
  else
    cd ~
  fi
}
