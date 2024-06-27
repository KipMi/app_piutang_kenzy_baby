import 'package:app_piutang_kenzy_baby/customer/screens/create_customer.dart';
import 'package:app_piutang_kenzy_baby/customer/screens/customer_detail.dart';
import 'package:app_piutang_kenzy_baby/customer/screens/customer_home.dart';
import 'package:app_piutang_kenzy_baby/customer/screens/customer_table.dart';
import 'package:app_piutang_kenzy_baby/customer/screens/edit_customer.dart';
import 'package:app_piutang_kenzy_baby/customer_category/screens/create_customer_category.dart';
import 'package:app_piutang_kenzy_baby/customer_category/screens/customer_category_detail.dart';
import 'package:app_piutang_kenzy_baby/customer_category/screens/customer_category_home.dart';
import 'package:app_piutang_kenzy_baby/customer_category/screens/customer_category_view.dart';
import 'package:app_piutang_kenzy_baby/expedition/screens/create_expedition.dart';
import 'package:app_piutang_kenzy_baby/expedition/screens/expedition_home.dart';
import 'package:app_piutang_kenzy_baby/expedition/screens/expedition_table.dart';
import 'package:app_piutang_kenzy_baby/firebase_options.dart';
import 'package:app_piutang_kenzy_baby/item/screens/create_item.dart';
import 'package:app_piutang_kenzy_baby/item/screens/edit_item.dart';
import 'package:app_piutang_kenzy_baby/item/screens/item_detail.dart';
import 'package:app_piutang_kenzy_baby/item/screens/item_home.dart';
import 'package:app_piutang_kenzy_baby/item/screens/item_table.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/screens/create_purchase_order.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/screens/purchase_order_add_item.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/screens/purchase_order_detail.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/screens/purchase_order_home.dart';
import 'package:app_piutang_kenzy_baby/purchase_order/screens/purchase_order_view.dart';
import 'package:app_piutang_kenzy_baby/role/screens/create_role.dart';
import 'package:app_piutang_kenzy_baby/role/screens/role_detail.dart';
import 'package:app_piutang_kenzy_baby/role/screens/role_home.dart';
import 'package:app_piutang_kenzy_baby/role/screens/role_table.dart';
import 'package:app_piutang_kenzy_baby/screens/view/home.dart';
import 'package:app_piutang_kenzy_baby/screens/view/login.dart';
import 'package:app_piutang_kenzy_baby/user/screens/create_user.dart';
import 'package:app_piutang_kenzy_baby/user/screens/user_detail.dart';
import 'package:app_piutang_kenzy_baby/user/screens/user_home.dart';
import 'package:app_piutang_kenzy_baby/user/screens/user_table.dart';
import 'package:app_piutang_kenzy_baby/utils/screen_size.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// import 'screens/view/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: MyApp()));
}

