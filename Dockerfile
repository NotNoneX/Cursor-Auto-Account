FROM python:3.9-slim

WORKDIR /app

# 安装 Chrome 和依赖（用于DrissionPage）
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    xvfb \
    libxi6 \
    libgconf-2-4 \
    socat \
    && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制项目文件
COPY requirements.txt .

# 安装Python依赖
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目文件
COPY . .

# 创建模板目录和截图目录
RUN mkdir -p templates screenshots

# 暴露端口
EXPOSE 8001 9223

# 设置环境变量
ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8001
ENV DEBUG=false

# 创建启动脚本
COPY start.sh /start.sh
RUN chmod +x /start.sh

# 启动服务
CMD ["/start.sh"]