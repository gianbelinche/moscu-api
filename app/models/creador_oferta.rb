require './app/models/errores'
class CreadorOferta
  def initialize(repo_oferta, repo_auto, repo_usuario)
    @repo_oferta = repo_oferta
    @repo_auto = repo_auto
    @repo_usuario = repo_usuario
  end

  def crear(patente, id_ofertante, precio) # rubocop:disable Metrics/AbcSize
    raise ErrorAutoNoExiste unless @repo_auto.existe_auto(patente)
    raise ErrorUsuarioInexistente unless @repo_usuario.existe_usuario(id_ofertante)

    ofertante = @repo_usuario.find(id_ofertante)
    auto = @repo_auto.find(patente)
    raise ErrorPropietarioRealizaOferta if auto.usuario.id == id_ofertante
    raise ErrorYaSeRealizoOferta if @repo_oferta.existe_oferta_usuario_auto_estado(id_ofertante, patente, Pendiente.new)
    raise ErrorOfertaEnAutoNoParticular unless auto.propietario_es_particular?

    oferta = Oferta.crear(auto, ofertante, precio)

    @repo_oferta.save(oferta)
  end
end
