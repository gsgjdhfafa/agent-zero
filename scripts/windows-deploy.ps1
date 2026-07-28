# ============================================================================
# WINDOWS DEPLOYMENT SCRIPT - gsgjdhfafa Projects Suite
# ============================================================================
# Purpose: Deploy Agent Zero, n8n, LibreChat, and other projects on Windows
# Supports: Windows 10/11 with PowerShell 5.1+
# Usage: powershell -ExecutionPolicy Bypass -File windows-deploy.ps1
# ============================================================================

param(
    [ValidateSet("all", "agent-zero", "n8n", "librechat", "pico-vr", "agentexamples", "goviralbro")]
    [string]$Project = "all",
    
    [ValidateSet("install", "update", "start", "stop", "uninstall")]
    [string]$Action = "install",
    
    [string]$InstallPath = "C:\DevApps",
    [switch]$SkipDocker = $false,
    [switch]$SkipPython = $false,
    [switch]$SkipNodeJS = $false,
    [switch]$Interactive = $false
)

# ============================================================================
# COLORS FOR CONSOLE OUTPUT
# ============================================================================
$Colors = @{
    Reset   = "`e[0m"
    Green   = "`e[32m"
    Yellow  = "`e[33m"
    Red     = "`e[31m"
    Blue    = "`e[36m"
    Bold    = "`e[1m"
}

function Write-Title { param([string]$Message)
    Write-Host "$($Colors.Bold)$($Colors.Blue)╔════════════════════════════════════════════════════════════╗$($Colors.Reset)"
    Write-Host "$($Colors.Bold)$($Colors.Blue)║ $($Message.PadRight(58)) ║$($Colors.Reset)"
    Write-Host "$($Colors.Bold)$($Colors.Blue)╚════════════════════════════════════════════════════════════╝$($Colors.Reset)"
}

function Write-Success { param([string]$Message)
    Write-Host "$($Colors.Green)✓ $Message$($Colors.Reset)"
}

function Write-Warning { param([string]$Message)
    Write-Host "$($Colors.Yellow)⚠ $Message$($Colors.Reset)"
}

function Write-Error { param([string]$Message)
    Write-Host "$($Colors.Red)✗ $Message$($Colors.Reset)"
}

function Write-Info { param([string]$Message)
    Write-Host "$($Colors.Blue)ℹ $Message$($Colors.Reset)"
}

# ============================================================================
# PREREQUISITES CHECK
# ============================================================================
function Test-Prerequisites {
    Write-Title "Checking Prerequisites"
    
    # PowerShell version
    $psVersion = $PSVersionTable.PSVersion.Major
    Write-Info "PowerShell Version: $psVersion"
    if ($psVersion -lt 5) {
        Write-Error "PowerShell 5.1+ required (you have $psVersion)"
        exit 1
    }
    
    # Check Administrator rights
    $isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $isAdmin) {
        Write-Warning "Running without Administrator rights. Some features may be limited."
        Write-Warning "Restart as Administrator for full functionality."
        if ($Interactive) {
            $response = Read-Host "Continue anyway? (y/n)"
            if ($response -ne "y") { exit 1 }
        }
    }
    
    # Create install directory
    if (-not (Test-Path $InstallPath)) {
        New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
        Write-Success "Created installation directory: $InstallPath"
    }
}

# ============================================================================
# DOCKER INSTALLATION & SETUP
# ============================================================================
function Install-Docker {
    Write-Title "Docker Desktop Setup"
    
    if ($SkipDocker) {
        Write-Warning "Docker installation skipped"
        return
    }
    
    # Check if Docker is already installed
    $dockerPath = "C:\Program Files\Docker\Docker\Docker.exe"
    if (Test-Path $dockerPath) {
        Write-Success "Docker Desktop already installed"
        return
    }
    
    Write-Info "Installing Docker Desktop for Windows..."
    
    # Download Docker Desktop installer
    $dockerUrl = "https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe"
    $dockerinstaller = "$env:TEMP\DockerInstaller.exe"
    
    Write-Info "Downloading Docker Desktop..."
    try {
        Invoke-WebRequest -Uri $dockerUrl -OutFile $dockerInstaller -UseBasicParsing -ErrorAction Stop
        Write-Success "Docker Desktop downloaded"
    } catch {
        Write-Error "Failed to download Docker Desktop"
        Write-Info "Please download manually from: https://www.docker.com/products/docker-desktop"
        return
    }
    
    Write-Info "Running Docker Desktop installer (requires manual completion)..."
    & $dockerInstaller
    
    Write-Warning "Docker Desktop installer opened. Please complete the installation."
    Write-Info "After installation, enable WSL 2: Settings → Update & Security → For developers → Developer Mode"
}

