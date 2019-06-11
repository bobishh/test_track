class Split < ActiveRecord::Base
  belongs_to :owner_app, required: true, class_name: "App"

  has_many :previous_split_registries
  has_many :assignments
  has_many :bulk_assignments
  has_many :variant_details

  validates :name, presence: true, uniqueness: true

  validate :registry_weights_must_sum_to_100
  validate :registry_weights_must_be_integers
  validates :registry, presence: true

  before_validation :cast_registry

  scope :active, -> { where(finished_at: nil) }

  enum platform: [:mobile, :desktop]

  def detail
    @detail ||= SplitDetail.new(split: self)
  end

  def has_details?
    %w(hypothesis assignment_criteria description owner location platform).any? { |attr| public_send(attr).present? }
  end

  def has_variant?(variant)
    registry.key?(variant.to_s)
  end

  def variants
    registry ? registry.keys : []
  end

  def variant_weight(variant)
    registry[variant]
  end

  def finished?
    finished_at.present?
  end

  def reassign_weight(weighting_registry)
    now = Time.zone.now
    previous_split_registries.build(registry: registry, created_at: updated_at, updated_at: now, superseded_at: now)
    self.registry = weighting_registry
    self.updated_at = now
  end

  def build_split_creation(params = {})
    SplitCreation.new({ weighting_registry: registry, name: name, app: owner_app }.merge(params))
  end

  def reweight!(weighting_registry)
    build_split_creation(weighting_registry: weighting_registry).save!
  end

  def assignment_count_for_variant(variant)
    assignments.where(variant: variant).count(:id)
  end

  def build_decision(params = {})
    Decision.new({ split: self }.merge(params))
  end

  def create_decision!(params = {})
    build_decision(params).tap(&:save!)
  end

  private

  def registry_weights_must_sum_to_100
    sum = registry && registry.values.sum
    errors.add(:registry, "must contain weights that sum to 100% (got #{sum})") unless sum == 100
  end

  def registry_weights_must_be_integers
    return unless registry.present?
    return unless @registry_before_type_cast.values.any? { |w| w.to_i.to_s != w.to_s }
    errors.add(:registry, "all weights must be integers")
  end

  def cast_registry
    @registry_before_type_cast = registry
    self.registry = registry.transform_values { |w| w.to_i } if registry
  end
end
