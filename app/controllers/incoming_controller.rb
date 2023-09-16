# frozen_string_literal: true

class IncomingController < ApplicationController
  @incoming_line = nil
  @provider_id = nil

  before_action :check_incoming_line, except: %i[conference_callback call_status_callback]
  before_action :check_provider_id, except: %i[conference_callback call_status_callback]
  before_action :validate_with_provider, except: %i[conference_callback call_status_callback]

  def voice
    # Check for existing ContactPhone, find contact, or create new contact & phone
    contact_phone = ContactPhone.joins(:contact).where(phone: Phonelib.parse(params[:From]).international).first

    if contact_phone.nil?
      contact = Contact.new
      contact.save!

      contact_phone = ContactPhone.new
      contact_phone.phone_number = params[:From]
      contact_phone.city = params[:CallerCity]
      contact_phone.state = params[:CallerState]
      contact_phone.zip = params[:CallerZip]
      contact_phone.country = params[:CallerCountry]
      contact_phone.contact = contact
      contact_phone.save!
    end

    c = Conversation.new
    c.started_at = DateTime.now
    c.status = 'Incoming'
    c.method = 'Phone'
    c.provider_id = params[:CallSid]
    c.contact_phone = contact_phone
    c.save!

    if @incoming_line.accepts_voicemails && contact.conversations.voicemail.today.count < @incomine_line.voicemail_per_day_limit
      Twilio::TwiML::VoiceResponse.new do |r|
        r.say(@incoming_line.voicemail_greeting)
        r.record(action: recording_complete_url)

        r.hangup
      end
    end
  end

  def recording_complete
    c = Conversation.where(:provider_id => params[:CallSid]).first
    return if !c.present?

    if params[:RecordingStatus] == 'failed'
      Rails.logger.info "Failed recording for #{c.id}"
      return
    end

    c.recording_id = params[:RecordingSid]
    c.save!
  end

  def sms; end

  private

  def check_incoming_line
    @incoming_line = Line.find_by(number: params[:To])

    @incoming_line = Line.find_by(number: params[:From]) if @incoming_line.nil?

    return if @incoming_line

    Rails.logger.info "Incoming request with line #{params[:To]}"
    head :forbidden
    nil
  end

  def check_provider_id
    if params[:CallSid].nil?
      Rails.logger.info 'Incoming request with no provider_id '
      head :forbidden
    end
    @provider_id = params[:CallSid]
  end

  def validate_with_provider
    return true if Rails.env.development?

    auth_token = Telephony::Connection::Client.password

    validator = ::Twilio::Security::RequestValidator.new(auth_token)

    twilio_signature = headers['X-Twilio-Signature']

    validator.validate(url, params, twilio_signature)
  end
end
