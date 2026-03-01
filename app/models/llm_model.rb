class LlmModel < ApplicationRecord
  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  before_validation :generate_slug, if: -> { slug.blank? && name.present? }

  scope :open_source, -> { where(open_source: true) }
  scope :proprietary, -> { where(open_source: false) }
  scope :with_api, -> { where(api_available: true) }
  scope :provider, ->(provider) { where(provider: provider) }
  scope :search, ->(query) { where('name ILIKE ? OR description ILIKE ? OR provider ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%") }
  scope :order_by_name, -> { order(name: :asc) }
  scope :order_by_release_date, -> { order(release_date: :desc) }

  def to_param
    slug
  end

  def to_s
    name
  end

  private

  def generate_slug
    self.slug = name.parameterize
  end
end
