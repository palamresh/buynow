import 'package:buynow/features/auth/signup/model/user_model.dart';
import 'package:buynow/features/users/model/order_model.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../features/admin/model/categories_model.dart';
import '../features/admin/model/discount_model.dart';
import '../features/admin/model/product_model.dart';
import '../features/users/model/address_model.dart';
import '../features/users/model/cart_item_model.dart';
import '../features/users/model/favourite_model.dart';
import '../features/users/model/favourite_with_product_model.dart';
import '../features/users/model/order_item_model.dart';

class DbHelper {
  static final DbHelper instance = DbHelper._init();
  static Database? _database;
  DbHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final dbPath = await getApplicationDocumentsDirectory();

    final path = join(dbPath.path, "buyNow.db");

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE discounts (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL,
      percentage REAL NOT NULL,
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      ''');

    await db.execute('''
      CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      password TEXT NOT NULL,
      phone TEXT,
      role TEXT DEFAULT 'user',
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      discount_id INTEGER DEFAULT NULL,
      FOREIGN KEY (discount_id) REFERENCES discounts(id) ON DELETE SET NULL

      ) 
      ''');
    await db.execute('''
      CREATE TABLE categories (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE NOT NULL, 
      is_active INTEGER DEFAULT 1, 
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
      ''');

    await db.execute('''
      CREATE TABLE products (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL, 
      description TEXT ,
      price REAL NOT NULL,
      stock INTEGER DEFAULT 0,
      image TEXT NOT NULL,
      category_id INTEGER NOT NULL,
      is_active INTEGER DEFAULT 1, 
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY(category_id) REFERENCES categories(id) ON DELETE CASCADE
      )
      ''');

    // await db.execute('''
    //   CREATE TABLE product_images (
    //   id INTEGER PRIMARY KEY AUTOINCREMENT,
    //   product_id INTEGER NOT NULL,
    //   image_url TEXT NOT NULL,
    //   is_primary INTEGER DEFAULT 0,
    //   create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    //   FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
    //   )
    //   ''');

    await db.execute('''
      CREATE TABLE favourites(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      product_id INTEGER NOT NULL,
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE,
      UNIQUE(user_id,product_id)
      )
      ''');

    await db.execute('''
      CREATE TABLE cart(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      product_id INTEGER NOT NULL,
      quantity INTEGER NOT NULL DEFAULT 1,
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE,
      FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE,
      UNIQUE(user_id,product_id)
      )
      ''');

    await db.execute('''
      CREATE TABLE addresses(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      address_line1 TEXT NOT NULL,
      city TEXT NOT NULL,
      state TEXT NOT NULL,
      country TEXT NOT NULL,
      pincode TEXT NOT NULL,
      is_default INTEGER DEFAULT 0,
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users (id)
      )
      ''');

    await db.execute('''
      CREATE TABLE orders(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      address TEXT NOT NULL, -- store json form
      total_amount REAL NOT NULL,
      status TEXT DEFAULT 'pending',
      payment_method TEXT,
      razorpay_order_id TEXT,
      razorpay_payment_id TEXT,
      razorpay_signature_id TEXT,
      create_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      update_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (user_id) REFERENCES users (id)
      )
      ''');

    await db.execute('''
      CREATE TABLE order_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      order_id INTEGER NOT NULL,
      product_id INTEGER NOT NULL,
      price REAL NOT NULL,
      product_name TEXT NOT NULL,
      quntity INTEGER NOT NULL,
      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
      FOREIGN KEY (order_id) REFERENCES orders(id),
      FOREIGN KEY (product_id) REFERENCES products(id)
      
      )
      

      ''');

    await db.insert("users", {
      "name": "Admin",
      "email": "admin@gmail.com",
      "role": "admin",
      "password": "123456",
    });
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE products ADD COLUMN image TEXT");
    }
    if (oldVersion < 3) {
      await db.execute("ALTER TABLE order_items ADD COLUMN image TEXT");
    }
  }

  Future<UserModel?> getUserByEmail(String email) async {
    final db = await DbHelper.instance.database;
    final result = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return UserModel.fromMap(result.first);
    }
    return null;
  }

  Future<int> createAccount(UserModel user) async {
    final db = await DbHelper.instance.database;
    final existingUser = await getUserByEmail(user.email);
    if (existingUser != null) {
      throw Exception("User with this email already exits");
    }
    return await db.insert("users", user.toMap());
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user == null) {
      throw Exception("User not found");
    }

    if (user.password != password) {
      throw Exception("Invalid Password");
    }

    return user;
  }

  /// User
  Future<List<UserModel>> getAllUsers({
    String? search,
    String? sortOptions,
    int limit = 10,
    int offset = 0,
  }) async {
    final db = await DbHelper.instance.database;
    String? where;
    List<Object>? whereArgs;
    if (search != null && search.isNotEmpty) {
      where = "name LIKE ? OR email LIKE ?";
      whereArgs = ["%$search%", "%$search%"];
    }
    String orderBy = "name ASC";
    switch (sortOptions) {
      case "name_asc":
        orderBy = "name ASC";
      case "name_desc":
        orderBy = "name DESC";
      case "email_asc":
        orderBy = "email ASC";
      case "email desc":
        orderBy = "email DESC";
    }
    final result = await db.query(
      "users",
      where: where,
      orderBy: orderBy,
      whereArgs: whereArgs,
      limit: limit,
      offset: offset,
    );

    return result.map((e) => UserModel.fromMap(e)).toList();
  }

  Future<int> deleteUser(int id) async {
    final db = await DbHelper.instance.database;
    final result = await db.delete("users", where: "id= ?", whereArgs: [id]);
    return result;
  }

  /// ✅ Insert Discount
  Future<int> insertDiscount(DiscountModel discount) async {
    final db = await DbHelper.instance.database;
    return await db.insert(
      'discounts',
      discount.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// ✅ Update Discount
  Future<int> updateDiscount(DiscountModel discount) async {
    final db = await DbHelper.instance.database;
    return await db.update(
      'discounts',
      discount.toMap(),
      where: 'id = ?',
      whereArgs: [discount.id],
    );
  }

  /// ✅ Delete Discount
  Future<int> deleteDiscount(int id) async {
    final db = await DbHelper.instance.database;
    return await db.delete('discounts', where: 'id = ?', whereArgs: [id]);
  }

  ///  Get All Discounts
  Future<List<DiscountModel>> getDiscounts() async {
    final db = await DbHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'discounts',
      orderBy: "id DESC",
    );
    return List.generate(maps.length, (i) => DiscountModel.fromMap(maps[i]));
  }

  /// ✅ Insert Category
  Future<int> insertCategory(CategoryModel category) async {
    final db = await DbHelper.instance.database;
    return await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// ✅ Update Category
  Future<int> updateCategory(CategoryModel category) async {
    final db = await DbHelper.instance.database;
    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  /// ✅ Delete Category
  Future<int> deleteCategory(int id) async {
    final db = await DbHelper.instance.database;
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  /// ✅ Get All Categories
  Future<List<CategoryModel>> getCategories() async {
    final db = await DbHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  /// ✅ Get Active Categories Only
  Future<List<CategoryModel>> getActiveCategories() async {
    final db = await DbHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  /// ✅ Toggle is_active status
  Future<int> toggleCategoryStatus(int id, int newStatus) async {
    final db = await DbHelper.instance.database;
    return await db.update(
      'categories',
      {'is_active': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// ✅ Insert Product
  Future<int> insertProduct(ProductModel product) async {
    final db = await DbHelper.instance.database;
    return await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// ✅ Update Product
  Future<int> updateProduct(ProductModel product) async {
    final db = await DbHelper.instance.database;
    return await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  /// ✅ Delete Product
  Future<int> deleteProduct(int id) async {
    final db = await DbHelper.instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  /// ✅ Get All Products
  Future<List<ProductModel>> getProducts() async {
    final db = await DbHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      orderBy: "id DESC",
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  /// ✅ Get Products by Category
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    final db = await DbHelper.instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'category_id = ?',
      whereArgs: [categoryId],
      orderBy: "id DESC",
    );
    return List.generate(maps.length, (i) => ProductModel.fromMap(maps[i]));
  }

  // ✅ Add Favourite
  Future<int> addFavourite(FavouriteModel favourite) async {
    final db = await DbHelper.instance.database;
    try {
      return await db.insert(
        'favourites',
        favourite.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore, // UNIQUE constraint handle
      );
    } catch (e) {
      print("Error inserting favourite: $e");
      return -1;
    }
  }

  Future<void> removeFromFavourites(int userId, int productId) async {
    final db = await DbHelper.instance.database;
    await db.delete(
      'favourites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  // ✅ Check if Favourite
  Future<bool> isFavourite(int userId, int productId) async {
    final db = await DbHelper.instance.database;
    final res = await db.query(
      'favourites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
    return res.isNotEmpty;
  }

  Future<List<FavouriteWithProduct>> getUserFavourites(int userId) async {
    final db = await DbHelper.instance.database;
    final result = await db.rawQuery(
      '''
      SELECT 
       f.id AS fav_id , f.user_id, f.product_id, f.create_at,
        p.id AS product_id, p.name, p.price, p.stock,p.description,
      p.category_id,
      p.image
      FROM favourites f
      INNER JOIN products p ON f.product_id = p.id
      WHERE f.user_id = ?
    ''',
      [userId],
    );

    return result.map((row) => FavouriteWithProduct.fromMap(row)).toList();
  }

  Future<int> addToCart(int userId, int productId) async {
    final db = await database; // assume tumhara db instance yahan hai
    try {
      // Check if product already in cart
      final existing = await db.query(
        'cart',
        where: 'user_id = ? AND product_id = ?',
        whereArgs: [userId, productId],
      );

      if (existing.isNotEmpty) {
        return 0;
      } else {
        // Insert new row
        return await db.insert('cart', {
          'user_id': userId,
          'product_id': productId,
          'quantity': 1,
          'create_at': DateTime.now().toIso8601String(),
          'update_at': DateTime.now().toIso8601String(),
        });
      }
    } catch (e) {
      print('Error adding to cart: $e');
      return -1;
    }
  }

  Future<int> updateQuantity(int userId, int productId, int quantity) async {
    final db = await database;
    return await db.update(
      'cart',
      {'quantity': quantity, 'update_at': DateTime.now().toIso8601String()},
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<int> removeFromCart(int userId, int productId) async {
    final db = await database;
    return await db.delete(
      'cart',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<List<CartItemModel>> getCartItems(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      '''
    SELECT cart.id, cart.user_id, cart.product_id, cart.quantity, cart.create_at, cart.update_at,
           products.name, products.price, products.image
    FROM cart
    JOIN products ON cart.product_id = products.id
    WHERE cart.user_id = ?
  ''',
      [userId],
    );

    return result.map((map) => CartItemModel.fromMap(map)).toList();
  }

  // 🔹 Insert new address
  Future<int> insertAddress(AddressModel address) async {
    final db = await instance.database;

    // agar is_default = 1 set karte ho to pehle sabko 0 kar do
    if (address.isDefault == 1) {
      await db.update(
        "addresses",
        {"is_default": 0},
        where: "user_id = ?",
        whereArgs: [address.userId],
      );
    }

    return await db.insert("addresses", address.toMap());
  }

  // 🔹 Fetch all addresses of user
  Future<List<AddressModel>> getAddresses(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      "addresses",
      where: "user_id = ?",
      whereArgs: [userId],
    );
    return result.map((e) => AddressModel.fromMap(e)).toList();
  }

  // 🔹 Get default address of user
  Future<AddressModel?> getDefaultAddress(int userId) async {
    final db = await instance.database;
    final result = await db.query(
      "addresses",
      where: "user_id = ? AND is_default = 1",
      whereArgs: [userId],
      limit: 1,
    );
    if (result.isNotEmpty) {
      return AddressModel.fromMap(result.first);
    }
    return null;
  }

  // 🔹 Update address
  Future<int> updateAddress(AddressModel address) async {
    final db = await instance.database;
    return await db.update(
      "addresses",
      address.toMap(),
      where: "id = ?",
      whereArgs: [address.id],
    );
  }

  // 🔹 Delete address
  Future<int> deleteAddress(int id) async {
    final db = await instance.database;
    return await db.delete("addresses", where: "id = ?", whereArgs: [id]);
  }

  // 🔹 Set default address
  Future<void> setDefaultAddress(int userId, int addressId) async {
    final db = await instance.database;
    await db.update(
      "addresses",
      {"is_default": 0},
      where: "user_id = ?",
      whereArgs: [userId],
    );
    await db.update(
      "addresses",
      {"is_default": 1},
      where: "id = ?",
      whereArgs: [addressId],
    );
  }

  Future<int> insertOrder(OrderModel order) async {
    final db = await instance.database;
    return await db.insert("orders", order.toMap());
  }

  Future<int> updateOrderStatus(int orderId, String status) async {
    final db = await instance.database;
    return await db.update(
      "orders",
      {"status": status, "update_at": DateTime.now().toIso8601String()},
      where: "id = ?",
      whereArgs: [orderId],
    );
  }

  Future<int> deleteOrder(int orderId) async {
    final db = await instance.database;
    // Pehle order items delete karo
    await db.delete("order_items", where: "order_id = ?", whereArgs: [orderId]);
    return await db.delete("orders", where: "id = ?", whereArgs: [orderId]);
  }

  Future<List<OrderModel>> getOrders(int userId) async {
    final db = await instance.database;
    final data = await db.query(
      "orders",
      where: "user_id = ?",
      whereArgs: [userId],
      orderBy: "create_at DESC",
    );
    return data.map((e) => OrderModel.fromMap(e)).toList();
  }

  // ---------------- ORDER ITEMS ----------------
  Future<int> insertOrderItem(OrderItemModel item) async {
    final db = await instance.database;
    return await db.insert("order_items", item.toMap());
  }

  Future<List<OrderItemModel>> getOrderItems(int orderId) async {
    final db = await instance.database;
    final data = await db.query(
      "order_items",
      where: "order_id = ?",
      whereArgs: [orderId],
    );
    return data.map((e) => OrderItemModel.fromMap(e)).toList();
  }

  Future<int> updateOrderItemQuantity(int itemId, int quantity) async {
    final db = await instance.database;
    return await db.update(
      "order_items",
      {"quntity": quantity},
      where: "id = ?",
      whereArgs: [itemId],
    );
  }

  Future<int> deleteOrderItem(int itemId) async {
    final db = await instance.database;
    return await db.delete("order_items", where: "id = ?", whereArgs: [itemId]);
  }
}
