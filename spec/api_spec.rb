# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'API' do
  let(:json) { JSON.parse(last_response.body) }
  let(:http_status) { last_response.status }

  describe '疎通確認' do
    let(:uri) { '/' }
    let(:method){'get'}
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

  describe '登録' do
    let(:method){'post'}
    let(:uri) { "/regist/" }
    let(:params) {{ uuid: 0, device: ''}}

    it_behaves_like '必須パラメータ', 'uuid' do
      let(:target){ 'uuid' }
    end
    it_behaves_like '必須パラメータ', 'デバイスID' do
      let(:target){ 'device' }
    end

    it 'DBに保存される' do
      before = CurrentLocation.count
      post uri, params
      after = CurrentLocation.count

      expect(after-before).to eq(1)
    end
  end

  describe '依頼' do
    let(:method){'post'}
    let(:uri) { "/order/" }
    let(:params) {{ price: 0, keyword: '', device: ''}}
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

    it_behaves_like '必須パラメータ', 'device' do
      let(:target){ 'device' }
    end

    context 'Placeがある' do

      xit 'channel = uuid' do
      end

      it 'pusherが1回呼ばれる' do
        expect(pusher_client).to receive(:trigger).once
        post uri,params
      end
    end
  end

  describe '了解' do
    let(:method){'get'}
    let(:uri) { "/accept/" }
    let(:params) {{ device: 0 }}
    let(:pusher_client){ double('Pusher client') }

    it_behaves_like '必須パラメータ', 'uuid' do
      let(:target){ 'uuid' }
    end
    it_behaves_like '必須パラメータ', 'デバイスID' do
      let(:target){ 'device' }
    end

  end

end
