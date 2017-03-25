class AuctionsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :bid]

  def index
    @auctions = Auction.all
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

  def bid
    @auction = Auction.find(params[:id])

    @auction.bids.create(user: current_user, price: @auction.top_offer + BigDecimal.new(0.01, 2))

    redirect_to auctions_index_path
  end

  private

  def auction_params
    params.require(:auction).permit(:name, :price, :photo)
  end
end
