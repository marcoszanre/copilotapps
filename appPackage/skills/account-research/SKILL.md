---
name: account-research
description: Builds an internal briefing on a named customer or account — who at our company touches it, engagement history and cadence, open opportunities, open issues, and a short "what you need to know" — from email, meetings, Teams messages, files and people data. Use it when the user asks about an account rather than a specific meeting.
---

# Account Research

Answer "what is going on with this customer?" using only what our own organization already knows about
them. This is an internal briefing, not a market report.

## When to use this skill

- The user names a customer or account and wants the picture: "brief me on Contoso", "what's our
  history with Fabrikam?", "tell me everything we know about Northwind".
- Relationship mapping: "who at our company works with Contoso?", "who owns the Fabrikam relationship?"
- Engagement and health questions: "how engaged is Contoso lately?", "what's open with Northwind?",
  "have we gone quiet on Fabrikam?"
- Handover and onboarding: "I'm taking over the Contoso account — what do I need to know?"

Do **not** use this skill when the user is preparing for a specific upcoming meeting — that is
**Meeting Prep** (which is shorter and meeting-shaped). Do **not** use it to recap a meeting that
happened — that is **Follow-Up Summary**.

## Inputs you need

| Input | How to resolve it |
| --- | --- |
| The account | The name the user gave. Resolve it to an email domain and to name variants (legal name, abbreviation, product/project code names used internally). If nothing matches, ask for the domain or an alternate spelling before giving up. |
| Time window | Default: last 6 months for engagement history, last 12 months for opportunities and issues. State the window. Widen on request or if results are thin. |
| Depth | Full briefing by default. If the user asked one narrow question ("who owns this?"), answer just that section and offer the full briefing. |

## How to do it

1. **Resolve the account.** Establish the email domain(s) and internal aliases. Say which you used —
   if the user meant a different Contoso, this is where they will catch it.
2. **Map the people.**
   - *Their side*: named contacts, titles, and how recently and how often each has appeared.
     Note who is most responsive and who has gone quiet.
   - *Our side*: colleagues who appear on threads, meetings, chats and documents for the account, with
     their role and the recency/volume of their involvement. Identify the apparent primary owner from
     evidence — and say it is an inference, not a system of record.
3. **Reconstruct the engagement history.** Walk the timeline: meetings held, major email threads,
   documents produced (proposals, decks, SOWs, QBRs), and notable milestones. Report cadence in plain
   terms — how often we meet, when the last contact was, whether the trend is up or down.
4. **Find open opportunities.** Anything in flight: proposals sent, pricing discussed, renewals or
   expansions raised, pilots or POCs, stated budget or timeline. Capture the value and stage **only if
   stated somewhere** — never estimate.
5. **Find open issues.** Escalations, support problems, missed dates, unresolved questions,
   dissatisfaction, contract or compliance blockers. Note whether each looks open or resolved and how
   you can tell.
6. **Write "What you need to know".** Three to five sentences at the top of the briefing: the single
   most important thing, the state of the relationship, and the most urgent next action. This is a
   synthesis of the evidence below, not new information.
7. **Assemble the output** in the exact structure below.

## Output format

```
# Account briefing: <Account>
Resolved to: <domain(s) / aliases used> · window: <window used> · sources: <email, meetings, Teams, files, people>

## What you need to know
3–5 sentences: the headline, the state of the relationship, the most urgent next action.

## Key contacts — their side
| Name | Title | Last contact | Engagement | Source |
| ---- | ----- | ------------ | ---------- | ------ |

## Who touches this account — our side
| Name | Role / involvement | Recent activity | Source |
| ---- | ------------------ | --------------- | ------ |
Apparent primary owner: <name> *(inferred from activity, not from a system of record)*

## Engagement history
- <Date> — <what happened> (source: <where>)
Cadence: <e.g. "roughly monthly since March; last contact 18 days ago">

## Open opportunities
| Opportunity | Stage / status | Value | Timeline | Source |
| ----------- | -------------- | ----- | -------- | ------ |
(Value and timeline only where explicitly stated; otherwise "not stated".)

## Open issues and risks
| Issue | Raised by | Raised on | Status | Source |
| ----- | --------- | --------- | ------ | ------ |

## Suggested next actions *(suggestions, not retrieved facts)*
- ...

## Gaps
- Not found in your Microsoft 365 content: <what is missing and why it matters>.
```

## What to watch for

- **This is internal knowledge only.** You have no CRM, no market data and no public web. If the user
  asks about the customer's financials, funding, headcount, competitors or news, say that is outside
  what you can see and offer the internal picture instead.
- **Never invent a contact, title, deal value, stage, or date.** "Not stated" is always the right
  answer when it was not stated. Never estimate a deal size.
- "Apparent owner", "most active", and "seems to have gone quiet" are inferences from activity —
  always label them as such.
- Distinguish "no activity found" from "nothing is happening"; you can only report the former.
- Absence of a reply is not proof of a problem. Report the silence and its length, not a verdict.
- Watch for account-name collisions (two similarly named customers, or a project code name reused).
  If the evidence looks like two different companies, stop and ask.
- Keep personal, HR, compensation and performance content about colleagues out of the briefing.
- If the account is genuinely not found, say where you looked and over what window, and ask for the
  email domain or an alternate name — do not return an empty template.
