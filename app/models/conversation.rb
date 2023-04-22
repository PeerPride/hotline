# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id                       :bigint           not null, primary key
#  method                   :string
#  notes                    :text
#  provider_id              :string
#  length                   :integer
#  started_at               :datetime
#  ended_at                 :datetime
#  status                   :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  contact_phone_id         :bigint           not null
#  conversation_category_id :bigint
#  recording_id             :string
#  is_voicemail             :boolean          default(FALSE)
#  voicemail_acknowledged   :datetime
#
# Indexes
#
#  index_conversations_on_contact_phone_id          (contact_phone_id)
#  index_conversations_on_conversation_category_id  (conversation_category_id)
#
class Conversation < ApplicationRecord
  @valid_statuses = ['Incoming', 'Language Selection', 'Pending Operator', 'Answered', 'Finished']
  @valid_methods = %w[Phone Text Web Signal WhatsApp]

  validates :status, presence: true, inclusion: { in: @valid_statuses }
  validates :method, presence: true, inclusion: { in: @valid_methods }
  validates :provider_id, presence: true, uniqueness: true, if: :can_have_provider_identification?

  # has_many :conversation_participant
  belongs_to :contact_phone
  has_one :contact, through: :contact_phone

  has_many :tag_groups
  has_many :tag_instances, through: :tag_groups

  belongs_to :conversation_category, optional: true

  before_save :calculate_length

  scope :in_progress, -> { where.not(status: 'Finished') }
  scope :completed, -> { where(status: 'Finished') }
  scope :unlogged, -> { completed.where(notes: nil) }
  scope :logged, -> { completed.where.not(notes: nil) }
  scope :recent, -> { order(created_at: :desc).limit(50) }
  scope :voicemail, -> { where(is_voicemail: true) }
  scope :unacknowledged_voicemail, -> { where(is_voicemail: true).where(voicemail_acknowledged: nil) }
  scope :today, -> { where("started_at > ?", Date.today)}

  def deep_tag_groups
    groups = []
    self.tag_groups.each do |tg|
      group = Hash.new
      group[:tags] = []
      group[:id] = tg.id
      tg.tag_instances.each do |ti|
        t = Hash.new
        t[:tag_instance_id] = ti.id
        t[:tag] = ti.tag.name
        t[:tag_id] = ti.tag_id
        group[:tags] << t
      end
      groups << group
    end

    groups
  end

  def finish
    now = DateTime.now
    self.ended_at = now
    self.status = 'Finished'
    # self.conversation_participant.where(:ended_at => nil).each do |cp|
    #   cp.ended_at = now
    #   cp.save
    # end
    save
  end

  def can_have_provider_identification?
    %w[Phone Text WhatsApp].include? method
  end

  private

  def calculate_length
    return if status != 'Finished'

    self.length = ((ended_at.to_datetime - started_at.to_datetime) * 24 * 60 * 60).to_i
  end
end
