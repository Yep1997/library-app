module Readers
  class App
    def initialize(repository: Repository.new)
      @repository = repository
    end

    def list
      repository.all
    end

    private

    attr_reader :repository
  end
end
