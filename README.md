# مصروفي — تطبيق Flutter تجريبي

واجهة عربية RTL لتتبع مصروفات تجريبية. الإضافة تعمل داخل الذاكرة فقط؛ لا توجد خدمة خارجية أو قاعدة بيانات.

## بناء APK سحابيًا عبر GitHub Actions

ملف workflow موجود في `.github/workflows/build-apk.yml`، ويبني APK عند كل push إلى `main` أو عند تشغيله يدويًا:

1. أنشئ مستودع GitHub وارفع إليه محتويات هذا المجلد، مع تضمين مجلد `.github` المخفي.
2. من تبويب **Actions** اختر **Build Android APK** ثم **Run workflow** (أو ادفع commit إلى `main`).
3. عند نجاح البناء، افتح نتيجة التشغيل وحمّل artifact باسم `masroofi-release-apk`.
4. فك ضغط artifact لتحصل على `app-release.apk`.

لا يحتاج workflow إلى أسرار أو مفاتيح API. ملف APK غير موقّع بمفتاح نشر خاص؛ مناسب للتجربة والتثبيت اليدوي، وليس للنشر في Google Play.

## تشغيل محليًا

يتطلب تثبيت Flutter SDK وAndroid SDK على Linux أو macOS أو Windows:

```sh
flutter create --platforms=android --project-name masroofi .
flutter pub get
flutter test
flutter run
```
