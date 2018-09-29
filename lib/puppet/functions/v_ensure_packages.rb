# Ensures that packages are installed depending on lookup policy (key policy::software::install).
# This function behaves like ensure_packages with the addition that it is controlled by the policy key to default the ensure parameter.
Puppet::Functions.create_function(:v_ensure_packages) do
  # @param package Package name to install
  # @param options Package hash options (see puppet package)
  # @return [Undef]
  #
  # @example basic usage
  #    v_ensure_packages("apt")
  #
  # @example usage with package options
  #    v_ensure_packages("apt", {ensure => absent})
  dispatch :v_ensure_packages do
    param 'String', :package
    optional_param 'Hash[String,Any]', :options
  end

  # @param packages Package names to install
  # @param options Package hash options (see puppet package)
  # @return [Undef]
  #
  # @example basic usage
  #    v_ensure_packages(["apt", "ntp", "vim"])
  #
  # @example usage with package options
  #    v_ensure_packages(["apt", "ntp", "vim"], {ensure => absent})
  dispatch :v_ensure_packages_a do
    param 'Array[String]', :packages
    optional_param 'Hash[String,Any]', :options
  end

  # @param package Package hash structure to install
  # @param options Package hash options (see puppet package)
  # @return [Undef]
  #
  # @example basic usage
  #    v_ensure_packages({'bash' => { ensure => latest }, 'vim' => { provider => 'rpm' } })
  #
  # @example usage with package options
  #    v_ensure_packages({'bash' => { ensure => latest }, 'vim' => { provider => 'rpm' }, {ensure => present})
  dispatch :v_ensure_packages_h do
    param 'Hash[String, Any]', :package
    optional_param 'Hash[String,Any]', :options
  end

  def v_ensure_packages(package, options={})
    softwarePolicy = call_function('lookup', 'policy::software::install',{'default_value'=>'latest'})
    if options
      defaults = {'ensure' => softwarePolicy }.merge(options)
    else
      defaults = {'ensure' => softwarePolicy}
    end

    call_function('ensure_resource', 'package', package, defaults)
  end

  def v_ensure_packages_h(packages, options={})
    softwarePolicy = call_function('lookup', 'policy::software::install',{'default_value'=>'latest'})
    if options
      defaults = {'ensure' => softwarePolicy }.merge(options)
    else
      defaults = {'ensure' => softwarePolicy}
    end

    call_function('ensure_resources', 'package', packages, defaults)
  end

  def v_ensure_packages_a(packages, options={})
    softwarePolicy = call_function('lookup', 'policy::software::install',{'default_value'=>'latest'})
    if options
      defaults = {'ensure' => softwarePolicy }.merge(options)
    else
      defaults = {'ensure' => softwarePolicy}
    end

    packages.each { |package_name|
      call_function('ensure_resource', 'package', package_name, defaults)
    }
  end
end
