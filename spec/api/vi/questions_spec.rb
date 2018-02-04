require 'rails_helper'

describe 'Question API' do
  let(:access_token) { create(:access_token) }

  describe 'GET /index' do
    def make_request(params = {})
      get '/api/v1/questions', params: { format: :json }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let!(:questions) { create_list :question, 2 }
      let(:question) { questions.last }
      let!(:answer) { create :answer, question: question }

      before { make_request access_token: access_token.token }

      it { expect(response).to be_success }

      it 'returns list of questions' do
        expect(response.body).to have_json_size 2
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    def make_request(params = {})
      question = params[:question] || create(:question)
      get "/api/v1/questions/#{question.id}", params: { format: :json }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      let(:question) { create(:question) }
      let!(:attachment) { create(:attachment, attachable: question) }
      let!(:comment) { create(:comment, commentable: question, user: question.user) }

      before { make_request access_token: access_token.token, question: question }

      it { expect(response).to be_success }

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path(attr)
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('attachments')
        end

        it 'has attachment url attr' do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path('attachments/0/url')
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path('comments')
        end

        %w(id body).each do |attr|
          it "comment contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("comments/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'POST /create' do
    def make_request(params = {})
      post '/api/v1/questions', params: { action: :create, format: :json, question: attributes_for(:question) }.merge(params)
    end

    it_behaves_like 'API Authorizable'

    context 'authorized' do
      before { make_request access_token: access_token.token }

      it { expect(response).to be_success }

      it 'create question' do
        expect { make_request access_token: access_token.token }.to change(Question, :count).by(1)
      end
    end
  end
end
