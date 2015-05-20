# Load .env file into shell session for environment variables
# http://joseph.is/1dlgnCz

function envup() {
  if [ -s .env ]; then
    export `cat .env`
  else
    echo 'No .env file found' 1>&2
    return 1
  fi
}
