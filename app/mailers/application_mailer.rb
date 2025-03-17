class ApplicationMailer < ActionMailer::Base
  default from: 'buiquocanh1612@gmail.com'
  default_url_options[:host] ||= 'localhost:3000'
  layout 'mailer'
end
