class AuctionsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create, :bid, :edit, :delete]

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

    @auction.bids.create(user: current_user, price: @auction.top_offer + BigDecimal.new(0.01, 2))

    redirect_to auctions_index_path
  end

  private

  def auction_params
    params.require(:auction).permit(:name, :price, :photo, :finish_at)
  end
end
