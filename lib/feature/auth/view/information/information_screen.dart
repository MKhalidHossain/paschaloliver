import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/assets.dart';
import '../work/work_schedule_screen.dart';
import 'kyc_back_flow.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  // Brand
  Color get _brandGreen => const Color(0xFF27AE60);
  Color get _bg => const Color(0xFFF5F5F5);
  Color get _borderGrey => const Color(0xFFE0E0E0);
  Color get _errorRed => const Color(0xFFE74C3C);
  Color get _textDark => const Color(0xFF333333);
  Color get _hintText => const Color(0xFF777777);

  final _picker = ImagePicker();

  // Front ID image used in back-side flow
  //    (this comes from your saved asset, matching your Figma front card)
  final ImageProvider _frontImage = const AssetImage(Images.idFront);

  // Personal details
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  String? _gender; // dropdown
  String? _dob; // you can swap to date picker
  String? _countryOfBirth;
  final _cityOfBirthCtrl = TextEditingController();

  // Documents
  String _docType = 'government_id'; // 'government_id' / 'passport'
  String? _countryOfDocument;
  final _documentNumberCtrl = TextEditingController();
  File? _documentFile;

  // Address
  final _streetCtrl = TextEditingController();
  final _streetNumberCtrl = TextEditingController();
  final _zipCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _streetRegionCtrl = TextEditingController();
  String? _countryAddress;

  bool _submitted = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _cityOfBirthCtrl.dispose();
    _documentNumberCtrl.dispose();
    _streetCtrl.dispose();
    _streetNumberCtrl.dispose();
    _zipCtrl.dispose();
    _cityCtrl.dispose();
    _streetRegionCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImportantCard(),
                    const SizedBox(height: 16),
                    _sectionTitle('Personal details'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _nameCtrl,
                      label: 'Name',
                      showError: _submitted && _nameCtrl.text.trim().isEmpty,
                    ),
                    _textField(
                      controller: _surnameCtrl,
                      label: 'Surname',
                      showError:
                      _submitted && _surnameCtrl.text.trim().isEmpty,
                    ),
                    _dropdownField<String>(
                      value: _gender,
                      label: 'Gender',
                      items: const ['Male', 'Female', 'Other'],
                      showError: _submitted && _gender == null,
                      onChanged: (v) => setState(() => _gender = v),
                    ),
                    _dropdownField<String>(
                      value: _dob,
                      label: 'Date of birth',
                      // for now simple list, swap to real date-picker in onTap if you want
                      items: const ['01/01/1990', '01/01/1995', '01/01/2000'],
                      showError: _submitted && _dob == null,
                      onChanged: (v) => setState(() => _dob = v),
                    ),
                    _dropdownField<String>(
                      value: _countryOfBirth,
                      label: 'Country of birth',
                      items: const ['Nigeria', 'Ghana', 'Kenya', 'Other'],
                      showError: _submitted && _countryOfBirth == null,
                      onChanged: (v) => setState(() => _countryOfBirth = v),
                    ),
                    _textField(
                      controller: _cityOfBirthCtrl,
                      label: 'City of birth',
                      showError: _submitted &&
                          _cityOfBirthCtrl.text.trim().isEmpty,
                    ),

                    const SizedBox(height: 18),
                    _sectionTitle('Identify Documents'),
                    const SizedBox(height: 8),
                    _buildDocTypeSelector(),
                    const SizedBox(height: 8),
                    _buildUploadButton(),

                    const SizedBox(height: 4),
                    _dropdownField<String>(
                      value: _countryOfDocument,
                      label: 'Country of the document',
                      items: const ['Nigeria', 'Ghana', 'Kenya', 'Other'],
                      showError: _submitted && _countryOfDocument == null,
                      onChanged: (v) => setState(() => _countryOfDocument = v),
                    ),
                    _textField(
                      controller: _documentNumberCtrl,
                      label: 'Document number',
                      showError: _submitted &&
                          _documentNumberCtrl.text.trim().isEmpty,
                    ),

                    const SizedBox(height: 8),
                    _dontHaveDocText(),

                    const SizedBox(height: 18),
                    _sectionTitle('Address'),
                    const SizedBox(height: 8),
                    _textField(
                      controller: _streetCtrl,
                      label: 'Street',
                      showError: _submitted && _streetCtrl.text.trim().isEmpty,
                    ),
                    _textField(
                      controller: _streetNumberCtrl,
                      label: 'Street number',
                      showError: _submitted &&
                          _streetNumberCtrl.text.trim().isEmpty,
                    ),
                    _textField(
                      controller: _zipCtrl,
                      label: 'Zip/Postal Code',
                      keyboardType: TextInputType.number,
                      showError: _submitted && _zipCtrl.text.trim().isEmpty,
                    ),
                    _textField(
                      controller: _cityCtrl,
                      label: 'City',
                      showError: _submitted && _cityCtrl.text.trim().isEmpty,
                    ),
                    _textField(
                      controller: _streetRegionCtrl,
                      label: 'Street/Country/Region',
                      showError: _submitted &&
                          _streetRegionCtrl.text.trim().isEmpty,
                    ),
                    _dropdownField<String>(
                      value: _countryAddress,
                      label: 'Country',
                      items: const ['Nigeria', 'Ghana', 'Kenya', 'Other'],
                      showError: _submitted && _countryAddress == null,
                      onChanged: (v) => setState(() => _countryAddress = v),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TOP BAR + IMPORTANT CARD
  // ---------------------------------------------------------------------------

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
          const SizedBox(width: 4),
          const Expanded(
            child: Text(
              'Information about your profile',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImportantCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Bulb from your assets
          Image.asset(
            Images.bulb,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Important',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF333333),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Check that the information is correct so that you can charge for the services correctly.',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Color(0xFF777777),
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PERSONAL/DOC/ADDRESS FIELDS
  // ---------------------------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: _brandGreen,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    bool showError = false,
  }) {
    final hasError = showError;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: hasError ? _errorRed : _hintText,
                fontSize: 13,
              ),
              filled: true,
              fillColor: _bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _borderGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? _errorRed : _borderGrey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? _errorRed : _brandGreen,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                'Please fill in the field',
                style: TextStyle(color: _errorRed, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  Widget _dropdownField<T>({
    required T? value,
    required String label,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    bool showError = false,
  }) {
    final hasError = showError;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(
                color: hasError ? _errorRed : _hintText,
                fontSize: 13,
              ),
              filled: true,
              fillColor: _bg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _borderGrey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? _errorRed : _borderGrey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: hasError ? _errorRed : _brandGreen,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 2,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<T>(
                isExpanded: true,
                value: value,
                hint: Text(
                  label,
                  style: TextStyle(color: _hintText, fontSize: 13),
                ),
                items: items
                    .map(
                      (e) => DropdownMenuItem<T>(
                    value: e,
                    child: Text(
                      e.toString(),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                'Please fill in the field',
                style: TextStyle(color: _errorRed, fontSize: 11),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocTypeSelector() {
    return Column(
      children: [
        _docTypeTile(title: 'Government ID', value: 'government_id'),
        const SizedBox(height: 6),
        _docTypeTile(title: 'Passport', value: 'passport'),
      ],
    );
  }

  Widget _docTypeTile({required String title, required String value}) {
    final selected = _docType == value;

    return GestureDetector(
      onTap: () => setState(() => _docType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: selected ? _brandGreen : _borderGrey,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off_outlined,
              color: selected ? _brandGreen : _hintText,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: selected ? _brandGreen : _textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    final hasError = _submitted && _documentFile == null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandGreen,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              // 👉 Go to back-photo flow, passing the saved front image
              Get.to(() => UploadFrontIdScreen());
            },
            icon: const Icon(Icons.upload_file, size: 18, color: Colors.white),
            label: const Text(
              'Upload documents',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        if (_documentFile != null)
          Text(
            'Document selected',
            style: TextStyle(color: _brandGreen, fontSize: 11),
          ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Upload the documents',
              style: TextStyle(color: _errorRed, fontSize: 11),
            ),
          ),
      ],
    );
  }

  Widget _dontHaveDocText() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 12, color: _hintText, height: 1.4),
          children: [
            const TextSpan(text: "Don't have any of these documents?\n"),
            TextSpan(
              text: 'Send us an email to contact@apphandynaija.com',
              style: TextStyle(
                color: _brandGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // (Optional) OLD UPLOAD SHEET – still here if you want gallery/camera picker
  // ---------------------------------------------------------------------------

  void _openUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Text(
                'Add Documents',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Upload your documents to Verified your profile',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.4, color: _hintText),
              ),
              const SizedBox(height: 20),
              _sheetButton(
                label: 'Camera',
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickDoc(ImageSource.camera);
                },
              ),
              const SizedBox(height: 8),
              _sheetButton(
                label: 'Gallery',
                onTap: () async {
                  Navigator.pop(ctx);
                  await _pickDoc(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: _brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _sheetButton({required String label, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: _borderGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _brandGreen,
          ),
        ),
      ),
    );
  }

  Future<void> _pickDoc(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source);
      if (file == null) return;

      setState(() {
        _documentFile = File(file.path);
      });
    } catch (e) {
      debugPrint('Document pick error: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // SAVE BUTTON + VALIDATION
  // ---------------------------------------------------------------------------

  Widget _buildSaveButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _brandGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          onPressed: _onSavePressed,
          child: const Text(
            'Save',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _onSavePressed() {
    setState(() => _submitted = true);

    final allValid = _validateForm();

    if (!allValid) {
      // just show errors inline
      return;
    }

    // TODO: send data + file to backend

    // Continue KYC flow -> WorkSchedule
    Get.to(() => const WorkScheduleScreen());
  }

  bool _validateForm() {
    final requiredTextCtrls = [
      _nameCtrl,
      _surnameCtrl,
      _cityOfBirthCtrl,
      _documentNumberCtrl,
      _streetCtrl,
      _streetNumberCtrl,
      _zipCtrl,
      _cityCtrl,
      _streetRegionCtrl,
    ];

    final anyEmptyText = requiredTextCtrls.any((c) => c.text.trim().isEmpty);

    final missingDropdown = _gender == null ||
        _dob == null ||
        _countryOfBirth == null ||
        _countryOfDocument == null ||
        _countryAddress == null;

    final missingDoc = _documentFile == null;

    return !(anyEmptyText || missingDropdown || missingDoc);
  }
}
