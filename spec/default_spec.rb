require 'chefspec'

describe 'proxmox::default' do
  chef_run = ChefSpec::ChefRunner.new
  chef_run.converge 'proxmox::default'

  it "should deploy a proxmox server" do
    #runner = expect(chef_run)

  end
end
