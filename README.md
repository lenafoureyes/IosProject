Основной функционал

Приложение представляет собой социальную платформу с возможностями:

✅ Авторизация – экран входа с логином и паролем (без реальной бэкенд-аутентификации, имитация).
✅ Профиль пользователя – отображение информации, аватара и коллекции фотографий.
✅ Лента постов – просмотр, добавление в избранное, создание новых постов (текст + фото).
✅ Избранное – сохранение и просмотр понравившихся постов.
✅ Фотогалерея – просмотр фотографий в полноэкранном режиме (при нажатии на коллекцию в профиле).
✅ Музыкальный плеер – список треков, воспроизведение при нажатии (переход в полноценный плеер).

Приложение построено на MVVM + Coordinator для четкого разделения логики и UI:

Model – данные (посты, пользователи, музыка).
ViewModel – бизнес-логика (обработка действий, загрузка данных).
View – UIKit, Auto Layout, кастомные UI-компоненты.
Coordinator – навигация между экранами.
🔹 Используемые технологии и библиотеки

UIKit (без SwiftUI)
MVVM
UserDefaults (хранение постов и избранного)
NotificationCenter (обновление UI при изменениях)
AVFoundation (воспроизведение музыки)

Скриншоты :
https://github.com/lenafoureyes/IosProject/blob/develop/1/Navigation1/asset/Screenshots/Screenshots.xcassets/Image%201.imageset/Снимок%20экрана%202025-07-19%20в%2022.45.39.png
https://github.com/lenafoureyes/IosProject/blob/develop/1/Navigation1/asset/Screenshots/Screenshots.xcassets/Image%202.imageset/Снимок%20экрана%202025-07-19%20в%2022.45.49.png
https://github.com/lenafoureyes/IosProject/blob/develop/1/Navigation1/asset/Screenshots/Screenshots.xcassets/Image%203.imageset/Снимок%20экрана%202025-07-19%20в%2022.46.20.png
https://github.com/lenafoureyes/IosProject/blob/develop/1/Navigation1/asset/Screenshots/Screenshots.xcassets/Image%204.imageset/Снимок%20экрана%202025-07-19%20в%2022.46.27.png
https://github.com/lenafoureyes/IosProject/blob/develop/1/Navigation1/asset/Screenshots/Screenshots.xcassets/Image%205.imageset/Снимок%20экрана%202025-07-19%20в%2022.46.30.png
https://github.com/lenafoureyes/IosProject/blob/develop/1/Navigation1/asset/Screenshots/Screenshots.xcassets/Image%206.imageset/Снимок%20экрана%202025-07-19%20в%2022.46.35.png
