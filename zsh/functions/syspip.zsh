# upgrade globally installed python packages

syspip() {
    PIP_REQUIRE_VIRTUALENV="" /usr/local/bin/pip "$@"
}

syspip2() {
    PIP_REQUIRE_VIRTUALENV="" /usr/local/opt/python@2/bin/pip2 "$@"
}
