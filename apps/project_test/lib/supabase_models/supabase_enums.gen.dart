// ignore_for_file: camel_case_types, constant_identifier_names
enum CustomerTableStateEnum {
  Reserved,
  InUse,
  Free,
}

enum DeliveryStateEnum {
  Canceled,
  Done,
  OnDelivery,
  Pending,
}

enum FoodIngredientStateEnum {
  Active,
  Disabled,
}

enum OrderDeliveryPlaceEnum {
  Inside,
  Outside,
}

enum OrderStateEnum {
  Done,
  Pending,
  Placed,
  Opened,
}

enum TransactionTypeEnum {
  Disposal,
  Cook,
  Supply,
}

enum UnitTypeEnum {
  Piece,
  Volume,
  Weight,
}
