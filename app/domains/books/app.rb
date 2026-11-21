module Books
  class App
    def self.list = new.list
    def self.find(serial_number) = new.find(serial_number)
    def self.add(...) = new.add(...)
    def self.remove(serial_number) = new.remove(serial_number)

    def initialize(repository: Repository.new)
      @repository = repository
    end

    def list
      @repository.all
    end

    def find(serial_number)
      @repository.find(serial_number)
    end

    def add(serial_number:, title:, author:)
      @repository.create(serial_number:, title:, author:)
    end

    def remove(serial_number)
      @repository.delete(serial_number)
    end
  end
end
