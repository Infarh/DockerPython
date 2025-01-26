# Первый этап: сборка
FROM python:3.9-slim AS builder

# Установка необходимых зависимостей для сборки
WORKDIR /app

# Копируем файлы в контейнер
COPY . /app

# Устанавливаем зависимости в директорию /app/dependencies
RUN pip install --no-cache-dir --target=/app/dependencies -r requirements.txt

# Второй этап: минималистичный контейнер
FROM python:3.9-alpine

WORKDIR /app

# Устанавливаем необходимые системные пакеты для работы Python и Flask
RUN apk add --no-cache gcc musl-dev libffi-dev

# Копируем зависимости из первого этапа
COPY --from=builder /app/dependencies /usr/local/lib/python3.9/site-packages

# Копируем только необходимые файлы приложения
COPY app.py /app/

# Указываем переменные окружения
ENV FLASK_APP=app.py

# Указываем порт для экспонирования
EXPOSE 5000

# Устанавливаем flask напрямую (для выполнения flask CLI)
RUN pip install --no-cache-dir flask

# Запускаем приложение через явный путь к интерпретатору Python
CMD ["python", "-m", "flask", "run", "--host=0.0.0.0"]