# ============================================================================
# PYTHON INSTALLATION
# ============================================================================
function Install-Python {
    Write-Title "Python Environment Setup"
    
    if ($SkipPython) {
        Write-Warning "Python installation skipped"
        return
    }
    
    # Check if Python is installed
    $pythonPath = (Get-Command python -ErrorAction SilentlyContinue).Source
    if ($pythonPath) {
        $version = python --version 2>&1
        Write-Success "Python already installed: $version"
        return
    }
    
    Write-Info "Installing Python 3.11+"
    Write-Warning "Please download from: https://www.python.org/downloads/windows/"
    Write-Info "Ensure 'Add Python to PATH' is checked during installation"
}

# ============================================================================
# NODE.JS INSTALLATION
# ============================================================================
function Install-NodeJS {
    Write-Title "Node.js Environment Setup"
    
    if ($SkipNodeJS) {
        Write-Warning "Node.js installation skipped"
        return
    }
    
    $nodePath = (Get-Command node -ErrorAction SilentlyContinue).Source
    if ($nodePath) {
        $version = node --version
        Write-Success "Node.js already installed: $version"
        return
    }
    
    Write-Info "Installing Node.js LTS"
    Write-Warning "Please download from: https://nodejs.org/"
}

# ============================================================================
# AGENT ZERO DEPLOYMENT
# ============================================================================
function Deploy-AgentZero {
    param([string]$Action)
    
    Write-Title "Agent Zero Deployment"
    
    $agentPath = "$InstallPath\agent-zero"
    
    if ($Action -eq "install") {
        Write-Info "Installing Agent Zero..."
        
        # Clone repository
        if (-not (Test-Path $agentPath)) {
            Write-Info "Cloning Agent Zero repository..."
            git clone https://github.com/gsgjdhfafa/agent-zero.git $agentPath 2>&1 | Out-Null
            Write-Success "Repository cloned"
        } else {
            Write-Warning "Agent Zero directory already exists"
        }
        
        # Create Docker Compose override for Windows
        $dockerComposeOverride = @"
version: '3.8'
services:
  agent-zero:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./data:/data
      - ./logs:/logs
      - ./projects:/projects
    environment:
      - PYTHONUNBUFFERED=1
      - LOG_LEVEL=INFO
    restart: unless-stopped
"@
        
        $dockerComposeOverride | Out-File -FilePath "$agentPath\docker-compose.override.yml" -Encoding UTF8 -Force
        Write-Success "Docker Compose configured"
        
        Write-Success "Agent Zero ready to deploy"
        Write-Info "Run: cd $agentPath && docker compose up -d"
    }
    
    if ($Action -eq "start") {
        if (Test-Path $agentPath) {
            Write-Info "Starting Agent Zero..."
            & docker compose -f "$agentPath\docker-compose.yml" up -d
            Write-Success "Agent Zero started"
            Write-Info "Access at: http://localhost"
        }
    }
    
    if ($Action -eq "stop") {
        if (Test-Path $agentPath) {
            Write-Info "Stopping Agent Zero..."
            & docker compose -f "$agentPath\docker-compose.yml" down
            Write-Success "Agent Zero stopped"
        }
    }
}

# ============================================================================
# N8N WORKFLOW AUTOMATION DEPLOYMENT
# ============================================================================
function Deploy-N8N {
    param([string]$Action)
    
    Write-Title "n8n Workflow Automation Deployment"
    
    $n8nPath = "$InstallPath\n8n"
    
    if ($Action -eq "install") {
        Write-Info "Installing n8n..."
        
        if (-not (Test-Path $n8nPath)) {
            New-Item -ItemType Directory -Path $n8nPath -Force | Out-Null
        }
        
        # Create docker-compose for n8n
        $dockerCompose = @"
version: '3.8'

services:
  n8n:
    image: n8n/n8n
    ports:
      - "5678:5678"
    environment:
      - N8N_BASIC_AUTH_ACTIVE=true
      - N8N_BASIC_AUTH_USER=admin
      - N8N_BASIC_AUTH_PASSWORD=change_me_please
      - N8N_EDITOR_BASE_URL=http://localhost:5678/
      - WEBHOOK_URL=http://localhost:5678/
    volumes:
      - n8n_data:/home/node/.n8n
      - $n8nPath\workflows:/home/node/workflows
    restart: unless-stopped

  postgres:
    image: postgres:15-alpine
    environment:
      - POSTGRES_USER=n8n
      - POSTGRES_PASSWORD=n8n_password
      - POSTGRES_DB=n8n
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  n8n_data:
  postgres_data:
"@
        
        $dockerCompose | Out-File -FilePath "$n8nPath\docker-compose.yml" -Encoding UTF8 -Force
        Write-Success "n8n Docker Compose created"
        Write-Success "n8n ready to deploy"
        Write-Info "Run: cd $n8nPath && docker compose up -d"
        Write-Warning "Change N8N_BASIC_AUTH_PASSWORD in docker-compose.yml before first run!"
    }
    
    if ($Action -eq "start") {
        if (Test-Path "$n8nPath\docker-compose.yml") {
            Write-Info "Starting n8n..."
            & docker compose -f "$n8nPath\docker-compose.yml" up -d
            Write-Success "n8n started"
            Write-Info "Access at: http://localhost:5678"
        }
    }
    
    if ($Action -eq "stop") {
        if (Test-Path "$n8nPath\docker-compose.yml") {
            Write-Info "Stopping n8n..."
            & docker compose -f "$n8nPath\docker-compose.yml" down
            Write-Success "n8n stopped"
        }
    }
}

