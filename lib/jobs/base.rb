# encoding: utf-8

# A very basic superclass for all the jobs in a Rails app.
# Make your jobs inherit from it to get this basic logging features.
module Jobs

  # Callbacks in jobs execution.
  class Base
    def self.before_perform_log(*args)
      puts "WORKER: Starting job #{self.name} at " + I18n.l(Time.current)
    end

    def self.after_perform_log(*args)
      puts "WORKER: Job #{self.name} finished at " + I18n.l(Time.current)
    end

    def self.on_failure_log(e, *args)
      puts "WORKER: Job #{self.name} #{args} failed at " + I18n.l(Time.current) + " causing the next exception: (#{e})."
    end
  end

end
