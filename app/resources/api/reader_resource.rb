module Api
  class ReaderResource
    include Alba::Resource

    attributes :card_number, :full_name, :email
  end
end
