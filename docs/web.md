# Pixel8 web dashboard

The dashboard is a Next.js 16 application in `apps/web`. It uses the generated TypeScript SDK for cookie-authenticated REST calls, Better Auth email OTP for sign-in, and direct S3 multipart uploads using short-lived server-issued part URLs. Upload progress and ETags are persisted locally so a selected file can resume after a reload; session metadata expires after 23 hours. Authentication credentials remain in the browser cookie jar.

## Local development

Run the API and web app from the repository root with `pnpm dev:api` and `pnpm dev:web`. Configure `NEXT_PUBLIC_API_URL` to the reachable API origin in `.env`. The default is `http://localhost:3001`. Open `http://localhost:3000` and sign in using the email OTP flow. The API must allow the dashboard origin and S3 must allow `localhost:3000` in its CORS policy so the browser can read multipart ETags.

The dashboard refreshes screen state every five seconds while signed in. Library asset and campaign state refreshes every five seconds while the Library view is open for a selected app; campaign editor drafts remain local until explicitly saved.

## Container build

Build from the repository root so shared contracts and SDK packages are available:

```sh
docker build -f apps/web/Dockerfile \
  --build-arg NEXT_PUBLIC_API_URL=https://api.example.com \
  -t pixel8-web .
docker run --rm -p 3000:3000 pixel8-web
```

`NEXT_PUBLIC_API_URL` is embedded at build time by Next.js. The container listens on port 3000.
