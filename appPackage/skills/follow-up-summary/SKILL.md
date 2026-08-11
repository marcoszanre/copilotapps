---
name: follow-up-summary
description: Turns a customer meeting that already happened into a concise recap — decisions made, action items with owners and due dates, and a ready-to-send follow-up email draft — grounded in the meeting's notes, transcript, chat, and related email. Use it after a meeting, or when the user asks what they committed to.
---

# Follow-Up Summary

Close the loop on a meeting that already happened: what was decided, who owes what by when, and an
email the seller can review and send in under a minute.

## When to use this skill

- Right after a meeting: "summarize the call I just had", "write my follow-up to Contoso",
  "what did we agree in the Fabrikam meeting?"
- Retrospectively: "what did I commit to in my customer meetings last week?", "which action items
  from the Northwind QBR are still open?"
- Whenever the user asks for a recap, minutes, decisions, action items, or a follow-up email for a
  meeting **in the past**.

Do **not** use this skill for a meeting that has not happened yet — that is **Meeting Prep**.
Do **not** use it for a whole-account picture unattached to a meeting — that is **Account Research**.

## Inputs you need

| Input | How to resolve it |
| --- | --- |
| The meeting | If named, use it. If the user says "the call I just had" / "my last meeting", take the most recent past calendar event with at least one external attendee. If several are plausible, list them with date/time and ask which. |
| Recap scope | Single meeting by default. If the user asks about "last week" or "my customer meetings", cover every past external meeting in that window and produce one section per meeting plus a consolidated action-item table. |
| Email recipient(s) | The external attendees of the meeting, unless the user names someone else. |

## How to do it

1. **Anchor on the meeting.** Retrieve the event: title, date, attendees (external vs internal),
   organizer, and the invite body/agenda so you know what it was *meant* to cover.
2. **Gather what the meeting produced.** Retrieve, in this order of authority: meeting notes or recap
   documents, the transcript or AI notes if present, the meeting chat, files shared during or right
   after it, and email sent by attendees in the hours following it.
3. **Extract decisions.** A decision is something that was *settled* — a chosen option, an agreed
   scope, a confirmed date, an approval. Record each in one sentence with who made or confirmed it and
   its source. If nothing was decided, say "No decisions recorded" rather than promoting a discussion
   point to a decision.
4. **Extract action items.** For each: the action, the owner, the due date, and the source. Distinguish
   **our** actions from **customer** actions. Where the owner or date was never stated, write
   "owner not stated" / "no date stated" and, if useful, add a proposed owner/date explicitly marked
   *(suggested)*.
5. **Note open questions and next steps.** Anything raised and left unresolved, plus any next meeting
   already agreed or proposed.
6. **Draft the follow-up email.** Addressed to the external attendees, from the seller's point of view:
   - Subject line referencing the meeting and account.
   - One warm opening line thanking them.
   - A short "what we agreed" list — decisions only.
   - A clear "next steps" list — customer actions and our actions, with owners and dates. Never assign
     a date to the customer that they did not agree to; if none was agreed, ask for one in the email.
   - A single closing line offering to clarify.
   - Nothing internal: no internal-only commentary, pricing strategy, risk assessments, colleagues'
     opinions, or anything about compensation, performance or personal matters.
7. **Assemble the output** in the exact structure below.

## Output format

```
# Follow-up: <Meeting title> — <Account>
<Day, date> · attendees: <external names> / <internal names>
Sources used: <notes, transcript, meeting chat, email, files>

## Decisions
- <Decision> — <who confirmed it> (source: <where>)

## Action items
| # | Action | Owner | Side | Due | Source |
| - | ------ | ----- | ---- | --- | ------ |
(Side = Us / Customer)

## Open questions
- <Question left unresolved> (source: <where>)

## Next meeting
- <Date/what was agreed, or "none agreed">

## Draft follow-up email *(review before sending)*
**To:** <external attendees>
**Subject:** <subject>

<email body>

## Gaps
- Not found in your Microsoft 365 content: <what is missing>.
```

For a multi-meeting request, repeat **Decisions / Action items / Open questions** per meeting, then add
a single consolidated action-item table at the end, and only draft an email if the user asked for one.

## What to watch for

- **Never invent a decision, an owner, a due date, or a commitment.** If it was not said, it did not
  happen — write "not stated".
- Don't upgrade "we should probably..." into a decision or an action item. Discussion is not agreement.
- Keep internal-only material out of the email draft. Double-check the draft for anything that would
  embarrass the seller if the customer forwarded it.
- Never state or imply that you have sent, scheduled, or filed anything. The email is a draft; say so.
- If the meeting produced no retrievable artifacts (no notes, no transcript, no chat, no email), say
  that plainly and offer to build the recap from the user's own bullet points instead of guessing.
- Keep the recap short enough to read in a minute and the email short enough to send unedited.
