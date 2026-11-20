module Books
  class App
    def self.list = new.list

    def initialize(repository: Repository.new)
      @repository = repository
    end

    def list
      @repository.all
    end
  end
end
