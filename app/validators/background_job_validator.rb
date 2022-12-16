class BackgroundJobValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin 
      bool = record.klass.constantize.respond_to? :set
      unless bool 
        record.errors.add(attribute, :blank, message: I18n.translate(".klass_not_background_job"))
      end
    rescue Exception => err
      record.errors.add(attribute, :missing, message: I18n.translate(".klass_not_background_job"))
    end
  rescue Exception => err 
      record.errors.add(attribute, :missing, message: I18n.translate(".error_unknown"))
  end
end
