class BdlFilesController < ApplicationController

  def show
    @bdl_file = BdlFile.includes(:instructions).find(params[:id])
    respond_to do |format|
      format.html
      format.json { render :json => @bdl_file, :include => :instructions }
    end
  end

  def new
    respond_to do |format|
      format.html
    end
  end

  def index
    @bdl_files = BdlFile.all
    respond_to do |format|
      format.html
    end
  end

  def create
    data = params["datafile"]["datafile"].read
    filename = params["datafile"]["datafile"].original_filename + Time.now.to_s
    bdl_file = BdlFile.create! :filename => filename, :data => data
    bdl_file.parse
    redirect_to :action => :show, :id => bdl_file.id
    #file = upload[:datafile]
  end


  def polygons
    @bdl_file = BdlFile.find params[:id].to_i
    bdl_file_id = params[:id].to_i
    @filter = params[:filter]

    # Polygons from spaces
    @spaces = Instruction.includes(:references).find_all_by_bdl_file_id_and_i_type(bdl_file_id, "SPACE")
    @polygons = @spaces.reduce([]) do |current, space|
      space.references.each do |reference|
        child = Instruction.find(reference.child_id)
        current << child if child.i_type == 'POLYGON'
      end
      current
    end

    # Vertices from polygons
    @vertices = @polygons.reduce({}) do |current, new_one|
      current[new_one.uname] = new_one.name_values.map do |nv|
        nvs = nv.value[1, nv.value.length-2].split(",")
        [nvs[0].to_f, nvs[1].to_f]
      end
      # close the path
      current[new_one.uname] << current[new_one.uname][0]
      current
    end

    respond_to do |format|
      format.json { render :json => @vertices }
      format.html
    end
  end
end


