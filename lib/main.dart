import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
//测试
void main(){
  var providers =Providers();
  
  var counter =Counter(); 
  var childCategory = ChildCategory();
  var categoryGoodsListProvide= CategoryGoodsListProvide();

  providers
   ..provide(Provider<Counter>.value(counter))
   ..provide(Provider<ChildCategory>.value(childCategory))
   ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide));
   
  runApp(ProviderNode(child: MyApp(),providers: providers,));
} 

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title: 'futter shop',
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}