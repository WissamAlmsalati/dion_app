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

class LoaningScreen extends StatelessWidget {
  LoaningScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController deptNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final createLoanRepository = CreateLoanRepository(
      authService: authService,
      dioService: DioService(),
    );

    return BlocProvider(
      create: (context) =>
          CreateLoanBloc(createLoanRepository: createLoanRepository),
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
                print(state.message);
                _showDialog(context, 'خطأ', state.message);
              } else if (state is CreateLoanCreated) {
                _showDialog(context, 'نجاح', 'تم إنشاء الدين بنجاح');
              }
            },
            builder: (context, state) {
              if (state is CreateLoanLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                                                width: MediaQuery.of(context).size.width * 0.04,

                        controller: deptNameController,
                        labelText: 'اسم الدين',
                        maxLength: 30,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجي ادخال اسم الدين';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      CustomTextField(
                                                width: MediaQuery.of(context).size.width * 0.04,

                        controller: phoneNumberController,
                        labelText: 'رقم الهاتف',
                        keyboardType: TextInputType.phone,
                        maxLength: 9,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجي ادخال رقم الهاتف';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      CustomTextField(
                        width: MediaQuery.of(context).size.width * 0.04,
                        controller: amountController,
                        labelText: 'المبلغ',
                        keyboardType: TextInputType.number,
                        maxLength: 7,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجي ادخال المبلغ';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      CustomTextField(
                                                width: MediaQuery.of(context).size.width * 0.04,

                        controller: notesController,
                        minLines: 1,
                        maxLines: 4,
                        labelText: 'ملاحظات',
                        maxLength: 144,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'يرجي ادخال الملاحظات';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
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
                              final phoneNumber = phoneNumberController.text;
                              final loaningModel = LoaningModel(
                                deptName: deptNameController.text,
                                phoneNumber: phoneNumber,
                                amount: double.parse(amountController.text),
                                dueDate: DateTime.now().toString(),
                                notes: notesController.text,
                                loanType: 1,
                              );
                              context
                                  .read<CreateLoanBloc>()
                                  .add(CreateLoan(loaningModel: loaningModel));
                            }
                          },
                          child: Text(
                            'انشاء دين',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.tajawal().fontFamily,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
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
}