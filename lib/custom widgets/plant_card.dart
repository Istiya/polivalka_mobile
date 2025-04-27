import 'package:flutter/material.dart';
import 'package:polivalka/custom%20widgets/custom_image.dart';

class PlantCard extends StatefulWidget {
  PlantCard(this.name, this.image, this.onChanged,
      {super.key, required this.isChecked});

  final String name;
  final String image;
  bool isChecked;
  ValueChanged<bool?>? onChanged;

  @override
  State<PlantCard> createState() => _PlantCardState();
}

class _PlantCardState extends State<PlantCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 7,
        shape: RoundedRectangleBorder(
            side:
                BorderSide(color: Color.fromRGBO(149, 188, 143, 1.0), width: 5),
            borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: CustomNetworkImage(
                        image: widget.image, height: 120, width: 120))),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.name),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Checkbox(
                checkColor: Colors.white,
                activeColor:
                Color.fromRGBO(149, 188, 143, 1.0),
                value: widget.isChecked,
                onChanged: widget.onChanged,
              ),
            )
          ],
        ));
  }
}
