import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../model/categorygoodslistmodel.dart';
import '../provide/category_goods_list.dart';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
          appBar: AppBar(
            title: Text("商品分类",style:TextStyle(fontSize: ScreenUtil().setSp(40))),
          ),
          body: Row(
            children: <Widget>[
              LeftCategoryNav(),
              Column(
                children: <Widget>[
                  RightCategoryNav(),
                  CategoryGoodsList()
                ],
              )
              
            ],
          ),
        )
    );
  }

  
}

class LeftCategoryNav extends StatefulWidget {
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list=[];
  var listIndex = 0; //索引
  @override
  void initState() {
    _getCategory();
    _getGoodsList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color:Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount:list.length,
        itemBuilder: (context,index){
          return _leftInkWel(index);
        },
      ),

    );
  }

  Widget _leftInkWel(int index){
    bool isClick=false;
    isClick=(index==listIndex)?true:false;

    return InkWell(
      onTap: (){
        setState(() {
           listIndex=index;
         });
         var childList = list[index].bxMallSubDto;
         var categoryId= list[index].mallCategoryId;
         Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);
        _getGoodsList(categoryId:categoryId );
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding:EdgeInsets.only(left:10,top:14),
        decoration: BoxDecoration(
          color: isClick?Colors.pink:Colors.white,
          border:Border(
            bottom:BorderSide(width: 1,color:Colors.black12)
          )
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(
            fontSize:ScreenUtil().setSp(28),
            color:isClick?Colors.white:Colors.black,
          ),
        ),
      ),
    );
}

  void _getCategory()async{
    await request('getCategory').then((val){
          var data = json.decode(val.toString());
          CategoryModel category = CategoryModel.fromJson(data);
          setState(() {
            list =category.data;
          });
          Provide.value<ChildCategory>(context).getChildCategory( list[0].bxMallSubDto,list[0].mallCategoryId);
    });
  }

  void _getGoodsList({String categoryId}) {
    var data = {
      'categoryId': categoryId== null?'4':categoryId,
      'categorysubId':'',
      'page':1
    };

    request("getMallGoods",formData: data).then((val){
      var data = json.decode(val.toString());
      
      CategoryGoodsListModel goodsList=  CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }
}

class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  //List list = ["全部","名酒","茅台","五粮液","剑南春","泸州老窖","江口醇","古酒"];
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context,child,childCategory){
        return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1,color: Colors.black12)
              )
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: childCategory.childCategoryList.length,
              itemBuilder: (BuildContext context, int index) {
                return _rightInkWell(index,childCategory.childCategoryList[index]);
              },
            ),
          );
      },
    ); 
  }

  Widget _rightInkWell(int index,BxMallSubDto item){
    bool isCheck = false;
    isCheck = (index==Provide.value<ChildCategory>(context).childIndex)?true:false;

    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);
        _getGoodssList(item.mallSubId);
      },
      child: Container(
        padding:EdgeInsets.fromLTRB(5.0,10.0,5.0,10.0),
        child: Text(
          item.mallSubName,
          style:TextStyle(
            fontSize:ScreenUtil().setSp(28),
            color:isCheck? Colors.pink: Colors.black ,
          ),
        ),
      )
    );
  }

  void _getGoodssList(String categorySubId) async{
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':categorySubId,
      'page':1
    };

    await request("getMallGoods",formData: data).then((val){
      var data = json.decode(val.toString());
      //print(data);
      
      CategoryGoodsListModel goodsList=  CategoryGoodsListModel.fromJson(data);
      if(goodsList.data==null){
         Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      }else{
        //print(goodsList.data);
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }

    });
  }

}

class CategoryGoodsList extends StatefulWidget {
  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  
  Widget build(BuildContext context) {
    
    return Provide<CategoryGoodsListProvide>(
      builder: (context,child,data){
        if(data.goodsList.length>0){
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570) ,
              //height: ScreenUtil().setHeight(1100),
              child:ListView.builder(
                itemCount: data.goodsList.length,
                itemBuilder: (context,index){
                  return _goodslistItem(data.goodsList,index);//教程里为：_ListWidget
                },
              ) ,
            ),
          );
        } else {
          return Text("暂时没有数据。");
        }

      },
    );

  }

  Widget _goodsImage(List newList,int index){
    return Container(
      //padding: EdgeInsets.all(2),
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodsTitle(List newList,int index){
    return Container(
      padding: EdgeInsets.all(5),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(List newList,int index){
    return Container(
      margin: EdgeInsets.only(top: 20),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格：￥${newList[index].presentPrice}',
            style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '${newList[index].oriPrice}',
            style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  Widget _goodslistItem(List newList,int index){
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0,color: Colors.black12) 
        )
      ),
      child: Row(
        children: <Widget>[
          _goodsImage(newList,index),
          Column(
            children: <Widget>[
              _goodsTitle(newList,index),
              _goodsPrice(newList,index)
            ],
          )
        ],
      ),
    );
  }
}
