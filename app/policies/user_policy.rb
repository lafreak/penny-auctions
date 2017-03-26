class UserPolicy
  attr_accessor :user1, :user2

  def initialize(user1, user2)
    @user1 = user1
    @user2 = user2
  end

  def index?
    user1.role == 2
  end

  def edit?
    user1.role == 2
  end

  def save?
    user1.role == 2
  end

  def delete?
    user1.role == 2
  end

  def block?
    user1.role == 2
  end

  def role?
    user1.role == 2 && user1.id != user2.id
  end
end