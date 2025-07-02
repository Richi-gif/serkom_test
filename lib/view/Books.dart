// import 'package:flutter/material.dart';
// import 'package:icons_plus/icons_plus.dart';
// import 'package:praktikum_1/widget/navigation.dart';
// import 'package:praktikum_1/widget/book_card.dart';
// import 'package:praktikum_1/service/cart/helper/cart_helper.dart';

// class Cart extends StatefulWidget {
//   const Cart({super.key});

//   @override
//   State<Cart> createState() => _CartState();
// }

// class _CartState extends State<Cart> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController quantityController = TextEditingController();
//   TextEditingController priceController = TextEditingController();
//   List<Map<String, dynamic>> cartItems = [];
//   final CartHelper _cartHelper = CartHelper();

//   @override
//   void initState() {
//     super.initState();
//     _loadCartItems();
//   }

//   Future<void> _loadCartItems() async {
//     final items = await _cartHelper.getCartItems();
//     setState(() {
//       cartItems = items;
//     });
//   }

//   Future<void> _removeItem(int id) async {
//     await _cartHelper.deleteCartItem(id);
//     _loadCartItems();
//   }

//   Future<void> _clearCart() async {
//     await _cartHelper.clearCart();
//     _loadCartItems();
//   }

//   Future<void> _showAddItemDialog() async {
//     TextEditingController nameController = TextEditingController();
//     TextEditingController quantityController = TextEditingController();
//     TextEditingController priceController = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Tambah Produk ke Keranjang"),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Nama Produk"),
//               ),
//               TextField(
//                 controller: quantityController,
//                 decoration: const InputDecoration(labelText: "Jumlah"),
//                 keyboardType: TextInputType.number,
//               ),
//               TextField(
//                 controller: priceController,
//                 decoration: const InputDecoration(labelText: "Harga"),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Batal"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (nameController.text.isNotEmpty &&
//                     quantityController.text.isNotEmpty &&
//                     priceController.text.isNotEmpty) {
//                   // Ambil nilai dari input
//                   String name = nameController.text;
//                   int quantity = int.tryParse(quantityController.text) ?? 1;
//                   int price = int.tryParse(priceController.text) ?? 0;

//                   // Simpan ke database
//                   Map<String, dynamic> newItem = {
//                     'id': DateTime.now().millisecondsSinceEpoch,
//                     'name': name,
//                     'quantity': quantity,
//                     'price': price,
//                   };
//                   await _cartHelper.insertCartItem(newItem);
//                   _loadCartItems();

//                   Navigator.pop(context); // Tutup dialog
//                 }
//               },
//               child: const Text("Tambah"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Cart"),
//         backgroundColor: Colors.white,
//         actions: [
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.delete_forever),
//                   onPressed: _clearCart,
//                 ),
//                 GestureDetector(
//                   onTap: _showAddItemDialog,
//                   child: Icon(Bootstrap.plus_circle),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//       body: cartItems.isEmpty
//           ? const Center(child: Text("Keranjang Kosong"))
//           : ListView.builder(
//               itemCount: cartItems.length,
//               itemBuilder: (context, index) {
//                 final item = cartItems[index];
//                 return Dismissible(
//                   key: Key(item['id'].toString()),
//                   direction: DismissDirection.endToStart,
//                   background: Container(
//                     color: Colors.red,
//                     alignment: Alignment.centerRight,
//                     padding: const EdgeInsets.only(right: 20.0),
//                     child: const Icon(Icons.delete, color: Colors.white),
//                   ),
//                   onDismissed: (direction) {
//                     _removeItem(item['id']);
//                   },
//                   child: 
//                 );
//               },
//             ),
//       bottomNavigationBar: const CustomNavigationBar(selectedIndex: 1),
//     );
//   }
// }
