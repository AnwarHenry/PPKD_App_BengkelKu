import 'package:aplikasi_bengkel_motor/API/auth_API.dart';
import 'package:aplikasi_bengkel_motor/model/service_model.dart';
import 'package:aplikasi_bengkel_motor/widgets/loading_indicator.dart';
import 'package:flutter/material.dart';

class ManageServicesPage extends StatefulWidget {
  const ManageServicesPage({super.key});
  static const id = "/manage_service";

  @override
  State<ManageServicesPage> createState() => _ManageServicesPageState();
}

class _ManageServicesPageState extends State<ManageServicesPage> {
  List<ServiceModel> _services = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    try {
      final response = await BengkelAPI.getAllServices();
      if (response.success) {
        setState(() {
          _services = response.data!;
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading services: $e'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showAddServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AddServiceDialog(onServiceAdded: _loadServices),
    );
  }

  void _showEditServiceDialog(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) =>
          AddServiceDialog(service: service, onServiceAdded: _loadServices),
    );
  }

  Future<void> _deleteService(int serviceId) async {
    try {
      final response = await BengkelAPI.deleteServis(serviceId);
      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _loadServices();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting service: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddServiceDialog,
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingIndicator()
          : _services.isEmpty
          ? const Center(child: Text('No services found'))
          : ListView.builder(
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
                return ListTile(
                  leading: const Icon(Icons.build, color: Colors.blue),
                  title: Text(service.name),
                  subtitle: Text(service.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${service.price.toStringAsFixed(2)}'),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showEditServiceDialog(service),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteService(service.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

class AddServiceDialog extends StatefulWidget {
  final ServiceModel? service;
  final VoidCallback onServiceAdded;

  const AddServiceDialog({
    super.key,
    this.service,
    required this.onServiceAdded,
  });

  @override
  State<AddServiceDialog> createState() => _AddServiceDialogState();
}

class _AddServiceDialogState extends State<AddServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.service != null) {
      _nameController.text = widget.service!.name;
      _descriptionController.text = widget.service!.description;
      _priceController.text = widget.service!.price.toString();
      _durationController.text = widget.service!.durationMinutes.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.service == null) {
        final response = await BengkelAPI.createServis(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          durationMinutes: int.parse(_durationController.text),
        );

        if (response.success) {
          Navigator.pop(context);
          widget.onServiceAdded();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service created successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final response = await BengkelAPI.updateServis(
          serviceId: widget.service!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          durationMinutes: int.parse(_durationController.text),
        );

        if (response.success) {
          Navigator.pop(context);
          widget.onServiceAdded();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Service updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving service: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.service == null ? 'Add Service' : 'Edit Service'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Service Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter service name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter valid price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(
                  labelText: 'Duration (minutes)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter valid duration';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _saveService,
          child: _isLoading
              ? const CircularProgressIndicator()
              : Text(widget.service == null ? 'Add' : 'Update'),
        ),
      ],
    );
  }
}
