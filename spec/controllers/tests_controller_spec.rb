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
    it { response.should have_selector('title', content: 'Users List') }
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
    it { response.should_not have_selector('title', content: 'Users List') }
    it { response.should_not have_selector('meta[content="Description for a users list"]', name: 'description') }
  end

  context "render all meta tags" do
    controller do
      def index
        meta :title, "Users List"
        meta :description, "Description for a users list"
        og_meta title: "OpenGraph Title", description: "OpenGraph Description"
        md_meta description: "MicroData Description"
        render :inline => <<-ERB
          <%= metanol_tags %>
        ERB
      end
    end

    before { get :index }

    it { response.should have_selector('meta[content="OpenGraph Title"]', property: 'og:title') }
    it { response.should have_selector('meta[content="OpenGraph Description"]', property: 'og:description') }
    it { response.should have_selector('title', content: 'Users List') }
    it { response.should have_selector('meta[content="Description for a users list"]', name: 'description') }
    it { response.should have_selector('meta[content="MicroData Description"]', itemprop: 'description') }
  end

  context "raise exception for unsupported metas" do
    controller do
      def index
        meta :title, "Users List"
        wm_meta fake: "Fake value"
        render :inline => <<-ERB
          <%= metanol_tags %>
        ERB
      end
    end

    it { expect { get :index }.to raise_error(NameError, "The meta tag 'fake' isn't supported.") }
  end

  context "filter whitespaces" do
    controller do
      def index
        meta :description, "Description \t\nfor \ta \tusers \r\nlist", :whitespaces
        render :inline => <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it('success') { response.should have_selector('meta[content="Description   for  a  users   list"]', name: 'description') }
  end

  context "filter HTML tags" do
    controller do
      def index
        meta({description: "<div>Description <br/>for <b>a users</b> <br>list</div>", keywords: "key,word"}, :html)
        render :inline => <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it('success') { response.should have_selector('meta[content="Description  for a users  list"]', name: 'description') }
  end

  context "filter HTML tags and whitespaces" do
    controller do
      def index
        meta(:description, "<div>\tDescription \r\n<br/>for \t<b>a users</b> \r\n<br>list</div>", :html, :whitespaces)
        render :inline => <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it('success') { response.should have_selector('meta[content=" Description    for  a users    list"]', name: 'description') }
  end

  context "filter spaces - leave only 1 space between words" do
    controller do
      def index
        meta :description, "Description   for    a users     list", :overspaces
        render :inline => <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it('success') { response.should have_selector('meta[content="Description for a users list"]', name: 'description') }
  end

  context "clean up a value from whitespaces, html tags etc (run all filters)" do
    controller do
      def index
        meta(:description, "<div>\tDescription \r\n<br/>for \t<b>a users</b> \r\n<br>list</div>", :clean)
        render :inline => <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it { response.should have_selector('meta[content=" Description for a users list"]', name: 'description') }
  end

  context "returns meta values in a controller and in a view" do
    controller do
      def index
        meta :title,          'Users List'
        wm_meta :alexa,       'alexa code'
        og_meta title:        'OpenGraph Title'
        md_meta description:  'MicroData Desc'

        @meta = get_meta :title
        @wm_meta = get_wm_meta :alexa
        @og_meta = get_og_meta :title
        @md_meta = get_md_meta :description
        @og_no_meta = get_og_meta :bad_meta_name

        render :inline => <<-ERB
          <span>Main meta is <%= get_meta :title %></span>
          <span>OpenGraph meta is <%= get_og_meta :title %></span>
          <span>Webmaster meta is <%= get_wm_meta :alexa %></span>
          <span>MicroData meta is <%= get_md_meta :description %></span>
        ERB
      end
    end

    before { get :index }

    it { response.should have_selector('span', content: 'Main meta is Users List') }
    it { response.should have_selector('span', content: 'OpenGraph meta is OpenGraph Title') }
    it { response.should have_selector('span', content: 'Webmaster meta is alexa code') }
    it { response.should have_selector('span', content: 'MicroData meta is MicroData Desc') }
    it { assigns(:meta).should == 'Users List' }
    it { assigns(:wm_meta).should == 'alexa code' }
    it { assigns(:og_meta).should == 'OpenGraph Title' }
    it { assigns(:md_meta).should == 'MicroData Desc' }
    it { assigns(:og_no_meta).should == nil }
  end

end