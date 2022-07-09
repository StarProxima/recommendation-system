import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:recommendation_system/data/app_styles.dart';
import 'package:recommendation_system/data/product_model.dart';
import 'package:recommendation_system/ui/widgets/product_card.dart';
import 'package:http/http.dart' as http;

class ProductPage extends StatefulWidget {
  const ProductPage({Key? key, required this.product}) : super(key: key);
  final Product product;
  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int amount = 0;

  late List<Product> similarProducts = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadSimilarProducts();
  }

  Future<void> loadSimilarProducts() async {
    var url = Uri(scheme: "http", host: "127.0.0.1", path: "/similar", port: 5000, queryParameters: {
      "product": "${widget.product.name};${widget.product.price.toInt().toString()};${widget.product.merchant}"
    });
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as List<dynamic>;

      setState(() {
        similarProducts.clear();
        for (var product in jsonResponse) {
          similarProducts.add(Product.fromJson(product));
        }
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: Colors.red,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width,
              height: width,
              color: Colors.white,
              padding: const EdgeInsets.all(36),
              child: const Image(
                image: AppImages.cart,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    widget.product.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    widget.product.merchant,
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: amount == 0 ? AppColors.headlineText : null,
                  ),
                  height: 48,
                  width: double.infinity,
                  child: amount == 0
                      ? TextButton(
                          onPressed: () {
                            setState(() {
                              amount = 1;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            primary: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.product.price.toInt()}₽  •  Купить',
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${widget.product.price.toInt() * amount}₽",
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                                Text(
                                  '${widget.product.price.toInt()}₽ x $amount шт',
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      amount--;
                                    });
                                  },
                                  backgroundColor: AppColors.headlineText,
                                  heroTag: null,
                                  child: const Icon(Icons.remove),
                                ),
                                SizedBox(
                                  width: 70,
                                  child: Center(
                                    child: Text(
                                      '$amount шт',
                                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                                            fontSize: 16,
                                          ),
                                    ),
                                  ),
                                ),
                                FloatingActionButton(
                                  onPressed: () {
                                    setState(() {
                                      amount++;
                                    });
                                  },
                                  backgroundColor: AppColors.headlineText,
                                  heroTag: null,
                                  child: const Icon(Icons.add),
                                ),
                              ],
                            )
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Похожие товары: ',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                itemCount: similarProducts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: similarProducts[index],
                    width: 130,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 16,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Покупают вместе: ',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(
              height: 280,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                scrollDirection: Axis.horizontal,
                itemCount: similarProducts.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: similarProducts[index],
                    width: 130,
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 16,
                  );
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: null,
    );
  }
}
