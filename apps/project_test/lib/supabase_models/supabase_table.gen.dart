// ignore_for_file: camel_case_types
import 'supabase_enums.gen.dart';

class Profiles {
  Profiles({
    required this.id,
    required this.createdAt,
    this.firstName,
    this.lastName,
    this.isActive,
  });
  final String id;
  final String createdAt;
  final String? firstName;
  final String? lastName;
  final bool? isActive;
}

class Units {
  Units({
    required this.id,
    required this.name,
    required this.unitType,
    this.description,
    this.baseUnit,
    this.conversionFactor,
  });
  final int id;
  final String name;
  final UnitTypeEnum unitType;
  final String? description;
  final int? baseUnit;
  final num? conversionFactor;
}

class Tables {
  Tables({
    required this.id,
    required this.createdAt,
    required this.tableName,
    this.description,
    required this.tableNumber,
    required this.isActive,
    this.maxPerson,
    required this.minPrice,
    this.isVip,
  });
  final String id;
  final String createdAt;
  final String tableName;
  final String? description;
  final int tableNumber;
  final bool isActive;
  final num? maxPerson;
  final num minPrice;
  final bool? isVip;
}

class Ingredients {
  Ingredients({
    required this.id,
    required this.createdAt,
    required this.addedBy,
    required this.name,
    required this.price,
    this.description,
    required this.unitId,
  });
  final String id;
  final String createdAt;
  final String addedBy;
  final String name;
  final num price;
  final String? description;
  final int unitId;
}

class Orders {
  Orders({
    required this.id,
    required this.createdAt,
    required this.dateOrder,
    this.deliveryPlace,
    this.locationCoordinate,
    required this.orderState,
    this.createdBy,
    this.orderConfirmationNumber,
  });
  final String id;
  final String createdAt;
  final String dateOrder;
  final String? deliveryPlace;
  final List<num>? locationCoordinate;
  final OrderStateEnum orderState;
  final String? createdBy;
  final String? orderConfirmationNumber;
}

class OrderItems {
  OrderItems({
    required this.id,
    required this.createdAt,
    required this.orderId,
    required this.itemId,
    required this.quantity,
  });
  final String id;
  final String createdAt;
  final String orderId;
  final String itemId;
  final int quantity;
}

class Deliveries {
  Deliveries({
    required this.id,
    required this.createdAt,
    required this.orderId,
    this.userId,
    this.handlingTime,
    this.deliveryState,
  });
  final String id;
  final String createdAt;
  final String orderId;
  final String? userId;
  final String? handlingTime;
  final DeliveryStateEnum? deliveryState;
}

class Foods {
  Foods({
    required this.id,
    required this.createdAt,
    required this.foodName,
    required this.cookTime,
    this.imageUrl,
    this.hasIngredients,
    required this.addedBy,
    required this.price,
    this.description,
  });
  final String id;
  final String createdAt;
  final String foodName;
  final int cookTime;
  final String? imageUrl;
  final bool? hasIngredients;
  final String addedBy;
  final num price;
  final String? description;
}

class FoodIngredients {
  FoodIngredients({
    required this.id,
    required this.createdAt,
    required this.quantity,
    required this.foodId,
    required this.ingredientId,
    this.foodIngredientStateState,
  });
  final int id;
  final String createdAt;
  final num quantity;
  final String foodId;
  final String ingredientId;
  final FoodIngredientStateEnum? foodIngredientStateState;
}

class InventoryBatches {
  InventoryBatches({
    required this.id,
    this.ingredientId,
    required this.quantity,
    this.expiryDate,
    this.createdAt,
    required this.buyPrice,
  });
  final String id;
  final String? ingredientId;
  final num quantity;
  final String? expiryDate;
  final String? createdAt;
  final num buyPrice;
}

class IngredientTransactions {
  IngredientTransactions({
    required this.id,
    required this.transactionType,
    required this.quantity,
    this.createdAt,
    this.userId,
    this.batchId,
    this.note,
  });
  final String id;
  final TransactionTypeEnum transactionType;
  final num quantity;
  final String? createdAt;
  final String? userId;
  final String? batchId;
  final String? note;
}

class Menus {
  Menus({
    required this.id,
    required this.createdAt,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
  });
  final String id;
  final String createdAt;
  final String name;
  final String? description;
  final num price;
  final String? imageUrl;
}

class MenuItems {
  MenuItems({
    required this.id,
    required this.createdAt,
    this.menuId,
    this.foodId,
    required this.price,
  });
  final String id;
  final String createdAt;
  final String? menuId;
  final String? foodId;
  final num price;
}

class AuditLogs {
  AuditLogs({
    required this.auditId,
    required this.tableName,
    required this.recordId,
    required this.actionType,
    this.changedData,
    this.changedBy,
    required this.changedAt,
  });
  final String auditId;
  final String tableName;
  final String recordId;
  final String actionType;
  final Map<String, dynamic>? changedData;
  final String? changedBy;
  final String changedAt;
}
