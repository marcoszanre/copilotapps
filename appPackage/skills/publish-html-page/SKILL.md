---
name: publish-html-page
description: Builds a polished, self-contained HTML page — a one-pager, landing page, briefing or dashboard — from a meeting recap, account briefing, or the user's own description, then shows it in full with the exact target path and, only after explicit approval, publishes it as a commit into a brand-new folder in the marcoszanre/copilotapps GitHub repository. Use it whenever the user wants a page built or something published.
---

# Publish HTML Page

## Purpose

Turn something the seller has — a meeting recap, an account briefing, a proposal outline, a set of
numbers, or a plain description of what they want — into a **polished, self-contained HTML page**,
show it to them, get their **explicit approval**, and only then **publish it as a commit** into a
brand-new folder in the GitHub repository `marcoszanre/copilotapps`.

This skill covers the whole loop: author → preview → approve → publish. The approval step is not
optional and is not a formality. Nothing is ever written to GitHub without a clear, explicit
go-ahead from the user in the current conversation.

## When to invoke

Invoke this skill when the user wants a page built, or wants something published:

- "build me a landing page for the Contoso roundtable"
- "monta uma landing page pro evento X"
- "turn this recap into a one-pager I can share"
- "cria um dashboard HTML com esses números"
- "make an HTML summary of the Fabrikam account briefing"
- "publish it" / "pode publicar" / "ship it" — when a page has already been drafted in this conversation
- "what have I published so far?" — listing existing published pages

Do **not** invoke this skill for:

- Ordinary questions about meetings, accounts, email or files — those belong to **Meeting Prep**,
  **Follow-Up Summary** and **Account Research**.
- Requests to change code in the repository, review pull requests, or manage issues. This skill
  publishes generated pages; it is not a general-purpose repository editor.

### Chaining from the sales skills

The most common path is a chain. The user runs **Follow-Up Summary** or **Account Research**, likes
the result, and asks for it as a page. When that happens:

1. Reuse the content already produced in the conversation. Do not re-run the research and do not
   silently change the facts.
2. Carry the grounding with you. If the recap said "decision confirmed in the 12 March email from
   Ana Duarte", the page must not upgrade that into an unattributed statement of fact.
3. Apply the confidentiality check in Step 4 before anything reaches the repository — content that
   was fine inside Microsoft 365 is not automatically fine in a Git repository.

## Target repository

| Setting | Value |
|---|---|
| Owner | `marcoszanre` |
| Repo | `copilotapps` |
| Branch | `main` |
| Publish root | `pages/` |

Everything this skill writes goes under `pages/`. Never write to the repository root, and never
modify or delete files that this skill did not create — in particular never touch `appPackage/`,
`m365agents.yml`, `env/`, or any other project file. This repository holds the source of the very
agent you are running as; treat everything outside `pages/` as read-only.

## Folder naming convention

Every publish creates a **new folder**. Existing folders are never overwritten and never reused.

```
pages/<slug>-<YYYYMMDD>-<HHMM>/index.html
```

- `<slug>` — the page title, lowercased, ASCII only (strip accents: "Reunião" → "reuniao"),
  spaces and punctuation collapsed to single hyphens, trimmed to at most 40 characters, with no
  leading or trailing hyphen.
- `<YYYYMMDD>-<HHMM>` — the current date and time, 24-hour.
- The file is always named `index.html` so the folder is directly servable if GitHub Pages is ever
  enabled on the repository.

Examples:

```
pages/landing-evento-roundtable-20260811-1843/index.html
pages/contoso-account-briefing-20260812-0930/index.html
pages/q3-pipeline-dashboard-20260812-1615/index.html
```

If the computed folder already exists — which realistically only happens when publishing twice in
the same minute — append a short disambiguating suffix (`-2`, `-3`, …) rather than overwriting.
Confirm the final path with the user as part of the approval step, and state it again after the
commit succeeds.

Any additional assets belong **inside the same folder** (for example
`pages/<slug>-<stamp>/data.csv`). Never scatter files across the repository.

## Step-by-step behaviour

### Step 1 — Understand the page

Establish, briefly, before writing any markup:

- **Purpose and audience** — an event landing page, a customer-facing one-pager, an internal
  dashboard? Who opens it?
- **Content source** — content generated earlier in this conversation, content the user pastes in,
  or content retrieved from Microsoft 365 via the other skills.
- **Must-have sections** — hero, agenda, metrics, action items, contact/call to action.
- **Tone and branding** — customer-facing pages are more formal than internal ones.

Ask at most two clarifying questions, and only when the answer would genuinely change the page. If
the request is clear enough to attempt, build a first draft and let the user react to something
concrete — iterating on a draft is faster than an interrogation.

### Step 2 — Build the HTML with the code interpreter

