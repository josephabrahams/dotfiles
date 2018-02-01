# upgrade globally installed python packages

syspip() {
    PIP_REQUIRE_VIRTUALENV="" $(which pip) "$@"
}
