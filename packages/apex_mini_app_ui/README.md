# mini_app_ui

`_mini_app_core` дээр суурилсан Flutter runtime.

## Энд юу байдаг вэ

 `UiMiniAppModule`
 `MiniAppSdk`
 `MiniAppHostController`
 `DefaultMiniAppHostController`
 `MiniAppHostShell`
 responsive helper (`MiniAppResponsive`)
 fixed host presentation runtime + logger primitives

## Launch behavior

`DefaultMiniAppHostController`:

 module бүртгэх/lookup хийх
 route validate хийх
 Navigator ашиглан launch хийх
 `MiniAppLaunchRes` буцаах

`MiniAppSdk`:

 module registration-ийг startup дээр цэгцтэй хийх
 `launch()` helper өгөх
 module registry болон host runtime-ийг controller-тэй холбох

## Хөгжүүлэлт

```bash
cd packages/mini_app_ui
dart analyze
flutter test
```