Use the code interpreter to assemble and sanity-check the page rather than free-typing markup into
the chat. Use it to:

- generate the HTML document and verify it parses and is well-formed;
- compute anything derived — totals, percentages, growth rates, sorted or grouped tables — instead
  of doing arithmetic in your head;
- render charts as **inline SVG** and embed them directly in the document;
- verify that the finished file contains no external references and no obvious broken markup.

**Hard requirements for every page produced:**

1. **Self-contained, single file.** All CSS in a `<style>` block, all scripts (if any) inline, all
   images either inline SVG or a `data:` URI. No CDN links, no external stylesheets, no external
   fonts, no external JavaScript. The page must render correctly with no network access.
2. **Complete and valid.** `<!DOCTYPE html>`, `<html lang="…">`, `<head>` with `<meta charset="utf-8">`,
   a responsive `<meta name="viewport" content="width=device-width, initial-scale=1">`, and a
   meaningful `<title>`.
3. **Responsive.** A sensible max-width container, fluid layout via flexbox or grid, and at least
   one breakpoint so it is usable on a phone.
4. **Accessible.** One `<h1>`; a logical heading order; real semantic elements (`<header>`, `<main>`,
   `<section>`, `<table>`, `<footer>`); `alt` text on meaningful images; text and background colours
   with adequate contrast.
5. **Presentable by default.** A restrained modern style: a system font stack, generous whitespace,
   a small consistent colour palette, readable line length. Do not ship unstyled markup.
6. **Language.** Write the page in the language the user is using, unless they say otherwise.

Keep the page a reasonable size. If the content is genuinely large, prefer a summary page over an
enormous dump.

### Step 3 — Present the draft and the exact target path

Show the user what will happen. This is the approval gate and it must always contain **all four**
of the following:

1. **What the page is** — one or two lines of purpose.
2. **A structure summary** — the sections in order, so they can see the shape without reading the
   markup.
3. **The full HTML** — in a fenced code block. Never a fragment, never an ellipsis, never
   "…rest of the page unchanged". They approve exactly what will be committed.
4. **The exact target path** — repository, branch, folder and file name, spelled out in full, plus
   the commit message you intend to use.

Use this format:

```
### Proposed page: <title>

**Purpose:** <one or two lines>

**Structure:**
1. <section> — <what it contains>
2. <section> — <what it contains>
...

**Will publish to:** marcoszanre/copilotapps · branch `main`
**Path:** `pages/<slug>-<YYYYMMDD>-<HHMM>/index.html`  (new folder — nothing existing is touched)
**Commit message:** `<message>`

**HTML:**
```html
<!DOCTYPE html>
...
```

Reply **publish** to commit this to GitHub, or tell me what to change.
```

### Step 4 — Confidentiality check before publishing

Before asking for approval, review the page as if it were about to leave the company, because it
is. Never publish, and always flag to the user, if the page contains:

- credentials of any kind — tokens, API keys, client secrets, passwords, connection strings,
  certificates. These must never appear in a generated page under any circumstances, and there is
  no user approval that makes it acceptable.
- personal data pulled from Microsoft 365 — home addresses, personal phone numbers, personal email
  addresses, salary or performance information.
- internal-only commercial detail — deal sizes, discounting, margins, pipeline forecasts, competitive
  intelligence, unannounced roadmap, legal or contractual disputes.
- verbatim customer communications that the customer would not expect to see republished.

For anything in the last three categories, call it out explicitly and ask the user to confirm it is
acceptable to publish before proceeding:

> ⚠️ This page includes internal commercial detail (Q3 pipeline figures per account). The repository
> is private, but this still leaves Microsoft 365. Confirm you want these published, or say "remove"
> and I will drop that section.

For credentials, do not ask — remove them and say what you removed.

### Step 5 — Wait for explicit approval

**Do not call any GitHub write tool until the user has approved in this conversation.**

- Approval is an affirmative response to the proposal you just showed: "publish", "yes", "go ahead",
  "pode publicar", "ship it", "aprovado", "looks good, publish it".
- Silence, a follow-up question, "nice", "interesting", or a change request is **not** approval.
- If the user asks for changes, revise the page, then present the **full proposal again** — updated
  structure, updated full HTML, updated path — and ask again. Every iteration gets its own approval.
- If the user approves an *older* draft after you have since changed the page, re-confirm which
  version they mean rather than guessing.
- Approval covers exactly one publish. Publishing a second page, or republishing after an edit,
  requires a fresh approval.
- If the user opens with "build and publish X" in a single sentence, you still show the proposal and
  still ask. A pre-authorisation given before the page existed is not approval of the page.

Never describe a publish as done before the tool call has actually succeeded.

### Step 6 — Publish via the GitHub connector

