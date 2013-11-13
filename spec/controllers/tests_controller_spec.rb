require 'spec_helper'

class TestsController < ApplicationController; end

describe TestsController, :type => :controller do

  context "render only main meta tags" do
    controller do
      def index
        meta :title, "Users List"
        meta :description, "Description for a users list"
        og_meta title: "OpenGraph Title", description: "OpenGraph Description"
        render :inline => <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it "shouldn't have an open graph title" do response.should_not have_selector('meta[content="OpenGraph Title"]', property: 'og:title') end
    it "shouldn't have an open graph description" do response.should_not have_selector('meta[content="OpenGraph Description"]', property: 'og:description') end
    it "should have a title" do response.should have_selector('meta[content="Users List"]', name: 'title') end
    it "should have a description" do response.should have_selector('meta[content="Description for a users list"]', name: 'description') end

  end

  context "render only open graph meta tags" do
    controller do
      def index
        meta :title, "Users List"
        meta :description, "Description for a users list"
        og_meta title: "OpenGraph Title", description: "OpenGraph Description"
        render :inline => <<-ERB
          <%= metanol_og_tags %>
        ERB
      end
    end

    before { get :index }

    it "should have an open graph title" do response.should have_selector('meta[content="OpenGraph Title"]', property: 'og:title') end
    it "should have an open graph description" do response.should have_selector('meta[content="OpenGraph Description"]', property: 'og:description') end
    it "shouldn't have a title" do response.should_not have_selector('meta[content="Users List"]', name: 'title') end
    it "shouldn't have a description" do response.should_not have_selector('meta[content="Description for a users list"]', name: 'description') end

  end

  context "render all meta tags" do
    controller do
      def index
        meta :title, "Users List"
        meta :description, "Description for a users list"
        og_meta title: "OpenGraph Title", description: "OpenGraph Description"
        render :inline => <<-ERB
          <%= metanol_tags %>
        ERB
      end
    end

    before { get :index }

    it "should have an open graph title" do response.should have_selector('meta[content="OpenGraph Title"]', property: 'og:title') end
    it "should have an open graph description" do response.should have_selector('meta[content="OpenGraph Description"]', property: 'og:description') end
    it "should have a title" do response.should have_selector('meta[content="Users List"]', name: 'title') end
    it "should have a description" do response.should have_selector('meta[content="Description for a users list"]', name: 'description') end

  end

  context "render default meta from a config" do

    before do
      Metanol.configure do |config|
        config.og_type = "website"
        config.og_locale = "uk_UA"
        config.verification.google = "google code"
        config.verification.yandex = "yandex code"
      end
    end

    context "webmaster's verification codes" do
      controller do
        def index
          meta :title, "Users List"
          og_meta description: "OpenGraph Description"
          render :inline => <<-ERB
            <%= metanol_tags %>
          ERB
        end
      end

      before { get :index }

      it "should have the type meta of OpenGraph" do response.should have_selector('meta[content="website"]', property: 'og:type') end
      it "should have the locale meta of OpenGraph" do response.should have_selector('meta[content="uk_UA"]', property: 'og:locale') end
      it "should have a verification code of Google" do response.should have_selector('meta[content="google code"]', name: 'google-site-verification') end
      it "should have a verification code of Yandex" do response.should have_selector('meta[content="yandex code"]', name: 'yandex-verification') end
    end

    context "default OpenGraph metas" do
      before { get :index }
    end

  end

  context "raise exception for unsupported metas"

end