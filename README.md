# Chess Middle Engine ♟️

[![Flutter CI](https://github.com/Shagdarovpro/Chess-pro/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/Shagdarovpro/Chess-pro/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Профессиональный шахматный движок, построенный на Flutter. Проект демонстрирует применение продвинутых архитектурных паттернов, кастомную отрисовку и сложную бизнес-логику генерации ходов.

## 🚀 Особенности проекта

- **Архитектура BLoC/Cubit:** Полное разделение UI и бизнес-логики.
- **Движок валидации ходов:** - Реализованы правила для всех типов фигур.
  - Алгоритм предотвращения ходов, ставящих собственного короля под шах.
  - Определение состояний мата и завершения игры.
- **Custom Rendering:** Решена проблема отображения Unicode-фигур на iOS через низкоуровневое использование `Paint API` (фигуры гарантированно белые/черные независимо от системных шрифтов).
- **Modern Flutter API:** Использование актуальных методов Dart (например, `.withValues()` вместо устаревшего `withOpacity`).
- **CI/CD:** Настроен GitHub Actions для автоматической проверки кода (анализ, форматирование и тесты) при каждом пуше.

## 📱 Скриншоты

| Игровое поле | Индикатор хода |
| :---: | :---: |
| <img src="screenshots/main_screen.png" width="300"> | <img src="screenshots/turn_indicator.png" width="300"> |

*(Примечание: добавьте скриншоты в папку screenshots в корне проекта)*

## 🛠 Стек технологий

- **Language:** Dart
- **Framework:** Flutter
- **State Management:** Flutter BLoC
- **CI/CD:** GitHub Actions
- **Testing:** Flutter Unit Tests

## 📦 Установка и запуск

1. Убедитесь, что у вас установлен [Flutter SDK](https://docs.flutter.dev/get-started/install).
2. Склонируйте репозиторий:
   ```bash
   git clone [https://github.com/Shagdarovpro/Chess-pro.git](https://github.com/Shagdarovpro/Chess-pro.git)
   ---

### 2. GitHub Actions (Автоматизация CI)
Это позволит автоматически проверять твой код при каждом `push` или `pull request`. Если ты случайно допустишь ошибку в коде, GitHub сообщит об этом.

Создай папку `.github/workflows/` и файл `flutter_ci.yml` внутри неё:

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, master ]
  pull_request:
    branches: [ main, master ]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3
      
      - name: Install Flutter
        uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
          
      - name: Install dependencies
        run: flutter pub get
        
      - name: Analyze code (Linter)
        run: flutter analyze
        
      - name: Run tests
        run: flutter test
