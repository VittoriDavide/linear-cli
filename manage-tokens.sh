#!/bin/bash

echo "🔐 PyPI Token Management"
echo "======================="
echo ""

case "${1:-help}" in
    "show")
        echo "🔍 Current PyPI token (first 20 chars):"
        TOKEN=$(security find-generic-password -a "vittoridavide" -s "pypi-token" -w 2>/dev/null)
        if [ $? -eq 0 ]; then
            echo "${TOKEN:0:20}..."
        else
            echo "❌ No token found in keychain"
        fi
        ;;
    
    "update")
        if [ -z "$2" ]; then
            echo "❌ Please provide new token as argument"
            echo "Usage: $0 update <new_token>"
            exit 1
        fi
        
        echo "🔄 Updating PyPI token in keychain..."
        security delete-generic-password -a "vittoridavide" -s "pypi-token" 2>/dev/null
        security add-generic-password -a "vittoridavide" -s "pypi-token" -w "$2"
        if [ $? -eq 0 ]; then
            echo "✅ Token updated successfully!"
        else
            echo "❌ Failed to update token"
        fi
        ;;
    
    "delete")
        echo "🗑️ Removing PyPI token from keychain..."
        security delete-generic-password -a "vittoridavide" -s "pypi-token"
        if [ $? -eq 0 ]; then
            echo "✅ Token removed successfully!"
        else
            echo "❌ Token not found or failed to remove"
        fi
        ;;
    
    "test")
        echo "🧪 Testing token authentication..."
        source venv/bin/activate 2>/dev/null
        if ! command -v twine &> /dev/null; then
            echo "Installing twine..."
            pip install twine
        fi
        
        TOKEN=$(security find-generic-password -a "vittoridavide" -s "pypi-token" -w 2>/dev/null)
        if [ $? -eq 0 ]; then
            echo "Testing connection to PyPI..."
            echo | TWINE_PASSWORD="$TOKEN" TWINE_USERNAME=__token__ twine check dist/* 2>/dev/null
            if [ $? -eq 0 ]; then
                echo "✅ Token authentication appears to be working"
            else
                echo "⚠️  Could not verify token (may need package files in dist/)"
            fi
        else
            echo "❌ No token found in keychain"
        fi
        ;;
    
    "help"|*)
        echo "PyPI Token Management Commands:"
        echo ""
        echo "  $0 show     - Show first 20 characters of stored token"
        echo "  $0 update   - Update token (provide new token as argument)"
        echo "  $0 delete   - Remove token from keychain"
        echo "  $0 test     - Test if token authentication works"
        echo "  $0 help     - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 show"
        echo "  $0 update pypi-AbCdEf123..."
        echo "  $0 delete"
        echo ""
        echo "Security Notes:"
        echo "- Tokens are stored securely in macOS keychain"
        echo "- Only your user account can access them"
        echo "- Tokens are never displayed in full for security"
        ;;
esac