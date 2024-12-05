# Използваме официалния Python образ като базов
FROM python:3.9-slim

# RUN apt-get update && apt-get install -y curl tar && \
# 	curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared-linux-amd64.deb && \
# 	dpkg -i cloudflared-linux-amd64.deb && \
# 	rm cloudflared-linux-amd64.deb && \
#     apt-get install -y git

RUN apt-get update && apt-get install -y curl tar && \
	if [ "$(uname -m)" = "armv7l" ]; then \
		curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-armhf.deb -o cloudflared-linux-armhf.deb && \
		dpkg -i cloudflared-linux-armhf.deb && \
		rm cloudflared-linux-armhf.deb; \
	else \
		curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb -o cloudflared-linux-amd64.deb && \
		dpkg -i cloudflared-linux-amd64.deb && \
		rm cloudflared-linux-amd64.deb; \
	fi && \
	apt-get install -y git


# Задаваме работната директория в контейнера
WORKDIR /app

# Копираме requirements файла в контейнера
COPY requirements.txt .

# Инсталираме необходимите зависимости
RUN pip install --no-cache-dir -r requirements.txt

# Копираме целия проект в контейнера
COPY . .

# Отваряме порт 7000 за достъп до приложението
EXPOSE 7000

# Стартираме приложението чрез Uvicorn
CMD ["sh", "-c", "pip install --no-cache-dir -r requirements.txt && cloudflared tunnel --url http://localhost:7000 & uvicorn main:app --host 0.0.0.0 --port 7000"]

