# Agent policy

Coding agents must not inherit the privileged CLIs that are installed and
logged in on this machine. Your own terminal keeps full access. Agents keep
local development: git, package managers, tests, linters, builds, Docker.

Permission prompts and repo instructions are not a boundary. The layers below
are.

## Denied to agents

- **Always:** `heroku`, `fly`, `flyctl`, `wrangler` (also through `npx` or
  `npm exec`), `aws`, `az`, `gcloud`, `kubectl`, `terraform`, `tofu`, `doctl`.
- **`gh`, partly:** `auth`, `secret`, `variable`, `release`, `workflow`, `api`,
  `repo delete`, `repo edit`, `pr merge`. Reads such as `gh pr view`, `pr list`,
  `pr checks`, `pr diff`, `run list`, `run view`, `issue view`, and
  `issue list` are allowed. `gh pr create` and `gh pr comment` ask first.
  `gh api` is denied whole because its method flag can go anywhere.

When an agent needs one of these, it should hand you the command to run.

## Layers

| Layer | Claude Code | Cursor |
| ----- | ----------- | ------ |
| Command rules | `permissions.deny` in each config dir. Match the start of the command only. | None. Cursor's allowlist and Auto-review are not a boundary. |
| Hook | `bin/agent-deny` as a `PreToolUse` hook. Reads the whole command, so it also catches `sh -c`, absolute paths, `env`, `npx`, `$(...)`. | The same script as a `beforeShellExecution` hook. Answers deny or ask, never allow. Fails closed. |
| Credentials | The sandbox hides `~/.netrc`, `~/.aws`, `~/.azure`, `~/.fly`, `~/.config/gh`, `~/.kube`, `~/.config/gcloud`, wrangler's config, `~/.docker/config.json`, and gpg private keys, and strips cloud token variables. `Read` deny rules cover the same paths for Claude's file tools. | No per-file read control. |
| Network | Open web: agents may fetch and download from any host. Control-plane APIs and `github.com` are on a deny list that wins over any allow. | `sandbox.json` allows package registries, plus Cursor's built-in package hosts, and denies the same hosts as Claude. Cursor treats this file as an allowlist whatever `default` says, and its only open mode, "Allow All", drops the deny list. With no credential hiding in Cursor, it stays closed. |

Claude's sandbox settings also set these:

- **`allowUnsandboxedCommands: false`**, so Claude can't retry a blocked
  command outside the sandbox.
- **`failIfUnavailable: true`**, so Claude refuses to run rather than run
  without a sandbox.
- **`autoAllowBashIfSandboxed: false`**, so you still get the same prompts as
  before. Turn it on to let sandboxed commands run without asking.

These run outside the sandbox, because they can't work inside it:

- **`docker`** can't run under the macOS sandbox at all.
- **`gh`** is a Go program, and Go programs fail TLS verification there.
- **`git push`, `fetch`, `pull`, and `ls-remote`** need SSH, which the
  sandbox's proxy doesn't carry.

They still go through the command rules, the hook, and the normal prompts.

## Files

| File | Linked to | Holds |
| ---- | --------- | ----- |
| `claude/settings.json` | copied into each Claude config dir | deny rules, gh read allows, hook, sandbox |
| `bin/agent-deny` | `~/bin/`, `~/.cursor/hooks/` | the hook, with the same tool list |
| `cursor/hooks.json` | `~/.cursor/hooks.json` | runs the hook for commands that mention a listed tool |
| `cursor/sandbox.json` | `~/.cursor/sandbox.json` | Cursor network policy |
| `claude/managed-settings.json` | optional, see below | the hook only |

Every Cursor instance shares `~/.cursor`, so isolated Cursor identities get the
same policy. Each Claude config dir has its own copy of the baseline.

## MCP server keys

Put an MCP key in the org's `.envrc`, not in a repo's `.env`:

- **`.envrc` reaches the editor.** direnv loads it into your shell when you
  enter the org folder, and `c` launches the editor from that shell. The
  editor, the agent, and the MCP servers the agent starts all inherit it. A
  repo's `.env` is only read by the app, when something like `uv run` or a
  Makefile loads it. The MCP config can't see it.
