import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/assets.dart';
import '../../../professional/controller/professional_registration_controller.dart';
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

  // Personal details
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  String? _gender;

  // ✅ DOB (date picker)
  final _dobCtrl = TextEditingController();
  DateTime? _dobDate;

  // ✅ Countries (ALL countries)
  String? _countryOfBirth;
  final _cityOfBirthCtrl = TextEditingController();

  // Documents
  String _docType = 'government_id'; // 'government_id' / 'passport'
  String? _countryOfDocument;
  final _documentNumberCtrl = TextEditingController();

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
    _dobCtrl.dispose();
    _cityOfBirthCtrl.dispose();
    _documentNumberCtrl.dispose();
    _streetCtrl.dispose();
    _streetNumberCtrl.dispose();
    _zipCtrl.dispose();
    _cityCtrl.dispose();
    _streetRegionCtrl.dispose();
    super.dispose();
  }

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
                      showError: _submitted && _surnameCtrl.text.trim().isEmpty,
                    ),

                    _dropdownField<String>(
                      value: _gender,
                      label: 'Gender',
                      items: const ['Male', 'Female', 'Other'],
                      showError: _submitted && _gender == null,
                      onChanged: (v) => setState(() => _gender = v),
                    ),

                    // ✅ Date picker (calendar)
                    _datePickerField(
                      controller: _dobCtrl,
                      label: 'Date of birth',
                      showError: _submitted && _dobDate == null,
                      onPick: () => _pickDob(context),
                    ),

                    // ✅ Country of birth (ALL)
                    _countryPickerField(
                      label: 'Country of birth',
                      value: _countryOfBirth,
                      showError: _submitted && _countryOfBirth == null,
                      onTap: () => _openCountryPicker(
                        onSelect: (c) =>
                            setState(() => _countryOfBirth = c.name),
                      ),
                    ),

                    _textField(
                      controller: _cityOfBirthCtrl,
                      label: 'City of birth',
                      showError:
                          _submitted && _cityOfBirthCtrl.text.trim().isEmpty,
                    ),

                    const SizedBox(height: 18),

                    // ===================== IDENTIFY DOCUMENTS (MATCHES YOUR IMAGE) =====================
                    _sectionTitle('Identify Documents'),
                    const SizedBox(height: 10),
                    _buildDocSelectorWithUpload(), // ✅ Government -> Upload -> Passport
                    const SizedBox(height: 12),

                    // ✅ Country of the document (ALL countries)
                    _countryPickerField(
                      label: 'Country of the document',
                      value: _countryOfDocument,
                      showError: _submitted && _countryOfDocument == null,
                      onTap: () => _openCountryPicker(
                        onSelect: (c) =>
                            setState(() => _countryOfDocument = c.name),
                      ),
                    ),

                    _textField(
                      controller: _documentNumberCtrl,
                      label: 'Document number',
                      showError:
                          _submitted && _documentNumberCtrl.text.trim().isEmpty,
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
                      showError:
                          _submitted && _streetNumberCtrl.text.trim().isEmpty,
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
                      showError:
                          _submitted && _streetRegionCtrl.text.trim().isEmpty,
                    ),

                    // ✅ Country (address) (ALL)
                    _countryPickerField(
                      label: 'Country',
                      value: _countryAddress,
                      showError: _submitted && _countryAddress == null,
                      onTap: () => _openCountryPicker(
                        onSelect: (c) =>
                            setState(() => _countryAddress = c.name),
                      ),
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
            icon: const Icon(Icons.arrow_back, size: 20),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Information about your profile',
              style: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.1,
                color: _textDark,
              ),
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
        color: const Color.fromARGB(255, 219, 219, 217),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            Images.bulb,
            width: 24,
            height: 24,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.lightbulb_outline, size: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Important',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                    color: const Color(0xFF333333),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Check that the information is correct so that you can charge for the services correctly.',
                  style: GoogleFonts.urbanist(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                    letterSpacing: 0,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION TITLE
  // ---------------------------------------------------------------------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.urbanist(
        color: _brandGreen, // #3FA96B
        fontSize: 24, // ✅ Figma 24px
        fontWeight: FontWeight.w600, // ✅ SemiBold
        height: 1.1, // ✅ 110%
        letterSpacing: 0, // ✅ 0%
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TEXT FIELD
  // ---------------------------------------------------------------------------

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
              labelStyle: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
                letterSpacing: 0,
                color: hasError ? _errorRed : const Color(0xFF3B3B3B),
              ),
              filled: true,
              fillColor: _bg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
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
            ),
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFF000000),
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

  // ---------------------------------------------------------------------------
  // NORMAL DROPDOWN (used only for Gender)
  // ---------------------------------------------------------------------------

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
      child: DropdownButtonFormField<T>(
        key: ValueKey(value),
        initialValue: value,
        isExpanded: true,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 22,
          color: Color(0xFF3B3B3B),
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.urbanist(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            height: 1.1,
            letterSpacing: 0,
            color: hasError ? _errorRed : const Color(0xFF3B3B3B),
          ),
          filled: true,
          fillColor: _bg,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: _borderGrey),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: hasError ? _errorRed : _borderGrey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: hasError ? _errorRed : _brandGreen),
          ),
        ),
        style: GoogleFonts.urbanist(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.1,
          letterSpacing: 0,
          color: const Color(0xFF000000),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem<T>(value: e, child: Text(e.toString())),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DATE PICKER FIELD
  // ---------------------------------------------------------------------------

  Widget _datePickerField({
    required TextEditingController controller,
    required String label,
    required VoidCallback onPick,
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
            readOnly: true,
            onTap: onPick,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.urbanist(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                height: 1.1,
                letterSpacing: 0,
                color: hasError ? _errorRed : const Color(0xFF3B3B3B),
              ),
              filled: true,
              fillColor: _bg,
              suffixIcon: const Icon(
                Icons.calendar_month_outlined,
                size: 20,
                color: Color(0xFF3B3B3B),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
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
            ),
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.1,
              letterSpacing: 0,
              color: const Color(0xFF000000),
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

  Future<void> _pickDob(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dobDate ?? DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(1900, 1, 1),
      lastDate: now,
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.light(
              primary: _brandGreen,
              onPrimary: Colors.white,
              onSurface: _textDark,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: _brandGreen),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _dobDate = picked;
      _dobCtrl.text = _formatDate(picked);
    });
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  // ---------------------------------------------------------------------------
  // COUNTRY PICKER (ALL COUNTRIES)
  // ---------------------------------------------------------------------------

  void _openCountryPicker({required ValueChanged<Country> onSelect}) {
    FocusScope.of(context).unfocus();

    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: onSelect,
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.circular(16),
        inputDecoration: InputDecoration(
          hintText: 'Search country',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _countryPickerField({
    required String label,
    required String? value,
    required bool showError,
    required VoidCallback onTap,
  }) {
    final hasError = showError;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              isEmpty: value == null,
              decoration: InputDecoration(
                labelText: label,
                floatingLabelBehavior: FloatingLabelBehavior.always,
                labelStyle: GoogleFonts.urbanist(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                  letterSpacing: 0,
                  color: hasError ? _errorRed : const Color(0xFF3B3B3B),
                ),
                filled: true,
                fillColor: _bg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                suffixIcon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 22,
                  color: Color(0xFF3B3B3B),
                ),
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
              ),
              child: Text(
                value ?? 'Select',
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                  letterSpacing: 0,
                  color: value == null ? _hintText : const Color(0xFF000000),
                ),
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

  // ---------------------------------------------------------------------------
  // ✅ IDENTIFY DOCUMENTS UI (MATCHES YOUR SCREENSHOT)
  // Government card -> Upload button -> Passport card
  // ---------------------------------------------------------------------------

  Widget _buildDocSelectorWithUpload() {
    final isGov = _docType == 'government_id';
    final isPass = _docType == 'passport';

    return Column(
      children: [
        _docCardTile(title: 'Government ID', value: 'government_id'),

        if (isGov) ...[const SizedBox(height: 2), _uploadPillButton()],

        const SizedBox(height: 14),
        _docCardTile(title: 'Passport', value: 'passport'),

        if (isPass) ...[const SizedBox(height: 14), _uploadPillButton()],

        const SizedBox(height: 14),
      ],
    );
  }

  // ✅ Figma doc card:
  // width: fill (343)
  // height: hug (62)
  // radius: 8
  // border: 0.5 (top/bottom) -> we’ll apply 0.5 all around for clean UI
  // padding: 16
  // gap: 8
  // shadow: x0 y2 blur8 spread0, #000 15%

  Widget _docCardTile({required String title, required String value}) {
    final selected = _docType == value;

    return InkWell(
      onTap: () => setState(() => _docType = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        height: 62, // ✅ Figma
        padding: const EdgeInsets.all(16), // ✅ Figma padding
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8), // ✅ Figma radius
          border: Border.all(
            color: selected ? _brandGreen : const Color(0xFFE0E0E0),
            width: 0.5, // ✅ 0.5px
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(38), // ✅ 15%
              blurRadius: 8, // ✅ blur 8
              offset: const Offset(0, 2), // ✅ y 2
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          children: [
            _docSelectIcon(selected: selected),
            const SizedBox(width: 8), // ✅ gap 8
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.urbanist(
                  fontSize: 16, // ✅ keep normal (your 30 was too big)
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                  color: const Color(0xFF3B3B3B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _docSelectIcon({required bool selected}) {
    const double size = 30;

    if (!selected) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFEAEAEA),
          border: Border.all(color: const Color(0xFF7A7A7A), width: 2),
        ),
      );
    }

    // ✅ double-ring + green center with check (like your screenshot)
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: _brandGreen, width: 4),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: _brandGreen, width: 3),
            ),
          ),
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _brandGreen,
            ),
            child: Center(
              child: Image.asset(
                Images.checkIcon,
                width: 40,
                height: 40,
                color: Colors
                    .white, // works if the asset is a PNG/SVG that supports tint
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadPillButton() {
    final regC = Get.find<ProfessionalRegistrationController>();
    final hasError = _submitted &&
        (regC.documentFrontImage == null || regC.documentBackImage == null);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: SizedBox(
              height: 38,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Keep your flow screen
                  Get.to(() => UploadFrontIdScreen());

                  // Upload flow continues in UploadFrontIdScreen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandGreen,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: Image.asset(
                  Images.uploadIcon,
                  width: 24,
                  height: 24,
                  color: Colors.white,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.file_upload_outlined,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
                label: Text(
                  'Upload documents',
                  style: GoogleFonts.urbanist(
                    fontSize: 16, // ✅ Figma
                    fontWeight: FontWeight.w500, // ✅ Medium (500)
                    height: 1.1, // ✅ 110%
                    letterSpacing: 0, // ✅ 0%
                    color: Colors.white, // ✅ #FFFFFF
                  ),
                ),
              ),
            ),
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
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
          child: Text(
            'Save',
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.1,
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
    if (!allValid) return;

    final regC = Get.find<ProfessionalRegistrationController>();
    regC.setPersonalDetails(
      name: _nameCtrl.text.trim(),
      surname: _surnameCtrl.text.trim(),
      gender: _gender ?? '',
      dateOfBirth: _dobDate!,
      countryOfBirth: _countryOfBirth ?? '',
      cityOfBirth: _cityOfBirthCtrl.text.trim(),
    );
    regC.setIdentity(
      documentType: _docType,
      documentNumber: _documentNumberCtrl.text.trim(),
      documentCountry: _countryOfDocument ?? '',
    );
    regC.setAddress(
      street: _streetCtrl.text.trim(),
      streetNumber: _streetNumberCtrl.text.trim(),
      zipCode: _zipCtrl.text.trim(),
      addressCity: _cityCtrl.text.trim(),
      addressCountry: _countryAddress ?? '',
      region: _streetRegionCtrl.text.trim(),
    );

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

    final missingDropdown =
        _gender == null ||
        _dobDate == null ||
        _countryOfBirth == null ||
        _countryOfDocument == null ||
        _countryAddress == null;

    final regC = Get.find<ProfessionalRegistrationController>();
    final missingDoc =
        regC.documentFrontImage == null || regC.documentBackImage == null;

    return !(anyEmptyText || missingDropdown || missingDoc);
  }
}
