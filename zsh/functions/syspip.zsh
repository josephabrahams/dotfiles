# upgrade globally installed python packages

function syspip(){
    PIP_REQUIRE_VIRTUALENV="" /usr/local/bin/pip "$@"
}
