class LinearTicketCli < Formula
  include Language::Python::Virtualenv

  desc "Comprehensive command-line tool for managing Linear tickets with AI-agent friendly interfaces"
  homepage "https://github.com/vittoridavide/linear-cli"
  url "https://files.pythonhosted.org/packages/d2/dc/9969ce90eb43319aae86804ff72efc13875c219c77de9f0527eb963b50aa/linear_ticket_cli-1.0.0.tar.gz"
  sha256 "7f972707235208652ef4a76d8dfaca87f58a975598e7498e297d3c94dd542575"
  license "MIT"

  depends_on "python@3.11"

  resource "requests" do
    url "https://files.pythonhosted.org/packages/source/r/requests/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "fuzzywuzzy" do
    url "https://files.pythonhosted.org/packages/source/f/fuzzywuzzy/fuzzywuzzy-0.18.0.tar.gz"
    sha256 "45016e92264780e58972dca1b3d939ac864b78437422beecebb3095f8efd00e8"
  end

  resource "python-levenshtein" do
    url "https://files.pythonhosted.org/packages/source/p/python-levenshtein/python-levenshtein-0.21.1.tar.gz"
    sha256 "74f3c9a3c524c2d6d6c7e8e24f4b2eb65001eddb654be8956b6e3cfcd52a90b6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/linear", "--help"
  end
end
