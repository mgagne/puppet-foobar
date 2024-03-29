require 'puppet'
require 'puppet/type/rabbitmq_policy'

describe Puppet::Type.type(:rabbitmq_policy) do

  before do
    @policy = Puppet::Type.type(:rabbitmq_policy).new(
      :name       => 'ha-all@/',
      :pattern    => '.*',
      :definition => {
        'ha-mode' => 'all'
      })
  end

  it 'should accept a valid name' do
    @policy[:name] = 'ha-all@/'
    @policy[:name].should == 'ha-all@/'
  end

  it 'should require a name' do
    expect {
      Puppet::Type.type(:rabbitmq_policy).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should fail when name does not have a @' do
    expect {
      @policy[:name] = 'ha-all'
    }.to raise_error(Puppet::Error, /Valid values match/)
  end

  it 'should accept a valid regex for pattern' do
    @policy[:pattern] = '.*?'
    @policy[:pattern].should == '.*?'
  end

  it 'should accept an empty string for pattern' do
    @policy[:pattern] = ''
    @policy[:pattern].should == ''
  end

  it 'should not accept invalid regex for pattern' do
    expect {
      @policy[:pattern] = '*'
    }.to raise_error(Puppet::Error, /Invalid regexp/)
  end

  it 'should accept valid value for applyto' do
    [:all, :exchanges, :queues].each do |v|
      @policy[:applyto] = v
      @policy[:applyto].should == v
    end
  end

  it 'should not accept invalid value for applyto' do
    expect {
      @policy[:applyto] = 'me'
    }.to raise_error(Puppet::Error, /Invalid value/)
  end

  it 'should accept a valid hash for definition' do
    definition = {'ha-mode' => 'all', 'ha-sync-mode' => 'automatic'}
    @policy[:definition] = definition
    @policy[:definition].should == definition
  end

  it 'should not accept invalid hash for definition' do
    expect {
      @policy[:definition] = 'ha-mode'
    }.to raise_error(Puppet::Error, /Invalid definition/)

    expect {
      @policy[:definition] = {'ha-mode' => ['a', 'b']}
    }.to raise_error(Puppet::Error, /Invalid definition/)
  end

  it 'should accept valid value for priority' do
    [0, 10, '0', '10'].each do |v|
      @policy[:priority] = v
      @policy[:priority].should == v
    end
  end

  it 'should not accept invalid value for priority' do
    ['-1', -1, '1.0', 1.0, 'abc', ''].each do |v|
      expect {
        @policy[:priority] = v
      }.to raise_error(Puppet::Error, /Invalid value/)
    end
  end

  #it "should autorequire rabbitmq_vhost" do
  #  vhost = Puppet::Type.type(:rabbitmq_vhost).new(:name => "/")
  #  config = Puppet::Resource::Catalog.new :testing do |conf|
  #    [vhost, perm].each { |resource| conf.add_resource resource }
  #  end
  #  rel = perm.autorequire[0]
  #  rel.source.ref.should == vhost.ref
  #  rel.target.ref.should == @policy.ref
  #end
end
