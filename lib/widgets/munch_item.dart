import 'package:flutter/material.dart';
import 'package:tumaz_kitchen/models/munch.dart';
import 'package:tumaz_kitchen/widgets/munch_item_attribute.dart';

class MunchItem extends StatelessWidget {
  const MunchItem({
    Key? key,
    required this.munch,
    required this.onSelectMunch,
  }) : super(key: key);

  final MunchiesModel munch;
  final void Function(BuildContext context, MunchiesModel munch) onSelectMunch;

  String get complexityText {
    return munch.complexity.toString().split('.').last;
  }

  String get affordabilityText {
    return munch.affordability.toString().split('.').last;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMunch(context, munch);
        },
        child: Stack(
          children: [
            Hero(
              tag: munch.id,
              child: Image.asset(
                munch.imagePath, 
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 6,
                  horizontal: 44,
                ),
                child: Column(
                  children: [
                    Text(
                      munch.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MunchItemAttribute(
                          icon: Icons.schedule,
                          label: '${munch.duration} min',
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        MunchItemAttribute(
                          icon: Icons.work,
                          label: complexityText,
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        MunchItemAttribute(
                          icon: Icons.attach_money,
                          label: affordabilityText,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
