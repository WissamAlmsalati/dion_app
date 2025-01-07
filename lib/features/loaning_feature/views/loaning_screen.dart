import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../repository/loaning_repository.dart';
import '../../authintication_feature/services/auth_service.dart';
import '../models/loaning_model.dart';

import '../viewmodel/loaning_bloc.dart';
import '../viewmodel/loaning_event.dart';
import '../viewmodel/loaning_state.dart';

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
    final loaningRepository = LoaningRepository(authService: authService);

    return BlocProvider(
      create: (context) => CreateLoanBloc(loaningRepository: loaningRepository),
      child: Scaffold(
        appBar: AppBar(
            title: const Text('انشاء دين'),
            centerTitle: true,


    ),
        body: BlocListener<CreateLoanBloc, CreateLoanState>(
          listener: (context, state) {
            if (state is CreateLoanError) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text('Error: ${state.message}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            } else if (state is CreateLoanCreated) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('نجاح'),
                  content: const Text('تم انشاء الدين بنجاح'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          },
          child: BlocBuilder<CreateLoanBloc, CreateLoanState>(
            builder: (context, state) {
              if (state is CreateLoanLoading) {
                return const Center(child: CircularProgressIndicator());
              } else {
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
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneNumberController,
                          labelText: 'رقم الهاتف',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجي ادخال رقم الهاتف';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          controller: _amountController,
                          labelText: 'المبلغ',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجي ادخال المبلغ';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        CustomTextField(
                          controller: _notesController,
                          labelText: 'ملاحظات',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجي ادخال الملاحظات';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          width: double.infinity,

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0), // Match the container radius
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final loaningModel = LoaningModel(
                                  deptName: _deptNameController.text,
                                  phoneNumber: _phoneNumberController.text,
                                  amount: double.parse(_amountController.text),
                                  dueDate: DateTime.now().toString(),
                                  notes: _notesController.text,
                                  loanType: 0, // Set loanType to default value 1
                                );

                                try {
                                  context.read<CreateLoanBloc>().add(
                                    CreateLoan(loaningModel: loaningModel),
                                  );
                                } catch (e) {
                                  print(e);
                                }
                              }
                            },
                            child:  Text(' انشاء دين',style: TextStyle(
                              fontSize: 14,
                            ),),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
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