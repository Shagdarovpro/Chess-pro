# Chess Middle Engine ♟️

Профессиональный шахматный движок на Flutter с использованием BLoC/Cubit. 
Проект демонстрирует архитектурные подходы Middle-уровня: управление сложным состоянием, иммутабельность и кастомную отрисовку.

## Особенности
- **Движок ходов:** Полная валидация (пешки, кони, слоны, ладьи, ферзи, короли).
- **Защита короля:** Алгоритм проверки шаха (фигура не может пойти так, чтобы подставить своего короля).
- **Состояние (Cubit):** Четкое разделение бизнес-логики и UI.
- **Cross-platform UI:** Исправлено отображение шахматных символов на iOS через низкоуровневый Paint API.

## Стек технологий
- **Flutter / Dart**
- **flutter_bloc** (Cubit)
- **Удаление устаревшего кода:** Использование `.withValues()` вместо `withOpacity`.

## Как запустить
1. Склонируйте репозиторий:
   ```bash
   git clone [https://github.com/your-username/chess_middle.git](https://github.com/your-username/chess_middle.git)


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