#!/bin/bash

# Linear CLI - PyPI Publication Script
# This script helps you publish the Linear CLI to PyPI safely

set -e

echo "🎫 Linear CLI - PyPI Publication Guide"
echo "======================================"
echo ""

# Check if we're in the right directory
if [ ! -f "pyproject.toml" ]; then
    echo "❌ Error: pyproject.toml not found. Please run this from the linear-cli directory."
    exit 1
fi

# Check if accounts are set up
echo "📋 Prerequisites Checklist:"
echo "  □ PyPI account created at https://pypi.org/account/register/"
echo "  □ Test PyPI account created at https://test.pypi.org/account/register/"
echo "  □ API tokens generated (recommended over username/password)"
echo ""

# Activate virtual environment
if [ ! -d "venv" ]; then
    echo "❌ Error: Virtual environment not found. Please run ./dev-setup.sh first."
    exit 1
fi

source venv/bin/activate

# Check if twine is installed
if ! command -v twine &> /dev/null; then
    echo "📦 Installing twine..."
    pip install twine
fi

echo "🔧 Step 1: Clean and build package"
echo "Removing old build artifacts..."
rm -rf dist/ build/ *.egg-info/

echo "Building fresh package..."
python -m build

echo ""
echo "✅ Package built successfully!"
echo "Created files:"
ls -la dist/

echo ""
echo "🧪 Step 2: Upload to Test PyPI (RECOMMENDED FIRST)"
echo ""
echo "This allows you to test the package before publishing to production PyPI."
echo ""
echo "Run this command and enter your Test PyPI credentials:"
echo "twine upload --repository testpypi dist/*"
echo ""
echo "After uploading to Test PyPI, test the installation:"
echo "pip install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple/ linear-cli"
echo ""

read -p "Press Enter when you're ready to see the production PyPI upload command..."

echo ""
echo "🚀 Step 3: Upload to Production PyPI"
echo ""
echo "⚠️  WARNING: This makes your package publicly available!"
echo "⚠️  Make sure you tested it on Test PyPI first!"
echo ""
echo "Run this command to publish to production PyPI:"
echo "twine upload dist/*"
echo ""
echo "After successful upload, users can install with:"
echo "pip install linear-cli"
echo ""

echo "🎉 Your Linear CLI will be available worldwide!"
echo ""
echo "📊 After publishing, you can:"
echo "  - View your package at: https://pypi.org/project/linear-cli/"
echo "  - Check download statistics"
echo "  - Update package info and descriptions"
echo "  - Upload new versions (update version in pyproject.toml first)"
echo ""

echo "💡 Pro tips:"
echo "  - Use API tokens instead of username/password for better security"
echo "  - Test thoroughly on Test PyPI before production release"
echo "  - Follow semantic versioning for updates (1.0.0 -> 1.0.1 -> 1.1.0)"
echo "  - Create GitHub releases to match PyPI releases"
echo ""

echo "Ready to publish! 🚀"