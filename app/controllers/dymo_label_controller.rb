# frozen_string_literal: true

class DymoLabelController < ApplicationController
  def label_preview
    render :preview
  end
end
