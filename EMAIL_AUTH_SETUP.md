# Email sign-in activation

Website and case storage remain on ChatGPT Sites. Supabase is used only for email identity verification. Authentication identity records are held by Supabase; case records and change history remain in the existing R2 binding.

## Required configuration

1. Connect the owner's Supabase account and select or create a project. Do not provision paid infrastructure without the user's authorization.
2. Configure Email Auth. Change both the Magic Link and initial signup confirmation email templates to show `{{ .Token }}` so first-time and returning users receive a code.
3. Configure production email delivery. Supabase's default sender may restrict recipients; test with an assigned staff address before activation. Configure rate limits and code expiry in the project.
4. Set Sites runtime values `SUPABASE_URL` (HTTPS project origin) and `SUPABASE_PUBLISHABLE_KEY`. Use the publishable/anon key, never a service-role key. Keep secrets out of source.
5. Open the register once as the existing ChatGPT administrator before external email activation. This binds the shared register to the original owner's storage prefix, preserving existing records.
6. Assign approved staff email addresses Viewer or Editor in Manage access.
7. Publish the configured version, validate with a real guest email code, and then change the Site audience to public for reaching the login page. All record and permission endpoints must continue to require verified identity and an assigned role. A public login page does not grant case access.
8. Test guest reads, editor writes, audit identity, denial for unassigned emails, revocation and logout through the deployed website.

## Session behavior

The email access token is placed in a Secure, HttpOnly, SameSite=Strict host cookie, capped at one hour. Tokens are checked against the authentication provider on record requests. There is no browser-local token storage and no refresh token retention; staff sign in again on expiry. Logout clears the browser cookie. Assigned roles are rechecked on every request.

## Current verification

`node tests/access.mjs` checks roles and history.
`node tests/email-auth.mjs` checks the integration against a simulated provider. It does not establish real email delivery or successful deployed guest login.

Do not claim activation until service configuration and actual guest verification succeed.
