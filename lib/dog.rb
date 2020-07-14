class Dog
attr_accessor :name, :breed
attr_reader :id

def initialize(name:name, breed:breed, id:id=nil)
@name = name
@breed = breed
@id = id
end

def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL
  
    DB[:conn].execute(sql)

end

def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end

 

  def save
    dog = DB[:conn].execute("SELECT * FROM dogs WHERE name = ? AND breed = ?", name, breed)
    if !dog.empty?
      dog_data = dog[0]
      dog = Dog.new(dog_data[0], dog_data[1], dog_data[2])
    else
      dog = self
            sql = <<-SQL
            INSERT INTO dogs (name, breed)
            VALUES (?, ?)
            SQL
            DB[:conn].execute(sql, self.name, self.breed)
            @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    dog
  end

  def self.create(dog_data)
    dog = Dog.new(name:dog_data[1], breed:dog_data[2], id:dog_data[0])
    dog.save
    
  end


end