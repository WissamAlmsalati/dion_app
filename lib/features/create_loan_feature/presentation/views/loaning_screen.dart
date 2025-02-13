import 'package:dion_app/core/services/dio_service.dart';
import 'package:dion_app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../domain/repository/create_loan_repository.dart';
import '../../../../core/services/auth_token_service.dart';
import '../../data/models/loaning_model.dart';
import '../create_loan_bloc/loaning_bloc.dart';
import '../create_loan_bloc/loaning_event.dart';
import '../create_loan_bloc/loaning_state.dart';

class LoaningScreen extends StatefulWidget {
  const LoaningScreen({super.key});

  @override
  _LoaningScreenState createState() => _LoaningScreenState();
}

class _LoaningScreenState extends State<LoaningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deptNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final createLoanRepository = CreateLoanRepository(authService: authService, dioService: DioService());

    return BlocProvider(
      create: (context) => CreateLoanBloc(createLoanRepository: createLoanRepository),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('انشاء دين'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<CreateLoanBloc, CreateLoanState>(
            listener: (context, state) {
              if (state is CreateLoanError) {
                print("" + state.message);
                _showDialog(context, 'خطأ', state.message);
              } else if (state is CreateLoanCreated) {
                _showDialog(context, 'نجاح', 'تم إنشاء الدين بنجاح');
              }
            },
            builder: (context, state) {
              if (state is CreateLoanLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return _buildForm(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _deptNameController,
              labelText: 'اسم الدين',
              
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجي ادخال اسم الدين';
                }
                return null;
              }, maxLength: 30,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            CustomTextField(
              controller: _phoneNumberController,
              labelText: 'رقم الهاتف',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجي ادخال رقم الهاتف';
                }
                return null;
              }, maxLength: 9,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            CustomTextField(
              controller: _amountController,
              labelText: 'المبلغ',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجي ادخال المبلغ';
                }
                return null;
              }, maxLength: 7,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            CustomTextField(
              controller: _notesController,
              maxLines: 4,
              minLines: 1,
              labelText: 'ملاحظات',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'يرجي ادخال الملاحظات';
                }
                return null;
              }, maxLength: 144
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final phoneNumber = _phoneNumberController.text;
                    final loaningModel = LoaningModel(
                      deptName: _deptNameController.text,
                      phoneNumber: phoneNumber,
                      amount: double.parse(_amountController.text),
                      dueDate: DateTime.now().toString(),
                      notes: _notesController.text,
                      loanType: 1,
                    );
                    context.read<CreateLoanBloc>().add(
                          CreateLoan(loaningModel: loaningModel),
                        );
                  }
                },
                child:  Text(
                  'انشاء دين',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.tajawal().fontFamily,
                ),
              ),
            ),
            )
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _deptNameController.dispose();
    _phoneNumberController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
