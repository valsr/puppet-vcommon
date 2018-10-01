# Returns the user specified policy from the lookup
#
# @summary Searches hiera for given policy and returns its value
#
# @param policy   Policy key to search (note: key may optionally include the full policy name)
# @param default  Default value to return if policy is not found (undef)
# @return Home directory or default if not found
#
# @example basic usage
#   $install = vcommon::get_policy('software::install')
#   $install2 = vcommon::get_policy('policy::software::install') # equivalent to above
#   $install3 = vcommon::get_policy('::software::install') # equivalent to above
#
# @example with default value
#   $install = vcommon::get_policy('software::install', 'latest')
function vcommon::get_policy(
  String $policy,
  Optional[Any] $default = undef
  ) >> Optional[Any] {

  $use_policy = $policy ? {
    /^policy::/ =>  $policy,
    /^::/ => "policy${policy}",
    default => "policy::${policy}"
  }

  lookup($use_policy, Any, 'first', $default)
}