- **`.envrc` is scoped to the org.** Only that org's editor instance gets the
  key, and the file sits outside every repo, so it is never committed.
- **Both files are hidden from agents,** so an agent can't read the key from
  either one.

The key never goes in `settings.local.json`. Claude reads MCP servers from a
repo's `.mcp.json`, and Cursor from `.cursor/mcp.json`. Both fill in values
from the environment, so the committed file holds only the variable's name.

### Example

An org called acme uses a service whose MCP server accepts a key in a header.

1. **Store the key** in the Keychain, once:

   ```bash
   security add-generic-password -a "$USER" -s acme-service-api-key -w
   ```

2. **Load it in the org's `.envrc`,** after the context line, then run
   `direnv allow`:

   ```bash
   dev_context acme code
   export SERVICE_API_KEY="$(security find-generic-password -s acme-service-api-key -w)"
   ```

3. **Reference it from the repo's MCP config.** For Claude, in `.mcp.json`:

   ```json
   { "mcpServers": { "service": { "type": "http", "url": "https://mcp.service.example/mcp",
     "headers": { "Authorization": "Bearer ${SERVICE_API_KEY}" } } } }
   ```

   For Cursor, in `.cursor/mcp.json`, write the value as
   `"Bearer ${env:SERVICE_API_KEY}"`.

4. **Optional: strip it from Claude's shell commands.** Skip this when the
   agent can already use the service through the MCP server anyway. Do it for
   a key that could do real damage if copied, such as payments, databases, or
   cloud accounts. Add it to the context's `~/.claude-acme/settings.json`. The
   baseline merge keeps additions like this:

   ```json
   { "sandbox": { "credentials": { "envVars": [{ "name": "SERVICE_API_KEY", "mode": "deny" }] } } }
   ```

5. **Restart the editor,** since it only reads the environment at launch. Close
   that org's windows, then run `c` again.

The MCP server runs outside the sandbox, so it gets the key. The agent's shell
commands don't. Cursor has no way to strip a variable, so in Cursor the agent's
terminal can see the key.

- **OAuth servers need none of this.** Claude keeps their tokens in the
  Keychain entry for the context's config dir, never in the environment, so
  each context has its own login. Either approach is fine. OAuth just has
  fewer steps to get right.
- **claude.ai connectors follow the account, not the config dir.** Two
  contexts logged into the same claude.ai account see the same connectors.

## Change the policy

**Add a denied tool.** Edit four places, then update the Claude config dirs:

1. `claude/settings.json`: add `Bash(<tool> *)` to `permissions.deny`.
2. `bin/agent-deny`: add it to `DENY_TOOLS` and to the fast-path pattern.
3. `cursor/hooks.json`: add it to the matcher.
4. If it has a credential file, add it to `sandbox.credentials.files` and as a
   `Read(...)` deny. If it has an API host, add it to both network deny lists.

**Update existing Claude config dirs.** `dev-context-init` copies the baseline
into a new context only. For existing ones, including personal `~/.claude`,
merge it in. The merge keeps each dir's own rules and settings, and the
baseline's security switches always win:

```bash
for d in ~/.claude ~/.claude-*; do
  cp "$d/settings.json" "$d/settings.json.bak"
  jq -s -f ~/.dotfiles/claude/merge.jq \
    ~/.dotfiles/claude/settings.json "$d/settings.json.bak" > "$d/settings.json"
done
```

A merge adds back any deny rule an exception removed, so apply exceptions again
afterwards.

## Exceptions for one context

An exception is a deliberate edit for one context, never a repo setting:

1. In that context's `.envrc`, let the hook through: `export AGENT_ALLOW="tofu"`.
2. In that context's `~/.claude-<name>/settings.json`, replace the wholesale
   deny with narrower ones. A repo can't grant this, because a deny in any
   scope beats any allow.
3. Allow the hosts it needs in that config dir's `sandbox.network.allowedDomains`.
4. Pair it with a narrow credential selected in the same `.envrc`.

Worked example, Terraform plan without apply:

- **Command rules:** replace `Bash(tofu *)` with denies for `tofu apply`,
  `destroy`, `import`, `state`, `taint`, `untaint`, `force-unlock`, and
  `workspace delete`. Allow `plan`, `validate`, `fmt`, `init`, and `show`.
  Leave `output` asking, since outputs can hold secrets.
