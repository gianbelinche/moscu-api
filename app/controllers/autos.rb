WebTemplate::App.controllers :autos, :provides => [:json] do
  post :create, :map => '/autos' do
    begin
      # input
      parametros = parametros_simbolizados
      # modelo
      nuevo_auto = CreadorAuto.new(repo_auto, repo_usuario)
                              .crear_auto(
                                parametros[:patente],
                                parametros[:modelo],
                                parametros[:kilometros],
                                parametros[:anio],
                                parametros[:id_prop]
                              )
      # output
      status 201
      {
        :patente => nuevo_auto.patente,
        :modelo => nuevo_auto.modelo,
        :kilometros => nuevo_auto.kilometros,
        :anio => nuevo_auto.anio,
        :id_prop => nuevo_auto.usuario.id
      }.to_json
    rescue ErrorEnLaAPI => e
      status 400
      {error: e.mensaje}.to_json
    end
  end

  get :list, :map => '/usuarios/:id_prop/autos' do
    begin
      # input
      id_prop = params[:id_prop].to_i

      # base de datos
      autos = repo_auto.por_propietario(id_prop)

      # output
      status 200
      respuesta = autos.map do |auto|
        {
          :patente => auto.patente,
          :modelo => auto.modelo,
          :kilometros => auto.kilometros,
          :anio => auto.anio,
          :id_prop => auto.usuario.id,
          :estado => auto.estado.zero? ? 'En revision' : 'Cotizado'
        }
      end

      respuesta.to_json
    rescue ErrorEnLaAPI => e
      status 400
      {error: e.mensaje}.to_json
    end
  end
end
