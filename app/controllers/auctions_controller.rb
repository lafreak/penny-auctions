class AuctionsController < ApplicationController
  def index
    @auctions = Auction.all
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = Auction.new(auction_params)
  end

  def show
    @auction = Auction.find(params[:id])
  end

  private

  def auction_params
    params.require(:auction).permit(:name, :price)
  end
end
