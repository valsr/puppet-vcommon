# Returns the user specified policy from the lookup. If a default value if provided it will return it if nothing is found. In addition, context can be specified to check for specific overrides. Policy override can be specified under the policy::override key (which is a hash of policy and their contexts (see examples for demonstration). By default contexts are named using the <type>::<name> schemas as in package::vim or service::puppet.
#
# Further note that context override is optional and not guaranteed to work or be implemented by target manifest. So use with care
#
# @summary Searches hiera for given policy and returns its value
#
# @param policy   Policy key to search (note: key may optionally include the full policy name)
# @param context  Context to use for checking overrides. If no context is provided, then overriding isn't preformed.
# @param default  Default value to return if policy is not found (undef)
# @return The policy to use
#
# @example basic usage
#   $install = vcommon::policy('software::install')
#   $install2 = vcommon::policy('policy::software::install') # equivalent to above
#   $install3 = vcommon::policy('::software::install') # equivalent to above
#
# @example with default value
#   $install = vcommon::policy('software::install', undef, 'latest')
#
# @example context override
#   # Consider the following policy structure:
#   policy:
#     software::install: 'latest'
#   #
#   # and following overrides
#   policy::override:
#     software::install:
#       package::puppet: 5.5.1-ubuntu1
#       package::vim: 7.1-debian1
#       package::alien: absent
#   #
#   # then the following will
#   vcommong::policy('software::install', 'package::vim', undef) # will return 7.1-debian1
#   vcommong::policy('software::install', 'package::alien', undef) # will return absent
#   vcommong::policy('software::install', 'package::gvim', undef) # will return latest
function vcommon::policy(
  String $policy,
  Optional[String] $context = undef,
  Optional[Any] $default = undef,
  ) >> Optional[Any] {

  $policy_name = $policy ? {
    /^policy::/ =>  $policy[8, -1],
    /^::/ => $policy[2, -1],
    default => $policy
  }

  # context provided so test for override
  if $context {
    $override = lookup('policy::override', Hash, 'deep', {})

    if $override.dig($policy_name, $context) {
      $override.dig($policy_name, $context)
    } else {
      $policy_hash = lookup('policy', Hash, 'first', {})
      $policy_hash.dig($policy_name) ? {
        undef => $default,
        default => $policy_hash.dig($policy_name)
      }
    }
  } else {
    $policy_hash = lookup('policy', Hash, 'first', {})
    $policy_hash.dig($policy_name) ? {
      undef => $default,
      default => $policy_hash.dig($policy_name)
    }
  }
}
