# Distribution Guide for Linear CLI

This document outlines different ways to distribute the Linear CLI tool to make it easily installable for users.

## 📦 Package Structure

The project is now set up as a proper Python package with:
- `pyproject.toml` - Modern Python packaging configuration
- `MANIFEST.in` - File inclusion rules for distribution
- Console script entry point: `linear = "linear_search:main"`

## 🚀 Distribution Methods

### 1. PyPI (Python Package Index) - Recommended

**Benefits:**
- Users can install with simple `pip install linear-cli`
- Automatic dependency management
- Version management and updates
- Widest reach for Python users

**Steps to publish:**

```bash
# 1. Build the package
python -m build

# 2. Upload to test PyPI first (recommended)
python -m twine upload --repository testpypi dist/*

# 3. Test installation from test PyPI
pip install --index-url https://test.pypi.org/simple/ linear-cli

# 4. Upload to production PyPI
python -m twine upload dist/*
```

**Prerequisites:**
- Create account at https://pypi.org
- Install twine: `pip install twine`
- Configure authentication (API tokens recommended)

### 2. GitHub Releases with Wheels

**Benefits:**
- Direct distribution from source code repository
- Users can install via `pip install git+https://github.com/vittoridavide/linear-cli.git`
- Great for pre-releases and testing

**Implementation:**
1. Create GitHub release with version tag (e.g., `v1.0.0`)
2. Attach built wheel files to the release
3. Users can download and install manually or via pip

### 3. Homebrew (macOS/Linux)

**Benefits:**
- Native package manager integration for macOS users
- Simple `brew install linear-cli` command
- Automatic updates through Homebrew

**Steps:**
1. Publish to PyPI first
2. Create Homebrew formula
3. Submit to homebrew-core or create tap

**Example Homebrew Formula:**
```ruby
class LinearCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for managing Linear tickets"
  homepage "https://github.com/vittoridavide/linear-cli"
  url "https://files.pythonhosted.org/packages/.../linear-cli-1.0.0.tar.gz"
  sha256 "..."
  license "MIT"

  depends_on "python@3.11"

  resource "requests" do
    url "https://pypi.org/simple/requests/..."
    sha256 "..."
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/linear", "--help"
  end
end
```

### 4. Docker Container

**Benefits:**
- Environment isolation
- Works across all platforms
- Easy to distribute with dependencies

**Dockerfile:**
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY . .
RUN pip install -e .

ENTRYPOINT ["linear"]
CMD ["--help"]
```

**Usage:**
```bash
# Build
docker build -t linear-cli .

# Run
docker run --rm -e LINEAR_API_TOKEN="$LINEAR_API_TOKEN" linear-cli --teams
```

### 5. Standalone Executables (PyInstaller)

**Benefits:**
- No Python installation required
- Single executable file
- Platform-specific builds

**Implementation:**
```bash
# Install PyInstaller
pip install pyinstaller

# Create executable
pyinstaller --onefile --name linear linear_search.py

# Distribute the executable from dist/linear
```

### 6. Arch Linux AUR (Arch User Repository)

**Benefits:**
- Native package manager for Arch Linux users
- Community-maintained packages

**Steps:**
1. Create PKGBUILD file
2. Submit to AUR
3. Users install with `yay -S linear-cli`

### 7. Snap Package (Ubuntu/Linux)

**Benefits:**
- Universal Linux package format
- Automatic updates
- Sandboxed execution

**Implementation:**
Create `snapcraft.yaml` and publish to Snap Store.

## 📋 Current Installation Methods

Based on the current setup, users can install the Linear CLI in the following ways:

### Option 1: From GitHub (Available Now)
```bash
pip install git+https://github.com/vittoridavide/linear-cli.git
```

### Option 2: Local Development Installation
```bash
git clone https://github.com/vittoridavide/linear-cli.git
cd linear-cli
pip install -e .  # Development mode
```

### Option 3: From Built Wheel
```bash
# Download wheel file from GitHub releases
pip install linear_cli-1.0.0-py3-none-any.whl
```

## 🔄 Version Management

**Semantic Versioning (SemVer):**
- `1.0.0` - Initial stable release
- `1.0.1` - Bug fixes
- `1.1.0` - New features (backward compatible)
- `2.0.0` - Breaking changes

**Update Process:**
1. Update version in `pyproject.toml`
2. Update CHANGELOG.md
3. Create Git tag
4. Build and distribute new version

## 📊 Recommended Distribution Strategy

**Phase 1: GitHub + pip install from Git**
- ✅ Currently available
- Users can install immediately
- Great for early adopters and testing

**Phase 2: PyPI Publication**
- Publish to PyPI for easy `pip install linear-cli`
- Create GitHub releases with changelogs
- Set up automated testing and publishing

**Phase 3: Platform-Specific Packages**
- Homebrew formula for macOS users
- Consider AUR for Arch Linux
- Docker images for containerized environments

**Phase 4: Advanced Distribution**
- Standalone executables for non-Python users
- Snap packages for Ubuntu users
- Consider Windows package managers

## 🤖 Automation

**GitHub Actions for automated publishing:**
```yaml
name: Publish to PyPI
on:
  release:
    types: [published]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: actions/setup-python@v4
    - name: Build package
      run: python -m build
    - name: Publish to PyPI
      uses: pypa/gh-action-pypi-publish@release/v1
      with:
        password: ${{ secrets.PYPI_API_TOKEN }}
```

## 📈 Analytics and Feedback

Track distribution success through:
- PyPI download statistics
- GitHub release download counts
- User feedback and issues
- Usage analytics (if implemented)

---

The Linear CLI is now properly packaged and ready for distribution through multiple channels, making it easy for users to install and use regardless of their preferred method! 🎉