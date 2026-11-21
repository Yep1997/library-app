module Books
  class App
    def initialize(repository: Repository.new)
      @repository = repository
    end

    def list
      repository.all
    end

    def find(serial_number)
      repository.find(serial_number)
    end

    def add(serial_number:, title:, author:)
      repository.create(serial_number:, title:, author:)
    end

    def remove(serial_number)
      repository.delete(serial_number)
    end

    def change_status(serial_number, status:, card_number: nil)
      ChangeStatus.new(repository:).call(serial_number, status:, card_number:)
    end

    private

    attr_reader :repository
  end
end
