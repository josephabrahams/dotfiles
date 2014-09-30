# Use `syspip' upgrade globally installed packages
syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}
