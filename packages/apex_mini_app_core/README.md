# mini_app_core

Mini App SDK-ийн цөм контракт, модель, валидацийн логик.

## Энэ багц юу эзэмшдэг вэ

 `MiniAppModule`, `MiniAppRouteSpec`
 `MiniAppLaunchReq`, `MiniAppLaunchRes`
 `MiniAppPaymentReq`, `MiniAppPaymentRes`, `MiniAppPaymentStatus`
 `MiniAppRegistry`

`lib/src` нь Flutter-ээс хамаарахгүй, pure Dart хэлбэртэй.

## Design intent

Энэ багц нь route-д суурилсан launch contract, module contract, registry
validation, payment req/res model зэрэг SDK-д үнэхээр хэрэгтэй pure Dart
контрактуудыг л хадгална.

## Валидацийн дүрмүүд

 module `displayName` болон `initialRoute` хоосон байж болохгүй
 route жагсаалт хоосон байж болохгүй
 глобал route path давхцахгүй
 module дотор route path давхцахгүй
 `initialRoute` нь routes дотор байх ёстой

## Хөгжүүлэлт

```bash
cd packages/mini_app_core
dart analyze
dart test
```
