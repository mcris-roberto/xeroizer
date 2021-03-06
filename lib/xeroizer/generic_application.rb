require 'xeroizer/record/application_helper'

module Xeroizer
  class GenericApplication

    include Http
    extend Record::ApplicationHelper

    attr_reader :client, :logger, :rate_limit_sleep, :rate_limit_max_attempts,
                :default_headers, :unitdp, :before_request, :after_request, :around_request, :nonce_used_max_attempts

    attr_accessor :xero_url

    extend Forwardable
    def_delegators :client, :access_token

    record :Account
    record :Allocation
    record :Attachment
    record :Balances
    record :BatchPayment
    record :BrandingTheme
    record :Contact
    record :ContactGroup
    record :CreditNote
    record :Currency
    record :Employee
    record :ExpenseClaim
    record :Invoice
    record :InvoiceReminder
    record :OnlineInvoice
    record :Item
    record :Journal
    record :LineItem
    record :ManualJournal
    record :Organisation
    record :Payment
    record :PaymentService
    record :Prepayment
    record :Overpayment
    record :PurchaseOrder
    record :Quote
    record :Receipt
    record :RepeatingInvoice
    record :Schedule
    record :TaxRate
    record :TrackingCategory
    record :TrackingCategoryChild
    record :BankTransaction
    record :BankTransfer
    record :User

    report :AgedPayablesByContact
    report :AgedReceivablesByContact
    report :BalanceSheet
    report :BankStatement
    report :BankSummary
    report :BudgetSummary
    report :ExecutiveSummary
    report :ProfitAndLoss
    report :TrialBalance

    public

      # Never used directly. Use sub-classes instead.
      # @see PublicApplication
      # @see PrivateApplication
      # @see PartnerApplication
      def initialize(client, options = {})
        raise Xeroizer::InvalidClientError.new unless [OAuth, OAuth2].member?(client.class)
        @xero_url = options[:xero_url] || "https://api.xero.com/api.xro/2.0"
        @rate_limit_sleep = options[:rate_limit_sleep] || false
        @rate_limit_max_attempts = options[:rate_limit_max_attempts] || 5
        @nonce_used_max_attempts = options[:nonce_used_max_attempts] || 1
        @default_headers = options[:default_headers] || {}
        @before_request = options.delete(:before_request)
        @after_request = options.delete(:after_request)
        @around_request = options.delete(:around_request)
        @client = client
        @logger = options[:logger] || false
        @unitdp = options[:unitdp] || 2
      end

      def payroll(options = {})
        xero_client = self.clone
        xero_client.xero_url = options[:xero_url] || "https://api.xero.com/payroll.xro/1.0"
        @payroll ||= PayrollApplication.new(xero_client)
      end

  end
end
