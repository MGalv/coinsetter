module Coinsetter
  class ClientSessions < Coinsetter::Collection

    def example
      JSON.generate({
        uuid: "38363173-e6fd-4f3a-8146-9ba50da2b1e3",
        message: "OK",
        requestStatus: "SUCCESS",
        userName: "johnqsmith#{rand(100)}",
        customerUuid: "b20ba985-827d-42f7-a355-37e699ac964b",
        customerStatus: "ACTIVE"
      })
    end
  end
end
