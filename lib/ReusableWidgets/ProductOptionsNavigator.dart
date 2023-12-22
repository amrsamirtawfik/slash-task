import 'package:flutter/material.dart';
import 'package:slash_task/Bloc/DataStructures.dart';

class ProductsOptionsNavigator extends StatefulWidget {
  final NavigationObject navigationObject;

  ProductsOptionsNavigator({required this.navigationObject});

  @override
  _ProductsOptionsNavigatorState createState() =>
      _ProductsOptionsNavigatorState();
}

class _ProductsOptionsNavigatorState extends State<ProductsOptionsNavigator> {
  late List<Map<String,dynamic>> options;
  late Map<String, String> selectedValues;
  @override

  initState() {
    options=widget.navigationObject.availableProps;
    selectedValues=widget.navigationObject.selectedOptions;
    print("initState Called");

    print('Selected values: $selectedValues\nOptions: $options');
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: options.map((property) {
        String propertyName = property['property'];
        List<Map<String, dynamic>> propertyValues = property['values'];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose $propertyName:',
                style: TextStyle(fontFamily: 'Cairo-Bold', fontSize: 20)),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: propertyValues.map((value) {
                int index = propertyValues.indexOf(value);

                return ElevatedButton(
                  onPressed: () {

                    setState(() {
                      selectedValues[property['property'] as String] =
                      value['value'] as String;
                      print(selectedValues);
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                        return selectedValues[property['property'] as String] ==
                            value['value']
                            ? Colors.blue // Highlighted color
                            : null;
                      },
                    ),
                  ),
                  child: Text(
                    value['value'],
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
