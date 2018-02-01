# upgrade globally installed python packages

syspip() {
    PIP_REQUIRE_VIRTUALENV="" $(which pip2) "$@"
}

syspip2() {
    PIP_REQUIRE_VIRTUALENV="" $(which pip2) "$@"
}

syspip3() {
    PIP_REQUIRE_VIRTUALENV="" $(which pip3) "$@"
}
