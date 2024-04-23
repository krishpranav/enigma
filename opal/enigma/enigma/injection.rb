#!/usr/bin/env/ruby

module Engima
    module Injection
        def init; end

        def with_root_component(component)
            @root_component = component
            self
        end

        def inject
            @root.component.injections.each do |name, instance|
                define_singleton_method(name) do
                    instance
                end
            end
            self
        end

        attr_reader :injections
        def init_injections
            @injections ||= {}
            self.class.injections.each do |name, clazz|
                if clazz.included_modules.include?(Engima::Injection)
                    @injections[name] = clazz
                        .new
                        .with_root_component(@root_component)
                else
                    raise Error, "Invalid #{clazz}, should mixin Enigma::Injection"
                end
            end
            @injections.each do |key, instance|
                instance.inject
                instance.init
            end
        end

        def render!
            Browser.animation_frame do
                @root_component.render_if_root
            end
        end
    end
end