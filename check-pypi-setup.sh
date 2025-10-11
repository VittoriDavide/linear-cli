#!/bin/bash

echo "🔍 Linear CLI - PyPI Setup Verification"
echo "======================================="
echo ""

# Check keychain token
echo "🔐 Checking PyPI token in keychain..."
if security find-generic-password -a "vittoridavide" -s "pypi-token" -w &>/dev/null; then
    TOKEN_PREVIEW=$(security find-generic-password -a "vittoridavide" -s "pypi-token" -w | head -c 20)
    echo "✅ PyPI token found in keychain: ${TOKEN_PREVIEW}..."
else
    echo "❌ PyPI token not found in keychain"
    exit 1
fi

# Check .pypirc file
echo ""
echo "📋 Checking .pypirc configuration..."
if [ -f ~/.pypirc ]; then
    echo "✅ .pypirc file exists"
    echo "   Contains repositories: $(grep -E '^\s*repository\s*=' ~/.pypirc | wc -l | tr -d ' ') configured"
else
    echo "❌ .pypirc file not found"
fi

# Check virtual environment
echo ""
echo "🐍 Checking Python environment..."
if [ -d "venv" ]; then
    echo "✅ Virtual environment found"
    source venv/bin/activate
    if command -v twine &> /dev/null; then
        echo "✅ Twine is installed: $(twine --version)"
    else
        echo "⚠️  Twine not installed - will be installed automatically"
    fi
    if command -v python &> /dev/null; then
        echo "✅ Python available: $(python --version)"
    else
        echo "❌ Python not available in venv"
    fi
else
    echo "❌ Virtual environment not found"
fi

# Check package build
echo ""
echo "📦 Checking package configuration..."
if [ -f "pyproject.toml" ]; then
    echo "✅ pyproject.toml found"
    PACKAGE_NAME=$(grep '^name = ' pyproject.toml | sed 's/name = "\(.*\)"/\1/')
    PACKAGE_VERSION=$(grep '^version = ' pyproject.toml | sed 's/version = "\(.*\)"/\1/')
    echo "   Package: $PACKAGE_NAME"
    echo "   Version: $PACKAGE_VERSION"
else
    echo "❌ pyproject.toml not found"
fi

if [ -f "MANIFEST.in" ]; then
    echo "✅ MANIFEST.in found"
else
    echo "⚠️  MANIFEST.in not found"
fi

echo ""
echo "🎯 Setup Summary:"
echo "=================="

if security find-generic-password -a "vittoridavide" -s "pypi-token" -w &>/dev/null && \
   [ -f ~/.pypirc ] && \
   [ -f "pyproject.toml" ] && \
   [ -d "venv" ]; then
    echo "✅ Your PyPI publishing setup is complete!"
    echo ""
    echo "🚀 Ready to publish! Run:"
    echo "./publish-secure.sh"
    echo ""
    echo "This will:"
    echo "  1. Build your package"
    echo "  2. Upload to Test PyPI first (recommended)"
    echo "  3. Ask if you want to upload to production PyPI"
    echo "  4. Handle authentication automatically using keychain"
else
    echo "⚠️  Some setup issues detected. Please fix the ❌ items above."
fi