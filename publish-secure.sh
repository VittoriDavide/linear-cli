#!/bin/bash

# Linear CLI - Secure PyPI Publication Script
# Uses macOS keychain to securely store and retrieve PyPI tokens

set -e

echo "🔐 Linear CLI - Secure PyPI Publication"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "pyproject.toml" ]; then
    echo "❌ Error: pyproject.toml not found. Please run this from the linear-cli directory."
    exit 1
fi

# Activate virtual environment
source venv/bin/activate

# Check if twine is installed
if ! command -v twine &> /dev/null; then
    echo "📦 Installing twine..."
    pip install twine
fi

echo "🔧 Building fresh package..."
rm -rf dist/ build/ *.egg-info/
python -m build

echo ""
echo "✅ Package built successfully!"
ls -la dist/

echo ""
echo "🧪 Testing upload to Test PyPI first..."
echo ""

# Retrieve token from keychain and upload to test PyPI
echo "Uploading to Test PyPI using keychain token..."
TWINE_PASSWORD=$(security find-generic-password -a "vittoridavide" -s "pypi-token" -w) \
TWINE_USERNAME=__token__ \
twine upload --repository testpypi dist/*

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Successfully uploaded to Test PyPI!"
    echo "🧪 Test the installation with:"
    echo "pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ linear-cli"
    echo ""
    
    read -p "🚀 Upload to production PyPI? (y/N): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        echo ""
        echo "🚀 Uploading to production PyPI..."
        
        TWINE_PASSWORD=$(security find-generic-password -a "vittoridavide" -s "pypi-token" -w) \
        TWINE_USERNAME=__token__ \
        twine upload dist/*
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "🎉 SUCCESS! Your package is now live on PyPI!"
            echo ""
            echo "📦 Users can now install with:"
            echo "pip install linear-cli"
            echo ""
            echo "🔗 View your package at:"
            echo "https://pypi.org/project/linear-cli/"
            echo ""
            echo "📊 Next steps:"
            echo "  - Update README.md to show 'pip install linear-cli' as the primary installation method"
            echo "  - Create a GitHub release with the same version tag (v1.0.0)"
            echo "  - Share with the community!"
        else
            echo "❌ Failed to upload to production PyPI"
            exit 1
        fi
    else
        echo "Cancelled production upload. You can run this script again when ready."
    fi
else
    echo "❌ Failed to upload to Test PyPI"
    exit 1
fi