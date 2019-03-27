import 'package:flutter/material.dart';
import '../model/categorygoodslistmodel.dart';

//ChangeNotifier的混入是不用管理听众
class CategoryGoodsListProvide with ChangeNotifier{
    List<CategoryGoodsListData> goodsList  = [];

    //点击大类时更换商品列表
    getGoodsList(List<CategoryGoodsListData> list){
      goodsList=list;   
      notifyListeners();
    }
    
}