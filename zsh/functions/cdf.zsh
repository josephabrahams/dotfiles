# Change working directory to the top-most Finder window location
# http://joseph.is/1yOpjYV

cdf() {
    cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}
