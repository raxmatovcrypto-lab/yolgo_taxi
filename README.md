# YoʻlGo - taksi ilovasi skeleti (yo'lovchi tomoni)

## Ishga tushirish
1. Flutter o'rnating: https://docs.flutter.dev/get-started/install
2. Loyiha papkasida platforma fayllarini yarating (bir marta):
   `flutter create . --org com.example --project-name yolgo_taxi`
3. `flutter pub get`
4. `flutter run`

## Hozir ishlaydi
- OpenStreetMap xaritasi (API kalit kerak emas)
- Xaritani bosib borish manzilini tanlash
- 3 ta tarif, narx hisoblash
- Soxta (mock) haydovchi qidirish va yaqinlashishi

## Keyingi qadamlar
1. `geolocator` bilan haqiqiy joylashuv
2. Manzil qidirish (Nominatim / Google Places)
3. Backend: auth (telefon SMS), buyurtmalar, WebSocket (haydovchi joylashuvi)
4. `MockRideRepository` o'rniga `HttpRideRepository`
5. Haydovchi ilovasi (alohida Flutter loyiha)
6. To'lov (Payme / Click) va push bildirishnomalar
