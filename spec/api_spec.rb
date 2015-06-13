# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'API' do
  let(:method){'get'}
  let(:json) { JSON.parse(last_response.body) }
  let(:http_status) { last_response.status }

  describe '疎通確認' do
    let(:uri) { '/' }
    let(:params) {{}}

    before do
      get uri+'?'+params.to_query
    end

    it 'ステータスコードが200' do
      expect(http_status).to eq(200)
    end

    it '返り値がhello :)' do
      expect(json).to match({ 'message' => 'hello :)' })
    end
  end

  describe '依頼' do
    let(:uri) { "/order/" }
    let(:params) {{ price: 0, keyword: ''}}
    let(:pusher_client){ double('Pusher client') }

    before do
      allow_any_instance_of(CafeSeat::Server).to receive(:pusher).and_return(pusher_client)
      allow(pusher_client).to receive(:trigger)
    end

    it_behaves_like '必須パラメータ', '値段' do
      let(:target){ 'price' }
    end
    it_behaves_like '必須パラメータ', '検索キーワード' do
      let(:target){ 'keyword' }
    end

    it 'pusherが1回呼ばれる' do
      expect(pusher_client).to receive(:trigger).once
      get uri+'?'+params.to_query
    end
  end

end
