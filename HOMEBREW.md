# Homebrew Tap for Linear CLI

This repository doubles as a Homebrew tap for installing the Linear CLI tool.

## Installation

```bash
# Add the tap
brew tap vittoridavide/linear-cli https://github.com/vittoridavide/linear-cli

# Install the tool
brew install linear-ticket-cli
```

## Usage

After installation, you can use the `linear` command:

```bash
# Set your API token
export LINEAR_API_TOKEN="your_token_here"

# Use the CLI
linear --help
linear add --title "Test ticket" --team "Backend"
```

## Updating

```bash
brew upgrade linear-ticket-cli
```

## Alternative Installation

If you prefer to install directly from PyPI:

```bash
pip install linear-ticket-cli
```