class Admin::SafeSeaechDetectionsController < ApplicationController
  def index
    @safe_seaech_detections = SafeSeaechDetection.all
  end
end
