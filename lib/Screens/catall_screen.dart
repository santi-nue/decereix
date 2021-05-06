import 'dart:typed_data';
import 'package:decereix/Provider/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CatAllTable extends StatelessWidget {
  const CatAllTable({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CatProvider _catProvider = Provider.of<CatProvider>(context, listen: false);
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
              DataCell(Text('Catall')),
              DataCell(Text('23')),
            ],
          ),
          DataRow(
            cells: <DataCell>[
              DataCell(Text('Catall')),
              DataCell(Text('24')),
            ],
          ),
        ],
      ),
    );
  }
}
