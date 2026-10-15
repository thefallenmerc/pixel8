# Pixel8 mobile app

The Flutter owner app lives in `apps/mobile` and targets Android and iOS. It uses the v1 owner REST API from `docs/contract.md`. Set `PIXEL8_API` to the API origin at build time; it defaults to `http://localhost:3001` for the local development stack. Android emulators reach host services through `10.0.2.2`, so pass `--dart-define=PIXEL8_API=http://10.0.2.2:3001`. The object store's signed public endpoint must also be reachable from the device (`http://10.0.2.2:19000` for Android emulators, localhost for iOS Simulator). Physical phones need the development host's LAN address exposed by both API and object store.

```sh
cd apps/mobile
flutter pub get
flutter run --dart-define=PIXEL8_API=http://10.0.2.2:3001
```

Sign in with an email verification code. The session bearer token is read from Better Auth's `set-auth-token` response header (or the response body fallback) and stored in platform secure storage. Uploads use the server's multipart part size and pre-signed object URLs; returned ETags are sent to the completion endpoint. A pending upload ID and completed-part ETags are persisted securely so selecting the same file again resumes remaining parts.

The app consumes the generated `pixel8_sdk` Dart package for typed Apps, Screens, Assets, and Campaign list reads; it keeps the same authenticated Dio transport for Better Auth and contract endpoints not currently present in the generated client. It provides Apps, Library, Screens, and Settings sections. Campaign edits include the expected revision; on HTTP 409 the latest campaign is loaded and the user is asked to review before saving again. Screen updates include the expected desired version. Pairing accepts a typed code and can scan a QR code. A 401 clears the secure token and returns the app to sign-in. The API address can be changed with `--dart-define=PIXEL8_API=https://api.example.com`.
