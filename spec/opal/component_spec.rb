require 'spec_helper'

describe Enigma::Component do
  let(:empty_component) { Class.new { include Enigma::Component }}
  let(:component) do
    Class.new do
      include Enigma::Component

      def render
        h1 class: 'test' do
          'Test'
        end
      end
    end
  end

  let(:nested_component) do
    Class.new do
      include Enigma::Component

      Inner = Class.new do
        include Enigma::Component

        def render
          div do
            'Inner'
          end
        end
      end

      def render
        h1 class: 'test' do
          component Inner
        end
      end
    end
  end

  let(:element) do
    Enigma::Browser::Document.JS.createElement('div')
  end

  it 'should fail when no #render method' do
    expect { empty_component.new.mount_to(element) }.to raise_error Enigma::Error
  end

  it 'should render html' do
    component.new.mount_to(element)
    expect(element.JS[:innerHTML]).to eq '<h1 class="test">Test</h1>'
  end

  it 'should render html with nested components' do
    nested_component.new.mount_to(element)
    expect(element.JS[:innerHTML]).to eq '<h1 class="test"><div>Inner</div></h1>'
  end
end