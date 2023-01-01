# frozen_string_literal: true

# class of controller's actions
class CalcController < ApplicationController
  before_action :set_input, only: :view 
  before_action :check_input, only: :view

  def input; end

  def view
    if @answer_in_db.nil?
      @answer.save
      @result = @answer.decode_output
      @message << 'Answer has been uploaded to database'
    else
      @result = @answer_in_db.decode_output
      @message << 'Answer has been downloaded from database'
    end
  end

  def xml
    @xml = Answer.all.map do |r|
      { id: r.id, input: r.input, output: r.output,
        created_at: r.created_at, updated_at: r.updated_at }
    end.to_xml
  end

  private

  def set_input
    @message = []
    @answer = Answer.new(input: params[:number])
    @answer_in_db = Answer.find_by(input: params[:number])
  end

  def check_input
    return if @answer.valid?

    redirect_to root_path, notice: @answer.errors.objects.map(&:message).first

  end

end