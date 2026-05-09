# Python 项目环境配置指南

## 目录
- [Python 安装](#python-安装)
  - [macOS](#macos)
  - [Windows](#windows)
  - [Linux](#linux)
- [虚拟环境管理](#虚拟环境管理)
  - [venv (Python 内置)](#venv-python-内置)
  - [Conda (Anaconda/Miniconda)](#conda-anacondaminiconda)
  - [Virtualenv + virtualenvwrapper](#virtualenv--virtualenvwrapper)
  - [Poetry](#poetry)
  - [Pipenv](#pipenv)
- [项目依赖管理](#项目依赖管理)

---

## Python 安装

### macOS

#### 方式一：使用 Homebrew (推荐)
```bash
# 安装 Homebrew (如果未安装)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 安装 Python 最新版本
brew install python3

# 或安装指定版本
brew install python@3.10

# 验证安装
python3 --version
pip3 --version
```

#### 方式二：使用 pyenv (多版本管理
```bash
# 安装 pyenv
brew install pyenv

# 配置环境变量 (zsh)
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc

# 重新加载配置
source ~/.zshrc

# 安装指定 Python 版本
pyenv install 3.11.0
pyenv global 3.11.0

# 验证
python --version
```

### Windows

#### 方式一：官方安装包
1. 访问 [Python 官网](https://www.python.org/downloads/windows/) 下载安装包
2. 运行安装程序，勾选 "Add Python to PATH"
3. 验证安装
```cmd
python --version
pip --version
```

#### 方式二：使用 Chocolatey
```powershell
# 安装 Chocolatey (管理员权限)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1')

# 安装 Python
choco install python

# 验证
python --version
```

#### 方式三：使用 pyenv-win
```powershell
# 安装 pyenv-win
Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"
.\install-pyenv-win.ps1

# 安装 Python
pyenv install 3.11.0
pyenv global 3.11.0
```

### Linux

#### Ubuntu/Debian
```bash
# 更新包列表
sudo apt update

# 安装 Python
sudo apt install -y python3 python3-pip python3-venv

# 安装构建依赖
sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
xz-utils tk-dev libffi-dev liblzma-dev

# 验证
python3 --version
```

#### CentOS/RHEL
```bash
# 安装 EPEL 仓库
sudo yum install -y epel-release

# 安装 Python
sudo yum install -y python3 python3-pip python3-devel

# 验证
python3 --version
```

#### 使用 pyenv (通用)
```bash
# 安装 pyenv
curl https://pyenv.run | bash

# 配置环境变量
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc

source ~/.bashrc

# 安装 Python
pyenv install 3.11.0
pyenv global 3.11.0
```

---

## 虚拟环境管理

### venv (Python 内置)

#### 创建虚拟环境
```bash
# 创建虚拟环境
python3 -m venv venv

# 激活虚拟环境
# macOS/Linux
source venv/bin/activate
# Windows (CMD)
venv\Scripts\activate.bat
# Windows (PowerShell)
venv\Scripts\Activate.ps1

# 退出虚拟环境
deactivate
```

### Conda (Anaconda/Miniconda)

#### 安装 Miniconda
```bash
# macOS/Linux
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh

# Windows
# 从 https://docs.conda.io/en/latest/miniconda.html 下载安装
```

#### 使用 Conda 环境管理
```bash
# 创建环境
conda create -n myenv python=3.11

# 激活环境
conda activate myenv

# 退出环境
conda deactivate

# 删除环境
conda env remove -n myenv

# 列出环境列表
conda env list

# 导出环境
conda env export > environment.yml

# 从文件创建环境
conda env create -f environment.yml
```

### Virtualenv + virtualenvwrapper

#### 安装
```bash
# 安装
pip install virtualenv virtualenvwrapper

# 配置 (macOS/Linux)
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.zshrc
echo 'export VIRTUALENVWRAPPER_PYTHON=$(which python3)' >> ~/.zshrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.zshrc
source ~/.zshrc
```

#### 使用
```bash
# 创建环境
mkvirtualenv myenv

# 激活环境
workon myenv

# 退出环境
deactivate

# 删除环境
rmvirtualenv myenv

# 列出环境
lsvirtualenv
```

### Poetry

#### 安装
```bash
# 安装 Poetry
curl -sSL https://install.python-poetry.org | python3 -

# 配置 (可选) 配置虚拟环境在项目目录下
poetry config virtualenvs.in-project true
```

#### 使用
```bash
# 初始化项目
poetry init

# 创建并激活虚拟环境
poetry shell

# 或直接运行命令
poetry run python script.py

# 安装依赖
poetry add package-name

# 安装开发依赖
poetry add --dev package-name

# 导出 requirements.txt
poetry export -f requirements.txt --output requirements.txt
```

### Pipenv

#### 安装
```bash
# 安装
pip install pipenv
```

#### 使用
```bash
# 创建环境
pipenv install

# 激活环境
pipenv shell

# 安装依赖
pipenv install package-name

# 安装开发依赖
pipenv install --dev package-name

# 锁定依赖
pipenv lock
```

---

## 项目依赖管理

### 使用 requirements.txt
```bash
# 生成依赖列表
pip freeze > requirements.txt

# 安装依赖
pip install -r requirements.txt
```

### 使用 pyproject.toml (PEP 621)
```toml
[project]
name = "my-project"
version = "0.1.0"
requires-python = ">=3.8"
dependencies = [
    "requests>=2.25.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=6.0",
]
```
