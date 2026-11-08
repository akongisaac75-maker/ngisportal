# NGIS: Offline mode and Parent Notifications - setup notes

## Offline mode (nothing to install)
1. Upload ALL files together (index.html AND sw.js) to your hosting. Open the app once with internet so the phone saves it.
2. Log in with internet at least once on each device. For offline sign-in, set up Fingerprint Login on that device (works for 30 days after the last online login).
3. While online, open the pages you will need offline (e.g. Enter Assessment for your class, week and subject, and the Class Register). Pages opened online are saved on the device.
4. With no network, keep working. Saves for assessments, mid-term, termly scores, class register, weekly comments etc. wait on the phone.
5. Tap the round network button (bottom-left) to see what is waiting. "Work offline" lets you switch to offline on a poor connection. When internet returns, changes are sent automatically (or press Sync now).

Limits: only score / attendance / comment saves work offline. Creating students, classes, deleting things, quizzes, etc. need internet. If two people edit the same score, the last one to sync wins.
On shared computers press "Clear offline data" in the network panel. Parent/student logins never save data on the device.

## Parent Notifications
1. Run `notifications_setup.sql` once in Supabase > SQL Editor.
2. Parent Notifications > Parent contacts: enter each family's phone/email once.
3. Send alert: choose Absent / Results published / Fees due / Announcement, check the message, Prepare recipients.
   - The WhatsApp / SMS / email buttons open your phone or computer with the message ready; you tap Send. Works immediately, no provider needed.
   - Absence alerts read the Class Register. Fees alerts use "Fees & Result Access". Publishing results offers to notify parents.
4. Notice board: notices appear at the top of the parent, teacher or admin dashboard.

## Optional: fully automatic sending (needs a developer and paid provider accounts)
`supabase_functions/send-notifications/index.ts` is an Edge Function that sends queued messages through Termii (SMS), Resend (email) and the WhatsApp Cloud API.
Deploy: `supabase functions deploy send-notifications`, then set secrets (see top of the file). WhatsApp business-initiated messages require a message template approved by Meta.
This function has NOT been tested with live accounts; send one test message first. Until it is deployed, "Send automatically" just leaves the messages queued in History.
