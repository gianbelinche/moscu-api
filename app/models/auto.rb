require_relative 'estado'

class Auto
  attr_reader :modelo, :kilometros, :anio, :usuario, :estado, :updated_on, :created_on, :precio
  attr_accessor :patente

  # Crear auto
  def self.crear(patente, modelo, kilometros, anio, usuario)
    Auto.new(patente, modelo, kilometros, anio, usuario, 0, EnRevision.new)
  end

  # Cargar desde la bdd
  def self.crear_desde_repo(patente, modelo, kilometros, anio, usuario, precio, estado) # rubocop:disable Metrics/ParameterLists
    Auto.new(patente, modelo, kilometros, anio, usuario, precio, estado)
  end

  def cotizar(precio)
    @precio = @estado.cotizar(precio)
    @estado = Cotizado.new
  end

  private

  def initialize(patente, modelo, kilometros, anio, usuario, precio, estado) # rubocop:disable Metrics/ParameterLists
    @patente = patente
    @modelo = modelo
    @kilometros = kilometros
    @anio = anio
    @usuario = usuario
    @precio = precio
    @estado = estado
  end
end
