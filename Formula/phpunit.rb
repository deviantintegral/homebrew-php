require File.expand_path("../../Requirements/php-meta-requirement", __FILE__)
require File.expand_path("../../Requirements/phar-requirement", __FILE__)

class Phpunit < Formula
  desc "PHPUnit is a programmer-oriented testing framework for PHP."
  homepage "http://phpunit.de"
  url "https://phar.phpunit.de/phpunit-5.1.0.phar"
  sha256 "83bf6154f7435f78495d6cbdce62db333dc86aa8032b3ed8370ed51fb351314d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a3eb9b6c32b1973627840993a16f217b8e3eb0efe807e2f45eefa29bf5de2464" => :el_capitan
    sha256 "5a911444dcee51d7e45fdc8483814cf785e9da05e19f4ca4e179f69f9f765a05" => :yosemite
    sha256 "5a911444dcee51d7e45fdc8483814cf785e9da05e19f4ca4e179f69f9f765a05" => :mavericks
  end

  def install
    libexec.install "phpunit-#{version}.phar"
    sh = libexec + "phpunit"

    wrapper = <<END
#!/usr/bin/env bash

PHP_VERSION=$(/usr/bin/env php -r 'echo PHP_MAJOR_VERSION . PHP_MINOR_VERSION;')
XDEBUG_SO=/usr/local/opt/php$PHP_VERSION-xdebug/xdebug.so

# Enable xdebug even if it's disabled to allow for code coverage reports. This
# lets xdebug be disabled for 'normal' CLI requests, resulting in significant
# performance improvements for Composer.
# https://getcomposer.org/doc/articles/troubleshooting.md#xdebug-impact-on-composer
if [ -e $XDEBUG_SO ]
then
    XDEBUG=-dzend_extension=$XDEBUG_SO
fi

echo /usr/bin/env php $XDEBUG -d allow_url_fopen=On -d detect_unicode=Off #{libexec}/phpunit-#{version}.phar $*
END

    sh.write(wrapper)
    chmod 0755, sh
    bin.install_symlink sh
  end

  test do
    shell_output("phpunit --version").include?(version)
  end
end
