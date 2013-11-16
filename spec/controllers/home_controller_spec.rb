require 'spec_helper'

describe HomeController do
  context "render meta tags with some global ones" do

    context "all meta tags" do
      before { get :index }

      it { response.should have_selector("meta[content=\"#{url_for(controller: :home, action: :index, host: 'test.host')}\"]", property: 'og:url') }
      it { response.should have_selector('meta[content="OpenGraph Title"]', property: 'og:title') }
      it { response.should have_selector('meta[content="OpenGraph Description"]', property: 'og:description') }
      it { response.should have_selector('meta[content="website"]', property: 'og:type') }
      it { response.should have_selector('meta[content="uk_UA"]', property: 'og:locale') }
      it { response.should have_selector('meta[content="bing code"]', name: 'msvalidate.01') }
      it { response.should have_selector('meta[content="alexa code"]', name: 'alexaVerifyID') }
      it { response.should have_selector('meta[content="google code"]', name: 'google-site-verification') }
      it { response.should have_selector('meta[content="yandex code"]', name: 'yandex-verification') }
    end

    context "only WebMaster's meta tags" do
      before { get :new }

      it { response.should_not have_selector('meta[content="website"]', property: 'og:type') }
      it { response.should_not have_selector('meta[content="uk_UA"]', property: 'og:locale') }
      it { response.should have_selector('meta[content="bing code"]', name: 'msvalidate.01') }
      it { response.should have_selector('meta[content="alexa code"]', name: 'alexaVerifyID') }
      it { response.should have_selector('meta[content="google code"]', name: 'google-site-verification') }
      it { response.should have_selector('meta[content="yandex code"]', name: 'yandex-verification') }
    end

  end
end