import 'dart:typed_data';
import 'package:flutter/material.dart';

class Cat10Table extends StatelessWidget {
  const Cat10Table({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DataTable(
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Name',
            ),
          ),
          DataColumn(
            label: Text(
              'Age',
            ),
          ),
        ],
        rows: const <DataRow>[
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Cat10')),
              DataCell(Text('23')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Cat10')),
              DataCell(Text('24')),
            ],
          ),
        ],
      ),
    );
  }
}
