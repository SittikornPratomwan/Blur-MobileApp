import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
	const AddPage({Key? key}) : super(key: key);

	@override
	State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
	final _formKey = GlobalKey<FormState>();
	final _titleCtrl = TextEditingController();
	final _descCtrl = TextEditingController();
	String _category = 'ไฟฟ้า';

	@override
	void dispose() {
		_titleCtrl.dispose();
		_descCtrl.dispose();
		super.dispose();
	}

	void _submit() {
		if (_formKey.currentState?.validate() ?? false) {
			// For now just show a snackbar — real POST can be implemented later
			ScaffoldMessenger.of(context).showSnackBar(
				SnackBar(content: Text('โพสต์เรียบร้อย: ${_titleCtrl.text}')),
			);
			Navigator.of(context).pop();
		}
	}

		@override
		Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.white,
			appBar: AppBar(
				title: const Text('แจ้งซ่อม'),
				centerTitle: true,
				backgroundColor: Colors.deepPurple[300],
				foregroundColor: Colors.white,
			),
			body: Padding(
				padding: const EdgeInsets.all(16.0),
				child: Form(
					key: _formKey,
					child: Column(
						crossAxisAlignment: CrossAxisAlignment.stretch,
						children: [
							TextFormField(
								controller: _titleCtrl,
								decoration: const InputDecoration(labelText: 'หัวข้อ'),
								validator: (v) => (v == null || v.isEmpty) ? 'กรุณากรอกหัวข้อ' : null,
							),
							const SizedBox(height: 12),
							DropdownButtonFormField<String>(
								value: _category,
								items: const [
									DropdownMenuItem(value: 'ไฟฟ้า', child: Text('ไฟฟ้า')),
									DropdownMenuItem(value: 'ประปา', child: Text('ประปา')),
									DropdownMenuItem(value: 'แอร์', child: Text('แอร์')),
								],
								onChanged: (v) {
									if (v != null) setState(() => _category = v);
								},
								decoration: const InputDecoration(labelText: 'หมวดหมู่'),
							),
							const SizedBox(height: 12),
							Expanded(
								child: TextFormField(
									controller: _descCtrl,
									decoration: const InputDecoration(labelText: 'รายละเอียด'),
									maxLines: null,
									expands: true,
									validator: (v) => (v == null || v.isEmpty) ? 'กรุณากรอกรายละเอียด' : null,
								),
							),
							const SizedBox(height: 12),
							ElevatedButton(
								onPressed: _submit,
								child: const Text('ส่งคำขอ'),
								style: ElevatedButton.styleFrom(
									backgroundColor: Colors.green,
									foregroundColor: Colors.white,
								),
							),
						],
					),
				),
			),
		);
	}
}
