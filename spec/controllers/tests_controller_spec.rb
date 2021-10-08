# frozen_string_literal: true

require 'spec_helper'

class TestsController < ApplicationController; end

RSpec.describe TestsController, type: :controller do
  context 'when render only main meta tags' do
    controller do
      def index
        meta :title, 'Users List'
        meta :description, 'Description for a users list'
        og_meta title: 'OpenGraph Title', description: 'OpenGraph Description'
        render inline: <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body)
        .not_to have_css('meta[content="OpenGraph Title"][property="og:title"]', visible: :hidden)
    end

    it do
      expect(response.body)
        .not_to have_css 'meta[content="OpenGraph Description"][property="og:description"]',
                         visible: :hidden
    end

    it do
      expect(response.body).to match '<title>Users List</title>'
    end

    it do
      expect(response.body).to have_css('meta[content="Description for a users list"][name="description"]',
                                        visible: :hidden)
    end
  end

  context 'when render only open graph meta tags' do
    controller do
      def index
        meta :title, 'Users List'
        meta :description, 'Description for a users list'
        og_meta title: 'OpenGraph Title', description: 'OpenGraph Description'
        render inline: <<-ERB
          <%= metanol_og_tags %>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body).to have_css('meta[content="OpenGraph Title"][property="og:title"]', visible: :hidden)
    end

    it do
      expect(response.body).to have_css('meta[content="OpenGraph Description"][property="og:description"]',
                                        visible: :hidden)
    end

    it do
      expect(response.body).not_to match '<title>'
    end

    it do
      expect(response.body).not_to have_css('meta[content="Description for a users list"][name="description"]',
                                            visible: :hidden)
    end
  end

  context 'when render all meta tags' do
    controller do
      def index
        meta :title, 'Users List'
        meta :description, 'Description for a users list'
        og_meta title: 'OpenGraph Title', description: 'OpenGraph Description'
        md_meta description: 'MicroData Description'
        render inline: <<-ERB
          <%= metanol_tags %>
        ERB
      end
    end

    before { get :index }

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
      expect(response.body).to match '<title>Users List</title>'
    end

    it do
      expect(response.body)
        .to have_css 'meta[content="Description for a users list"][name="description"]',
                     visible: :hidden
    end

    it do
      expect(response.body)
        .to have_css 'meta[content="MicroData Description"][itemprop="description"]',
                     visible: :hidden
    end
  end

  context 'when raise exception for unsupported metas' do
    controller do
      def index
        meta :title, 'Users List'
        wm_meta fake: 'Fake value'
        render inline: <<-ERB
          <%= metanol_tags %>
        ERB
      end
    end

    it { expect { get :index }.to raise_error(NameError, "The meta tag 'fake' isn't supported.") }
  end

  context 'when filter whitespaces' do
    controller do
      def index
        meta :description, "Description \t\nfor \ta \tusers \r\nlist", :whitespaces
        render inline: <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body).to have_css('meta[content="Description   for  a  users   list"][name="description"]',
                                        visible: :hidden)
    end
  end

  context 'when filter HTML tags' do
    controller do
      def index
        meta({ description: '<div>Description <br/>for <b>a users</b> <br>list</div>', keywords: 'key,word' }, :html)
        render inline: <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body).to have_css('meta[content="Description  for a users  list"][name="description"]',
                                        visible: :hidden)
    end
  end

  context 'when filter HTML tags and whitespaces' do
    controller do
      def index
        meta(:description, "<div>\tDescription \r\n<br/>for \t<b>a users</b> \r\n<br>list</div>", :html, :whitespaces)
        render inline: <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body).to have_css('meta[content=" Description    for  a users    list"][name="description"]',
                                        visible: :hidden)
    end
  end

  context 'when filter spaces - leave only 1 space between words' do
    controller do
      def index
        meta :description, 'Description   for    a users     list', :overspaces
        render inline: <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body).to have_css('meta[content="Description for a users list"][name="description"]',
                                        visible: :hidden)
    end
  end

  context 'when clean up a value from whitespaces, html tags etc (run all filters)' do
    controller do
      def index
        meta(:description, "<div>\tDescription \r\n<br/>for \t<b>a users</b> \r\n<br>list</div>", :clean)
        render inline: <<-ERB
          <%= metanol_main_tags %>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body).to have_css('meta[content=" Description for a users list"][name="description"]',
                                        visible: :hidden)
    end
  end

  context 'when returns meta values in a controller and in a view' do
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

        render inline: <<-ERB
          <span>Main meta is <%= get_meta :title %></span>
          <span>OpenGraph meta is <%= get_og_meta :title %></span>
          <span>Webmaster meta is <%= get_wm_meta :alexa %></span>
          <span>MicroData meta is <%= get_md_meta :description %></span>
        ERB
      end
    end

    before { get :index }

    it do
      expect(response.body).to have_css('span', text: 'Main meta is Users List')
    end

    it do
      expect(response.body).to have_css('span', text: 'OpenGraph meta is OpenGraph Title')
    end

    it do
      expect(response.body).to have_css('span', text: 'Webmaster meta is alexa code')
    end

    it do
      expect(response.body).to have_css('span', text: 'MicroData meta is MicroData Desc')
    end

    it do
      expect(controller.view_assigns['meta']).to eq 'Users List'
    end

    it do
      expect(controller.view_assigns['wm_meta']).to eq 'alexa code'
    end

    it do
      expect(controller.view_assigns['og_meta']).to eq 'OpenGraph Title'
    end

    it do
      expect(controller.view_assigns['md_meta']).to eq 'MicroData Desc'
    end

    it do
      expect(controller.view_assigns['og_no_meta']).to eq nil
    end
  end
end
