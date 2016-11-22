class DistributionsController < ApplicationController
  include DistributionActions
  before_action :authenticate_user!

  private

  def update_customization
    if @distribution.valid?
      redirect_to edit_dataset_path(@distribution.dataset)
      return
    end
    render :edit
    return
  end

  def distribution_params
    params.require(:distribution).permit(
      :title,
      :description,
      :publish_date,
      :download_url,
      :modified,
      :temporal,
      :byte_size,
      :media_type,
      :format
    )
  end
end
