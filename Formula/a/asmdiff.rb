class Asmdiff < Formula
  include Language::Python::Virtualenv

  desc "Compare per-function assembly across compilers"
  homepage "https://github.com/rt-rtos/asmdiff"
  url "https://files.pythonhosted.org/packages/56/7b/11e9a432ca0153bf4f228ddc40d36b65ed0307a22a9f7848d284dea8ae6c/asmdiff-0.4.1.tar.gz"
  sha256 "b36136dc87ef43c25e77f5486f05507b83f22d50036318217f71c7700c066200"
  license "MIT"
  head "https://github.com/rt-rtos/asmdiff.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, all: "0e49185dfe7e535e3c0c77de8be77add2ff9a00bbc3a43d8f84d9283e0a93e7c"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.14"

  deny_network_access!

  def install
    build_resources = %w[
      calver
      flit-core
      packaging
      pathspec
      poetry-core
      tomlkit
      trove-classifiers
      vcs-versioning
      setuptools-scm
      pluggy
      hatchling
    ]

    venv = virtualenv_create(libexec, "python3.14")
    build_resources.each do |name|
      venv.pip_install resource(name), build_isolation: false
    end
    venv.pip_install_and_link buildpath, build_isolation: false
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asmdiff --version")
    (testpath/"test.c").write "int add(int x) { return x + 1; }\n"
    output = shell_output("#{bin}/asmdiff test.c --cc '#{ENV.cc} -O2' --filter 'add$' --json")
    assert_match(/"_?add"/, output)
  end
end
