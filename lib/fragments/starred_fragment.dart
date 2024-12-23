import 'package:flutter/material.dart';

class StarredFragment extends StatefulWidget{
  final ThemeData theme;
  const StarredFragment(this.theme, {super.key});

  @override
  State<StarredFragment> createState() {
    // TODO: implement createState
    return _StarredFragmentState();
  }
}

class _StarredFragmentState extends State<StarredFragment>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: ListView.builder(
        reverse: true,
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Align(
              alignment: Alignment.centerRight,
              child: Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: widget.theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  'Hello',
                  style: widget.theme.textTheme.bodyLarge!
                      .copyWith(color: widget.theme.colorScheme.onPrimary),
                ),
              ),
            );
          }
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: widget.theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'Hi!',
                style: widget.theme.textTheme.bodyLarge!
                    .copyWith(color: widget.theme.colorScheme.onPrimary),
              ),
            ),
          );
        },
      ),
    );
  }
}