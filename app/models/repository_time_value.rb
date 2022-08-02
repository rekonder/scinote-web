# frozen_string_literal: true

class RepositoryTimeValue < RepositoryDateTimeValueBase
  SORTABLE_COLUMN_NAME = 'repository_date_time_values.data::time'

  def data_different?(new_data)
    new_time = Time.zone.parse(new_data)
    new_time.min != data.min || new_time.hour != data.hour
  end

  def formatted
    super(:time)
  end

  def self.add_filter_condition(repository_rows, join_alias, filter_element)
    parameters = filter_element.parameters
    timezone = Time.zone.tzinfo.identifier
    case filter_element.operator
    when 'equal_to'
      repository_rows.where("(#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time = (? AT TIME ZONE ?)::time",
                            timezone, Time.zone.parse(parameters['time']), timezone)
    when 'unequal_to'
      repository_rows.where.not("(#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time =
                                (? AT TIME ZONE ?)::time", timezone, Time.zone.parse(parameters['time']), timezone)
    when 'greater_than'
      repository_rows.where("(#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time > (? AT TIME ZONE ?)::time",
                            timezone, Time.zone.parse(parameters['time']), timezone)
    when 'greater_than_or_equal_to'
      repository_rows.where("(#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time >= (? AT TIME ZONE ?)::time",
                            timezone, Time.zone.parse(parameters['time']), timezone)
    when 'less_than'
      repository_rows.where("(#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time < (? AT TIME ZONE ?)::time",
                            timezone, Time.zone.parse(parameters['time']), timezone)
    when 'less_than_or_equal_to'
      repository_rows.where("(#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time <= (? AT TIME ZONE ?)::time",
                            timezone, Time.zone.parse(parameters['time']), timezone)
    when 'between'
      repository_rows.where("(#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time > (? AT TIME ZONE ?)::time AND
                            (#{join_alias}.data AT TIME ZONE 'utc' AT TIME ZONE ?)::time < (? AT TIME ZONE ?)::time",
                            timezone, Time.zone.parse(parameters['start_time']), timezone,
                            timezone, Time.zone.parse(parameters['end_time']), timezone)
    else
      raise ArgumentError, 'Wrong operator for RepositoryTimeValue!'
    end
  end

  def self.new_with_payload(payload, attributes)
    value = new(attributes)
    value.data = Time.zone.parse(payload)
    value
  end

  def self.import_from_text(text, attributes, _options = {})
    time_format = '%H:%M'
    new(attributes.merge(data: DateTime.strptime(text, time_format).strftime(time_format)))
  rescue ArgumentError
    nil
  end

  alias export_formatted formatted
end
