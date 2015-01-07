module Coinsetter
  module Customer
    class Accounts < Coinsetter::Collection

      def example
        JSON.generate({
        accountList:
          [
            {
              accountUuid: "50af62c2-7221-49a1-85a8-dd34c6e0dd70",
              customerUuid: "b20ba985-827d-42f7-a355-37e699ac964b",
              accountNumber: "CST0000001",
              name: "My Bitcoin account",
              description: "For primary trading",
              btcBalance: 0E-8,
              usdBalance: 11.2,
              accountClass: "TEST",
              activeStatus: "ACTIVE",
              approvedMarginRatio: 1.0000,
              createDate: "18/05/2013 10:10:25.000",
            },
            {
              accountUuid: "b03a8e48-6ce4-4b5a-a8f5-ea6af8f288da",
              customerUuid: "b20ba985-827d-42f7-a355-37e699ac964b",
              accountNumber: "CSV0000002",
              name: "My Bitcoin account.2",
              description: "For primary trading",
              btcBalance: 0E-8,
              usdBalance: 11.2,
              accountClass: "VIRTUAL",
              activeStatus: "ACTIVE",
              approvedMarginRatio: 1.0000,
              createDate: "18/05/2013 10:10:25.000",
            }
            ]
          }
        )
      end
    end
  end
end
