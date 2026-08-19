# Working notes for agents in this repo

Hard-won context for anyone (human or agent) picking up **Sales Studio**. These are
things that cost real debugging time — read them before changing auth or claiming
something works.

## What this repo is

Two agents that mirror each other:

| | Where | Identity |
|---|---|---|
| **Sales Studio** — M365 declarative agent | this folder, deployed via `wiqd` / Agents Toolkit | `Sales Studiodev`, title id `T_da2b4705-2539-88dc-137c-b3a5f0d2e1f8` |
| **Sales Studio 2** — Copilot Studio replica | `..\..\cps_sales_studio_v2\Sales Studio 2` | bot `693cf076-699b-f111-b8de-70a8a5b2f7b1`, env `diamond-dev` |

Both publish HTML pages into `pages/` in this repo through the **GitHub MCP server**
(`https://api.githubcopilot.com/mcp/`), only after explicit user approval.

## Auth rules for the GitHub MCP plugin — do not re-litigate these

- **MCP plugins support only OAuth 2.0 or Entra SSO.** API key auth is *explicitly
  unsupported* for `RemoteMCPServer` runtimes, even though `ApiKeyPluginVault` is a valid
  value in the v2.4 plugin schema. Don't "simplify" it to an API key — it will not work.
- **Dynamic client registration is not available.** GitHub's authorization server metadata
  (`https://github.com/.well-known/oauth-authorization-server/login/oauth`) has no
  `registration_endpoint`, so RFC 7591 DCR is out.
- **Keep `isPKCEEnabled: false`.** GitHub's OAuth *App* endpoint expects `client_secret` at
  the token endpoint; with PKCE on, the exchange silently never mints a token. The symptom
  is misleading: the agent re-prompts for sign-in every turn and reports *"there is no
  GitHub tool available"*, which looks like a missing tool rather than an auth failure.
- **Editing an existing auth config may not take effect.** When the PKCE change didn't
  apply, the fix was to blank `GITHUB_MCP_AUTH_ID` and let `provision` mint a fresh one.
- A **user-delegated GitHub sign-in is unavoidable** and can only be done by the account
  owner. Do not attempt to work around it by extracting browser cookies or session state.

## Validation is not proof

This has now burned this project twice:

- A build passed **59/59 deep validation** and shipped an agent with **no tools at all** —
  `agentConnectors[]` was set in the app manifest but `declarativeAgent.json` had no
  `actions[]`.
- A Copilot Studio push validated **20/20 files, 0 errors, 0 warnings** and then failed
  server-side with `[0x80040265:IsvAborted] "A record with the specified key values does
  not exist in connectionreference entity"` — an unreplaced `_REPLACE_with_...` placeholder.

**Always verify against the live surface**, not the package: send a real prompt to the
deployed agent and read the actual response.

## How to prove the pipeline actually wrote to GitHub

Author identity distinguishes agent writes from local ones:

```
44166430+marcoszanre@users.noreply.github.com   -> written via the GitHub API (the agent)
marcoszanre@hotmail.com                          -> written from a local git clone
```

`git log main -- pages/` on a local clone returns nothing, so anything under `pages/`
arrived through the MCP. Published pages are served at
<https://marcoszanre.github.io/copilotapps/>.

## Getting live evidence cheaply

- **Copilot Studio:** use the **Test pane** in an already-authenticated browser session.
  Standing up an SDK/DirectLine client needs its own interactive Entra token and is much
  slower.
- **Browser automation:** launch Edge with an **explicit `--user-data-dir`** —
  Edge 136+ silently ignores `--remote-debugging-port` on the default user-data-dir, and
  the only symptom is connection-refused on port 9222. The diax tenant profile is
  `Profile 16`.
- `evidence/Record-Evidence.ps1` wraps ffmpeg `gdigrab` for screen capture and writes a
  fragmented MP4 so the file stays playable even if the recorder is killed.

## Secrets

`GITHUB_MCP_CLIENT_ID` / `GITHUB_MCP_CLIENT_SECRET` live in `env/.env.dev.user`, which is
gitignored. Never commit them, and never echo the secret into output.
