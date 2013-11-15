require 'spec_helper'

class TestsController < ApplicationController; end

describe TestsController do

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

    it { response.should_not have_selector('meta[content="OpenGraph Title"]', property: 'og:title') }
    it { response.should_not have_selector('meta[content="OpenGraph Description"]', property: 'og:description') }
    it { response.should have_selector('meta[content="Users List"]', name: 'title') }
    it { response.should have_selector('meta[content="Description for a users list"]', name: 'description') }
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

    it { response.should have_selector('meta[content="OpenGraph Title"]', property: 'og:title') }
    it { response.should have_selector('meta[content="OpenGraph Description"]', property: 'og:description') }
    it { response.should_not have_selector('meta[content="Users List"]', name: 'title') }
    it { response.should_not have_selector('meta[content="Description for a users list"]', name: 'description') }
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

    it { response.should have_selector('meta[content="OpenGraph Title"]', property: 'og:title') }
    it { response.should have_selector('meta[content="OpenGraph Description"]', property: 'og:description') }
    it { response.should have_selector('meta[content="Users List"]', name: 'title') }
    it { response.should have_selector('meta[content="Description for a users list"]', name: 'description') }
  end

  context "raise exception for unsupported metas" do
    controller do
      def index
        meta :title, "Users List"
        og_meta fake: "OpenGraph Description"
        render :inline => <<-ERB
          <%= metanol_tags %>
        ERB
      end
    end

    it { expect { get :index }.to raise_error(NameError, "The meta tag 'fake' isn't supported.") }
  end

end