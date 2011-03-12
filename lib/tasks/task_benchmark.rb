class Rake::Task
  def execute_with_benchmark(*args)
    bench = Benchmark.measure do
      execute_without_benchmark(*args)
    end
    puts "  #{name} --> #{bench}"
  end
  alias_method_chain :execute, :benchmark
end

