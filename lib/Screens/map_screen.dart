import 'dart:typed_data';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({Key key}) : super(key: key);

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
              DataCell(Text('Map')),
              DataCell(Text('MAPAAAAA')),
            ],
          ),
        ],
      ),
    );
  }
}
