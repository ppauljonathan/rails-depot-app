class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"

  before_action :set_process_id_email_header

  private

    def set_process_id_email_header
      headers['X-SYSTEM-PROCESS-ID'] = Process.pid
    end
end
