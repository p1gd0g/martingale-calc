import 'package:flutter/material.dart';
import 'package:myapp/main.dart';
import 'package:myapp/theme.dart';

Widget buildResultsTable(List<MartingaleLevel> levels) {
  return Container(
    decoration: AppTheme.cardDecoration,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: AppTheme.cardPadding,
          child: Text(
            'Martingale Levels Detail',
            style: AppTheme.cardTitleStyle,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: AppTheme.tableHeaderRowColor,
            dataRowColor: AppTheme.tableDataRowColor,
            dividerThickness: AppTheme.tableDividerThickness,
            headingTextStyle: AppTheme.tableHeaderStyle,
            dataTextStyle: AppTheme.tableDataStyle,
            columnSpacing: AppTheme.tableColumnSpacing,
            columns: const [
              DataColumn(label: Text('Level')),
              DataColumn(label: Text('Entry Price')),
              DataColumn(label: Text('Exit Price')),
              DataColumn(label: Text('Position Size')),
              DataColumn(label: Text('Total Position')),
              DataColumn(label: Text('Avg Entry')),
              // DataColumn(label: Text('Avg Entry')),
              // DataColumn(label: Text('Avg Entry')),
              // DataColumn(label: Text('Avg Entry')),
            ],
            rows: levels.map((level) {
              return DataRow(
                cells: [
                  DataCell(Text(level.level.toString())),
                  DataCell(Text(level.entryPrice.toStringAsFixed(2))),
                  DataCell(Text(level.exitPrice.toStringAsFixed(2))),
                  DataCell(Text(level.positionSize.toStringAsFixed(6))),
                  DataCell(Text(level.totalPositionSize.toStringAsFixed(6))),
                  DataCell(Text(level.averageEntryPrice.toStringAsFixed(2))),
                  // DataCell(Text(level.averageEntryPrice.toStringAsFixed(2))),
                  // DataCell(Text(level.averageEntryPrice.toStringAsFixed(2))),
                  // DataCell(Text(level.averageEntryPrice.toStringAsFixed(2))),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}