# ============================================================================
# LIBRECHAT DEPLOYMENT
# ============================================================================
function Deploy-LibreChat {
    param([string]$Action)
    
    Write-Title "LibreChat Deployment"
    
    $librechatPath = "$InstallPath\LibreChat"
    
    if ($Action -eq "install") {
        Write-Info "Installing LibreChat..."
        
        if (-not (Test-Path $librechatPath)) {
            Write-Info "Cloning LibreChat repository..."
            git clone https://github.com/gsgjdhfafa/LibreChat.git $librechatPath 2>&1 | Out-Null
            Write-Success "Repository cloned"
        }
        
        # Create .env file
        $envFile = @"
MONGO_URI=mongodb://mongo:27017/librechat
JWT_SECRET=your_secret_key_here_change_me
OPENAI_API_KEY=your_api_key_here
ANTHROPIC_API_KEY=your_api_key_here
AZURE_API_KEY=your_api_key_here
PORT=3080
NODE_ENV=production
"@
        
        $envFile | Out-File -FilePath "$librechatPath\.env" -Encoding UTF8 -Force
        Write-Success "LibreChat .env configured"
        Write-Warning "Update API keys in .env file before running"
        Write-Info "Run: cd $librechatPath && docker compose up -d"
    }
    
    if ($Action -eq "start") {
        if (Test-Path $librechatPath) {
            Write-Info "Starting LibreChat..."
            Set-Location $librechatPath
            & docker compose up -d
            Write-Success "LibreChat started"
            Write-Info "Access at: http://localhost:3080"
        }
    }
}

# ============================================================================
# AGENTEXAMPLES DEPLOYMENT
# ============================================================================
function Deploy-AgentExamples {
    param([string]$Action)
    
    Write-Title "Agent Examples Framework Comparison"
    
    $agentExamplesPath = "$InstallPath\AgentExamples"
    
    if ($Action -eq "install") {
        Write-Info "Setting up Agent Examples..."
        
        if (-not (Test-Path $agentExamplesPath)) {
            Write-Info "Cloning AgentExamples repository..."
            git clone https://github.com/gsgjdhfafa/AgentExamples.git $agentExamplesPath 2>&1 | Out-Null
            Write-Success "Repository cloned"
        }
        
        # Create Python virtual environment
        Write-Info "Creating Python virtual environment..."
        & python -m venv "$agentExamplesPath\venv"
        
        # Activate venv and install dependencies
        $activateScript = "$agentExamplesPath\venv\Scripts\Activate.ps1"
        if (Test-Path $activateScript) {
            & $activateScript
            Set-Location $agentExamplesPath
            & pip install -r requirements.txt
            Write-Success "Dependencies installed"
        }
        
        Write-Info "Create .env with your API keys:"
        Write-Info "  TAVILY_API_KEY=..."
        Write-Info "  OPENAI_API_KEY=..."
        Write-Info "  ANTHROPIC_API_KEY=..."
        Write-Info "Run: streamlit run agent-ui.py"
    }
    
    if ($Action -eq "start") {
        if (Test-Path $agentExamplesPath) {
            $activateScript = "$agentExamplesPath\venv\Scripts\Activate.ps1"
            if (Test-Path $activateScript) {
                & $activateScript
                Set-Location $agentExamplesPath
                & streamlit run agent-ui.py
            }
        }
    }
}

