# frozen_string_literal: true

task create_fake_data: [:environment] do
  puts "Nope, not in prod" and return if !Rails.env.development?

  100.times do
    contact = Contact.new
    contact.save!

    contact_phone = ContactPhone.new
    contact_phone.phone = Faker::PhoneNumber.unique.cell_phone_in_e164
    contact_phone.city = Faker::Address.city
    contact_phone.state = Faker::Address.state_abbr
    contact_phone.zip = Faker::Address.zip_code(state_abbreviation: contact_phone.state)
    contact_phone.country = Faker::Address.country_code
    contact_phone.contact = contact
    contact_phone.save!

    convo = Conversation.new
    convo.started_at = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now)
    convo.contact_phone = contact_phone
    convo.provider_id = Faker::Alphanumeric.alphanumeric(number: 15)
    convo.method = 'Phone'
    convo.status = 'Incoming'
    convo.save!

    next unless Random.random_number > 0.15

    convo.finish
    num_minutes = Faker::Number.between(from: 1, to: 180)
    convo.ended_at = convo.started_at + num_minutes.minutes
    r = Random.random_number
    convo.notes = if r > 0.8
                    Faker::Lorem.paragraphs(number: 2).join(' ')
                  elsif r > 0.6
                    Faker::Lorem.paragraphs(number: 1).join(' ')
                  elsif r > 0.2
                    Faker::Lorem.sentences(number: 4).join(' ')
                  else
                    Faker::Lorem.sentences(number: 1).join(' ')
                  end
    convo.save!

    r2 = Random.random_number
    convo.conversation_category_id = if r2 > 0.4
                                       2
                                     elsif r2 > 0.1
                                       1
                                     else
                                       3
                                     end

    convo.save!
  end
end

task create_additional_calls: [:environment] do
  Contact.order('RANDOM()').limit(50).each do |contact|
    r = rand(1..20)

    r.times do
      convo = Conversation.new
      convo.started_at = Faker::Time.between(from: DateTime.now - 30, to: DateTime.now)
      convo.contact_phone = contact.contact_phones.first
      convo.provider_id = Faker::Alphanumeric.alphanumeric(number: 15)
      convo.method = 'Phone'
      convo.status = 'Incoming'
      convo.save!

      convo.finish
      num_minutes = Faker::Number.between(from: 1, to: 180)
      convo.ended_at = convo.started_at + num_minutes.minutes
      r2 = Random.random_number
      convo.notes = if r2 > 0.8
                      Faker::Lorem.paragraphs(number: 2).join(' ')
                    elsif r2 > 0.6
                      Faker::Lorem.paragraphs(number: 1).join(' ')
                    elsif r2 > 0.2
                      Faker::Lorem.sentences(number: 4).join(' ')
                    else
                      Faker::Lorem.sentences(number: 1).join(' ')
                    end

      r3 = Random.random_number
      convo.conversation_category_id = if r3 > 0.4
                                        2
                                      elsif r3 > 0.1
                                        1
                                      else
                                        3
                                      end
      
      convo.created_at = convo.started_at
      convo.save!
    end

  end
end
