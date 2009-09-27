require 'rake'
require 'collector'

PLUGIN_PLAN = 'ruby_debugger_plan.txt'
TEST_PLUGIN_PLAN = 'ruby_test_plan.txt'
PLUGIN_PATH = 'vim/plugin/ruby_debugger.vim'
TEST_PLUGIN_PATH = 'additionals/plugin/ruby_debugger_test.vim'
INSTALL_PLUGIN_PATH = File.expand_path '~/.vim/plugin'
INSTALL_DOC_PATH = File.expand_path '~/.vim/doc'
INSTALL_BIN_PATH = File.expand_path '~/.vim/bin'

desc 'Default: Build the plugin'
task :default => 'build'

desc "Build the plugin"
task :build do
  #`rm #{PLUGIN_PATH}`
  #`rm #{TEST_PLUGIN_PATH}`
  #combine_plan_files [PLUGIN_PLAN], PLUGIN_PATH
  #combine_plan_files [PLUGIN_PLAN, TEST_PLUGIN_PLAN], TEST_PLUGIN_PATH

  delete PLUGIN_PATH
  delete TEST_PLUGIN_PATH

  #build main plugin according to plan
  Collector.new([PLUGIN_PLAN], PLUGIN_PATH).accumulate!
  #build test plugin according to plan
  Collector.new([PLUGIN_PLAN, TEST_PLUGIN_PLAN], TEST_PLUGIN_PATH).accumulate!
end

desc "Install the plugin"
task :install => [:uninstall] do
  install_doc_and_bin
  FileUtils.copy PLUGIN_PATH, INSTALL_PLUGIN_PATH
end

desc "Install the plugin with tests"
task :install_test => [:uninstall] do
  install_doc_and_bin
  FileUtils.copy TEST_PLUGIN_PATH, INSTALL_PLUGIN_PATH
end

desc "Removes the installed plugins"
task :uninstall do
  delete "#{INSTALL_PLUGIN_PATH}/ruby_debugger.vim"
  delete "#{INSTALL_PLUGIN_PATH}/ruby_debugger_test.vim"
  delete "#{INSTALL_DOC_PATH}/ruby_debugger.txt"
  delete "#{INSTALL_BIN_PATH}/ruby_debugger.rb"
end

def install_doc_and_bin
  FileUtils.copy "vim/bin/ruby_debugger.rb", "#{INSTALL_BIN_PATH}/ruby_debugger.rb"
  FileUtils.copy "vim/doc/ruby_debugger.txt", INSTALL_DOC_PATH
end

def delete(path)
  File.delete path if File.exists? path
end

def combine_plan_files(plan_file, plugin_path)
  `awk '{system("cat "$1)}' #{plan_file} >> #{plugin_path}`
end

