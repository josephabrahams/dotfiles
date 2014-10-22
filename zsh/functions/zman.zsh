# use `zman` to search the zsh documentation

function zman() {
  PAGER="less -g -s '+/^       "$1"'" man zshall
}
