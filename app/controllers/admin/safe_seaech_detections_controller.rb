class Admin::SafeSeaechDetectionsController < ApplicationController
  before_action :get_safe_seaech_detection_matched_id
  before_action :authenticate_admin!

  def index
    @safe_seaech_detections = SafeSeaechDetection.valid.desc.page(params[:page]).per(6)
    if @safe_seaech_detections.blank? && params[:page].to_i > 1
      redirect_to admin_safe_seaech_detections_path(page: params[:page].to_i - 1)
    end
  end

  def destroy
    @safe_seaech_detection.destroy
    redirect_to request.referer
  end

  private

    def get_safe_seaech_detection_matched_id
      if params[:id]
        @safe_seaech_detection = SafeSeaechDetection.find_by(id: params[:id])
        redirect_to admin_safe_seaech_detections_path if @safe_seaech_detection.nil?
      end
    end
end
