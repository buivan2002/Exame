class DeviseMailer < Devise::Mailer
  default from: 'no-reply@yourapp.com'
  layout 'mailer'
end

