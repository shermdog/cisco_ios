#!/opt/puppetlabs/puppet/bin/ruby
require_relative '../lib/puppet/util/task_helper'
task = Puppet::Util::TaskHelper.new('cisco_ios')

result = {}

unless Puppet.settings.global_defaults_initialized?
  Puppet.initialize_settings
end

begin
  command = task.params['command']
  rtn = task.transport.run_command_enable_mode(command)
  if task.params['raw']
    puts rtn
    exit 0
  end
  result[:status]  = 'success'
  result[:results] = "#{rtn}"
rescue StandardError => e
  result[:_error] = {
    msg: e.message,
    kind: 'puppetlabs/cisco_ios',
    details: {
      class: e.class.to_s,
      backtrace: e.backtrace,
    },
  }
end

puts result.to_json