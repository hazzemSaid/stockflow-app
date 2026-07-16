# Google Sign-In with Supabase

## Summary

Add native Google Sign-In to MakhzanFlow using `google_sign_in` + Supabase's `signInWithIdToken()`. Users can sign in or sign up with their Google account on both Android and iOS.

## Changes

### New Files
| File | Purpose |
|------|---------|
| `lib/features/auth/domain/usecases/sign_in_with_google_usecase.dart` | Use case delegating to repository |
| `lib/features/auth/presentation/widgets/google_sign_in_button.dart` | Reusable Google button with branded "G" icon |
| `lib/features/auth/presentation/widgets/google_auth_section.dart` | Combined "أو" divider + Google button widget |
| `android/app/google-services.json` | Firebase Android config for Google Sign-In |
| `android/app/src/main/kotlin/com/makhzan/flow/MainActivity.kt` | Fixed package path (was `com.stockflow.app`) |
| `firebase.json` | Firebase project config |

### Modified Files
| File | Change |
|------|--------|
| `pubspec.yaml` | Added `google_sign_in: ^6.3.0` |
| `lib/core/env.dart` | Added `googleWebClientId` getter from `.env` |
| `lib/core/error/exceptions.dart` | Added `GoogleSignInCancelledException` |
| `lib/core/error/failures.dart` | Added `GoogleSignInCancelledFailure` |
| `lib/core/constants/app_strings.dart` | Added `signInWithGoogle`, `orContinueWith`, `googleSignInError`, `googleSignInCancelled` |
| `lib/core/di/service_locator.dart` | Registered `SignInWithGoogleUseCase`, wired into `AuthCubit` |
| `lib/features/auth/data/models/user_model.dart` | `fromSupabaseUser` falls back to `full_name` for Google metadata |
| `lib/features/auth/data/datasources/auth_remote_data_source.dart` | Added `signInWithGoogle()` — uses `GoogleSignIn` → `signInWithIdToken()` |
| `lib/features/auth/domain/repositories/auth_repository.dart` | Added `signInWithGoogle()` to interface |
| `lib/features/auth/data/repositories/auth_repository_impl.dart` | Implemented with proper Either error handling |
| `lib/features/auth/presentation/cubit/auth_cubit.dart` | Added `signInWithGoogle()` method |
| `lib/features/auth/presentation/pages/login_screen.dart` | Replaced inline code with `GoogleAuthSection` widget |
| `lib/features/auth/presentation/pages/register_screen.dart` | Same |
| `.gitignore` | Added `client_secret_*.json` |

### Android Native Config
- Added `google-services.json` with Web OAuth client (`client_type: 3`) and Android OAuth client (`client_type: 1`)
- Added `com.google.gms.google-services` Gradle plugin
- Fixed `MainActivity.kt` package from `com.stockflow.app` → `com.makhzan.flow`

## Architecture

```
UI (Google button tap)
  → AuthCubit.signInWithGoogle()
    → SignInWithGoogleUseCase.call()
      → AuthRepositoryImpl.signInWithGoogle()
        → AuthRemoteDataSourceImpl.signInWithGoogle()
          → GoogleSignIn.signIn()           // native account picker
          → googleUser.authentication       // get idToken
          → supabase.auth.signInWithIdToken() // exchange for Supabase session
```

Error handling uses Either throughout:
- User cancels → `GoogleSignInCancelledException` → `GoogleSignInCancelledFailure` → cubit emits `Unauthenticated` (no error toast)
- Any other error → `AuthException`/`ServerException` → `AuthFailure`/`ServerFailure` → cubit emits `AuthError`

## Setup Required

1. **Supabase Dashboard** → Authentication → Providers → Google → enable, paste:
   - Client ID: `791292304731-14l02r7kbjtjfbu4nvt6ffsafs86r8g1.apps.googleusercontent.com`
   - Client Secret: *(from Google Cloud Console)*
2. **`.env`** — already has `GOOGLE_WEB_CLIENT_ID` set
3. **iOS** — needs `GoogleService-Info.plist` from Firebase + `CFBundleURLSchemes` in `Info.plist` (iOS only)

## Testing

1. `flutter run` (full build, not hot restart) on Android device/emulator
2. Tap "تسجيل الدخول باستخدام Google" on Login or Register screen
3. Verify Google account picker appears and sign-in completes
4. Verify sign-out clears both Supabase and Google sessions
