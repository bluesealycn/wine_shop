import 'package:flutter/material.dart';
import '../model/category.dart';

//ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier{
    List<BxMallSubDto> childCategoryList = [];
    int childIndex = 0;       //小类高亮 索引
    String categoryId = '4';  //4--白酒类
    String subId =''; //小类ID 

    //点击大类时更换
    getChildCategory(List<BxMallSubDto> list, String id){
      categoryId = id;
      childIndex = 0;
      BxMallSubDto all=  BxMallSubDto();
      all.mallSubId='00';
      all.mallCategoryId='00';
      all.mallSubName = '全部';
      all.comments = 'null';
      childCategoryList=[all];
      childCategoryList.addAll(list);   
      notifyListeners();
    }

    //改变子类索引
    changeChildIndex(index,String id){
       childIndex=index;
       subId=id;
       notifyListeners();
    }
}