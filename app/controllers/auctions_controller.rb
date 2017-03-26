class AuctionsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :bid, :edit, :delete, :wins, :receive, :shipping, :ship]

  def index
    @auctions = Auction.all.order('finish_at ASC')
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = Auction.new(auction_params)
    
    if @auction.save
      flash[:success] = "Auction has been inserted."
      redirect_to auctions_index_path
    else
      render 'new'
    end
  end

  def show
    @auction = Auction.find(params[:id])
  end

  def edit
    @auction = Auction.find(params[:id])
  end

  def save
    @auction = Auction.find(params[:id])
    @auction.update(auction_params)

    flash[:success] = "Auction has been updated."

    redirect_to auctions_edit_path(@auction)
  end

  def delete
    @auction = Auction.find(params[:id])
    @auction.destroy

    flash[:success] = "Auction has been removed."

    redirect_to auctions_index_path
  end

  def bid
    @auction = Auction.find(params[:id])

    if (current_user.balance < 0.01)
      flash[:danger] = "Your balance is not enough."
      redirect_to auctions_index_path
      return
    end

    seconds_left = (@auction.finish_at.to_f - DateTime.now.to_f).to_i

    if seconds_left < 0
      redirect_to auctions_index_path
      return
    elsif seconds_left < 15
      @auction.update(finish_at: DateTime.now + 15.seconds)
    end

    new_price = @auction.top_offer + BigDecimal.new(0.01, 2)

    @auction.bids.create(user: current_user, price: new_price)
    current_user.update(balance: current_user.balance - BigDecimal.new(0.01, 2))

    @auction.update(user: current_user, top_price: new_price)

    redirect_to auctions_index_path
  end

  def wins
    @auctions = current_user.auctions.where('finish_at < ?', DateTime.now)
  end

  def pay
    @auction = Auction.find(params[:id])

    if current_user.balance < @auction.top_price
      flash[:danger] = "Not enough balance."
      redirect_to auctions_wins_path
      return
    elsif @auction.paid
      redirect_to auctions_wins_path
      return
    end

    flash[:success] = "Auction has been paid. Your item is on the way."
    current_user.update(balance: current_user.balance - @auction.top_price)
    @auction.update(paid: true)

    redirect_to auctions_wins_path
  end

  def shipping
    @auctions = Auction.where(paid: true)
  end

  def ship
    @auction = Auction.find(params[:id])

    if @auction.shipped
      redirect_to auctions_shipping_path
      return
    end

    flash[:success] = "Auction has been set as shipped."
    @auction.update(shipped: true)
    redirect_to auctions_shipping_path
  end

  private

  def auction_params
    params.require(:auction).permit(:name, :price, :photo, :finish_at)
  end
end
