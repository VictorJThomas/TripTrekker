import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.network(
              'https://thedebuggers.com/wp-content/uploads/2017/10/add-multiple-custom-markers-legend-gmap.png',
              width: 400,
              height: 400,
            ),
          ),
        ],
      ),
    );
  }
}