final GoRouter _router = GoRouter(initialLocation: '/login', routes: [
  GoRoute(
    path: '/',
    name: 'home',
    builder: (context, state) => const Home(),
    routes: [
      GoRoute(
        path: 'user-home',
        name: 'user-home',
        builder: (context, state) => const UserHomePage(),
        routes: [
          GoRoute(
            path: 'create-user',
            name: 'create-user',
            builder: (context, state) => const CreateUserPage(),
          ),
          GoRoute(
            path: 'user-table',
            name: 'user-table',
            builder: (context, state) => const UserTablePage(),
            routes: [
              GoRoute(
                path: 'user-detail/:id',
                name: 'user-detail',
                builder: (context, state) => UserDetailPage(
                  id: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: 'customer-home',
        name: 'customer-home',
        builder: (context, state) => const CustomerHome(),
        routes: [
          GoRoute(
            path: 'create-customer',
            name: 'create-customer',
            builder: (context, state) => const CreateCustomerPage(),
          ),
          GoRoute(
              path: 'customer-table',
              name: 'customer-table',
              builder: (context, state) => const CustomerTablePage(),
              routes: [
                GoRoute(
                    path: 'customer-detail/:id',
                    name: 'customer-detail',
                    builder: (context, state) => CustomerDetailPage(
                          id: state.pathParameters['id'],
                        ),
                    routes: [
                      GoRoute(
                        path: 'customer-edit/:customerId',
                        name: 'customer-edit',
                        builder: (context, state) => EditCustomerPage(
                          customerId: state.pathParameters['customerId'],
                        ),
                      ),
                    ]),
              ]),
        ],
      ),
      GoRoute(
        path: 'customer-category-home',
        name: 'customer-category-home',
        builder: (context, state) => const CustomerCategoryHomePage(),
        routes: [
          GoRoute(
            path: 'create-customer-category',
            name: 'create-customer-category',
            builder: (context, state) => const CreateCustomerCategoryPage(),
          ),
          GoRoute(
            path: 'customer-category-table',
            name: 'customer-category-table',
            builder: (context, state) => const CustomerCategoryTablePage(),
            routes: [
              GoRoute(
                path: 'customer-category-view/:id',
                name: 'customer-category-view',
                builder: (context, state) => CustomerCategoryDetailPage(
                  id: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: 'expedition-home',
        name: 'expedition-home',
        builder: (context, state) => const ExpeditionHomePage(),
        routes: [
          GoRoute(
            path: 'create-expedition',
            name: 'create-expedition',
            builder: (context, state) => const CreateExpeditionPage(),
          ),
          GoRoute(
            path: 'expedition-table',
            name: 'expedition-table',
            builder: (context, state) => const ExpeditionTablePage(),
          ),
        ],
      ),
      GoRoute(
        path: 'role-home',
        name: 'role-home',
        builder: (context, state) => const RoleHomePage(),
        routes: [
          GoRoute(
            path: 'create-role',
            name: 'create-role',
            builder: (context, state) => const CreateRolePage(),
          ),
          GoRoute(
            path: 'role-table',
            name: 'role-table',
            builder: (context, state) => const RoleTablePage(),
            routes: [
              GoRoute(
                path: 'role-detail/:id',
                name: 'role-detail',
                builder: (context, state) => RoleDetailPage(
                  id: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: 'item-home',
        name: 'item-home',
        builder: (context, state) => const ItemHomePage(),
        routes: [
          GoRoute(
              path: 'item-table',
              name: 'item-table',
              builder: (context, state) => const ItemTablePage(),
              routes: [
                GoRoute(
                    path: 'item-detail/:id',
                    name: 'item-detail',
                    builder: (context, state) => ItemDetailPage(
                          id: state.pathParameters['id'],
                        ),
                    routes: [
                      GoRoute(
                        path: 'item-edit/:itemId',
                        name: 'item-edit',
                        builder: (context, state) => EditItemPage(
                          itemId: state.pathParameters['itemId'],
                        ),
                      ),
                    ])
              ]),
          GoRoute(
            path: 'create-item',
            name: 'create-item',
            builder: (context, state) => const CreateItemPage(),
          ),
        ],
      ),
      GoRoute(
        path: 'purchase-order-home',
        name: 'purchase-order-home',
        builder: (context, state) => const PurchaseOrderHome(),
        routes: [
          GoRoute(
            path: 'create-purchase-order',
            name: 'create-purchase-order',
            builder: (context, state) => CreatePurchaseOrderPage(),
            routes: [
              GoRoute(
                path: 'add-item',
                name: 'add-item',
                builder: (context, state) => const AddItemPage(),
              ),
            ],
          ),
          GoRoute(
            path: 'purchase-order-view',
            name: 'purchase-order-view',
            builder: (context, state) => PurchaseOrderViewPage(),
            routes: [
              GoRoute(
                path: 'purchase-order-detail/:id',
                name: 'purchase-order-detail',
                builder: (context, state) => PurchaseOrderDetail(
                  id: state.pathParameters['id'],
                ),
              ),
            ],
          )
        ],
      ),
    ],
  ),
  GoRoute(
    path: '/login',
    name: 'login',
    builder: (context, state) => const LoginPage(),
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);
    return MaterialApp.router(
      title: 'Aplikasi Piutang',
      routerConfig: _router,
    );
  }
}
