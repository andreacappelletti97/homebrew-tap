class Clox < Formula
  include Language::Python::Virtualenv

  desc "Geeky clock for terminal enthusiasts"
  homepage "https://github.com/sepandhaghighi/clox"
  url "https://files.pythonhosted.org/packages/eb/81/f9e489fd0918907cb61eaa325f5f9d86dbb1c248ce285adbdb4195b9712d/clox-1.7.tar.gz"
  sha256 "a967d30bdb03f30769919141c71cbad13fdeb1d829da80752b52983de980653d"
  license "MIT"
  head "https://github.com/sepandhaghighi/clox.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "984abc19ea0791e2831b62249e944fc92d08f0a02a6eb75b5a0fc1f0c9367f54"
  end

  depends_on "python@3.14"

  resource "art" do
    url "https://files.pythonhosted.org/packages/d4/7d/7d80509bbd19fb747edef94ba487dbadd2747944774ccc0528ad0d005a36/art-6.5.tar.gz"
    sha256 "a98d77b42c278697ec6cf4b5bdcdfd997f6b2425332da078d4e31e31377d1844"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "jalali-core" do
    url "https://files.pythonhosted.org/packages/2b/3c/21e32e3444c572174a5d774643eb2aa8ab60ef68b99a4c3585a0a11428b4/jalali_core-1.0.0.tar.gz"
    sha256 "f4287c70c630323dcf0a3ab26df905ba4d451e230ac1f65b3bb2f77797894a2b"
  end

  resource "jdatetime" do
    url "https://files.pythonhosted.org/packages/f6/6d/5de9a677b405b279414fca3472daa381d51fa1e5a5e47a64d92b22eaae27/jdatetime-6.1.1.tar.gz"
    sha256 "2911781ec641a2530e9c57e1063a1ad8f2e20ec7feec9cbcebf6ab9db5efa47a"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/14/21/d83d6ef28c4c912c4bb4d1dcf591f7b8c6bde87b9c66f9f454677314e16d/pytz-2026.5.tar.gz"
    sha256 "fa23724b9c486543b9ff54a327ee7569ac83ade54bb9afd0fc18676620401c86"
  end

  resource "typio" do
    url "https://files.pythonhosted.org/packages/79/5f/d681589da136dee91f58392b81b2a87681e3eef2c3857ec272295c660f10/typio-1.3.tar.gz"
    sha256 "4ac0b0d517887965da7bd6960b05fa8e5608f5a81b63a87e6f2b5229ca342461"
  end

  deny_network_access!

  def install
    build_resources = %w[
      setuptools
      flit-core
      packaging
      pathspec
      pluggy
      trove-classifiers
      hatchling
      wheel
    ]

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install resources.reject { |resource| build_resources.include?(resource.name) },
                     build_isolation: false
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clox --version")
    assert_match "Countries list:", shell_output("#{bin}/clox --countries-list")
  end
end
