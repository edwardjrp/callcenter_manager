class ReportsWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  
  def perform(name, start_time, end_time, options = {})
    report = Report.new(name: name)
    report.generate(Time.parse(start_time), Time.parse(end_time), options)
  end
end