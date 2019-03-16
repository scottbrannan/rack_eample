module BaconExtender
    
    def self.included(target)
       target.send(:extend,ClassMethods) 
    end
    
    module ClassMethods
        def attr_bacon(*args)
           args.each do |arg|
              define_method :"#{arg}" do
                  instance_variable_get :"@#{arg}"
              end
              
              define_method :"#{arg}" do |value|
                  instance_variable_set :"@#{arg}", value
              end
           end
        end
    end
end

class Bacon
    include BaconExtender
    
    attr_bacon :test, :abc
end
