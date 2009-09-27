class Collector

  def initialize(input, output)
    @path = File.dirname(__FILE__)
    @input_files = input.map{|i| @path + '/' + i}
    @output_file = @path + '/' + output
    @file = ''
  end
  
  def accumulate!
    read_file
    save_file
  end

  
  protected
  
    def read_file
      @file = ""
      plan = @input_files.inject([]) {|sum, i| sum += File.read(i).split("\n") }
      plan.each do |line|
        @file += File.read(@path + '/' + line)
        @file += "\n"
      end
      @file
    end
    
    
    def save_file
      File.open(@output_file, 'w') do |file|
        file.write(@file)
      end
    end
  
end
