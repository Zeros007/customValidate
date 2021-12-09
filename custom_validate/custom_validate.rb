module CustomValidate
    def self.included(klass)
        klass.extend Methods
    end

    def validate!
        # the method detects whether all instance variables are valid
        result = []
        instance_variables.map{|i| i[1..].to_sym}.each do |var|
            begin
                public_send("#{var}=", instance_variable_get("@#{var}"))
            rescue RuntimeError => valid_error
                result << valid_error
            rescue => error
                result << error
            end
        end
        result.empty? ? "All variables is valid!" : result
    end
    
    def valid?
        # the method return true if all instance variables are valid else false
        validate!.kind_of?(Array) ? false : true
    end

    module Methods

        def validate(attribute, options = {})
            # the method determines whether the data just written to the instance variable is valid
            if instance_methods.include? "#{attribute}=".to_sym
                errors = []
                
                define_method("#{attribute}=") do |value|
                    val = instance_variable_set("@#{attribute}", value)
                    
                    options.each do |k,v|
                        case
                        when k.eql?(:type)
                            errors << "\n Validation error for the '#{attribute}'. Attribute must be an instance of the passed class.\n" unless v == self.class
                        when k.eql?(:presence) & v
                            errors << "\n Validation error for the '#{attribute}'. Attribute must be presence.\n" if val.nil? || val.to_s.empty?
                        when k.eql?(:format)
                            errors << "\n Validation format error for the '#{attribute}'.\n" if (val =~ v).nil?
                        end
                    end

                    if errors.empty?
                        val
                    else
                        raise errors.join
                    end

                end
            else
                raise "Attribute: '#{attribute}' has not exist"
            end

        end

    end
  
end