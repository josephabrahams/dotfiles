# ======================================================================
# Navigation
# ======================================================================


# Create a new directory and enter it
mcd() {
    mkdir -p "$@" && cd "$_"
}

# Open directory or file in Finder
o() {
    if [ $# -eq 0 ]; then
        open .
    else
        open "$@"
    fi
}

# ======================================================================
# Search
# ======================================================================

# Search file contents and names for a pattern
ag() {
    if [ -z "$1" ]; then
        echo "usage: ag <pattern> [path...]" >&2
        return 1
    fi
    local pattern="$1"
    shift
    local paths=("${@:-.}")
    local content names

    content="$(rg -S --hidden --glob '!.git/**' --heading -n --color=always "$pattern" "${paths[@]}")"
    names="$(fd -Hs -E .git "$pattern" "${paths[@]}")"

    [[ -n "$content" ]] && print -r -- "$content"

    if [[ -n "$names" ]]; then
        [[ -n "$content" ]] && print
        print "\e[35mFilename & directory matches:\e[0m"
        print -r -- "$names" | rg --color=always "$pattern"
    fi
}

# Case insensitive search for files & directories by name
f() {
    if [ -z "$1" ]; then
        echo "usage: f <pattern> [path...]" >&2
        return 1
    fi
    fd -Hi "$@"
}

# ======================================================================
# Files
# ======================================================================

# Show size of file or directory (defaults to current dir)
fsize() {
    du -sh -- "${@:-.}"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz() {
    local name="${@%/}"
    [[ "$name" == "." ]] && name="${PWD##*/}"
    local tmpFile="${name}.tar"
    local tar_cmd=(tar -cf "${tmpFile}"
        --exclude=".DS_Store"
        --exclude=".git"
        --exclude="node_modules"
        --exclude=".venv"
        --exclude="venv"
        --exclude="__pycache__"
        --exclude="${tmpFile}"
        --exclude="${tmpFile}.gz"
        "${@}")
    if hash gum 2>/dev/null; then
        gum spin --spinner dot --title "Creating archive of ${name}..." -- "${tar_cmd[@]}" || return 1
    else
        echo "Creating archive of ${name}..."
        "${tar_cmd[@]}" || return 1
    fi

    size=$(wc -c <"${tmpFile}" | tr -d ' ')

    local cmd=""
    if ((size < 52428800)) && hash zopfli 2>/dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli"
    else
        if hash pigz 2>/dev/null; then
            cmd="pigz"
        else
            cmd="gzip"
        fi
    fi

    local compress_cmd=("${cmd}" "${tmpFile}")
    if hash gum 2>/dev/null; then
        gum spin --spinner dot --title "Compressing ${tmpFile} ($((size / 1000)) kB) using ${cmd}..." -- "${compress_cmd[@]}" || return 1
    else
        echo "Compressing ${tmpFile} ($((size / 1000)) kB) using \`${cmd}\`..."
        "${compress_cmd[@]}" || return 1
    fi
    [ -f "${tmpFile}" ] && rm "${tmpFile}"

    zippedSize=$(wc -c <"${tmpFile}.gz" | tr -d ' ')

    local ratio=$((100 - (zippedSize * 100 / size)))
    echo "${tmpFile}.gz created successfully ($((zippedSize / 1000)) kB, ${ratio}% reduction)"
}

# Word-by-word colored diff between two files
diff() {
    if [[ $# -ne 2 ]]; then
        echo "usage: diff <file1> <file2>" >&2
        return 1
    fi
    git diff --no-index --color-words "$@"
}

# ======================================================================
# Development
# ======================================================================

# Open current directory in Cursor
c() {
    local editor reuse_flag=""

    # Already inside an editor? Force reuse in that editor
    if [[ -n "${CURSOR_CLI:-}" ]]; then
        editor="cursor"
        reuse_flag="-r"
    elif [[ "$TERM_PROGRAM" == "vscode" ]]; then
        editor="code"
        reuse_flag="-r"
    else
        # Not inside any editor, pick based on availability
        if command -v cursor >/dev/null 2>&1; then
            editor="cursor"
        elif command -v code >/dev/null 2>&1; then
            editor="code"
        else
            echo "c: neither cursor nor vscode is installed" >&2
            return 127
        fi
    fi

    # Open files or project
    if [ "$#" -eq 0 ]; then
        if [[ -n "$reuse_flag" ]]; then
            echo "c: already in a workspace, pass a file or path to open" >&2
            return 1
        fi
        local -a workspaces=( *.code-workspace(N) )
        if (( ${#workspaces} == 1 )); then
            echo "c: opening workspace ${workspaces[1]}"
            command "$editor" "${workspaces[1]}"
        elif (( ${#workspaces} > 1 )); then
            echo "c: multiple .code-workspace files found: ${workspaces[*]}" >&2
            return 1
        else
            command "$editor" .
        fi
    else
        command "$editor" $reuse_flag "$@"
    fi
}

# Export .env variables into current shell
envup() {
    if [ ! -s .env ]; then
        echo 'No .env file found' 1>&2
        return 1
    fi
    export $(sed 's/#.*//; /^$/d' .env | xargs)
}

# GitHub CLI wrapper
gh() {
    _gh_check_error() {
        local err="$1"
        if [[ "$err" == *"SAML"* ]]; then
            echo "$err" >&2
            echo "Run: gh auth refresh -h github.com -s admin:org" >&2
            return 1
        elif [[ "$err" != *"no pull request"* && "$err" != *"Could not resolve"* ]]; then
            echo "$err" >&2
            return 1
        fi
        return 0
    }

    if [ $# -eq 0 ]; then
        local branch=$(git branch --show-current)
        local err
        if ! err=$(command gh pr view --web 2>&1); then
            if ! _gh_check_error "$err"; then
                return 1
            fi
            # No PR: open branch on GitHub if it exists on remote, otherwise open repo
            if git ls-remote --heads origin "$branch" | grep -q .; then
                if ! err=$(command gh repo view -wb "$branch" 2>&1); then
                    _gh_check_error "$err"
                    return $?
                fi
            else
                if ! err=$(command gh repo view -w 2>&1); then
                    _gh_check_error "$err"
                    return $?
                fi
            fi
        fi
    else
        command gh "$@"
    fi
}
compdef _gh gh

# Delete all local branches except the main branch
gbda() {
  local main current
  git rev-parse --git-dir &>/dev/null || { echo "gbda: not a git repo" >&2; return 1; }
  main=$(git_main_branch)
  current=$(git branch --show-current)

  [ "$current" != "$main" ] && \
    echo "gbda: not on $main, keeping current branch (${current:-(detached HEAD)})"

  local branches=("${(@f)$(git branch --format='%(refname:short)' \
    | grep -vx "$main" | grep -vx "$current")}")
  [ -z "${branches[1]}" ] && { echo "gbda: nothing to delete"; return 0; }
  printf '  %s\n' "${branches[@]}"
  read -q "?Delete ${#branches[@]} branch(es)? [y/N] " || { echo; return 1; }
  echo
  git branch -D "${branches[@]}"
}

# Print the repo's main branch name (main, master, trunk, etc.)
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return

  local remote ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default,stable,master}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return 0
    fi
  done

  # Fallback: ask remote HEAD
  for remote in origin upstream; do
    ref=$(command git rev-parse --abbrev-ref $remote/HEAD 2>/dev/null)
    if [[ $ref == $remote/* ]]; then
      echo ${ref#"$remote/"}
      return 0
    fi
  done

  echo master
  return 1
}

# List remote branches on origin (sans the 'origin/' prefix)
gbr() {
  git branch -r --list 'origin/*' --format='%(refname:short)' \
    | sed -e '/^origin$/d' -e 's|origin/||'
}

# Smart git switch (auto-switches when only one other branch exists)
gs() {
  if [ $# -eq 0 ]; then
    local branches=($(git branch --format='%(refname:short)' | grep -v "^$(git branch --show-current)$"))
    if [ ${#branches[@]} -eq 1 ]; then
      git switch "${branches[1]}"
    else
      git switch
    fi
  else
    git switch "$@"
  fi
}

# Open CI page (GitHub Actions or CircleCI)
ci() {
    local remote_url repo_path

    remote_url=$(git remote get-url origin 2>/dev/null)
    if [[ -z "$remote_url" ]]; then
        echo "Not a git repository or no origin remote" >&2
        return 1
    fi

    # Extract owner/repo from remote URL
    repo_path=$(echo "$remote_url" | sed -E 's#(git@|https://)([^:/]+)[:/]##' | sed 's/\.git$//')

    if [[ -d ".circleci" ]]; then
        open "https://app.circleci.com/pipelines/github/${repo_path}"
    elif [[ -d ".github/workflows" ]]; then
        open "https://github.com/${repo_path}/actions"
    else
        echo "No CI configuration found (.github/workflows or .circleci)" >&2
        return 1
    fi
}

# Public resolver; bare `dig` still uses the system resolver for LAN names
DIGS_RESOLVER="${DIGS_RESOLVER:-1.1.1.1}"

# DNS lookup
digs() {
    if [ $# -gt 0 ]; then
        dig "@$DIGS_RESOLVER" +short "$@"
    elif [ ! -t 0 ]; then
        xargs -n1 dig "@$DIGS_RESOLVER" +short
    else
        echo "usage: digs <domain>..." >&2
        return 1
    fi
}

# Reverse DNS lookup
ptr() {
    if [ $# -gt 0 ]; then
        local ip
        for ip in "$@"; do
            dig "@$DIGS_RESOLVER" -x "$ip" +short
        done
    elif [ ! -t 0 ]; then
        xargs -n1 -I{} dig "@$DIGS_RESOLVER" -x {} +short
    else
        echo "usage: ptr <ip>..." >&2
        return 1
    fi
}

# ======================================================================
# Networking
# ======================================================================

# Shared color palette for ips / myip / vpncheck. Edit here, all three follow.
# Values: a $fg[...] name, a raw escape ('\e[90m'), or "default" for no color.
_NET_PALETTE=(
    label   blue       # labels + ips interface names
    ipv4    yellow     # IPv4 addresses
    ipv6    default    # IPv6 addresses
    suffix  default    # annotations: (en0), (via vpn), via utun6
    none    default    # "none", "n/a (no route)"
    ok      default    # OK verdict + "no leaks" summary
    bad     red        # LEAK verdict + leak summary
)

# Resolve _NET_PALETTE into _C_* escape vars. Colors only when stdout is a tty,
# so `myip > file` / `vpncheck | grep` stay clean.
_net_colors() {
    (( ${+fg} )) || { autoload -U colors && colors; }
    local tty=0; [[ -t 1 ]] && tty=1
    local name val esc
    for name val in "${_NET_PALETTE[@]}"; do
        if (( ! tty )) || [[ "$val" == default || -z "$val" ]]; then
            esc=""
        elif [[ "$val" == \\* || "$val" == $'\e'* ]]; then
            esc="${(g::)val}"          # (g::) expands \e etc. in a raw escape literal
        else
            esc="${fg[$val]}"          # named color
        fi
        typeset -g "_C_${(U)name}=$esc"
    done
    _C_RESET=""; (( tty )) && _C_RESET=$reset_color
}

# Color an address by family (IPv6 has a colon).
_net_addr() {
    local a="$1"
    [[ "$a" == *:* ]] && print -rn -- "${_C_IPV6}${a}${_C_RESET}" \
                      || print -rn -- "${_C_IPV4}${a}${_C_RESET}"
}

# Physical LAN interface that currently has an IPv4 (skips VPN tunnels).
# Prefers the default-route interface if it's physical, else first en* with an IP.
_lan_iface() {
    local def
    def=$(route -n get default 2>/dev/null | awk '/interface:/ {print $2}')
    if [[ "$def" == en* ]] && ipconfig getifaddr "$def" >/dev/null 2>&1; then
        print -r -- "$def"
        return
    fi
    local i
    for i in $(ifconfig -l); do
        [[ "$i" == en* ]] || continue
        ipconfig getifaddr "$i" >/dev/null 2>&1 && { print -r -- "$i"; return }
    done
}

# Active VPN tunnel interface, if any (else empty). Matches a tunnel with a real
# (non-link-local) IPv4 -- catches both full and split tunnels, unlike a default-
# route check which a split-tunnel VPN (e.g. OpenVPN) wouldn't satisfy.
_vpn_iface() {
    local i
    for i in $(ifconfig -l); do
        [[ "$i" == utun* || "$i" == ipsec* || "$i" == wg* ]] || continue
        # exit 0 (success) only if the interface had an "inet " line
        ifconfig "$i" 2>/dev/null | awk '/inet /{found=1} END{exit !found}' \
            && { print -r -- "$i"; return }
    done
}

# True if internet traffic actually exits via the VPN tunnel (so wanip is its
# exit). Routes to a real address rather than checking the default route, since
# OpenVPN's redirect-gateway adds 0/1 + 128/1 routes that override the default
# without replacing it -- the default route stays en0 but traffic goes utun.
_vpn_is_default() {
    local out=$(route -n get 1.1.1.1 2>/dev/null | awk '/interface:/ {print $2}')
    [[ -n "$out" && "$out" == "$(_vpn_iface)" ]]
}

# The interface the kernel would use to reach a destination, per protocol -- see
# _vpn_is_default for why this beats the default route. $1 is "-inet"/"-inet6",
# $2 a destination in that family.
_route_iface() {
    route -n get "$1" "$2" 2>/dev/null | awk '/interface:/ {print $2}'
}

# Best-effort name of the active VPN app/config (else empty). Checks the system
# VPN framework (WireGuard, IKEv2) for a friendly service name first, then falls
# back to recognizing the managing process (Viscosity, raw OpenVPN, Tailscale).
_vpn_app() {
    # macOS-registered VPN services (WireGuard.app, built-in IKEv2) report a
    # connected service with a quoted friendly name.
    local svc
    svc=$(scutil --nc list 2>/dev/null \
        | awk -F'"' '/^\* .*Connected/ {print $2; exit}')
    [[ -n "$svc" ]] && { print -r -- "$svc"; return }

    # Otherwise identify by process (Viscosity/OpenVPN, Tailscale, etc.)
    pgrep -fl 'viscosity_openvpn' >/dev/null 2>&1 && { print -r -- "Viscosity"; return }
    pgrep -fl 'Tunnelblick'       >/dev/null 2>&1 && { print -r -- "Tunnelblick"; return }
    pgrep -fl 'tailscaled'        >/dev/null 2>&1 && { print -r -- "Tailscale"; return }
    pgrep -fl '[o]penvpn'         >/dev/null 2>&1 && { print -r -- "OpenVPN"; return }
    pgrep -fl 'wireguard-go'      >/dev/null 2>&1 && { print -r -- "WireGuard"; return }
}

# Public IP as seen by the internet (the tunnel's exit when a VPN is up)
wanip() {
    curl -s --max-time 3 https://checkip.amazonaws.com
}

# Registered owner of an IP block (the ISP/org, not the individual subscriber --
# that's only in the ISP's records). Defaults to the current wan IP. WHOIS field
# names vary by registry, so try a few in order and print the first that hits.
whoip() {
    local ip="${1:-$(wanip)}"
    [[ -n "$ip" ]] || return 1
    local out=$(whois "$ip" 2>/dev/null)
    local f owner
    for f in OrgName Organization org-name owner netname NetName descr; do
        owner=$(awk -v f="$f" 'BEGIN{IGNORECASE=1}
            tolower($0) ~ "^"tolower(f)":" { sub(/^[^:]*:[ \t]*/, ""); print; exit }' \
            <<< "$out")
        [[ -n "$owner" ]] && { print -r -- "$owner"; return }
    done
}

# This machine's LAN IPv4 on its physical interface (bare address, pipeable)
lanip() {
    local iface=$(_lan_iface)
    [[ -n "$iface" ]] && ipconfig getifaddr "$iface"
}

# This machine's VPN tunnel IPv4, when a tunnel is active (else empty)
vpnip() {
    local iface=$(_vpn_iface)
    [[ -n "$iface" ]] && ifconfig "$iface" 2>/dev/null | awk '/inet /{print $2; exit}'
}

# This machine's physical router/gateway (the local network's, not the VPN's)
routerip() {
    local iface=$(_lan_iface)
    [[ -n "$iface" ]] && ipconfig getoption "$iface" router 2>/dev/null
}

# Every IPv4/IPv6 address on every interface, labeled by interface
ips() {
    # Strip the %zone suffix from link-local addrs -- it just repeats the
    # interface name in the first column. Colors from _NET_PALETTE, via awk vars.
    _net_colors
    # Pad the label before coloring so escapes don't count toward the width;
    # addresses line up in a column regardless of interface-name length.
    ifconfig | awk -v lbl="$_C_LABEL" -v v4="$_C_IPV4" -v v6="$_C_IPV6" -v rst="$_C_RESET" '
        /^[a-z]/ { iface = $1 }
        /inet /  { printf "%s%-7s%s%s%s%s\n", lbl, iface, rst, v4, $2, rst }
        /inet6 / { sub(/%.*/, "", $2); printf "%s%-7s%s%s%s%s\n", lbl, iface, rst, v6, $2, rst }
    '
}

# This machine's .local (Bonjour) name
myhostname() {
    scutil --get LocalHostName
}

# Summary of this machine's addresses: WAN, LAN, router, and VPN. The wan line is
# annotated with its registered owner, and "via vpn" only when the tunnel owns
# the default route (full tunnel); a split tunnel shows the vpn line but no "via
# vpn", since wanip stays local.
myip() {
    _net_colors
    local lan_if=$(_lan_iface) vpn_if=$(_vpn_iface)
    local none="${_C_NONE}none${_C_RESET}"
    local via=""
    _vpn_is_default && via="via vpn"

    local wan=$(wanip) lan=$(lanip) router=$(routerip)
    local wan_line="$none" lan_line="$none"
    if [[ -n "$wan" ]]; then
        wan_line="$(_net_addr "$wan")"
        # One parenthesized group: "owner", "via vpn", or "owner, via vpn".
        local owner=$(whoip "$wan")
        local wan_note="${owner}${owner:+${via:+, }}${via}"
        [[ -n "$wan_note" ]] && wan_line+=" ${_C_SUFFIX}($wan_note)${_C_RESET}"
    fi
    [[ -n "$lan" ]] && lan_line="$(_net_addr "$lan") ${lan_if:+${_C_SUFFIX}($lan_if)${_C_RESET}}"

    # Pad the label before coloring, so escapes don't count toward the width.
    _myip_row() { printf '%s%-8s%s%s\n' "$_C_LABEL" "$1" "$_C_RESET" "$2"; }

    local router_line="$none"
    [[ -n "$router" ]] && router_line="$(_net_addr "$router")"

    _myip_row "wan:"    "$wan_line"
    _myip_row "lan:"    "$lan_line"
    _myip_row "router:" "$router_line"
    if [[ -n "$vpn_if" ]]; then
        local app=$(_vpn_app)
        _myip_row "vpn:" "$(_net_addr "$(vpnip)") ${_C_SUFFIX}($vpn_if${app:+, $app})${_C_RESET}"
    fi
}

# Check whether traffic exits through the VPN or leaks around it. Works for any
# tunnel type: per protocol, checks which interface traffic actually uses --
# anything on a non-VPN interface is a leak. DNS is checked too, since a resolver
# reached outside the tunnel deanonymizes even tunneled traffic.
vpncheck() {
    _net_colors
    local vpn_if=$(_vpn_iface)
    if [[ -z "$vpn_if" ]]; then
        print -r -- "no VPN tunnel active -- nothing to check"
        return 2
    fi

    local leaks=0
    # Collect rows first so column widths size to actual content, not a guess.
    # Each row packs 5 fields (label, addr, via, verdict-color, verdict-text)
    # joined by \x1f (ASCII unit separator); the print loop below splits them
    # back apart with IFS=$'\x1f' read. aw/vw track the widest addr/via seen.
    local -a rows
    local aw=0 vw=0
    _vpncheck_row() {  # $1 label, $2 route-family, $3 probe-dest, $4 curl-flag, $5 echo-url
        local iface=$(_route_iface "$2" "$3")
        local addr via vc vt
        if [[ -z "$iface" ]]; then
            addr="n/a (no route)"; via=""; vc=$_C_NONE; vt=""
        else
            local exit_ip=$(curl "$4" -s --max-time 5 "$5" 2>/dev/null)
            addr="${exit_ip:-(no reply)}"
            if [[ "$iface" == "$vpn_if" ]]; then
                via="via $iface (vpn)"; vc=$_C_OK; vt="OK"
            else
                via="via $iface"; vc=$_C_BAD; vt="LEAK"; (( leaks++ ))
            fi
        fi
        (( ${#addr} > aw )) && aw=${#addr}
        (( ${#via}  > vw )) && vw=${#via}
        rows+=( "$1"$'\x1f'"$addr"$'\x1f'"$via"$'\x1f'"$vc"$'\x1f'"$vt" )
    }

    _vpncheck_row ipv4 -inet  1.1.1.1                 -4 https://api.ipify.org
    _vpncheck_row ipv6 -inet6 2606:4700:4700::1111    -6 https://api6.ipify.org

    # DNS: does the system resolver sit on the far side of the tunnel?
    local resolver=$(scutil --dns 2>/dev/null | awk '/nameserver\[0\]/ {print $3; exit}')
    if [[ -n "$resolver" ]]; then
        local fam=-inet; [[ "$resolver" == *:* ]] && fam=-inet6
        local dns_if=$(_route_iface "$fam" "$resolver")
        local dvia dvc dvt
        if [[ "$dns_if" == "$vpn_if" ]]; then
            dvia="via $dns_if (vpn)"; dvc=$_C_OK; dvt="OK"
        else
            dvia="via ${dns_if:-?}"; dvc=$_C_BAD; dvt="LEAK"; (( leaks++ ))
        fi
        (( ${#resolver} > aw )) && aw=${#resolver}
        (( ${#dvia}     > vw )) && vw=${#dvia}
        rows+=( "dns"$'\x1f'"$resolver"$'\x1f'"$dvia"$'\x1f'"$dvc"$'\x1f'"$dvt" )
    fi

    local row lbl addr via vc vt addr_col via_col ac
    for row in "${rows[@]}"; do
        IFS=$'\x1f' read -r lbl addr via vc vt <<< "$row"
        ac=$_C_IPV4; [[ "$addr" == *:* ]] && ac=$_C_IPV6
        [[ -z "$vt" ]] && ac=$_C_NONE   # no-route row: not an address, use the "none" color
        printf -v addr_col "%-${aw}s" "$addr"
        printf -v via_col  "%-${vw}s" "$via"
        printf '%s%-6s%s%s%s%s  %s%s%s  %s%s%s\n' \
            "$_C_LABEL"  "$lbl:"    "$_C_RESET" \
            "$ac"        "$addr_col" "$_C_RESET" \
            "$_C_SUFFIX" "$via_col"  "$_C_RESET" \
            "$vc"        "$vt"       "$_C_RESET"
    done

    print
    (( leaks )) && print -r -- "${_C_BAD}$leaks leak(s): traffic exiting around the tunnel${_C_RESET}" \
                || print -r -- "${_C_OK}no leaks: all traffic routes through the tunnel${_C_RESET}"
    return $(( leaks > 0 ))
}

# Start an HTTP server from a directory, optionally specifying the port
serve() {
    local port="${1:-8000}"
    sleep 1 && open "http://localhost:${port}/" &
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    python3 -c "import http.server; h = http.server.SimpleHTTPRequestHandler; h.extensions_map[''] = 'text/plain'; http.server.test(HandlerClass=h, port=$port)"
}
