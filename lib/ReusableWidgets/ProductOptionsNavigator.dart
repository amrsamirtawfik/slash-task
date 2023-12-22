import 'package:flutter/material.dart';
import 'package:slash_task/Bloc/DataStructures.dart';
import 'package:slash_task/Bloc/ProductsBloc.dart';

class ProductsOptionsNavigator extends StatefulWidget {
  final NavigationObject navigationObject;
  String currentVariationId;
  final String product_id;

  ProductsOptionsNavigator(
      {super.key,
      required this.navigationObject,
      required this.currentVariationId,
      required this.product_id});

  @override
  _ProductsOptionsNavigatorState createState() =>
      _ProductsOptionsNavigatorState();
}

class _ProductsOptionsNavigatorState extends State<ProductsOptionsNavigator> {
  late List<dynamic> options;
  late Map<String, String> selectedValues;

  @override
  initState() {
    options = (widget.navigationObject.availableProps);
    selectedValues = widget.navigationObject.selectedOptions;
   // print('opppp: $options');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((property) {
        String propertyName = property['property'];
        List<dynamic> propertyValues = property['values'];
        List<String> uniqueValues = [];
        for (var propertyValue in propertyValues) {
          if (!uniqueValues
              .contains(capitalizeFirstLetter(propertyValue['value']))) {
            uniqueValues.add(capitalizeFirstLetter(propertyValue['value']));
          }
        }
      //  print('unique: $uniqueValues');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Choose $propertyName:',
                style: TextStyle(fontFamily: 'Cairo-Bold', fontSize: 20)),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: uniqueValues.map((value) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedValues[property['property'] as String] =
                          value;
                      ProductsBloc.get(context).searchVariation(
                          widget.currentVariationId,
                          selectedValues,
                          widget.product_id);
                      //print(selectedValues);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return selectedValues[property['property'] as String] ==
                                value
                            ? Colors.blue // Highlighted color
                            : null;
                      },
                    ),
                  ),
                  child: Text(
                    capitalizeFirstLetter(value),
                    style: TextStyle(fontFamily: 'Cairo-medium', fontSize: 16),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }
}
