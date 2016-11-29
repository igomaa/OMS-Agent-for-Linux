# This code is excuted by Fluentd conf directly

require 'logger'
require_relative 'patch_management_lib'

# This is class to transform xml file to Json
class PatchManagementRunner
  @log = nil
  @linuxupdate_instance = nil
  @host_name = nil

  def initialize(logger)
    @log = logger
    # @log.formatter = proc do |severity, _time, _progname, msg|
    #  "#{severity} #{msg}\n"
    # end
    @hostname = OMS::Common.get_hostname || 'Unknown host'
    @linuxupdate_instance = LinuxUpdates.new(@log)
  end

  def invetory_file
    ARGV[0]
  end

  def transform_and_wrap
    @log.debug '~~~~~~~~~~~~~~Shujun Runner code is called~~~~~~~~~~~~~~'
    inventory_path = invetory_file
    @log.debug "Inventory file: #{inventory_path}"

    if File.exist?(inventory_path)
      @log.debug 'Found the patch management inventory file.'
      inventory_content = File.read(inventory_path)

      @log.debug "PatchManagementRunner : Inventory xml size=
      #{inventory_content.size}"

      wrapped_hash = @linuxupdate_instance.transform_and_wrap(
        inventory_content,
        @hostname,
        Time.now
      )

      wrapped_hash
    else
      {}
    end
  end
end

patch_management_runner_instance = PatchManagementRunner.new(Logger.new(STDERR))

ret = patch_management_runner_instance.transform_and_wrap
puts ret.to_json if !ret.nil?