class AuctionPolicy
  attr_reader :user, :auction

  def initialize(user, auction)
    @user = user
    @auction = auction
  end

  def index?
    true
  end

  def new?
    user.role >= 1 && !user.blocked
  end

  def create?
    user.role >= 1 && !user.blocked
  end

  def show?
    true
  end

  def edit?
    user.role >= 1 && !user.blocked
  end

  def save?
    user.role >= 1 && !user.blocked
  end

  def delete?
    user.role >= 1 && !user.blocked
  end

  def bid?
    if auction.special
      user.premium.to_f > DateTime.now.to_f && !user.blocked
    else
      !user.blocked
    end
  end

  def wins?
    true
  end

  def pay?
    true
  end

  def shipping?
    user.role >= 1 && !user.blocked
  end

  def ship?
    user.role >= 1 && !user.blocked
  end

end
