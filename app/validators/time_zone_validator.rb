class TimeZoneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless ActiveSupport::TimeZone[value]
      record.errors[attribute] << (options[:message] || I18n.t('non_valid_time_zone'))
    end
  end
end