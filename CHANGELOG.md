## 1.1.0

- Add `exception` getter to retrieve the exception that effectively canceled the token.
- Provide default implementations for `isCanceled` and `throwIfCanceled` (based on `exception`).
- Make `ensureStarted()` a method of `CancelationToken` to help control countdown in timeout tokens and composite tokens containing timeout tokens.

## 1.0.1

- Provide an example as per https://dart.dev/tools/pub/package-layout#examples.

## 1.0.0

- Initial version.
