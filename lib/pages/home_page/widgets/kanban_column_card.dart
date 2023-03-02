import 'package:flutter/material.dart';

class KanbanColumnCard extends StatelessWidget {
  const KanbanColumnCard({ Key? key,  this.child }) : super(key: key);
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black12,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: child,
    );
  }
}