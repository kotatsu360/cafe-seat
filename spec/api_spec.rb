# -*- coding: utf-8 -*-
require 'spec_helper'

describe 'hello' do
  let(:method){'get'}
  let(:uri) { '/' }
  let(:params) {{  }}
  let(:json) { JSON.parse(last_response.body) }
  let(:http_status) { last_response.status }

  describe '疎通確認' do

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

end
