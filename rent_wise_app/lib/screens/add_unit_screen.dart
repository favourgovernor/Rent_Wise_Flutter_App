import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddUnitScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onUnitAdded; // ← add this

  const AddUnitScreen({super.key, required this.onUnitAdded}); // ← add this

  @override
  State<AddUnitScreen> createState() => _AddUnitScreenState();
}

class _AddUnitScreenState extends State<AddUnitScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _blockController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _maintenanceController = TextEditingController();

  String _selectedStatus = 'Vacancy';

  @override
  void dispose() {
    _blockController.dispose();
    _floorController.dispose();
    _nameController.dispose();
    _rentController.dispose();
    _maintenanceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final newUnit = {
        'block': _blockController.text.trim(),
        'floor': _floorController.text.trim(),
        'status': _selectedStatus,
        'name': _nameController.text.trim().isEmpty
            ? 'N/A'
            : _nameController.text.trim(),
        'rent': _rentController.text.trim(),
        'maintenance': _maintenanceController.text.trim(),
      };

      widget.onUnitAdded(newUnit); // ← fires callback to UnitsScreen
      Navigator.pop(context); // ← goes back to grid
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Add Unit',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Block Name (e.g. B8)'),
              _buildTextField(
                controller: _blockController,
                hint: 'e.g. B8',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Block name is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Floor & Type (e.g. 2nd Floor, 1BR)'),
              _buildTextField(
                controller: _floorController,
                hint: 'e.g. 2nd Floor, 1BR',
                validator: (v) =>
                    v == null || v.isEmpty ? 'Floor info is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Status'),
              _buildStatusDropdown(),
              const SizedBox(height: 16),
              _buildLabel('Tenant Name (leave blank if vacant)'),
              _buildTextField(
                controller: _nameController,
                hint: 'e.g. John Doe',
              ),
              const SizedBox(height: 16),
              _buildLabel('Rent Amount'),
              _buildTextField(
                controller: _rentController,
                hint: 'e.g. 20000/-',
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Rent amount is required' : null,
              ),
              const SizedBox(height: 16),
              _buildLabel('Maintenance Requests'),
              _buildTextField(
                controller: _maintenanceController,
                hint: 'e.g. #tiles,#shower,#sink',
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3DBE6E),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Add Unit',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3DBE6E), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          isExpanded: true,
          style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
          items: ['Vacancy', 'Occupied'].map((status) {
            return DropdownMenuItem(
              value: status,
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: status == 'Occupied'
                          ? const Color(0xFF3DBE6E)
                          : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(status),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() => _selectedStatus = value!);
          },
        ),
      ),
    );
  }
}
