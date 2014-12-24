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
  subject(:post) { Post.new }

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
end
