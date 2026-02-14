#!/bin/bash

# สีสำหรับแสดงผล
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}🚀 เริ่มต้นการติดตั้ง OpenClaw: Perfect Edition (Android/Termux)${NC}"

# 1. ติดตั้ง Packages ที่จำเป็น
echo -e "${GREEN}[1/4] กำลังติดตั้งเครื่องมือระบบ (FFmpeg, Chromium, Python, Unzip)...${NC}"
pkg update -y && pkg install -y git python ffmpeg tur-repo unzip zip
pkg install -y chromium xvfb

# 2. แก้ไข Network Shim (แก้บั๊ก Android Error 13)
echo -e "${GREEN}[2/4] กำลังติดตั้งตัวแก้บั๊กเครือข่าย (Network Shim)...${NC}"
cat > $HOME/openclaw-shim.mjs << 'EOF'
import os from 'node:os';
const mockInterfaces = () => ({
  lo: [{
    address: '127.0.0.1',
    netmask: '255.0.0.0',
    family: 'IPv4',
    mac: '00:00:00:00:00:00',
    internal: true,
    cidr: '127.0.0.1/8'
  }]
});
os.networkInterfaces = mockInterfaces;
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
try {
  const osCJS = require('os');
  osCJS.networkInterfaces = mockInterfaces;
} catch (e) {}
EOF
cp $HOME/openclaw-shim.mjs $HOME/openclaw-shim.cjs

# 3. ตั้งค่า Environment Variables และ Aliases
echo -e "${GREEN}[3/4] กำลังตั้งค่าคำสั่งลัด (Aliases)...${NC}"
if ! grep -q "OpenClaw Perfect Setup" ~/.bashrc; then
cat >> ~/.bashrc << 'EOF'

# --- OpenClaw Perfect Setup (Thai Edition) ---
export NODE_OPTIONS="--require $HOME/openclaw-shim.cjs --import $HOME/openclaw-shim.mjs --max-old-space-size=1024"
export PATH="$HOME/bin:$PATH"
export DISPLAY=:99

# คำสั่งหลัก
alias start-claw='Xvfb :99 -screen 0 1280x1024x24 >/dev/null 2>&1 & openclaw gateway --bind loopback --force'
alias claw-tui='openclaw tui'
alias claw-status='openclaw status --all'
alias claw-update='npm install -g openclaw@latest'
alias claw-fix='openclaw doctor --fix'

# เมนูช่วยเหลือ
echo -e "\033[0;36m🤖 OpenClaw พร้อมทำงานแล้ว!\033[0m"
echo "พิมพ์ 'start-claw' เพื่อเริ่มระบบ"
echo "พิมพ์ 'claw-tui' เพื่อเปิดหน้าจอคุย"
EOF
fi

# 4. สร้างโฟลเดอร์ทำงาน
echo -e "${GREEN}[4/4] สร้างพื้นที่เก็บข้อมูล (Customers & Reports)...${NC}"
mkdir -p ~/.openclaw/workspace/incoming
mkdir -p ~/.openclaw/workspace/reports
mkdir -p ~/.openclaw/workspace/customers

echo -e "${CYAN}✅ ติดตั้งเสร็จสมบูรณ์! พิมพ์ 'source ~/.bashrc' เพื่อเริ่มใช้งาน${NC}"
