#creates symbolic links in your home directory to your new configs
#also backups your former config files
class Config
  attr_reader :config_files, :home, :backup_config_dir, :configs_dir
  def initialize
    @config_files = %w[unison bashrc bash_history bash_logout bash_profile vim/vimrc vim/gvimrc vim]
    @home = File.expand_path('~') + '/'
    @configs_dir = @home + '.configs/'
    @backup_config_dir = @home + 'configs_bak/'
  end

  def original_config_name config
    ".#{config[/\w*$/]}"
  end

  def create_link config
    File.symlink @configs_dir + config, @home + original_config_name(config)
  end

  def move_original_config config
    Dir.mkdir(@backup_config_dir) unless File.directory?(@backup_config_dir)
    %x[mv #{@home + config} #{@backup_config_dir + config}] unless File.exists?(@backup_config_dir + config)
  end
end

conf = Config.new
conf.config_files.each do |config|
  conf.move_original_config conf.original_config_name(config)
  conf.create_link( config ) unless File.symlink?(conf.home + conf.original_config_name(config))
end

# require 'test/unit'
# require 'test_unit_extensions.rb'
# class TestConfig < Test::Unit::TestCase
#   def setup
#     @conf = Config.new
#     @test_configs = %w[test config/conf /Atest]
#     @test_configs_original = %w[.test .conf .Atest]
#   end
# 
#   must "return original config name that starts with dot" do
#     @test_configs.each do |config|
#       assert_equal @test_configs_original.shift, @conf.original_config_name( config )
#     end
#   end
# 
#   must "move original files to the backup dir" do
#     %x[touch #{@test_configs_original.collect { |conf| @conf.home + conf }.join(' ')}]
#     @test_configs_original.each do |config|
#       @conf.move_original_config config
#       assert_equal true, File.exists?(@conf.backup_config_dir + config)
#       assert_equal false, File.exists?(@conf.home + config)
#     end
#     %x[rm -r #{@conf.backup_config_dir}] if File.directory?(@conf.backup_config_dir)
#   end
# 
#   must "create a link in a home dir to the file in config dir" do
#     @test_configs.each do |config|
#       @conf.create_link( config)
#       expected_file = @conf.home + @test_configs_original.shift
#       assert_equal true, File.symlink?(expected_file), "File doesn't exist #{expected_file}"
#       File.unlink expected_file
#     end
#   end
# end
