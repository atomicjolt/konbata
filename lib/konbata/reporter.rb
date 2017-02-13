module Konbata
  class Reporter
    def self.start_course(course, index, total)
      puts center("Starting course #{course} (#{index + 1}/#{total})")
    end

    def self.complete_course(course)
      puts center("Completed course #{course}")
    end

    def self.complete_source_file(index, total)
      puts "  >> Completed source file #{index + 1} of #{total}"
    end

    def self.center(message)
      message.center(55, "-")
    end
  end
end
