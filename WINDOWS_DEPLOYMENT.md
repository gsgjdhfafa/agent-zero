# Windows Deployment Guide - gsgjdhfafa Projects Suite

## 🚀 Quick Start

Deploy all your projects to Windows in **3 simple steps**:

```powershell
# 1. Download the deployment script
$url = "https://raw.githubusercontent.com/gsgjdhfafa/agent-zero/main/scripts/windows-deploy.ps1"
Invoke-WebRequest -Uri $url -OutFile windows-deploy.ps1 -UseBasicParsing

# 2. Run with Administrator privileges
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project all -Action install

# 3. Follow the prompts and configure API keys
```

---

## 📋 System Requirements

- **Windows 10/11** (latest updates recommended)
- **8GB+ RAM** (16GB+ for running multiple projects)
- **50GB+ free disk space**
- **Administrator access** (for Docker and system changes)
- **PowerShell 5.1+** (built-in on Windows 10/11)
- **Git for Windows** ([Download](https://git-scm.com/download/win))

---

## 🛠️ Installation Options

### Option 1: Deploy Everything (Recommended)
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project all -Action install
```

**Installs:**
- ✅ Docker Desktop
- ✅ Python 3.11+
- ✅ Node.js LTS
- ✅ Agent Zero
- ✅ n8n Workflow Automation
- ✅ LibreChat (Self-hosted ChatGPT)
- ✅ AgentExamples (Framework Comparison)
- ✅ GoViralBro (Social Media Coach)
- ✅ PICO 4 VR Control Center

### Option 2: Deploy Single Project
```powershell
# Deploy only Agent Zero
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project agent-zero -Action install

# Deploy only n8n
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project n8n -Action install

# Deploy only LibreChat
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project librechat -Action install
```

### Option 3: Custom Installation Path
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 `
  -Project all `
  -Action install `
  -InstallPath "D:\MyProjects"
```

### Option 4: Skip Prerequisites
```powershell
# Skip Docker installation
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -SkipDocker

# Skip Python installation
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -SkipPython

# Skip Node.js installation
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -SkipNodeJS
```

---

## 📦 Project Deployments

### 1. **Agent Zero** - AI Agent Framework
Fully autonomous, self-improving AI agent that uses your computer as a tool.

**Location:** `C:\DevApps\agent-zero`

**Start:**
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project agent-zero -Action start
```

**Access:** http://localhost

**Features:**
- 🤖 Multi-agent cooperation
- 💾 Persistent memory system
- 🔌 Extensible plugin architecture
- 🎯 Skills system (SKILL.md standard)
- 🌐 Web UI + Terminal interface

**Setup:**
1. Access http://localhost
2. Configure API keys (OpenAI, Anthropic, etc.)
3. Set up your agent's system prompt
4. Create projects for isolated workspaces

---

### 2. **n8n** - Workflow Automation
Low-code automation platform with 400+ integrations.

**Location:** `C:\DevApps\n8n`

**Start:**
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project n8n -Action start
```

**Access:** http://localhost:5678

**Default Credentials:**
- User: `admin`
- Password: `change_me_please` (⚠️ **Change on first login!**)

**Features:**
- 🔄 Visual workflow builder
- 🔌 400+ pre-built integrations
- 💾 Database connections (PostgreSQL included)
- 📅 Scheduling & triggers
- 🔐 Self-hosted & secure

**Quick Setup:**
1. Change admin password
2. Create new workflows
3. Connect services (Gmail, Slack, Discord, etc.)
4. Deploy and schedule

---

### 3. **LibreChat** - Self-Hosted ChatGPT Alternative
Multi-provider chat interface supporting OpenAI, Anthropic, Azure, and more.

**Location:** `C:\DevApps\LibreChat`

**Start:**
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project librechat -Action start
```

**Access:** http://localhost:3080

**Features:**
- 🤖 Multi-AI provider support (ChatGPT, Claude, etc.)
- 🔌 MCP (Model Context Protocol) integration
- 💬 Agent capabilities
- 🎨 Artifact generation (code, images)
- 👥 Multi-user with authentication
- 🔐 Privacy-focused (self-hosted)

**Configuration (.env):**
```env
MONGO_URI=mongodb://mongo:27017/librechat
JWT_SECRET=your_secret_key_change_me
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=claude-...
AZURE_API_KEY=...
PORT=3080
```

---

### 4. **AgentExamples** - Framework Comparison
Compare 12+ AI agent frameworks side-by-side with same task.

**Location:** `C:\DevApps\AgentExamples`

**Start:**
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project agentexamples -Action start
```

**Access:** http://localhost:8501 (Streamlit)

**Frameworks Included:**
- Anthropic API (low-level)
- OpenAI Responses API
- OpenAI Agents SDK
- LangChain (classic)
- LangGraph
- CrewAI
- Pydantic AI
- Llama-Index
- Atomic Agents
- Google ADK
- SmolAgents

**Configuration (.env):**
```env
TAVILY_API_KEY=your_tavily_key
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=claude-...
DEEPSEEK_API_KEY=deepseek-...
```

---

### 5. **GoViralBro** - Social Media Coaching
AI-powered system to discover winning topics, develop angles, and generate viral content.

**Location:** `C:\DevApps\goviralbro`

**Features:**
- 📊 Competitor intelligence (YouTube, Instagram, TikTok)
- 🎯 Topic discovery (Reddit, X, YouTube)
- 🪝 Hook generation (6 patterns)
- 📝 Script writing (longform, shortform, LinkedIn)
- 📈 Performance analytics & feedback loops
- 🧠 Evolving agent brain from data

**Setup:**
```bash
cd C:\DevApps\goviralbro
# Configure APIs in Claude Code
/viral:setup      # Platform wizard
/viral:onboard    # Agent brain setup
/viral:discover   # Topic research
/viral:script     # Generate content
```

**Required APIs:**
- OpenAI API key
- YouTube Data API v3
- (Optional) Instaloader for Instagram

---

### 6. **PICO 4 VR Control Center** - VR Management
Windows control center for PICO 4 Ultra VR headset with ADB, scrcpy, and office productivity.

**Location:** `C:\Users\{YourUser}\PicoSetup`

**Features:**
- 🔗 ADB device detection
- 📺 Live screen mirroring (scrcpy)
- 📱 App/package management
- 📁 File tree navigation
- 🔄 Multi-display workflows
- ⚡ Safe, reversible operations

**Quick Start:**
1. Open `C:\Users\{YourUser}\PicoSetup`
2. Run `PICO Status pruefen.cmd` (Check status)
3. Run `PICO Livefenster.cmd` (Live view)
4. Connect to PICO 4 Ultra via USB

---

## 🎮 Managing Projects

### Start All Projects
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project all -Action start
```

### Start Individual Project
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project agent-zero -Action start
```

### Stop All Projects
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project all -Action stop
```

### Update Project
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project agent-zero -Action update
```

### Uninstall Project
```powershell
powershell -ExecutionPolicy Bypass -File windows-deploy.ps1 -Project n8n -Action uninstall
```

---

## 🔧 Docker Management

### View Running Containers
```powershell
docker ps
```

### View Logs
```powershell
# Agent Zero logs
docker compose -f C:\DevApps\agent-zero\docker-compose.yml logs -f

# n8n logs
docker compose -f C:\DevApps\n8n\docker-compose.yml logs -f
```

### Stop All Containers
```powershell
docker compose down
```

### Restart Docker Desktop
```powershell
# PowerShell as Administrator
& 'C:\Program Files\Docker\Docker\Docker.exe'
```

---

## 🔐 API Keys & Configuration

### Where to Get API Keys

**OpenAI:**
- https://platform.openai.com/api-keys
- Required for: Agent Zero, n8n, LibreChat, AgentExamples

**Anthropic (Claude):**
- https://console.anthropic.com/
- Required for: Agent Zero, LibreChat, AgentExamples

**Tavily (Web Search):**
- https://tavily.com/
- Required for: AgentExamples

**YouTube Data API v3:**
- https://console.cloud.google.com/
- Required for: GoViralBro

### Store Keys Securely

**Option 1: Environment Variables** (Recommended)
```powershell
[System.Environment]::SetEnvironmentVariable("OPENAI_API_KEY", "sk-...", "User")
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "claude-...", "User")
```

**Option 2: .env Files** (Per project)
```
C:\DevApps\agent-zero\.env
C:\DevApps\LibreChat\.env
C:\DevApps\AgentExamples\.env
```

⚠️ **Never commit .env files to Git!**

---

## 📊 Port Reference

| Project | Port | URL |
|---------|------|-----|
| Agent Zero | 80 | http://localhost |
| n8n | 5678 | http://localhost:5678 |
| LibreChat | 3080 | http://localhost:3080 |
| Streamlit (AgentExamples) | 8501 | http://localhost:8501 |
| PostgreSQL (n8n) | 5432 | localhost:5432 |
| MongoDB (LibreChat) | 27017 | localhost:27017 |

**Modify ports in docker-compose.yml if conflicts occur.**

---

## 🐛 Troubleshooting

### Docker Desktop Won't Start
```powershell
# Enable virtualization in BIOS
# Or use Docker Desktop WSL 2 backend:
# Settings → Resources → WSL Integration
```

### Port Already in Use
```powershell
# Find process using port 80
netstat -ano | findstr :80

# Kill process (replace PID)
taskkill /PID <PID> /F
```

### Out of Disk Space
```powershell
# Check Docker disk usage
docker system df

# Clean up unused images/containers
docker system prune -a
```

### Python Virtual Environment Issues
```powershell
# Recreate venv
rm -r C:\DevApps\AgentExamples\venv
python -m venv C:\DevApps\AgentExamples\venv
& C:\DevApps\AgentExamples\venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

### Container Crashes
```powershell
# Check logs
docker compose logs --tail 100

# Rebuild image
docker compose build --no-cache
docker compose up -d
```

---

## 📚 Additional Resources

| Project | Documentation |
|---------|---------------|
| Agent Zero | https://agent-zero.ai/docs |
| n8n | https://docs.n8n.io |
| LibreChat | https://librechat.ai |
| AgentExamples | https://github.com/gsgjdhfafa/AgentExamples |
| GoViralBro | https://github.com/gsgjdhfafa/goviralbro/SETUP.md |

---

## 🤝 Contributing

Found an issue? Have a feature request?

- **Agent Zero:** https://github.com/gsgjdhfafa/agent-zero/issues
- **n8n:** https://github.com/n8n-io/n8n/issues
- **LibreChat:** https://github.com/danny-avila/LibreChat/issues

---

## 📄 License

All projects included in this suite respect their original licenses:
- Agent Zero: MIT
- n8n: Fair Code + Community
- LibreChat: MIT
- Other projects: See individual repositories

---

## 💬 Support

- **Discord:** https://discord.gg/B8KZKNsPpj (Agent Zero community)
- **YouTube:** https://youtube.com/@AgentZeroFW
- **GitHub Issues:** Check individual project repositories

---

## 🎯 Next Steps

1. ✅ Run deployment script
2. 🔑 Configure API keys
3. 🚀 Start Docker containers
4. 🌐 Access web UIs
5. 💡 Create your first workflow/agent
6. 📖 Read project documentation
7. 🚀 Build something amazing!

---

**Happy coding! 🚀**
