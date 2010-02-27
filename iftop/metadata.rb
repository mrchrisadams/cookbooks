maintainer       "Example Com"
maintainer_email "ops@example.com"
license          "Apache 2.0"
description      "Installs/Configures iftop, a nicer way network analyser"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

%w{ redhat centos debian ubuntu }.each do |os|
  supports os
end