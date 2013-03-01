class Admin::ManualController < ApplicationController
  def index
    text_file_path = Rails.root.join('public', 'manual', 'Administradores.md')
    if File.exists? text_file_path
      @text_file = File.read(text_file_path)
    end
  end
end