- **Network:** allow the state backend and provider API hosts.
- **Credential:** in the `.envrc`, set `AWS_PROFILE` to a read-only role. That
  makes apply impossible at the IAM layer whatever the agent runs. Do not
  enable plan in a context whose credentials can write.

Note that prefix denies miss global flags placed before the subcommand, such as
`tofu -chdir=infra apply`. The read-only credential is the real limit.

## What this does not cover

- **A repo can weaken Claude's sandbox on purpose.** A repo's
  `.claude/settings.json` can add `excludedCommands`, and in testing that let
  `sh -c 'heroku ...'` run with your real login. The hook stops that unless the
  same file also sets `disableAllHooks`, which a repo can do. The docs also
  suggest a trusted repo can set `sandbox.enabled: false`. Only managed
  settings survive this, see below. Glance at `.claude/settings.json` when you
  clone a repo you don't control.
- **The Claude command rules only match the start of a command.** That is why
  the hook and the sandbox exist.
- **The hook is a pattern check, not a shell parser.** It can deny a harmless
  command that puts a tool name at the start of a line, for example inside a
  heredoc. The agent can use a file-editing tool instead. It does not look
  inside backtick substitution, so the sandbox is the layer there.
- **Commands outside the sandbox keep their full reach.** `docker`, `gh`, and
  git's network commands skip file and network isolation. Docker in particular
  can mount any file into a container. Pre-push hooks run outside the sandbox.
- **Sandboxed commands can reach the macOS Keychain.** git's Keychain helper
  can return a GitHub credential inside the sandbox. An entry's own access
  rules decide whether its secret comes back without a prompt. That is why
  `github.com` and the GitHub API hosts are on the sandbox deny list. Any other
  token kept in the Keychain is readable too, so its service's API host belongs
  on that list.
- **Env files are hidden, so agent test runs that need them fail.** `.envrc`,
  `.env`, `.env.local`, `.env.*.local`, `.env.production`, `.env.prod`,
  `.env.staging`, and `.env.*secrets*` are hidden from Claude's file tools and
  sandbox, and from Cursor's file reads and shell. `.env.example` and
  `.env.test` stay readable. A repo whose tests load `.env` needs a
  non-secret file such as `.env.test` for agents. Secrets in other files, or
  in environment variables not on the list, are still visible.
- **`~/.ssh` stays readable,** so agents can push. Pushing still asks first.
- **Web fetches and MCP servers are outside the sandbox.** Claude's WebFetch
  tool runs outside the sandbox, and MCP servers such as Linear or Sentry use
  their own credentials. A `WebFetch(domain:*)` allow rule in any settings
  file also opens the sandbox network to every host except the deny list.
- **Your own typing is unrestricted.** Commands you type at Claude's `!`
  prompt, your terminal, and the editor itself are not sandboxed.
- **Cursor's sandbox is not a wall.** A command Cursor can't sandbox goes to
  its AI reviewer, which can approve it. The hook is Cursor's hard layer. The
  "Allow All" network mode ignores `sandbox.json`, so don't pick it.
- **The Cursor CLI** (`agent`) is not installed and not configured here.

## Optional: make the hook repo-proof

A managed settings file applies to every Claude config dir and can't be
switched off by a repo, including by `disableAllHooks`. Install it with the
hook alone:

```bash
sudo mkdir -p "/Library/Application Support/ClaudeCode"
sudo cp ~/.dotfiles/claude/managed-settings.json "/Library/Application Support/ClaudeCode/managed-settings.json"
```

It holds only the hook, so exceptions through `AGENT_ALLOW` still work.

## Check it

- **Claude:** run `/sandbox` in any context to see the active policy. Ask the
  agent to run `heroku auth:whoami`, and expect a denial.
- **Cursor:** in a Cursor context window, ask the agent to run `heroku auth:whoami`
  and `sh -c 'gh api user'`. Expect "Blocked by agent policy". In Cursor
  Settings, under Agents and then Approvals & Execution, check that the
  network mode is not "Allow All".
