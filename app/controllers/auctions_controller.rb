class AuctionsController < ApplicationController
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

  private

  def auction_params
    params.require(:auction).permit(:name, :price)
  end
end
