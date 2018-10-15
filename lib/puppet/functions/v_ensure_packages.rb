# frozen_string_literal: true

# Ensures that packages are installed depending on lookup policy (key policy::software::install).
# This function behaves like ensure_packages with the addition that it is controlled by the policy key to default the
# ensure parameter.
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

  def v_ensure_packages(package, options = {})
    policy = call_function('vcommon::get_policy', 'software::install', "package::#{package}", 'latest')

    defaults = if options
                 { 'ensure' => policy }.merge(options)
               else
                 { 'ensure' => policy }
               end

    call_function('ensure_resource', 'package', package, defaults)
  end

  def v_ensure_packages_h(packages, options = {})
    packages.each do |name, opts|
      call_function('v_ensure_packages', name, {}.merge(options).merge(opts)) # in case options in undef/nil
    end
  end

  def v_ensure_packages_a(packages, options = {})
    packages.each do |package|
      call_function('v_ensure_packages', package, options)
    end
  end
end
