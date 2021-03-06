class Usuario
  attr_reader :nombre, :email, :updated_on, :created_on
  attr_accessor :id

  def initialize(nombre, id, email)
    raise ErrorFaltanArgumentos if nombre.nil? || id.nil? || email.nil?

    @nombre = nombre
    @id = id
    @email = email
  end

  def es_particular?
    true
  end
end
