node.normal['java']['install_flavor'] = 'openjdk'
node.normal['java']['jdk_version'] = '7'
node.normal['java']['accept_license_agreement'] = true

# This workaround comes from CHEF-4234.  It forces the "java" recipe attributes
# to be reloaded, and the ones that interpolate the above to be reevaluated.
node.from_file(run_context.resolve_attribute(*parse_attribute_file_spec("java")))
