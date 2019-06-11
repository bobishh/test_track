class CreateSplit
  def initialize(params)
    @split = Split.new()
    @params = params
  end

  def call
    parse_registry
    create_split
  end

  private

  def create_split
    @split.assign_attributes(@params)
    if @split.save
      {success: true, split: @split}
    else
      {success: false, split: @split}
    end
  end

  def parse_registry
    begin
      @params['registry'] = JSON.parse(@params['registry'])
    rescue StandardError => _
      @params['registry'] = {}
      nil
    end
  end
end
