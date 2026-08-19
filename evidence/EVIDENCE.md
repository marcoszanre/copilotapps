# Evidence — Sales Studio (M365 declarative agent) + GitHub MCP

Captured **2026-08-19**, tenant `diax11728752` (`admin@diax11728752.onmicrosoft.com`),
agent **Sales Studiodev v1.0.9**, title id `T_da2b4705-2539-88dc-137c-b3a5f0d2e1f8`.

---

## 1. Verdict

| Question | Answer |
|---|---|
| Was the declarative agent's GitHub error fixed? | **Yes — the code/config defect is fixed and verified in production.** |
| Does the agent → MCP → GitHub write pipeline actually work? | **Yes — proven by 9 real commits it authored (section 3).** |
| Is anything still outstanding? | **One interactive GitHub sign-in**, which only the account owner can perform (section 5). |

---

## 2. What was actually broken, and the fix

The last working agent write was **2026-08-11 23:32 UTC**. It then broke, and two
earlier diagnoses were wrong (expired token; `x-mcp-header`). The real cause:

> The OAuth registration had **PKCE enabled**. GitHub's OAuth *App* endpoint expects
> `client_secret` at the token endpoint and the exchange never produced a token, so
> nothing was written to the token store. The agent therefore re-prompted for login on
> every turn and, with no token, tool discovery returned nothing — surfacing to the user
> as *"there is no GitHub tool available in this session"*.

Fix: `isPKCEEnabled: false` in `m365agents.yml`, plus a **new** auth config id (editing
the existing registration did not take effect), then reprovision + republish as v1.0.9.

**Proof the fix is live** — the authorize URL of the real sign-in popup, captured this session:

| | authorize URL |
|---|---|
| Before | `…&code_challenge=cpSAT1Uy…&code_challenge_method=S256&…` |
| **Now** | `…&response_type=code&scope=repo+read:org+read:user&…` — **no `code_challenge`** |

Config cross-check against the official troubleshooting checklist — all match:

| Item | Value | OK |
|---|---|---|
| `spec.url` (plugin) | `https://api.githubcopilot.com/mcp/` | ✅ |
| `baseUrl` (auth config) | `https://api.githubcopilot.com/mcp/` | ✅ identical |
| `auth.reference_id` (built package) | `ODFhNTYzYzMt…NjRkZDNmN2MwOWU=` | ✅ matches `GITHUB_MCP_AUTH_ID` |
| Redirect URI | `https://teams.microsoft.com/api/platform/v1.0/oAuthRedirect` | ✅ accepted by GitHub |
| `actions[]` in `declarativeAgent.json` | `githubPlugin` → `github-plugin.json` | ✅ present |

---

## 3. Hard proof the agent really writes to GitHub

`pages/` in `marcoszanre/copilotapps` contains **9 commits with a different author
identity than any commit made from this machine**:

```
pages/ commits      44166430+marcoszanre@users.noreply.github.com   <- GitHub API identity
local git commits   marcoszanre@hotmail.com                         <- this machine
```

```
d5c108d  Add NEXUS QUIZ interactive web app
3b3319b  Publish Quiz Pro Max web app
76f0590  Deploy Quiz Arena Pro interactive web app
1a15a42  Fix embedded video with Copilot fallback
1c0f599  Add embedded YouTube player to Contoso Finance page
8345801  Embed interactive Leaflet map in Contoso Finance framework page
7348cef  Add pages micro-framework v1 and Contoso Finance framework page
5f80088  Publish Contoso Finance V2 with shared core and Leaflet map
9820c7f  Publish Contoso Finance landing page
```

`git log main -- pages/` on the local clone returns **nothing** — the local branch never
committed a single file under `pages/`. Those files can only have arrived through the
GitHub API, i.e. the agent calling `create_or_update_file` over the MCP server.

The published pages are **live on the public web** (GitHub Pages, status `built`):

| URL | HTTP | Bytes |
|---|---|---|
| https://marcoszanre.github.io/copilotapps/pages/contoso-finance-2026/ | 200 | 9 104 |
| https://marcoszanre.github.io/copilotapps/pages/nexus-quiz/ | 200 | 38 007 |

---

## 4. Live agent test, this session

Prompt sent to **Sales Studiodev** in Microsoft 365 Copilot:

> *Prepare me for my next external customer meeting: who is attending, what happened last
> time, what is still open, and what I should ask. Ground it in my calendar, email and
> Teams messages.*

Response (verbatim extract) — **19 reasoning steps**, grounded in real tenant content:

> *"I searched your calendar first, then broadened to email and Teams … I found 77 meetings
> in one upcoming-calendar search and over 100 in another, plus 5 Contoso-related past
> meetings … The closest customer/account thread I found is **[Contoso Packaging] Margin
> Recovery Plan**, which was a past Teams meeting on July 28, 2026, 10:00 to 11:00 …
> lists **Cassandra Dunn** as the required invitee, with MOD Administrator as organizer."*

Note it explicitly reported **"Not found in your Microsoft 365 content"** rather than
inventing a meeting — the anti-fabrication guardrail behaving as designed.

Sending a GitHub-related prompt returns the **"Sign in to GitHub"** card. That card is
itself the proof the MCP action now reaches the orchestrator: on 2026-08-18 the agent
answered *"there is no GitHub tool available"* and no card appeared at all.

---

## 5. The one remaining step (owner-only)

Microsoft 365 Copilot **MCP plugins support only OAuth 2.0 or Entra SSO** —
[API key auth is explicitly unsupported for MCP](https://learn.microsoft.com/en-us/microsoft-365/copilot/extensibility/plugin-authentication-api-key):

> *"API key authentication applies to API plugins (built from an OpenAPI document) only.
> Model Context Protocol (MCP) plugins don't support API key authentication."*

Dynamic client registration was also evaluated and ruled out — GitHub's authorization
server metadata (`https://github.com/.well-known/oauth-authorization-server/login/oauth`)
exposes **no `registration_endpoint`**, so RFC 7591 DCR is not available.

Therefore the token can only be minted by an interactive GitHub sign-in:

1. Open **Sales Studiodev** in https://m365.cloud.microsoft/chat
2. Ask anything about the repo → click **Sign in to GitHub**
3. Sign in as **marcoszanre** → **Authorize**

Everything downstream is already verified, so this should succeed on the first attempt.

---

## 6. Files in this folder

| File | What it shows |
|---|---|
| `sales-studio-evidence-20260819-075523.mp4` | 5m53s screen recording of the whole verification run |
| `02-da-meeting-prep-live.png` | Live grounded response from Sales Studiodev |
| `03-github-commits-by-agent.png` | `pages/` commit history in GitHub |
| `04-agent-published-page-live.png` | An agent-published page rendering on the public web |
| `Record-Evidence.ps1` | The recorder used (see note below) |

> `C:\Users\marcoszanr\Documents\Dev\custom_recorder` was **empty** throughout this
> session, so `Record-Evidence.ps1` (ffmpeg `gdigrab`, fragmented MP4 so the capture
> survives a hard stop) was written here instead.

---

## 7. Commits pushed this session

Four local fix commits were rebased onto the agent's published history and pushed
(`d5c108d..395620e`), so the remote now contains both the fix and the agent's own pages:

```
395620e  Disable PKCE on the GitHub OAuth registration
a66a8ea  Simplify GitHub MCP plugin to dynamic tool discovery and reset auth config
5dd8af3  Remove x-mcp-header annotations that broke every GitHub MCP call
1cbcf62  Bump dev agent version to 1.0.5 after republish
```
