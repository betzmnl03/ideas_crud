require 'rails_helper'

RSpec.describe Idea, type: :model do
  def ideas
    @idea ||= Idea.new(
      title: 'Random Title',
      description: 'This is a really good idea'
    )
  end
end
