# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Metanol::Meta::Main do
  describe '#render' do
    subject(:result) { described_class.new(name, value, filters).render }

    let(:value) { "Some <br/><span>text</span>   here\n" }

    context 'when no filters' do
      let(:filters) { [] }

      context 'when a common meta tag' do
        let(:name) { 'description' }

        it { expect(result).to eq "<meta name=\"description\" content=\"Some <br/><span>text</span>   here\n\" />" }
      end

      context 'when <title> meta tag' do
        let(:name) { 'title' }

        it { expect(result).to eq "<title>Some <br/><span>text</span>   here\n</title>" }
      end
    end

    context 'when filters' do
      let(:name) { 'description' }

      [
        [%i[html], "<meta name=\"description\" content=\"Some  text   here\n\" />"],
        [
          %i[overspaces],
          "<meta name=\"description\" content=\"Some <br/><span>text</span> here\n\" />"
        ],
        [
          %i[whitespaces],
          '<meta name="description" content="Some <br/><span>text</span>   here " />'
        ],
        [%i[clean], '<meta name="description" content="Some text here " />'],
        [%w[html overspaces], "<meta name=\"description\" content=\"Some text here\n\" />"],
        [%i[html whitespaces], '<meta name="description" content="Some  text   here " />'],
        [%i[html clean], '<meta name="description" content="Some text here " />'],
        [
          %w[html overspaces whitespaces],
          '<meta name="description" content="Some text here " />'
        ],
        [
          %i[html overspaces whitespaces clean],
          '<meta name="description" content="Some text here " />'
        ],
        [
          %i[overspaces whitespaces],
          '<meta name="description" content="Some <br/><span>text</span> here " />'
        ],
        [
          %i[overspaces whitespaces clean],
          '<meta name="description" content="Some text here " />'
        ],
        [%i[whitespaces clean], '<meta name="description" content="Some text here " />']
      ].each do |filters, expected_result|
        context "with #{filters.join(', ')} filter(s)" do
          let(:filters) { filters }

          it { expect(result).to eq expected_result }
        end
      end
    end
  end

  describe '#value' do
    subject(:result) { described_class.new(name, value, filters).value }

    let(:value) { "Some <br/><span>text</span>   here\n" }

    context 'when no filters' do
      let(:filters) { [] }

      context 'when a common meta tag' do
        let(:name) { 'description' }

        it { expect(result).to eq "Some <br/><span>text</span>   here\n" }
      end

      context 'when <title> meta tag' do
        let(:name) { 'title' }

        it { expect(result).to eq "Some <br/><span>text</span>   here\n" }
      end
    end

    context 'when filters' do
      let(:name) { 'description' }

      [
        [%i[html], "Some  text   here\n"],
        [%i[overspaces], "Some <br/><span>text</span> here\n"],
        [%i[whitespaces], 'Some <br/><span>text</span>   here '],
        [%i[clean], 'Some text here '],
        [%w[html overspaces], "Some text here\n"],
        [%i[html whitespaces], 'Some  text   here '],
        [%i[html clean], 'Some text here '],
        [%w[html overspaces whitespaces], 'Some text here '],
        [%i[html overspaces whitespaces clean], 'Some text here '],
        [%i[overspaces whitespaces], 'Some <br/><span>text</span> here '],
        [%i[overspaces whitespaces clean], 'Some text here '],
        [%i[whitespaces clean], 'Some text here ']
      ].each do |filters, expected_result|
        context "with #{filters.join(', ')} filter(s)" do
          let(:filters) { filters }

          it { expect(result).to eq expected_result }
        end
      end
    end
  end

  describe '#filters=' do
    subject(:result) { meta.filters = new_filters }

    let(:meta) { described_class.new('description', 'Some value') }

    shared_examples 'not to raise any error' do
      it { expect { result }.not_to raise_error }
    end

    context 'when new filters is nil' do
      let(:new_filters) { nil }

      it do
        expect { result }.to raise_error(StandardError, 'The <filters> parameter must be an Array.')
      end
    end

    context 'when new filters include wrong filter' do
      let(:new_filters) { %i[fake] }

      it do
        expect { result }
          .to raise_error StandardError, 'Only html, overspaces, whitespaces, clean filters '\
                                         'are supported.'
      end
    end

    context 'when new filters is empty' do
      let(:new_filters) { [] }

      it_behaves_like 'not to raise any error'
    end

    context 'when new filters include correct filters (string names)' do
      let(:new_filters) { %w[html clean] }

      it_behaves_like 'not to raise any error'
    end

    context 'when new filters include correct filters (symbol names)' do
      let(:new_filters) { %i[html clean] }

      it_behaves_like 'not to raise any error'
    end
  end
end
