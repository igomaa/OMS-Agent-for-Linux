require 'test/unit'
require 'mocha/test_unit'
require_relative '../../../source/code/plugins/patch_management_runner'
require_relative '../../../source/code/plugins/patch_management_lib'
require_relative 'omstestlib'

# This is test class contains unit test cases for Patch_managment_runner
class PatchManagementTest < Test::Unit::TestCase
  @patch_management_runner_inst = nil

  def setup
    @patch_management_runner_inst = PatchManagementRunner.new(OMS::MockLog.new)
  end

  def test_xml2json
    test_inventory_file = File.join(
      File.dirname(__FILE__),
      'CompletePackageInventory.xml'
    )

    fake_os_details = {
      'OSName' => 'fake_os_name',
      'OSVersion' => '16.08',
      'OSFullName' => 'Ubuntu 16.08'
    }

    LinuxUpdates.any_instance.stubs(:getAgentId)
                .returns('fake_agent_id')
    LinuxUpdates.any_instance.stubs(:getHostOSDetails)
                .returns(fake_os_details)
    LinuxUpdates.any_instance.stubs(:getOSShortName)
                .returns('fake_os_short_name')

    @patch_management_runner_inst.expects(:invetory_file)
                                 .returns(test_inventory_file)
    ret = @patch_management_runner_inst.transform_and_wrap

    assert_equal('LINUX_UPDATES_SNAPSHOT_BLOB', ret['DataType'])
  end
end
