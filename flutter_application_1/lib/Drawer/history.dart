import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
	const HistoryPage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: const Text('History'),
				backgroundColor: Colors.deepPurple[300],
			),
			body: const Center(
				child: Text('History Page'),
			),
		);
	}
}
