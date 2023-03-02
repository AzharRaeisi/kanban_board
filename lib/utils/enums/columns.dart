import 'package:flutter/material.dart';
import 'package:kanban_board/generated/l10n.dart';

enum Columns{
  ideas,
  inProgress,
  done

}

String columnName(Columns column){
  switch (column) {
    case Columns.inProgress :
      return 'In Progress';
    case Columns.done :
      return 'Done';
    default:
    return 'Ideas';
  }
}

String columnNameLocalized(BuildContext context, Columns column){
  switch (column) {
    case Columns.inProgress :
      return S.of(context).inProgress;
    case Columns.done :
      return S.of(context).done;
    default:
    return S.of(context).ideas;
  }
}