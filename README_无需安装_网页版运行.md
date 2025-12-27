# 不需要在电脑安装任何东西的使用方式（只用浏览器）

你说“直接点开网站就能用”，要么：
- **有人把它部署到公网**（你直接访问链接）
- 或者你用**浏览器里自带的云开发环境/托管平台**来运行（你的电脑不用装 Docker/Python/ffmpeg）

我这里给你两种最简单的「只用浏览器」方案。

---

## 方案 A（最推荐）：GitHub Codespaces（纯浏览器运行，自动打开网页）

你只需要一个 GitHub 账号，不用装任何软件。

### 步骤（全是“点点点”）
1. 打开 github.com，登录/注册
2. 新建一个仓库（New repository）
3. 把本项目代码上传到仓库（GitHub 网页支持 Upload files）
4. 在仓库页面点绿色按钮 **Code**
5. 切到 **Codespaces** 标签
6. 点 **Create codespace on main**

等待它自动构建并启动后，会自动在浏览器打开应用（端口 8000）。

> 这个项目已内置 `.devcontainer`，Codespaces 会自动装依赖并启动服务。

---

## 方案 B：Hugging Face Spaces（生成一个“永久网址”，别人也能直接打开）

你只需要 Hugging Face 账号，不用装任何软件。

### 步骤
1. 打开 huggingface.co 注册/登录
2. 点击右上角头像 → **New Space**
3. Space SDK 选择 **Docker**
4. 把本项目文件上传到 Space（网页上传）
5. 在 Space 的 **Settings → Secrets** 里添加：
   - `ARK_API_KEY`：你的火山方舟 Key
6. 等它 Build 完成后，你会得到一个公开网址，打开就能用。

提示：Spaces 支持 Docker，并可通过 README 的 YAML 设置 `sdk: docker` 和 `app_port`。  
（我们的服务默认端口 8000，你可以在 Space README 顶部写 `app_port: 8000`。）

---

## 应用使用（两种方案都一样）
打开网页后：
1) 上传视频  
2) 填 Model ID / Endpoint ID（你要接入的模型名/ID）  
3) 填 ARK_API_KEY（如果你没在 Secrets/环境变量里设置）  
4) 点开始分析

