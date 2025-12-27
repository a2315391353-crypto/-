# 火山方舟：视频逐镜头拆解 & 生成 AI 提示词（Web 应用）

这个项目提供一个本地可运行的 Web 应用：

1) 上传视频  
2) 自动做“镜头切分”（shot boundary detection）  
3) 为每个镜头抽取关键帧（默认取镜头中间帧，可选取首/中/尾）  
4) 通过火山方舟（Ark）的 **Chat Completions** 接口（OpenAI 兼容）调用你填入的 **Model ID**，生成每个镜头对应的“可直接用于文生图 / 图生图 / 生视频”的提示词（prompt），并返回结构化 JSON。

> 说明：本项目默认走 **方舟数据面 API**：`https://ark.cn-beijing.volces.com/api/v3/`，并通过 `Authorization: Bearer <ARK_API_KEY>` 方式鉴权。官方文档给出了 `chat/completions` 的 curl 示例。  

---

## 你需要准备什么

- Python 3.10+（推荐）
- 本机已安装 ffmpeg（用于镜头切分与抽帧；Docker 方式会在镜像里自带）
- 火山方舟 API Key（ARK_API_KEY）
- 你要调用的 Model ID（在火山方舟“模型列表”中获取，可直接填入；也支持你自己创建的 Endpoint ID）

官方文档参考（强相关）：
- Base URL 与鉴权、以及 `chat/completions` 示例（`Authorization: Bearer <ARK_API_KEY>`、Base URL、curl）  
- OpenAI SDK 兼容调用方式（OpenAI Python SDK 设置 `base_url="https://ark.cn-beijing.volces.com/api/v3"`）  

---

## 目录结构

```
volc-video-shot-prompter/
  backend/
    main.py                 # FastAPI 服务（含任务队列、上传、进度查询）
    video_processing.py     # 镜头切分 + 关键帧提取（ffmpeg/ffprobe，无需 OpenCV/Numpy）
    ark_client.py           # 火山方舟（OpenAI 兼容）调用封装
    requirements.txt
    static/
      index.html            # 前端页面（纯前端，无需单独构建）
  docker-compose.yml
  backend/Dockerfile
```

---

## 方式 A：本机运行（Python）

```bash
cd volc-video-shot-prompter/backend
python -m venv .venv
# mac/linux
source .venv/bin/activate
# windows: .venv\Scripts\activate

pip install -r requirements.txt

# 可选：你也可以只用环境变量，不在网页里填
export ARK_API_KEY="你的APIKey"
export ARK_BASE_URL="https://ark.cn-beijing.volces.com/api/v3"  # 可选，默认就是这个

uvicorn main:app --host 0.0.0.0 --port 8000
```

打开：
- http://localhost:8000

---

## 方式 B：Docker 一键运行（推荐）

```bash
cd volc-video-shot-prompter
# 你也可以写到 .env 文件里（docker-compose 会读取）
export ARK_API_KEY="你的APIKey"
docker compose up --build
```

打开：
- http://localhost:8000

---

## 使用说明

1) 选择一个视频文件（mp4/mov 等）  
2) 填写：
   - **Model ID**：例如你在控制台看到的 doubao-* 或你创建的 Endpoint ID  
   - **ARK_API_KEY**：可留空（若已在环境变量里设置）  
3) 点击「开始分析」  
4) 等待任务完成后，会看到：
   - 每个镜头的时间段
   - 关键帧缩略图
   - LLM 输出的结构化结果（包含可一键复制的 prompt / negative_prompt / params 等）

---

## 常见问题

### 1) 为什么只抽关键帧，不是“每一帧都生成提示词”？
视频逐帧会产生海量帧（比如 60 秒 30fps = 1800 帧），每帧调用一次大模型成本很高，也不利于“镜头级”创作控制。  
本项目按“镜头”粒度生成提示词——更贴近剪辑/分镜工作流；你也可以把 `frames_per_shot` 改成 3（首/中/尾）提高细粒度。

### 2) 我想用火山方舟的“视频理解”模型行不行？
可以：本项目的默认方式是把关键帧作为图片输入（OpenAI 兼容的 image_url data URL）。如果你有视频理解模型，也可以在 `ark_client.py` 里改成上传文件 + 视频理解的接口形态（方舟提供 Files API / 多模态理解能力）。

### 3) 安全性
前端页面会把你输入的 API Key 发给后端（只在内存中使用，不落盘）。如果你不希望在网页里输入 key，请用环境变量 `ARK_API_KEY`。

---

## 许可
MIT
