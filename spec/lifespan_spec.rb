require 'spec_helper'
require 'lifespan/version'

describe Lifespan do
  it 'has a version number' do
    expect(Lifespan::VERSION).not_to be nil
  end

  context 'Delorean' do
    before do
      User.delete_all
      Article.delete_all
    end

    let!(:start_at1) { DateTime.new( 2015, 03,  1, 12, 10,  0, "+0900") }
    let!(:start_at2) { DateTime.new( 2015, 02,  1, 12, 10,  0, "+0900") }
    let!(:end_at)    { DateTime.new( 2015, 03, 31, 23, 59, 59, "+0900") }

    let!(:user1) { User.create(name: "user1") }
    let!(:user2) { User.create(name: "user2") }
    let!(:user1_article1) { Article.create(name: "user1's article1", user_id: user1.id, start_at: start_at1, end_at: nil) }
    let!(:user1_article2) { Article.create(name: "user1's article2", user_id: user1.id, start_at: start_at1, end_at: end_at) }
    let!(:user1_article3) { Article.create(name: "user1's article3", user_id: user1.id, start_at: start_at1, end_at: start_at1) } # Dead record
    let!(:user2_article1) { Article.create(name: "user2's article1", user_id: user2.id, start_at: start_at1) }
    let!(:user2_article2) { Article.create(name: "user2's article2", user_id: user2.id, start_at: start_at2) }

    shared_examples "delorean check" do
      it {
        Delorean.time_travel_to( now_datetime ) do
          expect( Article.all ).to match_array match_array_data
        end
      }

      it {
        Delorean.time_travel_to( now_datetime ) do
          expect( Article.all ).to_not include not_include
        end
      }
    end

    [
      '2015-02-01 12:10:00 +0900',
    ].each do |now_datetime_str|
      context now_datetime_str do
        let(:now_datetime) { DateTime.parse( now_datetime_str) }
        let(:match_array_data) { [user2_article2] }
        let(:not_include) { [user1_article1, user1_article2, user2_article1, user1_article3] }

        it_behaves_like "delorean check"
      end
    end

    [
      '2015-02-01 12:09:59 +0900',
    ].each do |now_datetime_str|
      context now_datetime_str do
        let(:now_datetime) { DateTime.parse( now_datetime_str) }
        let(:match_array_data) { [] }
        let(:not_include) { [user1_article1, user1_article2, user2_article1, user1_article3, user2_article2] }

        it_behaves_like "delorean check"
      end
    end

    [
      '2015-03-01 12:10:00 +0900',
      '2015-03-31 23:59:58 +0900',
      #'2015-03-31 23:59:59 +0900'  # FIXME Rails4.2 record not find
    ].each do |now_datetime_str|
      context now_datetime_str do
        let(:now_datetime) { DateTime.parse( now_datetime_str) }
        let(:match_array_data) { [user1_article1, user1_article2, user2_article1, user2_article2] }
        let(:not_include) { [user1_article3] }

        it_behaves_like "delorean check"
      end
    end

    [
      '2015-04-01 00:00:00 +0900',
    ].each do |now_datetime_str|
      context now_datetime_str do
        let(:now_datetime) { DateTime.parse( now_datetime_str) }
        let(:match_array_data) { [user1_article1, user2_article1, user2_article2] }
        let(:not_include) { [user1_article2, user1_article3] }

        it_behaves_like "delorean check"
      end
    end
  end
end
