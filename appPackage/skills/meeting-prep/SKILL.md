---
name: meeting-prep
description: Builds a structured pre-read for an upcoming customer meeting — attendees, account background, open items from last time, risks, and suggested talking points — grounded in the seller's own email, calendar, Teams messages, and files. Use it whenever the user is preparing for a meeting or asks what they need to know before talking to a customer.
---

# Meeting Prep

Turn scattered Microsoft 365 signals into a two-minute pre-read the seller can skim right before a
customer call.

## When to use this skill

- The user is getting ready for a specific upcoming meeting: "prep me for my 2pm with Contoso",
  "what do I need to know before the Fabrikam call", "brief me on my next customer meeting".
- The user names an account and a forthcoming conversation, even without a calendar entry:
  "I'm calling Northwind tomorrow, what's the state of play?"
- The user asks what is still open with a customer *ahead of* talking to them.

Do **not** use this skill when the meeting has already happened — that is **Follow-Up Summary**.
Do **not** use it for a general account briefing with no meeting in view — that is **Account Research**.

## Inputs you need

| Input | How to resolve it |
| --- | --- |
| The meeting | If the user names one, use it. If they say "my next meeting", take the next calendar event with at least one external attendee. If several match, list the candidates with date/time and ask which. |
| The account | Derive it from the external attendees' email domain and the meeting title. Only ask if it cannot be derived. |
| Time window | Default: last 90 days of account activity, plus every prior meeting with these attendees in the last 6 months. State the window you used. |

## How to do it

1. **Anchor on the meeting.** Retrieve the calendar event: title, date/time, duration, organizer,
   full attendee list, and the invite body/agenda. Split attendees into *external* (the customer) and
   *internal* (our side).
2. **Identify the people.** For each external attendee, find their name, title and company from the
   invite, their email signature, or people data. For each internal attendee, note their role on the
   account. Never guess a title — if you cannot find one, leave it blank rather than inventing it.
3. **Retrieve prior conversations.** Find previous meetings with these attendees or this account:
   titles, dates, and any notes, recaps, or agendas attached to or following them.
4. **Retrieve the paper trail.** Search email threads with the account domain and internal threads
   naming the account; search Teams chats and channels; search OneDrive/SharePoint for decks,
   proposals, SOWs, pricing, QBR docs and notes touching the account. Prefer the most recent and the
   most substantive items over merely matching ones.
5. **Extract open items.** From the last meeting's notes/recap and from the email and chat threads,
   pull every commitment that has not visibly been closed — ours and theirs — with who owns it and
   any stated date.
6. **Assess risk.** Look for concrete signals only: unanswered emails, slipped dates, escalations,
   pricing or budget pushback, a champion who has gone quiet, competitor mentions, contract or
   renewal deadlines. Each risk must cite the item it came from.
7. **Draft talking points and questions.** These are *your* suggestions, derived from the evidence
   above — label them as suggestions. Tie each one to something concrete (an open item, a risk, a
   stated goal) rather than offering generic sales advice.
8. **Assemble the output** in the exact structure below.

## Output format

```
# Pre-read: <Meeting title> — <Account>
<Day, date, time> · <duration> · organizer: <name>
Sources searched: <email, meetings, Teams, files> · window: <window used>

## Attendees
**Customer**
- <Name> — <Title>, <Company> — <one line on prior interaction, or "no prior contact found">
**Our side**
- <Name> — <role on the account>

## Account background
- 3–5 bullets: what this account is to us, where the engagement stands, stage/timeline if stated.
- Each bullet ends with its source, e.g. (email "Renewal timing", Dana Reyes, 12 Mar).

## Since we last spoke
- Last meeting: <title>, <date>.
- What was agreed, and what has moved since — each with a source.

## Open items
| Item | Owner | Due | Status | Source |
| --- | --- | --- | --- | --- |

## Risks and watch-outs
- <Risk> — evidence: <source>.

## Suggested talking points *(suggestions, not retrieved facts)*
- ...

## Questions to ask *(suggestions)*
- ...

## Gaps
- Not found in your Microsoft 365 content: <what is missing and why it matters>.
```

Omit a section only if it would be entirely empty **and** you have said so under **Gaps**.

## What to watch for

- **Never invent an attendee, title, company, date, or amount.** Blank beats fabricated.
- Don't pass off suggestions as findings — talking points and questions stay under their own headings.
- Don't dump every matching document. Cite the few that actually inform the meeting.
- If two sources conflict (dates, scope, pricing), show both and flag the conflict; do not pick one.
- If the meeting is internal only (no external attendees), say so and confirm the user still wants a prep.
- If you find almost nothing, say so plainly, state where you looked and over what window, and offer to
  widen the window or search a different account name — do not emit a skeleton full of placeholders.
- Keep it skimmable in about two minutes. Depth belongs in **Account Research**.
