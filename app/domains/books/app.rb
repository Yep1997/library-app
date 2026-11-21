module Books
  class App
    def self.list = new.list
    def self.find(serial_number) = new.find(serial_number)

    def initialize(repository: Repository.new)
      @repository = repository
    end

    def list
      @repository.all
    end

    def find(serial_number)
      @repository.find(serial_number)
    end
  end
end
