# calculates assignments for all active splits
class AssignmentsCalculation
  def initialize(fingerprint, user_id, id_type_id)
    @fingerprint = fingerprint
    @id_type_id = id_type_id
    @user_id = user_id
  end

  def call
    if @user_id.present?
      associate_fingerprint if no_association?
    end
    process_identity
    { assignments: calculate_variants }
  end

  def visitor
    @visitor ||= Visitor.find_or_create_by(fingerprint: @fingerprint)
  end

  private

  def process_identity
    @canonical_visitor = if identifier.present? && identifier.value.present?
                           find_canonical_visitor(identifier.value)
                         else
                           visitor
                         end
  end

  def identifier
    visitor.identifiers.first
  end

  def find_canonical_visitor(value)
    Identifier.where(value: value,
                     identifier_type_id: @id_type_id)
      .order(created_at: :asc)
      .first&.visitor
  end

  def associate_fingerprint
    Identifier.create!(visitor_id: visitor.id,
                       identifier_type_id: @id_type_id,
                       value: @user_id)
  end

  def no_association?
    !Identifier.exists?(visitor_id: visitor.id)
  end

  def calculate_variants
    unassigned_splits.each_with_object({}) do |split, acc|
      acc[split.name] = assign_split(split)
    end.merge(assigned_splits_values)
  end

  def assign_split(split)
    variant = VariantCalculator.new(visitor_id: @canonical_visitor.id,
                                    split: split).variant
    Assignment.create(visitor_id: @canonical_visitor.id,
                      variant: variant,
                      split_id: split.id,
                      context: :backend)
    variant
  end

  def unassigned_splits
    Split.active.where.not(id: existing_assignments.map(&:split_id))
  end

  def assigned_splits_values
    existing_assignments.each_with_object({}) do |assignment, acc|
      acc[assignment.split.name] = assignment.variant
    end
  end

  def existing_assignments
    @existing_assignments ||= Assignment.includes(:split)
                                        .where(visitor_id: @canonical_visitor.id)
  end
end