Publishing happens entirely through the GitHub MCP connector — the commit is created server-side
through the GitHub API. There is no local git, no clone, no working copy, and nothing to push by
hand.

**Single file (the normal case — a page and nothing else):** use `create_or_update_file`.

| Parameter | Value |
|---|---|
| `owner` | `marcoszanre` |
| `repo` | `copilotapps` |
| `branch` | `main` |
| `path` | `pages/<slug>-<YYYYMMDD>-<HHMM>/index.html` |
| `content` | the full HTML, **as plain text** — do not base64-encode it, the server does that |
| `message` | the commit message |
| `sha` | omit — this is always a new file in a new folder |

`sha` is only required when replacing a file that already exists. Because this skill always creates
a new folder, you should never need it. If a call fails asking for a `sha`, do not fetch it and
overwrite — you have collided with an existing file; pick a new folder name instead.

**Multiple files in one commit** (page plus assets): use `push_files` with `owner`, `repo`,
`branch`, `message` and `files` — an array of `{ path, content }` objects. This produces a single
commit containing every file.

**Commit messages.** Be descriptive and specific. Never "update" or "add file".

```
Add Contoso roundtable landing page (pages/landing-evento-roundtable-20260811-1843)
Publish Fabrikam account briefing one-pager
Add Q3 pipeline dashboard with per-region breakdown
```

**First publish into an empty repository.** The repository may have no commits and no materialised
default branch yet. Prefer `create_or_update_file` for the very first publish: creating a single
file can establish the initial commit and the default branch. `push_files` builds on an existing
branch reference and may fail on a repository with no commits. If a publish fails with a message
about a missing branch, missing reference, or an empty repository, say so plainly and explain that
the repository needs an initial commit before pages can be published — do not silently retry with a
different branch, and do not attempt to create a repository.

### Step 7 — Confirm what happened

After a successful publish, report:

- the file path that was committed;
- the commit message, and the commit SHA and URL if the tool returned them;
- the repository and branch;
- a one-line reminder that the repository is private, so the page is visible only to people with
  access to it.

```
✅ Published to marcoszanre/copilotapps

**Path:** pages/landing-evento-roundtable-20260811-1843/index.html
**Branch:** main
**Commit:** "Add Contoso roundtable landing page" · a1b2c3d
**Link:** <url if returned>

The repository is private, so only people with access to it can open this page.
```

If the publish fails, report the actual error and what it means. Never claim success on a failed
call, and never describe a page as published when only a draft exists.

## Listing what has been published

When the user asks what has already been published, read `pages/` in the repository and list the
folders, newest first, deriving the date from the folder name. If `pages/` does not exist or the
repository has no commits, say exactly that — "nothing has been published yet" — rather than
inventing entries.

## Guardrails

- **Approval is mandatory and per-publish.** No GitHub write tool is ever called before an explicit
  go-ahead for the specific version being published. There is no "the user said yes earlier" and no
  "this is obviously what they wanted".
- **Never overwrite.** Every publish creates a new folder. Never modify or delete an existing file,
  and never touch anything outside `pages/`.
- **Never invent content.** When the page presents facts drawn from Microsoft 365 content — meeting
  outcomes, account history, names, dates, numbers — those facts must come from retrieved items. Do
  not pad a page with plausible filler, invented testimonials, fake metrics or made-up quotes. If a
  section lacks real content, either omit it or mark it clearly as a placeholder for the user to
  complete.
- **Never publish secrets.** Tokens, API keys, secrets, passwords, connection strings and
  certificates never go into a generated page. This is absolute.
- **No external dependencies.** A published page must render with no network access. No CDNs, no
  external fonts, no remote images, no external scripts.
- **Say when something is missing.** If a tool returns nothing, if the repository is empty, or if
  content the user referred to cannot be found, state it plainly. Do not fill the gap with
  assumptions.
- **Report tool failures honestly.** If a GitHub call fails — authentication, permissions, a missing
  branch — say what failed and what it means. An authentication or permission error means the user
  needs to sign in to GitHub or lacks write access; it does not mean the page was published.
- **Stay in scope.** This skill builds and publishes pages. It does not refactor the repository,
  open pull requests, manage issues, or change project configuration.

## First-time GitHub sign-in

The first time this skill needs GitHub, Microsoft 365 Copilot shows a sign-in prompt for the GitHub
connection. The user signs in with their GitHub account and authorises access; the authorisation is
remembered for later turns.

If the user has not authorised, or their GitHub account cannot write to `marcoszanre/copilotapps`,
publishing fails with an authentication or permission error. Explain that they need to complete the
GitHub sign-in and have write access to the repository. Do not retry in a loop, and do not offer any
alternative route — there is no local git fallback.
