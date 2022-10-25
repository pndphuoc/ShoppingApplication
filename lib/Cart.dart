library cart;

import 'model/CartItem.dart';
import 'model/ProductModel.dart';

List<CartItem> list = [];
double total = getTotal();

void add(ProductModel e, int Quantity)
{
  CartItem item = CartItem(model: e, Quantity: Quantity);
  if(list.isEmpty)
    list.add(item);
  else
    {
      bool isExists = false;
      for (int i = 0; i < list.length; i++) {
        if (list[i].model.id == e.id) {
          list[i].Quantity += Quantity;
          isExists = true;
        }
      }
      if (!isExists) {
        list.add(item);
      }
    }
}

void remove(CartItem e)
{
  list.remove(e);
}

double getTotal()
{
  double total = 0;
  for (int i=0; i<list.length; i++)
    {
      total += list[i].Quantity * list[i].model.price;
    }
  return total;
}