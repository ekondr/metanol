# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HomeController, type: :controller do
  context 'when renders meta tags' do
    context 'with all meta tags' do
      before { get :index }

      it do
        url = url_for(controller: :home, action: :index, host: 'test.host')
        expect(response.body)
          .to have_css "meta[content=\"#{url}\"][property=\"og:url\"]", visible: :hidden
      end

      it do
        expect(response.body)
          .to have_css('meta[content="OpenGraph Title"][property="og:title"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css 'meta[content="OpenGraph Description"][property="og:description"]',
                       visible: :hidden
      end

      it do
        expect(response.body)
          .to have_css('meta[content="website"][property="og:type"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css('meta[content="uk_UA"][property="og:locale"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css('meta[content="bing code"][name="msvalidate.01"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css('meta[content="alexa code"][name="alexaVerifyID"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css 'meta[content="google code"][name="google-site-verification"]',
                       visible: :hidden
      end

      it do
        expect(response.body)
          .to have_css 'meta[content="yandex code"][name="yandex-verification"]',
                       visible: :hidden
      end

      it do
        expect(response.body).to match(%r{<title>Index Page</title>})
      end
    end

    context 'with webmaster meta tags' do
      before { get :new }

      it do
        expect(response.body)
          .not_to have_css('meta[content="website"][property="og:type"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .not_to have_css('meta[content="uk_UA"][property="og:locale"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css('meta[content="bing code"][name="msvalidate.01"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css('meta[content="alexa code"][name="alexaVerifyID"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css('meta[content="google code"][name="google-site-verification"]', visible: :hidden)
      end

      it do
        expect(response.body)
          .to have_css('meta[content="yandex code"][name="yandex-verification"]', visible: :hidden)
      end
    end

    context 'with main meta tags' do
      before { get :show_title }

      it 'not have title meta tag' do
        expect(response.body).not_to match(/<title>/)
      end
    end
  end
end
