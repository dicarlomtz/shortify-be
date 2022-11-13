# Url validation has generic usage
class UrlValidator < ActiveModel::EachValidator

    # Validates if the value is a valid url
    def validate_each(record, attribute, value)
        unless value =~ /\Ahttps?:\/\/[^\n]+\z/i
            record.errors.add attribute, (options[:message]  || 'is not a valid url')
        end
    end

end