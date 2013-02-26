class InstructionsController  < ApplicationController
  def show
    @instruction = Instruction.includes([:name_values,:references]).find(params[:id])
    respond_to do|format|
      format.html
      format.json {render :json => @instruction, :include => [:name_values,:references]  }
    end

  end
end