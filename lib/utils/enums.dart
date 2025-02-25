//EG Airtme_Purchase, Electricity,Cable_TV,Internet, Airline, Betting,
enum TransactionType {
  airtime_data,
  electricity,
  airline,
  betting,
  remita,
  tv,
}

enum PaymentGateway { remita, interswitch, paystack }

enum PaymentStatus { failed, pending, paid, completed, initiated, processing }

enum NotificationType { transaction, notification }

enum FieldType { text, alphanumeric, number, email, singleselect, multiselect, date, multiselectwithprice }
