class StaticPagesController < ApplicationController
  before_action :authenticate_user!, only: [:premium, :buy]

  def index
  end

  def premium
  end

  def buy
    if current_user.premium > DateTime.now
      flash[:danger] = "You already have premium account."
      redirect_to show_premium_path
      return
    end

    if current_user.balance < BigDecimal.new(10.00, 2)
      flash[:danger] = "Not enough balance."
      redirect_to show_premium_path
      return
    end

    flash[:succeess] = "You have premium account now."
    current_user.update(premium: DateTime.now + 30.days, balance: current_user.balance - BigDecimal.new(10.00, 2))
    redirect_to auctions_index_path
  end
end
