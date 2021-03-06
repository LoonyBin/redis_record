require 'spec_helper'
require 'active_attr/rspec'

class Blog < RedisRecord
  integer :id
end

class Post < RedisRecord
  string :id
  belongs_to :blog
  has_many :comments
end

class Comment < RedisRecord
  string :id
  belongs_to :post
end

describe Post do
  subject(:post) { Post.new id: '123' }

  it { should respond_to :comments }

  context 'with belongs_to' do
    it { should have_attribute(:blog_id).of_type(Integer) }
    let(:blog) { Blog.create id: 123 }

    it 'should have a getter for the relation' do
      post.blog_id = blog.id
      expect(post.blog).to eq blog
    end

    it 'should have a setter for the relation' do
      post.blog = blog
      expect(post.blog_id).to eq blog.id
    end
  end

  context 'has_many comments' do
    let(:comments) { (1..2).map { |i| Comment.create id: i } }
    it 'should have a getter for the relation' do
      comments.each {|c| c.update_attributes post_id: post.id }

      expect(post.comments.all).to match_array comments
    end

    it 'should have a setter for the relation' do
      post.comments = comments
      expect(comments.map &:post_id).to all eq post.id
    end

    it 'should have a constructor to add elements' do
      post.comments.create id: '234'
      expect(Comment.find('234').post_id).to eq post.id
    end

    context 'with default filter' do
      class FilteredComment < RedisRecord
        integer :id
        create_filter :id
        belongs_to :post
      end

      class Post
        has_many :filtered_comments, -> { filter :id, 0 }
      end

      it 'should apply default filters' do
        2.times {|i| FilteredComment.create id: i, post_id: post.id}

        expect(post.filtered_comments.to_a).to match_array [FilteredComment.find(0)]
      end
    end

    context 'with options' do
      class Post
        has_many :comments, dependent: :destroy
      end

      it 'should destroy dependent records' do
        post.comments.create id: '345'

        post.destroy
        expect(Comment.find('345')).to eq nil
      end
    end
  end
end
