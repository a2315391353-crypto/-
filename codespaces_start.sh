#!/usr/bin/env bash
set -euo pipefail

# 启动 FastAPI（后台）
if pgrep -f "uvicorn main:app" >/dev/null 2>&1; then
  echo "uvicorn 已在运行。"
  exit 0
fi

cd backend
nohup uvicorn main:app --host 0.0.0.0 --port 8000 > ../uvicorn.log 2>&1 &
echo "已启动 uvicorn（日志：uvicorn.log）。打开已转发的 8000 端口即可。"
