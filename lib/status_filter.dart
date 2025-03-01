import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'characters_view_model.dart';

class StatusFilter extends StatelessWidget {

  const StatusFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CharactersViewModel>(
        builder: (BuildContext context,viewModel, Widget? child) {
      return SizedBox(
        height: 100,
        width: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: Status.values.length,
            itemBuilder: (BuildContext context, int index) {
              final status = Status.values[index];
              return InkWell(
                  child: FilterChip(
                label: Text(status.name),
                selected: viewModel.statusFilterList.contains(status),
                onSelected: (bool selected) {
                  viewModel.setStatusFilter(selected, status);
                },
              ));
            }),
      );
    });
  }
}
