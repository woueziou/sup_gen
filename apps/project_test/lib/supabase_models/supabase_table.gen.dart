// ignore_for_file: camel_case_types
import 'dart:convert';

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
  factory Profiles.fromJson(Map<String, dynamic> json) {
    return Profiles(
      id: json['id'],
      createdAt: json['created_at'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      isActive: json['is_active'],
    );
  }
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
  factory Units.fromJson(Map<String, dynamic> json) {
    return Units(
      id: json['id'],
      name: json['name'],
      unitType: json['unit_type'],
      description: json['description'],
      baseUnit: json['base_unit'],
      conversionFactor: json['conversion_factor'],
    );
  }
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
  factory Tables.fromJson(Map<String, dynamic> json) {
    return Tables(
      id: json['id'],
      createdAt: json['created_at'],
      tableName: json['table_name'],
      description: json['description'],
      tableNumber: json['table_number'],
      isActive: json['is_active'],
      maxPerson: json['max_person'],
      minPrice: json['min_price'],
      isVip: json['is_vip'],
    );
  }
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
  factory Ingredients.fromJson(Map<String, dynamic> json) {
    return Ingredients(
      id: json['id'],
      createdAt: json['created_at'],
      addedBy: json['added_by'],
      name: json['name'],
      price: json['price'],
      description: json['description'],
      unitId: json['unit_id'],
    );
  }
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
  factory Orders.fromJson(Map<String, dynamic> json) {
    return Orders(
      id: json['id'],
      createdAt: json['created_at'],
      dateOrder: json['date_order'],
      deliveryPlace: json['delivery_place'],
      locationCoordinate: json['location_coordinate'],
      orderState: json['order_state'],
      createdBy: json['created_by'],
      orderConfirmationNumber: json['order_confirmation_number'],
    );
  }
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
  factory OrderItems.fromJson(Map<String, dynamic> json) {
    return OrderItems(
      id: json['id'],
      createdAt: json['created_at'],
      orderId: json['order_id'],
      itemId: json['item_id'],
      quantity: json['quantity'],
    );
  }
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
  factory Deliveries.fromJson(Map<String, dynamic> json) {
    return Deliveries(
      id: json['id'],
      createdAt: json['created_at'],
      orderId: json['order_id'],
      userId: json['user_id'],
      handlingTime: json['handling_time'],
      deliveryState: json['delivery_state'],
    );
  }
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
  factory Foods.fromJson(Map<String, dynamic> json) {
    return Foods(
      id: json['id'],
      createdAt: json['created_at'],
      foodName: json['food_name'],
      cookTime: json['cook_time'],
      imageUrl: json['image_url'],
      hasIngredients: json['has_ingredients'],
      addedBy: json['added_by'],
      price: json['price'],
      description: json['description'],
    );
  }
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
  factory FoodIngredients.fromJson(Map<String, dynamic> json) {
    return FoodIngredients(
      id: json['id'],
      createdAt: json['created_at'],
      quantity: json['quantity'],
      foodId: json['food_id'],
      ingredientId: json['ingredient_id'],
      foodIngredientStateState: json['food_ingredient_state_state'],
    );
  }
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
  factory InventoryBatches.fromJson(Map<String, dynamic> json) {
    return InventoryBatches(
      id: json['id'],
      ingredientId: json['ingredient_id'],
      quantity: json['quantity'],
      expiryDate: json['expiry_date'],
      createdAt: json['created_at'],
      buyPrice: json['buy_price'],
    );
  }
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
  factory IngredientTransactions.fromJson(Map<String, dynamic> json) {
    return IngredientTransactions(
      id: json['id'],
      transactionType: json['transaction_type'],
      quantity: json['quantity'],
      createdAt: json['created_at'],
      userId: json['user_id'],
      batchId: json['batch_id'],
      note: json['note'],
    );
  }
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
  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      id: json['id'],
      createdAt: json['created_at'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['image_url'],
    );
  }
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
  factory MenuItems.fromJson(Map<String, dynamic> json) {
    return MenuItems(
      id: json['id'],
      createdAt: json['created_at'],
      menuId: json['menu_id'],
      foodId: json['food_id'],
      price: json['price'],
    );
  }
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
  factory AuditLogs.fromJson(Map<String, dynamic> json) {
    return AuditLogs(
      auditId: json['audit_id'],
      tableName: json['table_name'],
      recordId: json['record_id'],
      actionType: json['action_type'],
      changedData: json['changed_data'] != null
          ? jsonDecode(json['changed_data'].toString()) as Map<String, dynamic>
          : null,
      changedBy: json['changed_by'],
      changedAt: json['changed_at'],
    );
  }
}

class FoodsWithIngredients {
  FoodsWithIngredients({
    this.foodId,
    this.foodName,
    this.price,
    this.foodDescription,
    this.cookTime,
    this.imageUrl,
    this.hasIngredients,
    this.ingredients,
  });
  final String? foodId;
  final String? foodName;
  final num? price;
  final String? foodDescription;
  final int? cookTime;
  final String? imageUrl;
  final bool? hasIngredients;
  final Map<String, dynamic>? ingredients;
  factory FoodsWithIngredients.fromJson(Map<String, dynamic> json) {
    return FoodsWithIngredients(
      foodId: json['food_id'],
      foodName: json['food_name'],
      price: json['price'],
      foodDescription: json['food_description'],
      cookTime: json['cook_time'],
      imageUrl: json['image_url'],
      hasIngredients: json['has_ingredients'],
      ingredients: json['ingredients'] != null
          ? jsonDecode(json['ingredients'].toString()) as Map<String, dynamic>
          : null,
    );
  }
}

class AvailableIngredients {
  AvailableIngredients({
    this.ingredientId,
    this.ingredientName,
    this.ingredientDescription,
    this.unit,
    this.availableQuantity,
    this.price,
    this.nearestExpiryDate,
  });
  final String? ingredientId;
  final String? ingredientName;
  final String? ingredientDescription;
  final String? unit;
  final num? availableQuantity;
  final num? price;
  final String? nearestExpiryDate;
  factory AvailableIngredients.fromJson(Map<String, dynamic> json) {
    return AvailableIngredients(
      ingredientId: json['ingredient_id'],
      ingredientName: json['ingredient_name'],
      ingredientDescription: json['ingredient_description'],
      unit: json['unit'],
      availableQuantity: json['available_quantity'],
      price: json['price'],
      nearestExpiryDate: json['nearest_expiry_date'],
    );
  }
}
