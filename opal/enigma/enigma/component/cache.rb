#!/usr/bin/env/ruby

module Enigma
    module Component
        module Cache
            def cache_componenet(component, &block)
                @cache_componenet ||= {}
                @cache_componenet_counter ||=0
                @cache_componenet_counter += 1
                @cache_component["#{component}-#{@cache_component_counter}"] || @cache_component["#{component}-#{@cache_component_counter}"] = block.call
            end
        end
    end 
end