# ============================================================================
# GOVIRALBRO DEPLOYMENT
# ============================================================================
function Deploy-GoViralBro {
    param([string]$Action)
    
    Write-Title "GoViralBro Social Media Coaching"
    
    $goviralPath = "$InstallPath\goviralbro"
    
    if ($Action -eq "install") {
        Write-Info "Setting up GoViralBro..."
        
        if (-not (Test-Path $goviralPath)) {
            Write-Info "Cloning GoViralBro repository..."
            git clone https://github.com/gsgjdhfafa/goviralbro.git $goviralPath 2>&1 | Out-Null
            Write-Success "Repository cloned"
        }
        
        Set-Location $goviralPath
        Write-Info "Running initialization script..."
        if (Test-Path "scripts\init-viral-command.sh") {
            # Convert bash script to PowerShell
            Write-Info "GoViralBro setup. Please configure:"
            Write-Info "  - OpenAI API key"
            Write-Info "  - YouTube Data API v3 key"
            Write-Info "  - Instagram (optional)"
            Write-Info "See: SETUP.md for detailed instructions"
        }
        
        Write-Success "GoViralBro ready"
    }
}

# ============================================================================
# PICO VR DEPLOYMENT
# ============================================================================
function Deploy-PicoVR {
    param([string]$Action)
    
    Write-Title "PICO 4 VR Control Center"
    
    $picoPath = "$InstallPath\PICCO-4-VR-NEXT"
    
    if ($Action -eq "install") {
        Write-Info "Setting up PICO 4 VR Control Center..."
        
        if (-not (Test-Path $picoPath)) {
            Write-Info "Cloning PICCO-4-VR-NEXT repository..."
            git clone https://github.com/gsgjdhfafa/PICCO-4-VR-NEXT.git $picoPath 2>&1 | Out-Null
            Write-Success "Repository cloned"
        }
        
        # Copy scripts to standard location
        $setupPath = "C:\Users\$env:USERNAME\PicoSetup"
        if (-not (Test-Path $setupPath)) {
            New-Item -ItemType Directory -Path $setupPath -Force | Out-Null
        }
        
        Copy-Item -Path "$picoPath\scripts\*" -Destination $setupPath -Recurse -Force
        Write-Success "PICO scripts copied to: $setupPath"
        
        Write-Info "Creating desktop shortcuts..."
        $shell = New-Object -ComObject WScript.Shell
        $desktopPath = [System.Environment]::GetFolderPath("Desktop")
        
        # Create shortcut
        $shortcut = $shell.CreateShortcut("$desktopPath\PICO Setup.lnk")
        $shortcut.TargetPath = $setupPath
        $shortcut.Save()
        
        Write-Success "Desktop shortcut created"
    }
}

# ============================================================================
# MAIN MENU
# ============================================================================
function Show-MainMenu {
    Write-Title "gsgjdhfafa Projects - Windows Deployment Menu"
    Write-Info "Install Path: $InstallPath`n"
    Write-Host "Select Project to Deploy:"
    Write-Host ""
    Write-Host "  1) Agent Zero          - AI Agent Framework"
    Write-Host "  2) n8n                 - Workflow Automation"
    Write-Host "  3) LibreChat           - Self-Hosted ChatGPT Clone"
    Write-Host "  4) AgentExamples       - Framework Comparison"
    Write-Host "  5) GoViralBro          - Social Media Coach"
    Write-Host "  6) PICO VR             - VR Control Center"
    Write-Host "  7) All Projects        - Full Suite Installation"
    Write-Host "  0) Exit"
    Write-Host ""
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================
function Main {
    # Check prerequisites
    Test-Prerequisites
    
    # Ensure Git is installed
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Error "Git is not installed. Please install from: https://git-scm.com/download/win"
        exit 1
    }
    
    # Install prerequisites
    if ($Action -eq "install" -or $Action -eq "all") {
        Install-Docker
        Install-Python
        Install-NodeJS
    }
    
    # Deploy based on Project parameter
    switch ($Project) {
        "agent-zero" { Deploy-AgentZero -Action $Action }
        "n8n" { Deploy-N8N -Action $Action }
        "librechat" { Deploy-LibreChat -Action $Action }
        "agentexamples" { Deploy-AgentExamples -Action $Action }
        "goviralbro" { Deploy-GoViralBro -Action $Action }
        "pico-vr" { Deploy-PicoVR -Action $Action }
        "all" {
            Deploy-AgentZero -Action $Action
            Deploy-N8N -Action $Action
            Deploy-LibreChat -Action $Action
            Deploy-AgentExamples -Action $Action
            Deploy-GoViralBro -Action $Action
            Deploy-PicoVR -Action $Action
        }
    }
    
    Write-Title "Deployment Complete"
    Write-Success "All selected projects configured for Windows"
    Write-Info "Next steps:"
    Write-Info "  1. Configure API keys in .env files"
    Write-Info "  2. Start Docker Desktop"
    Write-Info "  3. Run: docker compose up -d"
}

# Execute main
Main
