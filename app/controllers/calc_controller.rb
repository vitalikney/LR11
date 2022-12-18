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

  private

  def set_input
    @message = []
    @answer = Answer.new(input: params[:number])
    @answer_in_db = Answer.find_by(input: params[:number])
  end

  def check_input
    return if @answer.valid?

    redirect_to root_path, notice: @answer.errors.objects.map(&:message).first

    # # if @input&.match
    # begin
    #   return if @input.match?(/^\d+$/) && @input.to_i <= 999_999
    # rescue NoMethodError
    #   @result = 'EmptyInputError'
    # end

    # redirect_to(root_path, notice:
    #   'Введены некорректные данные! Повторите ввод')
  end
  
  end