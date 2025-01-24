FROM python:3.12.1 AS builder
COPY requirements.txt .

RUN pip install --user -r requirements.txt

FROM python:3.12.1-slim
WORKDIR /code

COPY --from=builder /root/.local /root/.local
COPY ./src /code

ENV PATH=/root/.local/bin:$PATH

CMD ["python", "-v", "main.py"]