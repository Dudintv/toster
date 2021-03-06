require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'
  
  let!(:user)     { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer)   { create(:answer) }
  let!(:my_question) { create(:question, user: user) }
  let!(:my_answer) { create(:answer, user: user) }
  let(:file1) { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
  let(:file2) { Rack::Test::UploadedFile.new("#{Rails.root}/README.md") }
  let(:file3) { Rack::Test::UploadedFile.new("#{Rails.root}/config.ru") }
  let(:valid_params) { { answer: attributes_for(:answer, attachments_attributes: { '0': { file: [file1, file2] } }), question_id: question } }
  let(:invalid_params) { { answer: attributes_for(:invalid_answer), question_id: question } }

  describe 'POST #create' do
    sign_in_user

    context 'with valid attribute' do
      let(:create_valid_answer) { post :create, params: valid_params, format: :js }

      it 'saves the new answer' do
        expect { create_valid_answer }.to change(question.answers, :count).by(1)
      end

      it 'saves with current user as author' do
        create_valid_answer
        expect(assigns(:answer).user_id).to eq @user.id
      end

      it 'saves with attached files' do
        create_valid_answer
        expect(assigns(:answer).attachments.count).to eq 2
      end

      it 'redirect to associates question' do
        create_valid_answer
        expect(response).to render_template 'answers/create'
      end
    end

    context 'with invalid attribute' do
      let(:create_invalid_answer) { post :create, params: invalid_params, format: :js }

      it 'does not save the answer' do
        expect { create_invalid_answer }.to_not change(Question, :count)
      end

      it 're-render associates question view' do
        create_invalid_answer
        expect(response).to render_template('answers/create')
      end
    end
  end

  describe 'POST #update' do
    context 'Authenticated user' do
      before do
        sign_in user
      end

      context 'As author' do
        let!(:my_answer) { create(:answer, user: user) }
        let(:update_my_answer_valid) do
          post :update, params: { question_id: my_answer.question.id, id: my_answer.id, answer: { body: 'edited body', attachments_attributes: { '0': { file: [file3] } } }, format: :js }
        end
        let(:update_my_answer_invalid) { post :update, params: { question_id: my_answer.question.id, id: my_answer.id, answer: { body: '' }, format: :js } }

        it 'update my answer with valid inputs' do
          update_my_answer_valid
          expect(assigns(:answer).body).to eq 'edited body'
        end

        it 'saves with additional attached files' do
          update_my_answer_valid
          expect(assigns(:answer).attachments.count).to eq 1
        end

        it 'not update my answer with invalid inputs' do
          expect { update_my_answer_invalid }.to_not change { my_answer.reload.body }
          expect { update_my_answer_invalid }.to_not change { my_answer.reload.updated_at }
        end
      end

      context 'As non-author user' do
        let!(:foreign_answer) { create(:answer) }
        let(:update_foreign_answer) { post :update, params: { question_id: foreign_answer.question.id, id: foreign_answer.id, answer: { body: 'edited body' }, format: :js } }

        it 'does not update foreign answer' do
          expect { update_foreign_answer }.to_not change { foreign_answer.reload.body }
          expect { update_foreign_answer }.to_not change { foreign_answer.reload.updated_at }
        end
      end
    end

    context 'Guest user' do
      let(:update_answer) { post :update, params: { question_id: answer.question.id, id: answer.id, answer: { body: 'edited body' } }, format: :js }

      it 'does not update a answer' do
        expect { update_answer }.to_not change(answer, :body)
        expect { update_answer }.to_not change(answer, :updated_at)
      end

      it '401 response' do
        update_answer
        expect(response.status).to eq 401
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'Authenticated user' do
      before do
        sign_in user
      end

      context 'As author' do
        let(:delete_my_answer) { delete :destroy, params: { question_id: my_answer.question.id, id: my_answer.id }, format: :js }

        it 'deletes my answer' do
          expect { delete_my_answer }.to change(user.answers, :count).by(-1)
        end

        it 'render destroy.js' do
          delete_my_answer
          expect(response).to render_template 'answers/destroy'
        end
      end

      context 'As non-author user' do
        let(:delete_foreign_answer) { delete :destroy, params: { question_id: answer.question.id, id: answer.id }, format: :js }

        it 'does not delete foreign answer' do
          expect { delete_foreign_answer }.to_not change(Answer, :count)
        end

        it '403 status' do
          delete_foreign_answer
          expect(response).to have_http_status 403
        end
      end
    end

    context 'Guest user' do
      let(:guest_try_delete_answer) { delete :destroy, params: { question_id: answer.question.id, id: answer.id } }

      it 'does not delete a answer' do
        expect { guest_try_delete_answer }.to_not change(Answer, :count)
      end

      it 'redirected to login page' do
        guest_try_delete_answer
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST #set_as_best' do
    context 'Authenticated user' do
      before do
        sign_in user
      end

      context 'As author of question' do
        let!(:answer_of_my_question) { create(:answer, question: my_question) }
        let(:set_best_answer_of_my_question) { post :set_as_best, params: { question_id: answer_of_my_question.question.id, id: answer_of_my_question.id }, format: :js }

        it 'change answer_of_my_question.best from false to true' do
          expect { set_best_answer_of_my_question }.to change { answer_of_my_question.reload.best }.from(false).to(true)
        end
      end

      context 'As non-author of question' do
        let(:set_best_answer_of_foreign_question) { post :set_as_best, params: { question_id: question.id, id: answer.id }, format: :js }

        it 'NOT change answer.best' do
          expect { set_best_answer_of_foreign_question }.to_not change(answer, :best)
        end
      end
    end

    context 'As guest' do
      let(:guest_set_best_answer) { post :set_as_best, params: { question_id: question.id, id: answer.id }, format: :js }

      it 'NOT change answer.best' do
        expect { guest_set_best_answer }.to_not change(answer, :best)
      end
    end
  end
end
